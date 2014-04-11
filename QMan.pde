import sprites.utils.*;
import sprites.maths.*;
import sprites.*;

// Need G4P library
import g4p_controls.*;

import java.awt.Font;
import java.awt.*;


Sprite tBase;

int min_x = 64;
int min_y = 100;
int max_x = 576;
int max_y = 512;
int grid_size = 64;

final int NORTH = 0;
final int WEST = 1;
final int SOUTH = 2;
final int EAST = 3;

ArrayList tiles;

int tileCount = 35;

ArrayList allTilesOnMap;


ArrayList sprinklers;

public void setup() {
  size(640, 640, JAVA2D);
  //createGUI();
  //customGUI();
  // Place your setup code here
  tBase = new Sprite(this, "target.png", 1, 1, 100);
  //tBase.setFrameSequence(5 * 8 + 7, 5 * 8);
  fillGridArray();
  createTileArray();
  setupSprinklers();
}

public void draw() {
  background(230);
  stroke( #cccccc );
  for (int i = 0; i < allTilesOnMap.size(); i++) {
    stroke(#000000);
    fill( #cccccc );
    PVector e = (PVector)allTilesOnMap.get(i);
    rect(e.x, e.y, 64, 64);
  }
  for (int i = 0; i < tiles.size(); i++) {
    Tile t = (Tile)tiles.get(i);
    t.draw();
  }
  for (int i = 0; i < sprinklers.size(); i++) {
    Sprite s = (Sprite)sprinklers.get(i);
    s.draw();
  }

  tBase.setXY(96, 132);
  tBase.setRot(0);
  tBase.draw();
}

void fillGridArray() {
  allTilesOnMap = new ArrayList();
  for ( int x=min_x; x<max_x; x+=grid_size ) {
    for ( int y=min_y; y<max_y; y+=grid_size ) {
      allTilesOnMap.add(new PVector(x, y));
    }
  }
}

void createTileArray() {
  tiles = new ArrayList();
  // Create the Tiles
  for (int i = 0; i < tileCount; i++) {
    int randomIndex = (int)(random(0, allTilesOnMap.size()));
    PVector randomPosition = (PVector)allTilesOnMap.get(randomIndex);
    allTilesOnMap.remove(randomIndex);
    Tile t = new Tile(randomPosition);
    tiles.add(t);
  }
}

void setupSprinklers() {
  sprinklers = new ArrayList();
  boolean first = true;
  int x = 0;
  // Create the Sprinklers
  for ( int i = 0; i < 2; i++ ) {
    for ( int y = min_y; y < max_y; y+=grid_size ) {
      if (first) x = 32;
      else x = width - 31;
      Sprite s = new Sprite(this, "sprinkler.jpg", 1, 1, 100);
      s.setXY(x, y+32);
      sprinklers.add(s); 
    }
    first = !first;
  }
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI() {
  title.setFont(new Font("Dialog", Font.PLAIN, 24));
}

public void startGame() {
  println("started");
}

void keyPressed() {
  switch(key) {
  case 'r':
  case 'R':
    fillGridArray();
    createTileArray();
    break;
  }
}

