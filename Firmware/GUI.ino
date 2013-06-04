#include "GUI.h"
#include <I2C.h>

void initializeSerial(){
  //initialize serial communication with computer
  Serial.begin(19200);

  //I2C HERE
  
}

void uploadResults(){
  int i, j;
  String toSend;
  
  for(i=0; i<TOTAL_MEASUREMENTS; i++){
    toSend="";
    
    for(j=0; j<6; j++){
      toSend=toSend+"ch"+j+":"+Channel[j].rawMeasurement[i]+",";
    }
    toSend=toSend+";";
    
    Serial.println(toSend);
    delay(10);
  }
  
}
