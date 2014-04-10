import sprites.utils.*;
import sprites.maths.*;
import sprites.*;

// Need G4P library
import g4p_controls.*;

import java.awt.Font;
import java.awt.*;


public void setup(){
  size(640, 640, JAVA2D);
  createGUI();
  customGUI();
  // Place your setup code here
  
}

public void draw(){
  background(230);
  
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){
   title.setFont(new Font("Dialog", Font.PLAIN, 24));
}
