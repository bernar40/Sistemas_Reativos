#include "event_driven.h"
#include "app.h"
#include "pindefs.h"

void appinit(void) {
  button_listen(KEY1);
  button_listen(KEY2);
  timer_set(1000);
}
void button_changed(int p, int v) {
  if (p == KEY1){
    digitalWrite(LED1, v);
    digitalWrite(LED2, v);
    digitalWrite(LED3, v);
  }
}
void timer_expired(void) {
  digitalWrite(LED1, 0);
  timer_set(1000);
}
