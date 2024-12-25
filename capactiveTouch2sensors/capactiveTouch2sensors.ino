// import the library (must be located in the Arduino/libraries directory)
#include <CapacitiveSensor.h>

// create an instance of the library
// pin 4 sends electrical energy
// pin 2 senses senses a change
CapacitiveSensor capSensor = CapacitiveSensor(4, 2);
CapacitiveSensor capSensor2 = CapacitiveSensor(8,6);

// threshold for turning the lamp on
int threshold = 1000;
int threshold2 = 1000;

// pin the LED is connected to
const int ledPin = 12;
const int ledPin2 = 13;


void setup() {
  // open a serial connection
  Serial.begin(9600);
  // set the LED pin as an output
  pinMode(ledPin, OUTPUT);
  pinMode(ledPin2, OUTPUT);
}

void loop() {
  // store the value reported by the sensor in a variable
  long sensorValue = capSensor.capacitiveSensor(30);
  long sensorValue2 = capSensor2.capacitiveSensor(30);

  // print out the sensor value
  //Serial.println(sensorValue);
  Serial.print(sensorValue);  // serial print to add to line
  Serial.print(","); // add a space
  Serial.println(sensorValue2);

  // if the value is greater than the threshold
  if (sensorValue > threshold) {
    // turn the LED on
    digitalWrite(ledPin, HIGH);
  }
  // if it's lower than the threshold
  else {
    // turn the LED off
    digitalWrite(ledPin, LOW);
  }

// if the value is greater than the threshold
  if (sensorValue2 > threshold2) {
    // turn the LED on
    digitalWrite(ledPin2, HIGH);
  }
  // if it's lower than the threshold
  else {
    // turn the LED off
    digitalWrite(ledPin2, LOW);
  }
  delay(10);
}
