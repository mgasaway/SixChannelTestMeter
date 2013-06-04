#ifndef FIRMWARE_H
#define FIRMWARE_H

//Debug mode prints status messages to a computer via serial
const int DEBUG=0, CHANNELS_IN_METER = 6, TOTAL_MEASUREMENTS = 100, intervalINms=10000;

//define analog pins
const int ADC_OUT = 14, ADC_IN = 15;

//define digital pins
const int SELECT_C = 0, SELECT_B = 1, SELECT_A = 2, MUX_ENABLE = 3;
const int FILL_DETECTION_CH1 = 4, FILL_DETECTION_CH2 = 5;

//define other pins
const int LED = 13;

//structure to hold measurements for one channel
struct channelStruct{
  int rawMeasurement[TOTAL_MEASUREMENTS], index;
  int peak, slope, conversionConstant;
};

static channelStruct Channel[CHANNELS_IN_METER];
static int i;

//Serial
int dev, data_low, data_high, pec, con;

#endif
