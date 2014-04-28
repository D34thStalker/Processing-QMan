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

int tileCount = 50;
int tilesFlipped;

Player player;
ArrayList<Enemy> enemies;
int moveTimer = 0;
ArrayList<Tile> tiles;
// Actual number of tiles and locations
ArrayList<PVector> allTilesOnMap;
// Available tiles after giving to the flippable
ArrayList<PVector> allAvailableTilesOnMap;
ArrayList<Sprite> sprinklers;

boolean playing = false;

public void setup() {
  size(640, 640, JAVA2D);
  frameRate(30);
  createGUI();
  customGUI();
  // Place your setup code here
  background(loadImage("bg.jpg"));
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

  tilesFlipped = 0;

  //  int randomIndex = (int)(random(0, tiles.size()));
  //  Tile t = (Tile)tiles.get(randomIndex);
  //  PVector randomPosition = t.getLoc();
  player = new Player(new PVector(64, 100), new Sprite(this, "QMan.png", 1, 1, 100));
  enemies = new ArrayList<Enemy>();
  enemies.add(new Enemy(new PVector(512, 100), new Sprite(this, "Enemy.png", 1, 1, 100)));
  enemies.add(new Enemy(new PVector(512, 484), new Sprite(this, "Enemy.png", 1, 1, 100)));
}

public void draw() {
  // background(230);
  if (playing) {
    background(#0000ff);
    rectMode(CORNER);
    stroke( #cccccc );
    for (PVector e : allAvailableTilesOnMap) {
      stroke(#000000);
      fill( #cccccc );
      rect(e.x, e.y, 64, 64);
    }
    for (Tile t : tiles) { 
      t.draw();
    }
    for (Sprite s : sprinklers) {
      s.draw();
    }

    //    tBase.setXY(96, 132);
    //    tBase.setRot(0);
    //    tBase.draw();

    player.draw();
    for (Enemy e : enemies) { 
      if (e.moveTimer == 0) e.chase(player);
      e.moveTimer++;
      if (e.moveTimer >= 20) e.moveTimer = 0;
      e.draw();
    }

    checkIfWon();
    checkIfLost();

    // println("tilesFlipped : " + tilesFlipped);
  }
}

void fillGridArray() {
  allTilesOnMap = new ArrayList<PVector>();
  allAvailableTilesOnMap = new ArrayList<PVector>();
  for ( int x=min_x; x<max_x; x+=grid_size ) {
    for ( int y=min_y; y<max_y; y+=grid_size ) {
      allTilesOnMap.add(new PVector(x, y));
      allAvailableTilesOnMap.add(new PVector(x, y));
    }
  }
}

void createTileArray() {
  tiles = new ArrayList<Tile>();
 
  /*
  ArrayList<Integer>colors = new ArrayList<Integer>();
  colors.add(#7628ca);
  colors.add(#ffff00);
  colors.add(#ff8f00);
  */

  // Create the Tiles
  for (int i = 0; i < tileCount; i++) {
    int randomIndex = (int)(random(0, allAvailableTilesOnMap.size()));
    PVector randomPosition = allAvailableTilesOnMap.get(randomIndex);
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

void checkIfWon() {
  if (tilesFlipped == tileCount) {
    println("YOU WIN!");
    playing = false;
  }
}

void checkIfLost() {
  for ( Enemy e : enemies ) {
    if ( e.getSprite().bb_collision(player.getSprite()) ) {
      println("YOU LOSE!");
      playing = false;
    }
  }
}

void checkIfOnTile() {
  for ( Tile t : tiles ) {
    PVector playLoc = player.getLoc();
    PVector tileLoc = t.getLoc();
    if ((( playLoc.x > tileLoc.x )           && ( playLoc.x < tileLoc.x + t.w )           && ( playLoc.y > tileLoc.y )           && ( playLoc.y < tileLoc.y + t.h )) ||
      (( playLoc.x > tileLoc.x )           && ( playLoc.x < tileLoc.x + t.w )           && ( playLoc.y + player.h > tileLoc.y ) && ( playLoc.y + player.h < tileLoc.y + t.h )) ||
      (( playLoc.x + player.w > tileLoc.x ) && ( playLoc.x + player.w < tileLoc.x + t.w ) && ( playLoc.y + player.h > tileLoc.y ) && ( playLoc.y + player.h < tileLoc.y + t.h )) ||
      (( playLoc.x + player.w > tileLoc.x ) && ( playLoc.x + player.w < tileLoc.x + t.w ) && ( playLoc.y > tileLoc.y )           && ( playLoc.y < tileLoc.y + t.h ))) {
      t.flip();
    }
  }
}

void keyPressed() {
  switch(key) {
  case 'r':
  case 'R':
    playGame();
    break;
  case 'w':
  case 'W':
    if (playing) {
      if (!player.willHit(NORTH)) {
        player.move(NORTH);
        checkIfOnTile();
      }
    }
    break;
  case 's':
  case 'S':
    if (playing) {
      if (!player.willHit(SOUTH)) {
        player.move(SOUTH);
        checkIfOnTile();
      }
    }
    break;
  case 'a':
  case 'A':
    if (playing) {
      if (!player.willHit(WEST)) {
        player.move(WEST);
        checkIfOnTile();
      }
    }
    break;
  case 'd':
  case 'D':
    if (playing) {
      if (!player.willHit(EAST)) {
        player.move(EAST);
        checkIfOnTile();
      }
    }
    break;
  default:
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

