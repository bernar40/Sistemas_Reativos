#include "event_driven.h"
#include "app.h"
#include "pindefs.h"

static bool button1_interess = 0;
static bool button2_interess = 0;
static bool button1_active = 1;
static bool button2_active = 1;
static unsigned long time_interval = 0;
static unsigned long time_now;
static unsigned long time_before = 0;
bool button1_read;
bool button2_read;

void button_listen (int pin) {
   if (pin == KEY1)
     button1_interess = 1;
   if (pin == KEY2)
     button2_interess = 1;
}
void timer_set(int ms){
 time_interval = ms; 
}

/*Codigo Principal*/
void setup() {
  pinMode(LED1, OUTPUT);
  pinMode(KEY1, INPUT_PULLUP);
  pinMode(KEY2, INPUT_PULLUP);
  appinit();
}

void loop() {
  if (button1_interess){ //interessado no botao 1
    button1_read = digitalRead(KEY1); //le o botao 1
    if (button1_read != button1_active) { //vai ativar quando for pressionado ou levantado
      button_changed(KEY1, button1_read);
      button1_active = button1_read;
    }
  }
  if (button2_interess){ //interessado no botao 2
    button2_read = digitalRead(KEY2); //le o botao 2
    if (button2_read != button2_active) { //vai ativar quando for pressionado ou levantado
      button_changed(KEY2, button2_read);
      button2_active = button2_read;
    }
  }
  if(time_interval){
    time_now = millis();
    if(time_now - time_before > time_interval){
     timer_expired();
     time_before = time_now; 
    }
  }
}


