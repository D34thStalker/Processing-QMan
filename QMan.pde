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

Player player;

ArrayList tiles;

int tileCount = 50;

// Actual amount of tiles and locations
ArrayList allTilesOnMap;
// Available tiles after giving to the flippable
ArrayList allAvailableTilesOnMap;


ArrayList sprinklers;

boolean playing = false;

public void setup() {
  size(640, 640, JAVA2D);
  createGUI();
  customGUI();
  // Place your setup code here
}

void playGame() {
  setupGame();
  playing = true;
}

void setupGame() {
  tBase = new Sprite(this, "target.png", 1, 1, 100);
  //tBase.setFrameSequence(5 * 8 + 7, 5 * 8);
  fillGridArray();
  createTileArray();
  setupSprinklers();

  //  int randomIndex = (int)(random(0, tiles.size()));
  //  Tile t = (Tile)tiles.get(randomIndex);
  //  PVector randomPosition = t.getLoc();
  player = new Player(new PVector(64, 100));
}

public void draw() {
  background(230);
  if (playing) {
    background(#0000ff);
    rectMode(CORNER);
    stroke( #cccccc );
    for (int i = 0; i < allAvailableTilesOnMap.size(); i++) {
      stroke(#000000);
      fill( #cccccc );
      PVector e = (PVector)allAvailableTilesOnMap.get(i);
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

    //    tBase.setXY(96, 132);
    //    tBase.setRot(0);
    //    tBase.draw();

    player.draw();
  }
}

void fillGridArray() {
  allTilesOnMap = new ArrayList();
  allAvailableTilesOnMap = new ArrayList();
  for ( int x=min_x; x<max_x; x+=grid_size ) {
    for ( int y=min_y; y<max_y; y+=grid_size ) {
      allTilesOnMap.add(new PVector(x, y));
      allAvailableTilesOnMap.add(new PVector(x, y));
    }
  }
}

void createTileArray() {
  tiles = new ArrayList();
  // Create the Tiles
  for (int i = 0; i < tileCount; i++) {
    int randomIndex = (int)(random(0, allAvailableTilesOnMap.size()));
    PVector randomPosition = (PVector)allAvailableTilesOnMap.get(randomIndex);
    allAvailableTilesOnMap.remove(randomIndex);
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
  playGame();
}

void checkIfOnTile() {
  for ( int i = 0; i < tiles.size(); i++ ) {
    Tile t = (Tile)tiles.get(i);
    PVector playLoc = player.getLoc();
    PVector tileLoc = t.getLoc();
    if ((( playLoc.x > tileLoc.x )           && ( playLoc.x < tileLoc.x + t.w )           && ( playLoc.y > tileLoc.y )           && ( playLoc.y < tileLoc.y + t.h )) ||
      (( playLoc.x > tileLoc.x )           && ( playLoc.x < tileLoc.x + t.w )           && ( playLoc.y + player.h > tileLoc.y ) && ( playLoc.y + player.h < tileLoc.y + t.h )) ||
      (( playLoc.x + player.w > tileLoc.x ) && ( playLoc.x + player.w < tileLoc.x + t.w ) && ( playLoc.y + player.h > tileLoc.y ) && ( playLoc.y + player.h < tileLoc.y + t.h )) ||
      (( playLoc.x + player.w > tileLoc.x ) && ( playLoc.x + player.w < tileLoc.x + t.w ) && ( playLoc.y > tileLoc.y )           && ( playLoc.y < tileLoc.y + t.h )) ||
      (( tileLoc.x > playLoc.x )         && ( tileLoc.x < playLoc.x + player.w )         && ( tileLoc.y > playLoc.y )         && ( tileLoc.y < playLoc.y + player.h )) ||
      (( tileLoc.x > playLoc.x )         && ( tileLoc.x < playLoc.x + player.w )         && ( tileLoc.y + t.h > playLoc.y ) && ( tileLoc.y + t.h < playLoc.y + player.h )) ||
      (( tileLoc.x + t.w > playLoc.x ) && ( tileLoc.x + t.w < playLoc.x + player.w ) && ( tileLoc.y + t.h > playLoc.y ) && ( tileLoc.y + t.h < playLoc.y + player.h )) ||
      (( tileLoc.x + t.w > playLoc.x ) && ( tileLoc.x + t.w < playLoc.x + player.w ) && ( tileLoc.y > playLoc.y )         && (tileLoc.y < playLoc.y + player.h ))) {
      println("On Tile " + i);
      t.flipTile();
    }
  }
}

void keyPressed() {
  switch(key) {
  case 'r':
  case 'R':
    setupGame();
    break;
  case 'w':
  case 'W':
    if (playing)
      player.move(1);
      checkIfOnTile();
    break;
  case 's':
  case 'S':
    if (playing)
      player.move(2);
      checkIfOnTile();
    break;
  case 'a':
  case 'A':
    if (playing)
      player.move(3);
      checkIfOnTile();
    break;
  case 'd':
  case 'D':
    if (playing)
      player.move(4);
      checkIfOnTile();
    break;
  }
  //  switch(keyCode) {
  //  case UP:
  //    if (playing)
  //      player.move(1);
  //    break;
  //  case DOWN:
  //    if (playing)
  //      player.move(2);
  //    break;
  //  case LEFT:
  //    if (playing)
  //      player.move(3);
  //    break;
  //  case RIGHT:
  //    if (playing)
  //      player.move(4);
  //    break;
  //  }
}

void keyReleased() {
}

