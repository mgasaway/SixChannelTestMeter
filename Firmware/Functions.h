#ifndef FUNCTIONS_H
#define FUNCTIONS_H

//function declaration
long readVcc();
void measureAllChannels();
double readADC();
int selectChannel(int);
void waitForBlood();

#endif
