/**
 * drawing with a changing shape by draging the mouse.
 *    
 * MOUSE
 * position x          : length
 * position y          : thickness and number of lines
 * drag                : draw
 * 
 * KEYS
 * del, backspace      : erase
 * s                   : save png
 * r                   : start pdf record
 * e                   : end pdf record
 */

import processing.pdf.*;
import java.util.Calendar;

boolean recordPDF = false;
PVector loc = new PVector (0, 0);

void setup(){
  size(1920, 1080);
  smooth();
  noFill();
  background(255);
  
}

void draw(){
  //if(mousePressed){
    pushMatrix();
    translate(width/2,height/2);

    //int circleResolution = (int)map(mouseY+100,0,height,2, 10);
    int circleResolution = (int)map(loc.y+100,0,height,2, 10);
    float radius = loc.x-width/2 + 0.5;
    float angle = TWO_PI/circleResolution;

    strokeWeight(2);
    colorMode(HSB, (int) Math.sqrt(height*height + width*width));
    stroke( (float) ((Math.sqrt(height*height + width*width))-Math.sqrt((width-loc.x)*loc.x+(height-loc.y)*(loc.y))*2), loc.y*2, loc.x*2, 25);

    beginShape();
    for (int i=0; i<=circleResolution; i++){
      float x = 0 + cos(angle*i) * radius;
      float y = 0 + sin(angle*i) * radius;
      vertex(x, y);
    }
    endShape();
    
    popMatrix();
    loc.x += (int) random(-20, 20);
    loc.y += (int) random(-20, 20);
    if(loc.x > width || loc.x < 0) {
      loc.x = width/2;
    }
    if(loc.y > height || loc.y < 0) {
      loc.y = height/2;
    }
  //}
  
}

void keyReleased(){
  if (key == DELETE || key == BACKSPACE) background(255);
  if (key=='s' || key=='S') saveFrame(timestamp()+"_##.png");

  // ------ pdf export ------
  // press 'r' to start pdf recording and 'e' to stop it
  // ONLY by pressing 'e' the pdf is saved to disk!
  if (key =='r' || key =='R') {
    if (recordPDF == false) {
      beginRecord(PDF, timestamp()+".pdf");
      println("recording started");
      recordPDF = true;
      smooth();
      noFill();
      background(255);
    }
  } 
  else if (key == 'e' || key =='E') {
    if (recordPDF) {
      println("recording stopped");
      endRecord();
      recordPDF = false;
      background(255); 
    }
  }  
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}