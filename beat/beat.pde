import processing.sound.*;

SinOsc kickOsc, snareOsc, hiHatOsc; // Oscillators
Env kickEnv, snareEnv, hiHatEnv;    // Envelopes for short bursts

int currentBeat = 0;
int patternLength = 8;
float tempo = 120; // Beats per minute
int lastBeatTime = 0;

// Patterns for kick, snare, and hi-hat
int[] kickPattern, snarePattern, hiHatPattern;

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
}

void draw() {
  background(50);
  
  // Map mouseX to tempo and mouseY to oscillator frequency
  tempo = map(mouseX, 0, width, 100, 300); // Adjust tempo with mouseX
  float freq = map(mouseY, 0, height, 200, 1000); // Adjust frequency with mouseY
  
  // Display the tempo
  fill(255);
  textSize(16);
  text("Tempo: " + int(tempo) + " BPM", 20, 30);

  // Visualize the patterns
  for (int i = 0; i < patternLength; i++) {
    fill(kickPattern[i] == 1 ? color(255, 0, 0) : 100);
    ellipse(50 + i * 40, height / 2 - 50, 20, 20);

    fill(snarePattern[i] == 1 ? color(0, 255, 0) : 100);
    ellipse(50 + i * 40, height / 2, 20, 20);

    fill(hiHatPattern[i] == 1 ? color(0, 0, 255) : 100);
    ellipse(50 + i * 40, height / 2 + 50, 20, 20);
  }

  // Trigger sounds at the correct timing
  if (millis() - lastBeatTime > (60000 / tempo)) {
    playCurrentBeat(freq);
    currentBeat = (currentBeat + 1) % patternLength;
    lastBeatTime = millis();
  }
}

void playCurrentBeat(float freq) {
  if (kickPattern[currentBeat] == 1) {
    kickOsc.freq(50); // Low frequency for kick
    kickEnv.play(kickOsc, 0.01, 0.1, 0.1, 0.8); // Short burst envelope
  }
  
  if (snarePattern[currentBeat] == 1) {
    snareOsc.freq(freq); // MouseY determines frequency
    snareEnv.play(snareOsc, 0.01, 0.1, 0.2, 0.5); // Short burst envelope
  }
  
  if (hiHatPattern[currentBeat] == 1) {
    hiHatOsc.freq(freq * 2); // Higher frequency for hi-hat
    hiHatEnv.play(hiHatOsc, 0.005, 0.05, 0.1, 0.3); // Very short burst
  }
}
