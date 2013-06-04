#ifndef FUNCTIONS_H
#define FUNCTIONS_H

//function declaration
long readVcc();
double readADC();
void measureAllChannels();
void measureChannelsForInterval();
int selectChannel(int);
void waitForBlood();

#endif
