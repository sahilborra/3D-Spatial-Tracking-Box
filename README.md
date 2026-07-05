# 3d Spatial Tracking Box

I have created a physical 3d tracking box I built from scratch using an Arduino Mega and three ultrasonic sensors. It tracks where an object is inside a 30cm x 30cm x 30cm space and displays it in a 3d visualization window coded in Processing (Java).


What the Project Does : 
I set up 3 cardboard square to represent the X, Y, and Z planes. 
- Left Wall (X-Axis) : Tracks left and right movement
- Ceiling (Y-Axis) : Tracks up and down movement
- Back Wall (Z-Axis) : Tracks forward and backward movement
Inside the box, I move a cube around, and the Arduino constantly calculates its position using sound waves. Then, it sends the coordinates to the Processing code, which maps a single point representing the position of the cube on the computer screen in real time.


Hardware Used : 
- Arduino Mega 2560
- HC-SR04 Sensors (3x)
- 30 x 30 cm cardboard panels (3x)
- Tape


Challenges Faced : 
1. Echoes and Ghost signals
Initially, I tried firing all sensors at the exact same time, but the readings were very inconsistent. Since all sensors were emitting signals in the same 40 kHz frequency, the sound waves would interfere with other sensors' readings.

*The fix* : I used a technique called Time Division Multiplexing, which essentially makes the Arduino fire each sensor one by one in a loop, pausing for 10 to 15 milliseconds in between each pulse. This give the previous echoes enough time to die down before the next sensor looks for a signal.

2. Tracking Uneven Objects
Flat surfaces are ideal for ultrasonic sensors because the sound bounces back nicely. However, tracking a ball or a moving hand is different. In my experiments with uneven objects, huge spikes or random zeroes were seen in the data. This happens because sound waves hit curves and scatter in random directions.

*The fix* : I added code to automatically filter out impossible readings. For example, if a sensor says the object is 50 cm away, the code ignores it because the box is only 30 cm max
