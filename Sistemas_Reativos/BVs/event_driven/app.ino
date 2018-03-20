#include "event_driven.h"
#include "app.h"
#include "pindefs.h"

static bool LED = 1;
static unsigned long time2_interval = 1000;
static unsigned long bt1_before = 0;
static unsigned long bt2_before = 0;

void appinit(void) {
  button_listen(KEY1); //interessado no botao 1
  button_listen(KEY2); //interessado no botao 2
  timer_set(1000); //intervalo inicial
  Serial.begin(9600);

}
void button_changed(int p, int v) {
  unsigned long current = millis(); //contabilizando tempo

    if (p == KEY1){ //Botao 1 foi pressionado ou liberado
    	if(v == 0){ //Botao 1 -> pressionado
        	bt1_before = current; //comeca a contar timer
        }
	    else{
	      	if(current - bt2_before < 500){ //botoes apertados "ao mesmo tempo" -> led desliga
            Serial.println("1 Desliga");
		        digitalWrite(LED1, HIGH);
		        timer_set(0);
	      	}
	      	else{ //apenas botao 1 -> led fica mais rapido
		        Serial.println("Fica mais rapido");
		        time2_interval = time2_interval - 200;
		        if (time2_interval < 200){
		        	time2_interval = 200;
		        }
		        timer_set(time2_interval);
      		}
    	}
    }
//  	if (p == KEY2){ //Botao 2 foi pressionado ou liberado
      else{
        	if(v == 0){ //Botao 2 -> pressionado
          		bt2_before = current;
          	}
        	else{
    	      	if(current - bt1_before < 500){//botoes apertados "ao mesmo tempo" -> led desliga
                Serial.println("2 Desliga");
    		       	digitalWrite(LED1, HIGH);
    		        timer_set(0);
    	      	}
    	      	else{ // apenas botao 2 -> led fica mais devagar
    		        Serial.println("Fica mais devagar");
    		        time2_interval = time2_interval+200;
    		        timer_set(time2_interval);
          		}
        	}
    	}
}
void timer_expired(void) {
  if(LED == 1)
    digitalWrite(LED1, LOW);
  else
    digitalWrite(LED1, HIGH);
  LED = !LED;
}

