//Header files
#include "Firmware.h"

void setup() {
  int i;
  
  //initialize MUX select pins as output
  pinMode(SELECT_A, OUTPUT);  
  pinMode(SELECT_B, OUTPUT);
  pinMode(SELECT_C, OUTPUT);
  pinMode(MUX_ENABLE, OUTPUT);
  
  //initialize fill detection pins
  pinMode(FILL_DETECTION_CH1, INPUT);
  pinMode(FILL_DETECTION_CH2, INPUT);
  
  //no need to declare ADC pins as input/output
  
  //initialize serial communication with computer
  Serial.begin(19200);
  
  //initialize variables
  for(i=0; i < CHANNELS_IN_METER; i++){
    Channel[i].index = 0;
  }
}

void loop() {
  //waitForBlood();
  //for(i=0; i<10000; i++){
  //  measureAllChannels();
  //}  
  // print the results to the serial monitor:
  Serial.print("ADC_IN = ");
  Serial.print(analogRead(ADC_IN));
  Serial.print("\n");
  delay(1000);
}

