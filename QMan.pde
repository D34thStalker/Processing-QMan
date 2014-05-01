import gifAnimation.*;

import sprites.utils.*;
import sprites.maths.*;
import sprites.*;

// Need G4P library
import g4p_controls.*;

import java.awt.Font;
import java.awt.*;

Nut nut;
boolean isNut = false;

Sprite squirrel;
boolean stunEnemies = false;

Gif grass;

int min_x = 64;
int min_y = 100;
int max_x = 576;
int max_y = 512;
int grid_size = 64;

final int NORTH = 0;
final int WEST = 1;
final int SOUTH = 2;
final int EAST = 3;

int obstacleCount = 5;

int tilesFlipped;

Player player;
ArrayList<Enemy> enemies;
ArrayList<Tile> tiles;
// Actual number of tiles and locations
ArrayList<PVector> allTilesOnMap;
// Available tiles after giving to the flippable ( OBSTACLES )
ArrayList<PVector> allAvailableTilesOnMap;
ArrayList<Sprinkler> sprinklers;
ArrayList<Obstacle> obstacles;

boolean playing = false;
boolean win = false;

int squirrelRot = 0;
int sCounter = 0;
int gCounter = 0;

public void setup() {
  size(640, 640, JAVA2D);
  frameRate(60);
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
  grass = new Gif(this, "grass.gif");
  fillGridArray();
  createObstacles();
  createTileArray();
  setupSprinklers();

  tilesFlipped = 0;
  isNut = false;
  stunEnemies = false;
  stunTimer = 0;
  gCounter = 0;
  sCounter = 0;
  squirrelRot = 0;

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
    drawObstacles();
    drawTiles();
    drawSprinklers();

    if (isNut) nut.draw();
    else {
      double nut_probability = 0.005;
      int randomNumber = (int)(random(0, 1000));
      // println("randomNumber: " + randomNumber);

      if (randomNumber <= nut_probability*1000) dropNut();
    }

    player.draw();

    for (Enemy e : enemies) { 
      if (e.moveTimer == 0 && !stunEnemies) e.chase(player);
      e.moveTimer++;
      if (e.moveTimer >= 60) e.moveTimer = 0;
      e.draw();
    }

    if (stunEnemies) stunTheEnemies();
    checkIfHitNut();
    checkIfWon();
    checkIfLost();
    // println("tilesFlipped : " + tilesFlipped);
  }
  if (win) {
    background(#0000ff);
    drawObstacles();
    drawSprinklers();

    switch(gCounter) {
    case 0: 
      runSprinklerAnimation();
      break;
    case 60:
    case 120:
    case 180:
      grass.play();
      break;
    case 90:
    case 150:
      grass.pause();
      break;
    case 209:
      grass.stop();
      break;
    }
    drawGrass();
    if (gCounter < 210) gCounter++;
  }
}

void drawObstacles() {
  for (Obstacle o : obstacles) {
    o.draw();
  }
}

void drawTiles() {
  for (Tile t : tiles)
    t.draw();
}

void drawSprinklers() {
  for (Sprinkler s : sprinklers)
    s.draw();
}

PVector [][] tileMap = new PVector[8][] ;

void fillGridArray() {
  int x_array_pos = 0;
  int y_array_pos = 0;

  allTilesOnMap = new ArrayList<PVector>();
  allAvailableTilesOnMap = new ArrayList<PVector>();
  for ( int x=min_x; x<max_x; x+=grid_size ) {
    for ( int y=min_y; y<max_y; y+=grid_size ) {
      allTilesOnMap.add(new PVector(x, y));
      allAvailableTilesOnMap.add(new PVector(x, y));
      
      tileMap[x_array_pos][y_array_pos] = new PVector(x, y);
      y_array_pos++;
    }
    x_array_pos++;
    y_array_pos = 0;
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
  for (int i = 0; i < allAvailableTilesOnMap.size(); i++)
    tiles.add(new Tile(new PVector(allAvailableTilesOnMap.get(i).x, allAvailableTilesOnMap.get(i).y)));
  allAvailableTilesOnMap.clear();
}

void createObstacles() {
  /****** CORNERS ********/
  // x = 64, x = 512
  // y = 100, y = 484
  // 64, 100, 0
  // 64, 484, 0
  // 512, 100, 0
  // 512, 484, 0
  /***********************/
  obstacles = new ArrayList<Obstacle>();

  for (int i = 0; i < obstacleCount; i++) {
    int randomIndex = (int)(random(0, allAvailableTilesOnMap.size()));
    PVector randomPosition = allAvailableTilesOnMap.get(randomIndex);
    allAvailableTilesOnMap.remove(randomIndex);
    obstacles.add(new Obstacle(randomPosition, loadImage("obstacles/obstacle"+i+".png")));
  }
}

void setupSprinklers() {
  int num = 0;
  sprinklers = new ArrayList<Sprinkler>();
  boolean first = true;
  int x = 0;
  // Create the Sprinklers
  for ( int i = 0; i < 2; i++ ) {
    for ( int y = min_y; y < max_y; y+=grid_size ) {
      if (first) {
        x = 0;
        num = 0;
      }
      else {
        x = width - 64;
        num = 1;
      }
      Sprinkler s = new Sprinkler(new PVector(x, y), new Gif(this, "sprinkler"+num+".gif"));
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
  if (tilesFlipped == tiles.size()) {
    println("YOU WIN!");
    playing = false;
    win = true;
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

void drawGrass() {
  for ( Tile t : tiles ) {
    image(grass, t.getLoc().x, t.getLoc().y);
  }
}

void runSprinklerAnimation() {
  for ( Sprinkler s : sprinklers ) {
    s.play();
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

void checkIfHitNut() {
  if (!isNut) return;
  if ( player.getSprite().bb_collision(nut.getSprite()) ) {
    println("Got a Nut!");
    stunEnemies = true;
    isNut = false;
    nut = null;
    squirrel = new Sprite(this, "squirrel.png", 1, 1, 100);
  }
}


void dropNut() {
  if (stunEnemies) return;
  int randomIndex = (int)(random(0, tiles.size()));
  PVector randomPosition = tiles.get(randomIndex).getLoc();
  nut = new Nut(randomPosition, new Sprite(this, "nut.png", 1, 1, 100));
  isNut = true;
}

int stunTimer = 0;
void stunTheEnemies() {
  if (stunTimer == 150) {
    stunTimer = 0;
    stunEnemies = false; 
    squirrel = null;
    return;
  }
  if (sCounter == 0)
    squirrelRot--;
  sCounter++;
  if (sCounter >= 10)
    sCounter = 0;

  for ( Enemy e : enemies ) {
    squirrel.setXY(e.getLoc().x+32, e.getLoc().y+32);
    squirrel.setRot(squirrelRot);
    squirrel.draw();
  }
  stunTimer++;
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

