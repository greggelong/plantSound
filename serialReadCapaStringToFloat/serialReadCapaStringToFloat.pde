// Read data from the serial port and assign it to a variable. Set the fill a
// rectangle on the screen using the value read from a light sensor connected
// to the Wiring or Arduino board

import processing.serial.*;

String myString = null;
int nl = 10;
float myVal;

Serial port;  // Create object from Serial class
int val;      // Data received from the serial port

void setup() {
  size(200, 200);
  noStroke();
  frameRate(10);  // Run 10 frames per second
  // Open the port that the board is connected to and use the same speed (9600 bps)


  String portName = Serial.list()[2];
  port = new Serial(this, portName, 9600);
  println(portName);
}

void draw() {
  while (port.available()>0) {
    myString =port.readStringUntil(nl);
    if (myString != null) {
      background(0);
      myVal =float(myString);
      println(myVal);
    }
  }
}
