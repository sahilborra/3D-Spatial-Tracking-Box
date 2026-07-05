import processing.serial.*;

Serial myPort;
float x, y, z;

float rotX = radians(-30);
float rotY = radians(45);

void setup() {
  size(800, 800, P3D); 
  myPort = new Serial(this, Serial.list()[2], 9600);
  myPort.bufferUntil('\n'); 
}

void draw() {
  background(25); 
  lights();       
  
  translate(width/2, height/2, -100);
  rotateX(rotX);
  rotateY(rotY);
  
  // Wireframe Box
  noFill();
  stroke(80);       
  strokeWeight(1);
  box(400);          
  
  // Floor Grid
  stroke(50);
  for(int i = -200; i <= 200; i += 40) {
    line(i, 200, -200, i, 200, 200); 
    line(-200, 200, i, 200, 200, i);
  }
  
  // --- VISUAL SENSOR INDICATORS ---
  // Blue (Ceiling)
  pushMatrix(); translate(0, -200, 0); rotateX(HALF_PI); fill(0, 100, 255); noStroke(); ellipse(0, 0, 25, 25); popMatrix();
  // Green (Back Wall)
  pushMatrix(); translate(0, 0, -200); fill(0, 255, 100); noStroke(); ellipse(0, 0, 25, 25); popMatrix();
  // Red (Left Wall)
  pushMatrix(); translate(-200, 0, 0); rotateY(HALF_PI); fill(255, 50, 50); noStroke(); ellipse(0, 0, 25, 25); popMatrix();
  
  // --- LINEAR TRACKING LOGIC ---
  // As x gets closer to 0 (close to left wall), mappedX stays near -200.
  float mappedX = map(x, 0, 30, -200, 200); 
  
  // As y gets closer to 0 (close to back wall), mappedY stays near -200.
  float mappedY = map(y, 0, 30, -200, 200); 
  
  // As z gets closer to 0 (close to ceiling), ball moves toward the ceiling (-200).
  float mappedZ = map(z, 0, 30, -200, 200); 

  // Draw Floor Shadow
  fill(50, 50, 50, 150); noStroke();
  pushMatrix(); translate(mappedX, 199, mappedY); ellipse(0, 0, 20, 20); popMatrix();

  // Draw Tracking Ball
  pushMatrix(); translate(mappedX, mappedZ, mappedY); fill(255, 255, 0); noStroke(); sphere(20); popMatrix();
}

void mouseDragged() {
  rotY += (mouseX - pmouseX) * 0.01;
  rotX -= (mouseY - pmouseY) * 0.01;
}

void serialEvent(Serial myPort) {
  String inputString = myPort.readStringUntil('\n');
  if (inputString != null) {
    inputString = trim(inputString);
    float[] values = float(split(inputString, ','));
    if (values.length == 3) {
      x = values[0]; y = values[1]; z = values[2];
    }
  }
}
