/*
 * Dupla:
 * Alexandre Wanick - 1512647
 * Bernardo Ruga - 1511651
 */


#include "pindefs.h"

#define MINUTE 60000
#define ALARM_DELAY 300

/* Segment byte maps for numbers 0 to 9 */
const byte SEGMENT_MAP[] = {0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0X80,0X90};
/* Byte maps to select digit 1 to 4 */
const byte SEGMENT_SELECT[] = {0xF1,0xF2,0xF4,0xF8};

static bool button1_read;
static bool button2_read;
static bool button3_read;
static bool button1_interess = 0;
static bool button2_interess = 0;
static bool button3_interess = 0;
static bool button1_state = 0;
static bool button2_state = 0;
static bool button3_state = 0;

static char clock_segment[4] = {1, 2, 0, 0};
static char alarm_segment[4] = {0, 7, 0, 0};

unsigned long last_time = 0;
unsigned long alarm_time = 0;
unsigned long bt3_before;

static bool display_alarm_flag = 0;
static bool alarm_state = 0;
static bool alarm_delay_state = LOW;

/* Write a decimal number between 0 and 9 to one of the 4 digits of the display */
void WriteNumberToSegment(byte Segment, byte Value)
{
  digitalWrite(LATCH_DIO, LOW);
  shiftOut(DATA_DIO, CLK_DIO, MSBFIRST, SEGMENT_MAP[Value]);
  shiftOut(DATA_DIO, CLK_DIO, MSBFIRST, SEGMENT_SELECT[Segment] );
  digitalWrite(LATCH_DIO, HIGH);
}

void WriteTimeInDisplay(char segment[])
{
  for (int i = 0; i < 4; i++)
    WriteNumberToSegment(i, segment[i]);
}

void next_hour(char segment[])
{
  if (segment[0] < 2) {  // caso 00:59 a 19:59
    if (segment[1] < 9) {
      segment[1]++;
    } else {
      segment[1] = 0;
      segment[0]++;
    }
  } else {  // caso 20:59 a 23:59
    if (segment[1] < 3)  // caso 20:59 a 22:59
      segment[1]++;
    else  // caso 23:59
      segment[0] = segment[1] = 0;
  }
}

void next_minute(char segment[])
{ 
  if (segment[3] < 9) {
    segment[3]++;
  } else {
    segment[3] = 0;
    
    if (segment[2] < 5)
      segment[2]++;
    else  // caso hh:59
      segment[3] = segment[2] = 0;
  }
}

void button_listen(int pin)
{
  if (pin == KEY1)
    button1_interess = 1;
  if (pin == KEY2)
    button2_interess = 1;
  if (pin == KEY3)
    button3_interess = 1;
}

void appinit(void)
{
  button_listen(KEY1);  // interessado no botao 1
  button_listen(KEY2);  // interessado no botao 2
  button_listen(KEY3);  // interessado no botao 3
}

void button_changed(int p, int v)
{
  unsigned long current = millis();
  
  if (p == KEY1)  // Botao 1 foi pressionado ou liberado
    if (v == 1)  // Botao 1 -> pressionado
      if (!display_alarm_flag)
        next_hour(clock_segment);
      else
        next_hour(alarm_segment);
        
  if (p == KEY2)  // Botao 2 foi pressionado ou liberado
    if (v == 1)  // Botao 2 -> pressionado
      if (!display_alarm_flag)
        next_minute(clock_segment);
      else
        next_minute(alarm_segment);

  if (p == KEY3) {  // Botao 3 foi pressionado ou liberado
    if (v == 1) {  // Botao 3 -> pressionado
      display_alarm_flag = 1;
      bt3_before = current;
    } else {
      display_alarm_flag = 0;

      if (current - bt3_before < 200)
        alarm_state = !alarm_state;
    }
  }
}

bool check_clock_alarm(void)
{
  for (int i = 0; i < 4; i++)
    if (clock_segment[i] != alarm_segment[i])
      return 0;

  return 1;
}

void setup(void)
{
  pinMode(KEY1, INPUT_PULLUP);
  pinMode(KEY2, INPUT_PULLUP);
  pinMode(KEY3, INPUT_PULLUP);
  pinMode(LED1, OUTPUT);
  pinMode(BUZZ, OUTPUT);

  /* Set DIO pins to outputs */
  pinMode(LATCH_DIO, OUTPUT);
  pinMode(CLK_DIO, OUTPUT);
  pinMode(DATA_DIO, OUTPUT);
  
  Serial.begin(9600);

  digitalWrite(BUZZ, HIGH);

  appinit();
}

void loop(void)
{
  unsigned long current_time = millis();

  if (current_time - last_time >= MINUTE) {
    next_minute(clock_segment);
    
    if (clock_segment[2] == 0 && clock_segment[3] == 0)
      next_hour(clock_segment);
    
    last_time = current_time;
  }
   
  if (button1_interess) {  // interessado no botao 1
    button1_read = !digitalRead(KEY1);  // le o botao 1
    
    if (button1_read != button1_state) {
      button_changed(KEY1, button1_read);
      button1_state = button1_read;
    }
  }
  
  if (button2_interess) {  // interessado no botao 2
    button2_read = !digitalRead(KEY2);  // le o botao 2
    
    if (button2_read != button2_state) {
      button_changed(KEY2, button2_read);
      button2_state = button2_read;
    }
  }
  
  if (button3_interess) {  // interessado no botao 3
    button3_read = !digitalRead(KEY3);  // le o botao 3
    
    if (button3_read != button3_state) {
      button_changed(KEY3, button3_read);
      button3_state = button3_read;
    }
  }

  if (!alarm_state) {  // modo alarme desligado
    digitalWrite(LED1, HIGH);
    digitalWrite(BUZZ, HIGH);
  } else {  // modo alarme ligado
    digitalWrite(LED1, LOW);

    if (check_clock_alarm()) {  // alarme ligado
      if (current_time - alarm_time >= ALARM_DELAY) {
        digitalWrite(BUZZ, alarm_delay_state);
        alarm_delay_state = !alarm_delay_state;
        alarm_time = current_time;
      }
    } else {
        digitalWrite(BUZZ, HIGH);
    }
  }

  if (!display_alarm_flag)
    WriteTimeInDisplay(clock_segment);
  else
    WriteTimeInDisplay(alarm_segment);
}

