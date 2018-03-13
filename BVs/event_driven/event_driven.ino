#include "event_driven.h"
#include "app.h"
#include "pindefs.h"

static bool button1_interess = 1;
static bool button2_interess = 1;
static bool button1_active = 0;
static bool button2_active = 0;

void button_listen (int pin) {
   if (pin == KEY1)
     button1_interess = 1;
   if (pin == KEY2)
     button2_interess = 1;
}
void timer_set (int ms) {

  // timer deve expirar após “ms” milisegundos
}

/*Codigo Principal*/
void setup() {
  pinMode(KEY1, INPUT_PULLUP);
  pinMode(KEY2, INPUT_PULLUP);
  Serial.begin(9600);
  //appinit();
}

void loop() {
  digitalWrite(LED3, HIGH);
  delay(200);
  digitalWrite(LED3, LOW);
  delay(200);
  bool button1_read;
  bool button2_read;
    
  if (button1_interess){
    button1_read = digitalRead(KEY1);
    if (button1_active != button1_read) {
      Serial.println("entrou no 2o if");
      Serial.println(button1_read);

      button_changed(KEY1, !button1_read);
      button1_active = button1_read;
    }
  }

}

