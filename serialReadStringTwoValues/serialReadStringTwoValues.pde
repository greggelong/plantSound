// Read data from the serial port and assign it to a variable. Set the fill a
// rectangle on the screen using the value read from a light sensor connected
// to the Wiring or Arduino board

import processing.serial.*;
import processing.sound.*;

SinOsc[] sineWaves; // Array of sines
float[] sineFreq; // Array of frequencies
int numSines = 5; // Number of oscillators to use

String myString = null;  // a string with two values comma seperated
int nl = 10;
float myVal;
float myVal2;

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
  // sound stuff
  sineWaves = new SinOsc[numSines]; // Initialize the oscillators
  sineFreq = new float[numSines]; // Initialize array for Frequencies

  for (int i = 0; i < numSines; i++) {
    // Calculate the amplitude for each oscillator
    float sineVolume = (1.0 / numSines) / (i + 1);
    // Create the oscillators
    sineWaves[i] = new SinOsc(this);
    // Start Oscillators
    sineWaves[i].play();
    // Set the amplitudes for all oscillators
    sineWaves[i].amp(sineVolume);
  }
}

void draw() {
  while (port.available()>0) {
    myString =port.readStringUntil(nl);
    //println(myString);
    if (myString != null) {
      background(0);
      // split string into 2 values
      String[] vallist = split(myString, ',');
      //println(vallist[0]);
      myVal =float(vallist[0]);
      myVal2 = float(vallist[1]);
      println(myVal, myVal2);
      //Map mouseY from 0 to 1
      float yoffset = map(myVal, 0, 1000, 0, 1);
      //Map mouseY logarithmically to 150 - 1150 to create a base frequency range
      float frequency = pow(1000, yoffset) + 150;
      //Use mouseX mapped from -0.5 to 0.5 as a detune argument
      float detune = map(myVal2, 0,1000, -0.5, 0.5);

      for (int i = 0; i < numSines; i++) {
        sineFreq[i] = frequency * (i + 1 * detune);
        // Set the frequencies for all oscillators
        sineWaves[i].freq(sineFreq[i]);
      }
    }
  }
}
