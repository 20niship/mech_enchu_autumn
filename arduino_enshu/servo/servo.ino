#define SERVO_PIN 2 // set digital pin ID 
#include <Servo.h> 
Servo servo; 
 
void setup() 
{  
  servo.attach(SERVO_PIN); // select a pin for the servo signal 
} 
 
void loop() 
{ 
  servo.write(45); 
  delay(1000); 
  servo.write(90); 
  delay(1000); 
  servo.write(135); 
  delay(1000); 
  servo.write(90); 
  delay(1000); 
}
