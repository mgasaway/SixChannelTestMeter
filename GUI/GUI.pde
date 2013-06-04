import processing.serial.*;

//GUI stuff
float dataMin, dataMax;

float plotX1, plotY1;
float plotX2, plotY2;
float labelX, labelY;

int rowCount;
int columnCount;
int currentColumn = 0;

int timeMin, timeMax;
int[] time;

int timeInterval = 500;
int volumeInterval = 10;

PFont plotFont; 

float[] tabLeft, tabRight;  // Add above setup()
float tabTop, tabBottom;
float tabPad = 10;

int volumeIntervalMinor = 5;

String columnName[];

//store measurment data
int[][][] channel;

color off = color(255, 0, 0);
color on = color(0, 255, 0);

boolean measure=true, squareWave=false, sinWave=false;

//serial connection
Serial arduino;
String data;

void setup() {
  size(1200, 400);
  
  //instantiate new serial object if arduino is connected
  try{
    String port = Serial.list()[0];
    arduino = new Serial(this, port, 19200);
  }catch( ArrayIndexOutOfBoundsException e){
    arduino=null; 
  }
  
  timeMin = 0;
  timeMax = 10000;
  
  columnName = new String[9];
  columnName[0]="Channel 1";
  columnName[1]="Channel 2";
  columnName[2]="Channel 3";
  columnName[3]="Channel 4";
  columnName[4]="Channel 5";
  columnName[5]="Channel 6";
  columnName[6]="Measure";
  columnName[7]="Square Wave";
  columnName[8]="Sin Wave";
  columnCount = 9;
  
  dataMin = 0;
  dataMax = 100;

  // Corners of the plotted time series
  plotX1 = 120; 
  plotX2 = width - 80;
  labelX = 50;
  plotY1 = 60;
  plotY2 = height - 70;
  labelY = height - 25;
  
  plotFont = createFont("SansSerif", 40);
  textFont(plotFont);

  smooth();
  channel = new int[6][2][100];
  initializeFakeData();
}

void initializeFakeData(){
  for(int i = 0; i < 6; i++){
    for(int j = 0; j<100; j++){
      channel[i][0][j]=(int)(((double)1/(i+1))*j); 
    }
  }
  
  for(int i = 0; i<6; i++){
    for(int j = 0; j<100; j++){
      channel[i][1][j]=(j+1)*100;
    }
  }
}

void draw() {
  background(224);
  
  // Show the plot area as a white box  
  fill(255);
  rectMode(CORNERS);
  noStroke();
  rect(plotX1, plotY1, plotX2, plotY2);

  drawTitleTabs();
  drawAxisLabels();
  drawTimeLabels();
  drawVolumeLabels();

  // draw the data using a long curve
  noFill();
  //stroke(32, 128, 192);
  // balance the weight of the lines with the closeness of the data points
  strokeWeight(3);
  //drawDataCurve(currentColumn);
  drawDataPoints(currentColumn);
  drawDataLine(currentColumn);
}


void drawAxisLabels() {
  fill(0);
  textSize(13);
  textLeading(15);
  
  textAlign(CENTER, CENTER);
  text("Current\n(uA)\n", labelX, (plotY1+plotY2)/2);
  textAlign(CENTER);
  text("Time (mS)", (plotX1+plotX2)/2, labelY);
}


void drawTimeLabels() {
  fill(0);
  textSize(10);
  textAlign(CENTER);
  
  // Use thin, gray lines to draw the grid
  stroke(224);
  strokeWeight(1);

  for(int row = 0; row < 100; row++){
    if (channel[currentColumn][1][row] % timeInterval == 0) {
      float x = map(channel[currentColumn][1][row], timeMin, timeMax, plotX1, plotX2);
      text(channel[currentColumn][1][row], x, plotY2 + textAscent() + 10);
      line(x, plotY1, x, plotY2);
    }
  }
}

