#include "pindefs.h"
#include <avr/sleep.h>
#include <avr/power.h>

// globais

volatile int buttonChanged = 0;

void pciSetup(byte pin) {
    *digitalPinToPCMSK(pin) |= bit (digitalPinToPCMSKbit(pin));  // enable pin
    PCIFR  |= bit (digitalPinToPCICRbit(pin)); // clear any outstanding interrupt
    PCICR  |= bit (digitalPinToPCICRbit(pin)); // enable interrupt for the group
}

ISR (PCINT1_vect) { // handle pin change interrupt for A0 to A5 here
   buttonChanged=1;
 }  
 
void enterSleep(void){     
  set_sleep_mode(SLEEP_MODE_PWR_DOWN);     
  sleep_enable();     
  sleep_mode();     /* The program  will continue  from here. */  
  /* First thing to do is disable  sleep.  */    
  sleep_disable(); 
}

void setup() {
  
  pinMode(LED1, OUTPUT); pinMode(LED2, OUTPUT);
  digitalWrite(LED1,HIGH); digitalWrite(LED2,HIGH);
  pinMode (KEY1, INPUT_PULLUP); 
  pinMode (KEY2, INPUT_PULLUP);
  pinMode(KEY3, INPUT_PULLUP);
  Serial.begin(9600);
  pciSetup(KEY1); pciSetup(KEY2); pciSetup(KEY3);
}


void loop() {
  Serial.print("!");
  delay(10);
//  enterSleep();
  if (buttonChanged) {
     digitalWrite(LED1,digitalRead(KEY1));
     digitalWrite(LED2,digitalRead(KEY2));
     buttonChanged = 0;
  }
}

