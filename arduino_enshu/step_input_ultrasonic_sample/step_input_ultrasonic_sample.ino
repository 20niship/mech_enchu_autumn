#define TRIG_PIN 2 // set digital pin ID
#define ECHO_PIN 3
#include <Stepper.h>
#define MOTOR_PIN1 5
#define MOTOR_PIN2 6
#define MOTOR_PIN3 7
#define MOTOR_PIN4 8
#define STEPS_PER_ROTATE_28BYJ48 2048 // 1回転に必要なステップ数. 360[deg] / 5.625[deg/step] / 2(相励磁) *64(gear比)
const float time_gain = 1.0/58; // gain for duration [us] to distance [cm]
float read_sensor(){
// trigger
digitalWrite(TRIG_PIN, HIGH);
delayMicroseconds(10); // 10 usec
digitalWrite(TRIG_PIN, LOW);
// measure the duration when echo is high
return time_gain*pulseIn(ECHO_PIN,HIGH);
}
const int StepsPerRotate = STEPS_PER_ROTATE_28BYJ48;
int rpm = 15; // 毎分の回転数(rpm) 1-15rpmでないと動かない
int Steps = 512; // モータに与えるステップ数(90度回転) 360deg : 90deg = 2048 : 512
// ライブラリとモータ配線の整合性を取り, C1, C2を入れ替える
Stepper myStepper(StepsPerRotate, MOTOR_PIN1, MOTOR_PIN3, MOTOR_PIN2, MOTOR_PIN4);
void setup() {
Serial.begin(9600); // シリアル通信の初期化
// ultrasonic sensor
pinMode(TRIG_PIN, OUTPUT);
pinMode(ECHO_PIN, INPUT);
myStepper.setSpeed(rpm); // rpmを設定
}
float distance;
void loop() {
// ステッピングモータを回転
distance = read_sensor();
Serial.println(distance);
if(distance < 30){
Serial.println("->Rotate");
myStepper.step(Steps);
} else {
Serial.println("->Stop");
}
delay(500);
}