void drawVolumeLabels() {
  fill(0);
  textSize(10);
  textAlign(RIGHT);
  
  stroke(128);
  strokeWeight(1);

  for (float v = dataMin; v <= dataMax; v += volumeIntervalMinor) {
    if (v % volumeIntervalMinor == 0) {     // If a tick mark
      float y = map(v, dataMin, dataMax, plotY2, plotY1);  
      if (v % volumeInterval == 0) {        // If a major tick mark
        float textOffset = textAscent()/2;  // Center vertically
        if (v == dataMin) {
          textOffset = 0;                   // Align by the bottom
        } else if (v == dataMax) {
          textOffset = textAscent();        // Align by the top
        }
        text(floor(v), plotX1 - 10, y + textOffset);
        line(plotX1 - 4, y, plotX1, y);     // Draw major tick
      } else {
        //line(plotX1 - 2, y, plotX1, y);     // Draw minor tick
      }
    }
  }
}

void drawDataPoints(int col) {
  for (int row = 0; row < 100; row++) {
      float value = channel[currentColumn][0][row];
      float x = map(channel[currentColumn][1][row], timeMin, timeMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      point(x, y);
    }
}


void drawDataLine(int col) {  
  beginShape();
  for (int row = 0; row < 100; row++) {
      float value = channel[currentColumn][0][row];
      float x = map(channel[currentColumn][1][row], timeMin, timeMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);      
      vertex(x, y);
  }
  endShape();
}

void keyPressed() {
  if (key == '[') {
    currentColumn--;
    if (currentColumn < 0) {
      currentColumn = columnCount - 1;
    }
  } else if (key == ']') {
    currentColumn++;
    if (currentColumn == columnCount) {
      currentColumn = 0;
    }
  } else if (key == '1') {
    currentColumn = 0;  
  } else if (key == '2') {
    currentColumn = 1;  
  } else if (key == '3') {
    currentColumn = 2;  
  } else if (key == '4') {
    currentColumn = 3;  
  } else if (key == '5') {
    currentColumn = 4;  
  } else if (key == '6') {
    currentColumn = 5;  
  }
  
}

void drawTitleTabs() {
  rectMode(CORNERS);
  noStroke();
  textSize(20);
  textAlign(LEFT);

  // On first use of this method, allocate space for an array
  // to store the values for the left and right edges of the tabs
  if (tabLeft == null) {
    tabLeft = new float[columnCount];
    tabRight = new float[columnCount];
  }
  
  float runningX = plotX1; 
  tabTop = plotY1 - textAscent() - 15;
  tabBottom = plotY1;
  
  for (int col = 0; col < columnCount; col++) {
    String title = columnName[col];
    tabLeft[col] = runningX; 
    float titleWidth = textWidth(title);
    tabRight[col] = tabLeft[col] + tabPad + titleWidth + tabPad;
    
    // If the current tab, set its background white, otherwise use pale gray
    if(col<6){
      fill(col == currentColumn ? 255 : 224);
    }
    else{
     if((col==6 && measure)||(col==7 && squareWave)||(col==8 && sinWave)) fill(on);
     else fill(off); 
    }
    rect(tabLeft[col], tabTop, tabRight[col], tabBottom);
    
    // If the current tab, use black for the text, otherwise use dark gray
    fill(col == currentColumn ? 0 : 64);
    text(title, runningX + tabPad, plotY1 - 10);
    
    runningX = tabRight[col];
  }
}

void mousePressed() {
  if (mouseY > tabTop && mouseY < tabBottom) {
    for (int col = 0; col < columnCount; col++) {
      if (mouseX > tabLeft[col] && mouseX < tabRight[col]) {
        if(col < 6) setCurrent(col);
        else{
          measure=false;
          squareWave=false;
          sinWave=false;
          
          if(col==6) measure=true;
          else if(col==7) squareWave=true;
          else if(col==8) sinWave=true;
          //start measurements
          //send square wave and start measurements
          //send sine wave and start measurements
        }
      }
    }
  }
}

void setCurrent(int col) {
  currentColumn = col;
}

//example: ch0:123,ch1:123,ch2:123,ch3:123,ch4:123,ch5:123;
void serialEvent(Serial arduino){
  String listA[];
  //TODO
  data = arduino.readStringUntil(';');
  listA=split(data, ',');
}
