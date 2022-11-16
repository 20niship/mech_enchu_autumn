#define MOTOR_PIN1 5 // digital pinのIDを設定
#define MOTOR_PIN2 6
#define MOTOR_PIN3 7
#define MOTOR_PIN4 8
const float step_period = 10; // step入力の時間幅 [msec]
void setup() {
Serial.begin(9600); // シリアル通信の初期化
pinMode(MOTOR_PIN1, OUTPUT); // digital pinのモードを設定
pinMode(MOTOR_PIN2, OUTPUT);
pinMode(MOTOR_PIN3, OUTPUT);
pinMode(MOTOR_PIN4, OUTPUT);
}
void loop() {
// 1001
digitalWrite(MOTOR_PIN1, HIGH); // digital pinをHIGH/LOWに切り替え
digitalWrite(MOTOR_PIN2, LOW);
digitalWrite(MOTOR_PIN3, LOW);
digitalWrite(MOTOR_PIN4, HIGH);
Serial.println("1001"); // シリアルモニタにprint
delay(step_period);
// 1100
digitalWrite(MOTOR_PIN1, HIGH);
digitalWrite(MOTOR_PIN2, HIGH);
digitalWrite(MOTOR_PIN3, LOW);
digitalWrite(MOTOR_PIN4, LOW);
Serial.println("1100");
delay(step_period);
// 0110
digitalWrite(MOTOR_PIN1, LOW);
digitalWrite(MOTOR_PIN2, HIGH);
digitalWrite(MOTOR_PIN3, HIGH);
digitalWrite(MOTOR_PIN4, LOW);
Serial.println("0110");
delay(step_period);
// 0011
digitalWrite(MOTOR_PIN1, LOW);
digitalWrite(MOTOR_PIN2, LOW);
digitalWrite(MOTOR_PIN3, HIGH);
digitalWrite(MOTOR_PIN4, HIGH);
Serial.println("0011");
delay(step_period);
Serial.println();
}
