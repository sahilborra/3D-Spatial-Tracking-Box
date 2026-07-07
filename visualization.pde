// This code was written using Gemini AI. Prompt : Create a Processing program which renders 3D tracking data using the P3D renderer and the serial port to collect this data. The program will create an 800x800 3D window, initialize the serial connection at 9600 baud rate, open the third serial port available, and asynchronously split the incoming strings into three float variables corresponding to the X, Y, and Z values. The `draw()` function should render a 400 units bounding box, a floor grid, and colored circle sensors on the left, back, and top surfaces of the cube. Next, convert the raw sensor readings, which go from 0 to 30, into the 3D coordinate system where values are from -200 to 200, so that a yellow sphere and its floor shadow reflect the actual sensor location. Lastly, add mouse drag interaction in `mouseDragged()` method.
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
  
  noFill();
  stroke(80);       
  strokeWeight(1);
  box(400);          
  
  stroke(50);
  for(int i = -200; i <= 200; i += 40) {
    line(i, 200, -200, i, 200, 200); 
    line(-200, 200, i, 200, 200, i);
  }
  
  pushMatrix(); translate(0, -200, 0); rotateX(HALF_PI); fill(0, 100, 255); noStroke(); ellipse(0, 0, 25, 25); popMatrix();

  pushMatrix(); translate(0, 0, -200); fill(0, 255, 100); noStroke(); ellipse(0, 0, 25, 25); popMatrix();

  pushMatrix(); translate(-200, 0, 0); rotateY(HALF_PI); fill(255, 50, 50); noStroke(); ellipse(0, 0, 25, 25); popMatrix();
  


  float mappedX = map(x, 0, 30, -200, 200); 
  

  float mappedY = map(y, 0, 30, -200, 200); 
  
 
  float mappedZ = map(z, 0, 30, -200, 200); 


  fill(50, 50, 50, 150); noStroke();
  pushMatrix(); translate(mappedX, 199, mappedY); ellipse(0, 0, 20, 20); popMatrix();


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
