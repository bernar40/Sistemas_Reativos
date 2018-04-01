#define KEY1 A1
#define KEY2 A2
#define KEY3 A3

void setup() {
  pinMode(13, OUTPUT);
  pinMode(KEY1, INPUT_PULLUP);
  pinMode(KEY2, INPUT_PULLUP);
  pinMode(KEY3, INPUT_PULLUP);
  Serial.begin(9600);
}
int state = 1;
unsigned long ledOld;
unsigned long but1Time = 0;
unsigned long but2Time = 1000;
unsigned long interval = 1000;

void loop() {

  unsigned long ledNow = millis();
  if(ledNow >= ledOld+interval){
    ledOld = ledNow;
    state = !state;
    digitalWrite(13, state);
  }
  int but1 = digitalRead(KEY1);
  if(!but1){
    but1Time = millis();
    delay(100);
    interval = interval - 200; 
  }

  int but2 = digitalRead(KEY2);
  if(!but2){
    but2Time = millis();
    delay(100);
    interval = interval + 200; 
  }
  Serial.println(but1Time);
  Serial.println(but2Time);
  if(but1Time > but2Time){
   if((but1Time - but2Time) < 500){
    digitalWrite(13, HIGH);
    while(1);
   }
  }
  else if (but1Time < but2Time){
   if((but2Time - but1Time) < 500){
    digitalWrite(13, HIGH);
    while(1);
   }
  }
}

