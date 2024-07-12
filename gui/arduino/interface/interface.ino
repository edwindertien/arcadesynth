// first code for gui module taking knobs and potentiometers (16 channels) and generating
// CV (pitch), analog modulation signals, tones, an LFO etc
// using Arduino Pro Micro, an 128 x 32 O-LED display, a 74HC4067 mux
// and simple Low pass filters on PWM outputs for analogue signal synthesis

#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#define SCREEN_WIDTH 128  // OLED display width, in pixels
#define SCREEN_HEIGHT 32  // OLED display height, in pixels
// Declaration for an SSD1306 display connected to I2C (SDA, SCL pins)
// The pins for I2C are defined by the Wire-library.
// On an arduino UNO:       A4(SDA), A5(SCL)
// On an arduino MEGA 2560: 20(SDA), 21(SCL)
// On an arduino LEONARDO:   2(SDA),  3(SCL), ...
#define OLED_RESET 4         // Reset pin # (or -1 if sharing Arduino reset pin)
#define SCREEN_ADDRESS 0x3C  ///< See datasheet for Address; 0x3D for 128x64, 0x3C for 128x32
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);
#define limit(number, min, max) (((number) > (max)) ? (max) : (((number) < (min)) ? (min) : (number)))

#include <light_CD74HC4067.h>
// s0 s1 s2 s3: select pins
CD74HC4067 mux(16, 15, 14, 19);
int inputs[16];
#define signal_pin A0

// For 32u4 (3, 5, 6, 9, 10, 11, 13)
/*
  Pin  5 => TIMER3A
  Pin  6 => TIMER4D
  Pin  9 => TIMER1A
  Pin 10 => TIMER1B
*/

void setup() {
  // set PWM timers at high frequencies
  TCCR1B = TCCR1B & B11111000 | B00000001;
  TCCR3B = TCCR3B & B11111000 | B00000001;
  TCCR4B = TCCR4B & B11111000 | B00000001;
  Serial.begin(115200);  // Debug
  if (!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
    Serial.println(F("SSD1306 allocation failed"));
    for (;;)
      ;  // Don't proceed, loop forever
  }
  for (int i = 4; i < 11; i++) {
    pinMode(i, OUTPUT);
  }
  pinMode(A2, OUTPUT);
}

void loop() {
  static unsigned long looptime;
  static unsigned long fasttime;
  static int pulseOut = 100;
  if (millis() > looptime + 19) {
    looptime = millis();
    display.clearDisplay();
    display.setCursor(0, 0);  // Start at top-left corner
    display.setTextSize(1);   // Draw 2X-scale text
    display.setTextColor(SSD1306_WHITE);
    display.println(F("1234567812345678"));
    // show 16 bars
    for (int i = 0; i < 16; i++) {
      mux.channel(i);
      inputs[i] = analogRead(signal_pin);  // Read analog value
      Serial.print(inputs[i]);             // Print value
      Serial.print('\t');
      display.fillRect(i * 6, 32 - inputs[i] / 64, 4, 32, SSD1306_INVERSE);
    }
    display.display();
    // direct outputs of 2 joystick input channels
    analogWrite(10, 255 - inputs[1] / 4);
    analogWrite(6, inputs[0] / 4);
    //combined output - does not seem to work on 5 but this might be due to electrical error
    analogWrite(5, limit(255 - inputs[3] / 4 + 16 - inputs[2] / 8, 0, 255));
    // use two potentiometers to synthesise a tone
    tone(4, max(((1023 - inputs[3]) + (512 - inputs[2]) / 10), 30));
    int pitch = 103;
    if (inputs[10] < 512) pitch += 10;
    if (inputs[11] < 512) pitch += 22;
    if (inputs[12] < 512) pitch += 30;
    if (inputs[13] < 512) pitch += 39;
    if (inputs[14] < 512) pitch += 52;
    if (inputs[4] < 200) pitch -= 5;
    if (inputs[4] > 800) pitch += 5;
    if (inputs[5] < 200) pitch += 102;
    if (inputs[5] > 800) pitch -= 102;
    // CV out (pitch)
    analogWrite(9, pitch);
    // trigger (gate) with only one (left) button
    if (inputs[9] < 512) digitalWrite(7, HIGH);
    else digitalWrite(7, LOW);
    // trigger (gate) with all other buttons
    if (inputs[15] < 512 || inputs[10] < 512 || inputs[11] < 512 || inputs[12] < 512 || inputs[13] < 512 || inputs[14] < 512) digitalWrite(8, HIGH);
    else digitalWrite(8, LOW);
    // set timer value for LFO
    pulseOut = 260 - (inputs[6] - 387);
  }
  //LFO
  if (millis() > fasttime + pulseOut) {
    fasttime = millis();
    if (digitalRead(A2)) digitalWrite(A2, LOW);
    else digitalWrite(A2, HIGH);
  }
}
