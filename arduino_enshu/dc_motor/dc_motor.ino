#define MOTOR_PIN1 9 // set digital pin ID 
#define MOTOR_PIN2 10 
#define ENABLE_PIN 2 
 
void setup() { 
  pinMode(ENABLE_PIN, OUTPUT); 
  digitalWrite(ENABLE_PIN, HIGH); 
 
  analogWrite(MOTOR_PIN2, 0); 
} 
 
float voltage; 
void loop() { 
  // 1.0 V = duty 20% = 51 
  voltage = 1.0; 
  analogWrite(MOTOR_PIN1, voltage*51); 
  delay(1000); 
 
  // 2.0 V = duty 40% = 102 
  voltage = 2.0; 
  analogWrite(MOTOR_PIN1, voltage*51); 
  delay(1000); 
 
  // 3.0 V = duty 60% = 153 
  voltage = 3.0; 
  analogWrite(MOTOR_PIN1, voltage*51); 
  delay(1000); 
}
