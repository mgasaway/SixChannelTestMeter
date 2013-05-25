#include "Functions.h"
#include "Firmware.h"

void measureAllChannels(){
  int i;
  
  for(i=0; i<CHANNELS_IN_METER; i++){
    if(Channel[i].index >= TOTAL_MEASUREMENTS){
      if(DEBUG){
        Serial.print("Maximum amount of measurements reached on channel ");
        Serial.print(i+1);
        Serial.print(".\n");
      }
      continue;
    }
    selectChannel(i);
    Channel[i].rawMeasurement[Channel[i].index++] = analogRead(ADC_IN);
  }
}

/*
* Selects the channel to read (0-7).  Returns 0 on success, otherwise
* returns the error encountered.
*/
int selectChannel(int select){
  //declare local msb (most signifigant bit), mb(middle bit), lsb(least signifigant bit)
  int  msb, mb, lsb;
  
  if(DEBUG){
    Serial.print("Channel ");
    Serial.print(select);
    Serial.print(" on MUX selected.\n");
  }
  
  //make sure select is in a valid range
  if((select > 7)||(select < 0)) return 1;
  
  //calculate binary
  lsb = select%2;
  
  if(lsb) select-=1;
  select/=2;
  
  mb = select%2;
  
  if(mb) select-=1;
  select/=2;
  
  msb=select;
  
  //Select that channel by writing to the 3 select lines
  digitalWrite(SELECT_A, msb);
  digitalWrite(SELECT_B, mb);
  digitalWrite(SELECT_C, lsb);
  
  //wait for MUX and traces to stabalize
  delay(1);
  
  return 0;
}

void waitForBlood(){
  
  //while blood is not present in all channels
  while(!(digitalRead(FILL_DETECTION_CH1) && digitalRead(FILL_DETECTION_CH2))){
    if(DEBUG) Serial.print("\nWaiting for blood to fill channels\n");
    delay(1000);
  }
  
  if(DEBUG) Serial.print("Blood detected!");
  
  return;
}
