import sprites.utils.*;
import sprites.maths.*;
import sprites.*;

// Need G4P library
import g4p_controls.*;

import java.awt.Font;
import java.awt.*;


Sprite tBase;


public void setup(){
  size(640, 640, JAVA2D);
  createGUI();
  customGUI();
  // Place your setup code here
  tBase = new Sprite(this, "target.png", 1, 1, 100);
  //tBase.setFrameSequence(5 * 8 + 7, 5 * 8);
}

public void draw(){
  background(230);
  tBase.setXY(50, 50);
  tBase.setRot(0);
  tBase.setSpeed(1, 0);
  tBase.stopImageAnim();
  tBase.draw();
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){
   title.setFont(new Font("Dialog", Font.PLAIN, 24));
}

public void startGame() {
  println("started");
}
