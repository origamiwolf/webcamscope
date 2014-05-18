// Run this program only in the Java mode inside the IDE,
// not on Processing.js (web mode)!!

import processing.video.*;

Capture cam;

// line measurement variables
int xStart = 0;
int yStart = 0;
int xFin = 0;
int yFin = 0;
float lineDist = 0.0;
int tmpMouseX = 0;
int tmpMouseY = 0;

int camImageH = 480;
int camImageW = 640;
int camFPS = 100;
int textBarH = 60;

// calibration variables
int calButtonX = camImageW - 100;  // relative to text bar box
int calButtonY = camImageH;               // relative to text bar box
int calButtonW = 100;
int calButtonH = 20;
int calPoint1X = 0;
int calPoint1Y = 0;
int calPoint2X = 0;
int calPoint2Y = 0;
int calInputLength = 0;
color calButtonColour = #00FFFF;
color calButtonOverColour = #00AAFF;
boolean calButtonOver = false;

// text input variables
String calLength="_";
String tmpString = "";

byte mode = 0; 
// 0 - normal, 1 - calibration point 1, 2 - calibration point 2, 3 - cal input
// 4 - linedraw 

void setup() {
  size(camImageW, camImageH + textBarH);
  cam = new Capture(this, camImageW, camImageH, camFPS);
  cam.start();
  fill(0);
  rect(0,camImageH,camImageW,camImageH + textBarH);
  fill(255);
  text("Length", 10, camImageH + 20);
}

void draw() {
  if(cam.available()) {
    cam.read();
  }
  image(cam, 0, 0);

// draw calibration button  
  if (overCalButton()) {
    fill(calButtonOverColour);
  } else {
    fill(calButtonColour);
  }
  rect(calButtonX, calButtonY, calButtonW, calButtonH);

  if (mode == 2 || mode == 3)
  {
      fill(255);
      line(calPoint1X - 20, calPoint1Y, calPoint1X + 20, calPoint1Y);
      line(calPoint1X, calPoint1Y-20, calPoint1X, calPoint1Y+20);
    if (mode == 3) {
      fill(255);
      line(calPoint2X - 20, calPoint2Y, calPoint2X + 20, calPoint2Y);
      line(calPoint2X, calPoint2Y-20, calPoint2X, calPoint2Y+20);
      rect(camImageH/2, camImageW/2, textWidth("Distance?") + 35, 40);
      fill(0);
      text("Distance?", camImageH/2 + 15, camImageW/2 + 15);
      text(calLength, camImageH/2 + 15, camImageW/2 + 30);
    }    
  }
 
  if (mode == 4) {
    if (mouseX >= 0 && mouseX <= camImageW &&
        mouseY >= 0 && mouseY <= camImageH) { 
      tmpMouseX = mouseX;
      tmpMouseY = mouseY;
    }
    line(xStart, yStart, tmpMouseX, tmpMouseY);
    lineDist = sqrt(sq(tmpMouseX-xStart) + sq(tmpMouseY-yStart));
    fill(0);
    rect(0,camImageH + 30,100,10);
    fill(255);
    text(lineDist, 10, camImageH + 40);
  }
  

}

void mousePressed() {

  // if within the camera image
  if (mouseX >= 0 && mouseX <= camImageW &&
      mouseY >= 0 && mouseY <= camImageH) {
  // normal mode
      if (mode == 0) {
      mode = 4;
      xStart = mouseX;
      yStart = mouseY;
    } else if (mode == 1) {
      mode = 2;
      calPoint1X = mouseX;
      calPoint1Y = mouseY;
      fill(0);
      rect(calButtonX - 100, calButtonY+30,100,15);
      fill(255);  
      text("Pick second point", calButtonX - 100, calButtonY+40);       
    } else if (mode == 2) {
      mode = 3;
      calPoint2X = mouseX;
      calPoint2Y = mouseY;
      fill(0);
      rect(calButtonX - 100, calButtonY+10,100,15);
      rect(calButtonX - 100, calButtonY+30,100,15);
    }      
  }
  
  // if over the calibration button
  if (mouseX >= calButtonX && mouseX <= calButtonX + calButtonW &&
      mouseY >= calButtonY && mouseY <= calButtonY + calButtonH) {

    // enter calibration mode        
    if (mode == 0) {
      mode = 1;
      fill(255);
      text("CALIBRATION", calButtonX - 100, calButtonY+20);   
      text("Pick first point", calButtonX - 100, calButtonY+40);  
    } 
  }
}

void mouseReleased() {
  if (mode == 4) {
    mode = 0;
  }
}

boolean overCalButton()
{
  if (mouseX >= calButtonX && mouseX <= calButtonX + calButtonW &&
      mouseY >= calButtonY && mouseY <= calButtonY + calButtonH) {
    return true;
  } else {
    return false;
  }  
}

void keyTyped() {
// only in calibration mode (mode 3)
  if (mode == 3) {
    // enter key finishes everything
    if (key == '\n') {
      calInputLength = int(tmpString);
      calLength = "_";
      tmpString = "";
      mode = 0;
    } else if (key >= '0' && key <= '9' && tmpString.length() < 4) {
      tmpString += key;
      calLength = tmpString + "_";
    } else if (key == BACKSPACE && tmpString.length() > 0) {
      tmpString = tmpString.substring(0, tmpString.length() - 1);
      calLength = tmpString + "_";
    }
  }
}


