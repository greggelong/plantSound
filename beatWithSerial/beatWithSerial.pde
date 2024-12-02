import processing.serial.*;
import processing.sound.*;

SinOsc kickOsc, snareOsc, hiHatOsc;  // Oscillators for the instruments
Env kickEnv, snareEnv, hiHatEnv;     // Envelopes for short bursts
int currentBeat = 0;
int patternLength = 8;
float tempo = 120;                    // Tempo in beats per minute
int lastBeatTime = 0;                 // Last time a beat was triggered

int[] kickPattern, snarePattern, hiHatPattern; // Patterns for kick, snare, and hi-hat

String myString = null;   // A string with two comma-separated values
int nl = 10;              // Newline character for serial communication
float myVal, myVal2;      // Values from serial input
Serial port;              // Serial port object

void setup() {
  size(400, 400);
  
  // Initialize oscillators
  kickOsc = new SinOsc(this);
  snareOsc = new SinOsc(this);
  hiHatOsc = new SinOsc(this);
  
  // Initialize envelopes
  kickEnv = new Env(this);
  snareEnv = new Env(this);
  hiHatEnv = new Env(this);

  // Define rhythmic patterns
  kickPattern = new int[] {1, 0, 1, 0, 1, 0, 1, 0};
  snarePattern = new int[] {0, 0, 0, 1, 0, 0, 0, 1};
  hiHatPattern = new int[] {1, 1, 1, 1, 1, 1, 1, 1};

  // Serial setup
  String portName = Serial.list()[2];  // Change index if necessary
  port = new Serial(this, portName, 9600);
  println("Connected to: " + portName);
}

void draw() {
  background(50);
  
  // Map serial data to frequency and detune
  while (port.available() > 0) {
    myString = port.readStringUntil(nl);
    if (myString != null) {
      // Split the serial data into two values
      String[] vallist = split(myString.trim(), ',');
      if (vallist.length >= 2) {
        myVal = float(vallist[0]);
        myVal2 = float(vallist[1]);
        println("Serial input: " + myVal + ", " + myVal2);
        
        // Map serial data to frequency
        float yoffset = map(myVal, 10, 3500, 0, 1);
        float frequency = pow(14000, yoffset) + 150;

        // Map serial data to detune
       // float detune = map(myVal, 0, 2500, -0.5, 0.5);

        // Set frequencies for the instruments (kick, snare, hi-hat)
        kickOsc.freq(frequency * 0.5);     // Kick at a lower frequency
        snareOsc.freq(frequency);          // Snare at the base frequency
        hiHatOsc.freq(frequency * 2);      // Hi-hat at a higher frequency
      }
    }
  }

  // Map mouseX to tempo (to adjust tempo interactively if desired)
  tempo = map(myVal2, 0, 3000, 100, 300); // Adjust tempo with mouseX

  // Display the tempo
  fill(255);
  textSize(16);
  text("Tempo: " + int(tempo) + " BPM", 20, 30);

  // Trigger sounds based on the current beat
  if (millis() - lastBeatTime > (60000 / tempo)) {
    playCurrentBeat();
    currentBeat = (currentBeat + 1) % patternLength;  // Loop through the pattern
    lastBeatTime = millis();
  }

  // Visualize the patterns
  for (int i = 0; i < patternLength; i++) {
    fill(kickPattern[i] == 1 ? color(255, 0, 0) : 100);
    ellipse(50 + i * 40, height / 2 - 50, 20, 20);

    fill(snarePattern[i] == 1 ? color(0, 255, 0) : 100);
    ellipse(50 + i * 40, height / 2, 20, 20);

    fill(hiHatPattern[i] == 1 ? color(0, 0, 255) : 100);
    ellipse(50 + i * 40, height / 2 + 50, 20, 20);
  }
}

void playCurrentBeat() {
  // Trigger kick
  if (kickPattern[currentBeat] == 1) {
    kickEnv.play(kickOsc, 0.01, 0.1, 0.1, 0.8);  // Short burst envelope
  }
  
  // Trigger snare
  if (snarePattern[currentBeat] == 1) {
    snareEnv.play(snareOsc, 0.01, 0.1, 0.2, 0.5);  // Short burst envelope
  }
  
  // Trigger hi-hat
  if (hiHatPattern[currentBeat] == 1) {
    hiHatEnv.play(hiHatOsc, 0.005, 0.05, 0.1, 0.3);  // Very short burst envelope
  }
}
