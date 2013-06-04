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
  //however we need to declare that we are using an external analog reference.
  //analogReference(EXTERNAL);
  
  //initialize serial/I2C
  initializeSerial();
  
  //initialize variables
  for(i=0; i < CHANNELS_IN_METER; i++){
    Channel[i].index = 0;
  }
}

void loop() {
  //waitForBlood();
  //for(i=0; i<150; i++){
  //  measureAllChannels();
  //}  
  // print the results to the serial monitor:
  //Serial.print("ADC_IN = ");
  //Serial.print(analogRead(ADC_IN));
  //Serial.print("\n");
  /*
  if(!con){
    
    //establish connection
    int dev = 0x5A<<1;
    int data_low = 0;
    int data_high = 0;
    int pec = 0;
    
    i2c_start_wait(dev+I2C_WRITE);
    i2c_write(0x07);
    
    // read
    i2c_rep_start(dev+I2C_READ);
    data_low = i2c_readAck(); //Read 1 byte and then send ack
    data_high = i2c_readAck(); //Read 1 byte and then send ack
    pec = i2c_readNak();
    i2c_stop();
  }
  */
  measureChannelsForInterval();
  uploadResults();
  delay(1000);
}

