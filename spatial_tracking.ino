//This code was written using Gemini AI. Prompt : Write an Arduino program to use the three HC-SR04 ultrasonic sensors (X using pins 6/7, Y using 4/5, and Z using 2/3) to detect 3D coordinates in a 30cm cube volume. Your program should include a reusable function for each of the sensors to obtain the distances by making standard 10µs pulses and setting the `pulseIn` timeout to 18,000µs, as well as returning the last valid reading in case of an out-of-bounds or timed-out reading (values below 2.5cm or greater than 30cm). For the main function, stagger the readings of the sensors in 20ms intervals to avoid interference, apply the low-pass filter (70% old + 30% new values), and keep streaming the filtered values in the Serial Monitor at 9600 baud, separated by commas and one decimal place.
const int trigX = 6; const int echoX = 7;
const int trigY = 4; const int echoY = 5;
const int trigZ = 2; const int echoZ = 3;

const float BOX_SIZE = 30.0; 

float lastValidX = BOX_SIZE / 2;
float lastValidY = BOX_SIZE / 2;
float lastValidZ = BOX_SIZE / 2;

void setup() {
  Serial.begin(9600);
  pinMode(trigX, OUTPUT); pinMode(echoX, INPUT);
  pinMode(trigY, OUTPUT); pinMode(echoY, INPUT);
  pinMode(trigZ, OUTPUT); pinMode(echoZ, INPUT);
}

float readSensor(int trigPin, int echoPin, float lastValidValue) {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  long duration = pulseIn(echoPin, HIGH, 18000); 
  
  if (duration == 0) return lastValidValue; 
  
  float dist = (duration * 0.0343) / 2;
  if (dist > BOX_SIZE || dist < 2.5) return lastValidValue; 
  return dist;
}

void loop() {
  float rawX = readSensor(trigX, echoX, lastValidX); delay(20);
  float rawY = readSensor(trigY, echoY, lastValidY); delay(20);
  float rawZ = readSensor(trigZ, echoZ, lastValidZ); delay(20);

  lastValidX = (lastValidX * 0.7) + (rawX * 0.3);
  lastValidY = (lastValidY * 0.7) + (rawY * 0.3);
  lastValidZ = (lastValidZ * 0.7) + (rawZ * 0.3);

  Serial.print(lastValidX, 1);
  Serial.print(",");
  Serial.print(lastValidY, 1);
  Serial.print(",");
  Serial.println(lastValidZ, 1);

  delay(15); 
}
