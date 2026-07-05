const int trigX = 6; const int echoX = 7;
const int trigY = 4; const int echoY = 5;
const int trigZ = 2; const int echoZ = 3;

const float BOX_SIZE = 30.0; 

// Memory variables to preserve 3D positioning
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
  // Read absolute distance from the wall/sensor face
  float rawX = readSensor(trigX, echoX, lastValidX); delay(20);
  float rawY = readSensor(trigY, echoY, lastValidY); delay(20);
  float rawZ = readSensor(trigZ, echoZ, lastValidZ); delay(20);

  // Smooth out transitions smoothly
  lastValidX = (lastValidX * 0.7) + (rawX * 0.3);
  lastValidY = (lastValidY * 0.7) + (rawY * 0.3);
  lastValidZ = (lastValidZ * 0.7) + (rawZ * 0.3);

  // Stream raw, clean distances
  Serial.print(lastValidX, 1);
  Serial.print(",");
  Serial.print(lastValidY, 1);
  Serial.print(",");
  Serial.println(lastValidZ, 1);

  delay(15); 
}