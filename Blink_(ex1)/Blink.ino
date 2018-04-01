#define KEY1 A1
#define KEY2 A2
#define KEY3 A3

void setup() {
  pinMode(13, OUTPUT);
  pinMode(KEY1, INPUT_PULLUP);
  pinMode(KEY2, INPUT_PULLUP);
  pinMode(KEY3, INPUT_PULLUP);
  
}

void loop() {
  digitalWrite(13, HIGH);
  delay(1000);           
  digitalWrite(13, LOW);
  delay(1000);          
  
  int but = digitalRead(A1);
  if(!but){
    digitalWrite(13, LOW);
    while(1);
  }

}

