// furby sound sampler audio test with OLED display
// playing a sample from memory.

// used examples: 
// Pico I2S simpletone
// SSD1306 128x64 I2C
// PWMaudio
//
#include <Arduino.h>           // arduino core / framework
#include <SPI.h>               // not used but necessary for other displays in the SSD1306 lib
#include <Wire.h>              // the I2C communication lib for the display
#include <Adafruit_GFX.h>      // graphics, drawing functions (sprites, lines)
#include <Adafruit_SSD1306.h>  // display driver
#include <PWMAudio.h>          // cp process to play audio on PWM pin
#include "furby.h"             // converted furby sample data (using Wav2c)

#include <I2S.h>
// Audio output through I2S: Create the I2S port using a PIO state machine
I2S i2s(OUTPUT);
// GPIO pin numbers
#define pBCLK 17
#define pWS (pBCLK + 1)
#define pDOUT 16
const int sampleRate = 22050;  // minimum for UDA1334A
volatile int A = 0;
volatile int B = 0;
Adafruit_SSD1306 display = Adafruit_SSD1306(128, 32, &Wire);
// The sample pointers
const int16_t *start = (const int16_t *)out_raw;
const int16_t *p = start;  // the real sample value pointer
// Create the PWM audio device on pin A3 (internal buzzer on Expansion board)
PWMAudio pwm(19);
unsigned int count = 0;  // check where in the sample you are, human readable
volatile int hue = 0;    // to cycle through LED colours (and misused as frequency setting)

void cb() {              // thread process to do audio update regularly
  while (pwm.availableForWrite()) {
    i2s.write(*p);  // write sample to left channel
    i2s.write(*p);  // write sample to right channel
    pwm.write(*p++);
    count += 2;  // was 2
    if (count >= B) {
      count = A;
      p = start+A/2;
      //pwm.setFrequency(22050 + hue * 120);
    }
  }
}
// now for the code
void setup() {

  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(7, INPUT_PULLUP);
  pinMode(8, INPUT_PULLUP);
  pinMode(9, INPUT_PULLUP);
  Serial1.begin(115200);

  display.begin(SSD1306_SWITCHCAPVCC, 0x3C);  // Address 0x3C for 128x32
  display.clearDisplay();                     // start the screen
  pwm.onTransmit(cb);                         // start the audio playback
  pwm.begin(22050);                           // set the playback frequency

  i2s.setBCLK(pBCLK);
  i2s.setDATA(pDOUT);
  i2s.setBitsPerSample(16);
  if (!i2s.begin(sampleRate)) {
    Serial.println("Failed to initialize I2S!");
    while (1)
      ;  // do nothing
  }

  A = 0;
  B = sounddata_length;
}

void loop() {
  static unsigned long looptime;
  if (millis() > looptime + 49) {  // run this code at 10Hz
    looptime = millis();

     A = sounddata_length * analogRead(A0)/1023.0;
     B = sounddata_length * (1023-analogRead(A2))/1023.0;
     if(B<A) B=A+5;
    Serial1.print(analogRead(A0));
    Serial1.print(',');
    Serial1.print(analogRead(A1));
    Serial1.print(',');
    Serial1.println(analogRead(A2));

    display.clearDisplay();
    for (int i = 0; i < display.width(); i++) {    // this is for building up a sound wave picture
      int p = sounddata_length / display.width();  // scale the data to the full screen width
      display.drawLine(i, display.height() / 2 + out_raw[i * p] / 4, i, display.height() / 2 - out_raw[i * p] / 4, SSD1306_WHITE);
    }
    int cursor = display.width() * count / sounddata_length;
    display.drawLine(cursor, 4, cursor, display.height()-4, SSD1306_WHITE);
    int cursorA = display.width() * A/sounddata_length;
    int cursorB = display.width() * B/sounddata_length;
    display.drawLine(cursorA, 0, cursorA, display.height(), SSD1306_WHITE);
    display.fillRect(cursorA, 0, 4, 4, SSD1306_WHITE);
    display.fillRect(cursorB, 0, 4, 4, SSD1306_WHITE);
    display.drawLine(cursorB, 0, cursorB, display.height(), SSD1306_WHITE);
    display.display();  // Update screen with each newly-drawn line

  }
}
