#define KEY1 A1
#define KEY2 A2
#define KEY3 A3

void setup() {
  pinMode(13, OUTPUT);
  pinMode(KEY1, INPUT_PULLUP);
  pinMode(KEY2, INPUT_PULLUP);
  pinMode(KEY3, INPUT_PULLUP);  
}
int state = 1;
unsigned long old;

void loop() {
  unsigned long now = millis();
  if(now >= old+1000){
    old = now;
    state = !state;
    digitalWrite(13, state);
  }
  
  int but = digitalRead(A1);
  if(!but){
    digitalWrite(13, LOW);
    delay(2000);
  }

}

