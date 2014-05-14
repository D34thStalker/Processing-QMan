import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

import gifAnimation.*;

import sprites.utils.*;
import sprites.maths.*;
import sprites.*;

// Need G4P library
import g4p_controls.*;

import java.awt.Font;
import java.awt.*;

Minim minim;

AudioSnippet theme;
AudioSnippet song;
AudioSnippet credit;

String where = "";
String setWhere = "";

Integer levelNumber = 1;

PFont f;

Nut nut;
boolean isNut = false;

Sprite squirrel;
boolean stunEnemies = false;

int min_x = 64;
int min_y = 100;
int max_x = 576;
int max_y = 512;
int grid_size = 64;

final int NORTH = 0;
final int WEST = 1;
final int SOUTH = 2;
final int EAST = 3;

final int MAX_X_MAP = 8;
final int MAX_Y_MAP = 7;

int obstacleCount = 0;

int tilesFlipped;
int moves = 0;

Player player;
ArrayList<Enemy> enemies;
ArrayList<Tile> tiles;
// Actual number of tiles and locations
ArrayList<PVector> allTilesOnMap;
// Available tiles after giving to the flippable ( OBSTACLES )
ArrayList<PVector> allAvailableTilesOnMap;
ArrayList<Sprinkler> sprinklers;
ArrayList<Obstacle> obstacles;

int squirrelRot = 0;
int sCounter = 0;
int gCounter = 0;

PVector [][] tileMap = new PVector[8][7] ;
HashMap<PVector, PVector> pointToTileMapPosition = new HashMap<PVector, PVector>();
Set<PVector> moveSet = new HashSet<PVector>();

// IMAGES
ArrayList<PImage> obstacleImages;
ArrayList<PImage> grassImages;
ArrayList<Gif> sprinklerImages;
Sprite playerSprite;
Sprite enemySprite;
Sprite enemySprite1;
Sprite squirrelSprite;
Sprite nutSprite;

// Sounds
AudioSnippet sprinklerSound;

// DATA
PrintWriter writer;
BufferedReader reader;
String line;
String[] scores;
int[] topScores;

// Scores Scene
int scoreLevel = 1;

public void setup() {
  size(640, 640, JAVA2D);
  frameRate(60);
  createGUI();
  customGUI();
  // Place your setup code here
  background(loadImage("bg.jpg"));

  minim = new Minim(this);

  f = createFont("Verdana", 34, true);

  InstantiateSounds();
  InstantiateLists();
  LoadImages();

  //showMenu();
  showCredits();
}


void switchToLevel(int level) {
  switch(level) {
  case 1:
    obstacleCount = 2;
    break;
  case 2:
    obstacleCount = 3;
    break;
  case 3:
    obstacleCount = 4;
    break;
  case 4:
    obstacleCount = 5;
    break;
  }
}

void InstantiateSounds() {
  sprinklerSound = minim.loadSnippet("sprinkler.wav");
  theme = minim.loadSnippet("theme.mp3");
  song = minim.loadSnippet("song.mp3");
  credit = minim.loadSnippet("credits.mp3");
}

void InstantiateLists() {
  tiles = new ArrayList<Tile>();
  enemies = new ArrayList<Enemy>();
  obstacles = new ArrayList<Obstacle>();
  sprinklers = new ArrayList<Sprinkler>();

  obstacleImages = new ArrayList<PImage>();
  grassImages = new ArrayList<PImage>();
  sprinklerImages = new ArrayList<Gif>();
}
void LoadImages() {

  for (int i = 0; i < 5; i++)
    obstacleImages.add(loadImage("obstacles/obstacle"+i+".png"));

  for (int i = 0; i < 4; i++)
    grassImages.add(loadImage("grass/grass"+i+".png"));


  for (int i = 0; i < 2; i++)
    sprinklerImages.add(new Gif(this, "sprinkler"+i+".gif"));

  playerSprite = new Sprite(this, "characters/qman.png", 1, 1, 100);
  enemySprite = new Sprite(this, "characters/security-guard.png", 1, 1, 100);
  enemySprite1 = new Sprite(this, "characters/security-guard-2.png", 1, 1, 100);

  squirrelSprite = new Sprite(this, "squirrel.png", 1, 1, 100);
  nutSprite = new Sprite(this, "nut.png", 1, 1, 100);
}

void playGame() {
  switchToLevel(levelNumber);

  fillGridArray();
  createObstacles();
  createTileArray();
  setupSprinklers();

  tilesFlipped = 0;
  moves = 0;
  isNut = false;
  stunEnemies = false;
  stunTimer = 0;
  gCounter = 0;
  sCounter = 0;
  squirrelRot = 0;

  player = new Player(tileMap[0][0], playerSprite);

  enemies.add(new Enemy(tileMap[MAX_X_MAP-1][0], enemySprite));
  if (levelNumber > 2)
    enemies.add(new Enemy(tileMap[MAX_X_MAP-1][MAX_Y_MAP-1], enemySprite1));


  levelLabel.setText("Level " + levelNumber);

  setLoadUp("game");
}

void resetGame() {
  for (Sprinkler s : sprinklers)
    s.jump(0);

  switchToLevel(levelNumber);
  clearGame();
  playGame();

  continueBtn.setVisible(false);
  resetBtn.setVisible(false);
  levelLabel.setVisible(true);
  movesLabel.setVisible(true);
  backBtn.setVisible(true);
}

void clearGame() {
  if (where.equals("win")) stopSprinklerAnimation();
  allTilesOnMap.clear();
  allAvailableTilesOnMap.clear();
  enemies.clear();
  tiles.clear();
  obstacles.clear();
  sprinklers.clear();
}

public void draw() {
  // background(230);
  if (where.equals("loading")) {
    loading();
  }
  if (where.equals("menu")) {
    menu();
  }
  if (where.equals("scores")) {
    scoresScreen();
  }
  if (where.equals("game")) {
    game();
  }
  if (where.equals("win")) {
    winScreen();
  }
  if (where.equals("lose")) {
    loseScreen();
  }
  if (where.equals("credits")) {
    credits();
  }
}

void setLoadUp(String w) {
  where = "loading";
  setWhere = w;

  title.setVisible(false);
  startBtn.setVisible(false);
  movesLabel.setVisible(false);
  scoresBtn.setVisible(false);
  levelLabel.setVisible(false);
  score1.setVisible(false);
  score2.setVisible(false);
  score3.setVisible(false);
  score4.setVisible(false);
  backBtn.setVisible(false);
  continueBtn.setVisible(false);
  resetBtn.setVisible(false);
}

void setScene(String scene) {
  where = scene;
  setWhere = "";
}

int loadingCounter = 0;
void loading() {
  background(#0000ff);

  loadingCounter++;
  if (loadingCounter >= 15) {
    setScene(setWhere);
    loadingCounter = 0;
  }
}

void menu() {
  background(loadImage("bg.jpg"));
}

void game() {
  background(#0000ff);
  rectMode(CORNER);
  drawObstacles();
  drawTiles();
  drawSprinklers();

  if (levelNumber > 2) {
    if (isNut) nut.draw();
    else {
      double nut_probability = 0.005;
      int randomNumber = (int)(random(0, 1000));
      // println("randomNumber: " + randomNumber);

      if (randomNumber <= nut_probability*1000) dropNut();
    }
  }

  player.draw();

  //println(pointToTileMapPosition.get(player.getLoc()));

  moveSet.clear();
  for (Enemy e : enemies) { 
    if (e.readyToMove() && !stunEnemies) {
      e.setNextMove(player);
      // Try to see if the next position is already taken by another enemy.
      // If so, remove it from possible list of moves.
      if (!moveSet.add(e.getNextPosition())) {
        println("OVERLAP! REMOVING POSITION!");
        e.removeMove(e.getNextMove());
      }
      e.chase(player);
    }
    e.incrementMoveTimer();
    e.draw();
  }

  movesLabel.setText("Total Steps: " + moves);
  if (stunEnemies) stunTheEnemies();
  checkIfHitNut();
  checkIfWon();
  checkIfLost();
  // println("tilesFlipped : " + tilesFlipped);
}

void winScreen() {
  background(#0000ff);
  if (levelNumber < 4) {
    drawObstacles();
    drawSprinklers();

    if (gCounter == 0)
      runSprinklerAnimation();
    if (gCounter < 89)
      drawGrass();
    else
      changeGrass();

    if (gCounter < 90) gCounter++;
    else continueBtn.setVisible(true);
  } 
  else {
    // THIS IS WHERE THE "PARTY" SCENE IS HAPPENING!!!
    // YOU WON THE GAME!!!
  }
}

void loseScreen() {
  background(#0000ff);
  resetBtn.setVisible(true);
}

void scoresScreen() {
  // Show the top scores
  background(#0000ff);
  startBtn.setVisible(false);
  scoresBtn.setVisible(false);

  fill(#ffffff);
  textAlign(CENTER);
  textFont(f, 30);
  text("TOP SCORES", width/2, 100);
  textFont(f, 26);
  int scoreLength = topScores.length > 10 ? 10 : topScores.length;
  text("Level " + scoreLevel + " Scores", width/2, 250);

  if (scoreLength == 0) {
    text("There are no scores yet.", width/2, 300);
    return;
  }
  for (int i = 0; i < scoreLength; i++) {
    text((i+1) + ": " + topScores[i] + " Steps", width/2, 300+(i*25));
  }
}


float creditY = 0;
float finalTextY = 0;
float creditIncrement = .75;
void credits() {
  background(loadImage("bg.jpg"));
  fill(#ff0000);
  textAlign(CENTER);
  textFont(f, 30);

  text("QMAN", width/2, height-creditY);
  text("Developed by \n Michael Squitieri \n Julius Btesh", width/2-200, height+75-creditY, 400, 200);
  text("THANK YOU FOR PLAYING", width/2, finalTextY);

  if (finalTextY > height/2) {
    creditY += creditIncrement;
    finalTextY -= creditIncrement;
  }
}

void showCredits() {
  setLoadUp("credits");

  song.cue(0);
  song.pause();
  credit.play();
  
  finalTextY = height+550;
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
      pointToTileMapPosition.put(new PVector(x, y), new PVector(x_array_pos, y_array_pos));
      y_array_pos++;
    }
    x_array_pos++;
    y_array_pos = 0;
  }
}

void createTileArray() {
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
  for (int i = 0; i < obstacleCount; i++) {

    PVector randomPosition = null;

    do {
      int randomX = (int)(random(1, 7));
      int randomY = (int)(random(1, 6));

      randomPosition = tileMap[randomX][randomY];
    } 
    while (obstacles.contains (new Obstacle (randomPosition)));

    // int randomIndex = (int)(random(0, allAvailableTilesOnMap.size()));
    // PVector randomPosition = allAvailableTilesOnMap.get(randomIndex);
    allAvailableTilesOnMap.remove(randomPosition);

    if (levelNumber < 4) 
      obstacles.add(new Obstacle(randomPosition, grassImages.get(levelNumber-1)));
    else
      obstacles.add(new Obstacle(randomPosition, obstacleImages.get(i)));
  }
}

void setupSprinklers() {
  int num = 0;
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
      Sprinkler s = new Sprinkler(new PVector(x, y), sprinklerImages.get(num));
      sprinklers.add(s);
    }
    first = !first;
  }
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI() {
  title.setFont(new Font("Dialog", Font.PLAIN, 24));
  movesLabel.setFont(new Font("Dialog", Font.PLAIN, 24));
  levelLabel.setFont(new Font("Dialog", Font.BOLD, 28));

  title.setVisible(true);
  startBtn.setVisible(true);
  scoresBtn.setVisible(true);
  movesLabel.setVisible(false);
  backBtn.setVisible(false);
  levelLabel.setVisible(false);
  continueBtn.setVisible(false);
  resetBtn.setVisible(false);

  score1.setVisible(false);
  score2.setVisible(false);
  score3.setVisible(false);
  score4.setVisible(false);
}

public void startGame() {
  println("started"); 
  levelNumber = 1;
  playGame();

  theme.cue(0);
  theme.pause();
  song.loop();

  title.setVisible(false);
  startBtn.setVisible(false);
  scoresBtn.setVisible(false);
  levelLabel.setVisible(true);
  movesLabel.setVisible(true);
  backBtn.setVisible(true);
}

void checkIfWon() {
  if (tilesFlipped == tiles.size()) {
    setLoadUp("win");

    readTopScores(levelNumber);
    writeTopScores(levelNumber);
  }
}

void writeTopScores(int level) {
  writer = createWriter(dataPath("topScores"+level+".txt"));
  if ( scores != null && scores.length > 0) {
    String[] tempScores = new String[scores.length];
    for (int i = 0; i < scores.length-1; i++) {
      tempScores[i] = scores[i];
    } 
    tempScores[tempScores.length-1] = str(moves);
    for (int i = 0; i < tempScores.length; i++) {
      writer.print(tempScores[i]+",");
    }
  } 
  else {
    writer.print(moves+",");
  }

  writer.flush(); // write any buffered data to the file
  writer.close(); // close the file
}

void readTopScores(int level) {
  reader = createReader(dataPath("topScores"+level+".txt"));
  try {
    line = reader.readLine();
  } 
  catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  if (line != null) {
    scores = split(line, ",");
  } 
  else {
    scores = new String[0];
  }
}

void showMenu() {
  background(loadImage("bg.jpg"));

  if (!where.equals("scores")) {
    song.pause();
    song.cue(0);
    theme.loop();
  } 
  else {
    score1.setVisible(false);
    score2.setVisible(false);
    score3.setVisible(false);
    score4.setVisible(false);
  }

  setLoadUp("menu");
  title.setVisible(true);
  startBtn.setVisible(true);
  scoresBtn.setVisible(true);
  movesLabel.setVisible(false);
  backBtn.setVisible(false);
  levelLabel.setVisible(false);
  continueBtn.setVisible(false);
  resetBtn.setVisible(false);
}

void showScores() {
  setLoadUp("scores");
  loadTopScores();

  backBtn.setVisible(true);
  score1.setVisible(true);
  score2.setVisible(true);
  score3.setVisible(true);
  score4.setVisible(true);
}

void loadTopScores() {
  readTopScores(scoreLevel);
  if (scores.length == 0) {
    topScores = new int[0];
    return;
  }
  topScores = new int[scores.length-1];
  for (int i = 0; i < scores.length-1; i++) {
    topScores[i] = int(scores[i]);
  }
  topScores = sort(topScores);
}

void checkIfLost() {
  if (player.getInvincible()) return;
  for ( Enemy e : enemies ) {
    if ( e.getSprite().bb_collision(player.getSprite()) ) {
      println("YOU LOSE!");
      setLoadUp("lose");
      //levelNumber = 1;
      levelLabel.setVisible(true);
      movesLabel.setVisible(true);
      backBtn.setVisible(true);
    }
  }
}

void drawGrass() {
  for ( Tile t : tiles )
    image(grassImages.get(levelNumber-1), t.getLoc().x, t.getLoc().y);
  for ( Obstacle o : obstacles )
    image(grassImages.get(levelNumber-1), o.getLoc().x, o.getLoc().y);
}

void changeGrass() {
  for ( Tile t : tiles )
    image(grassImages.get(levelNumber), t.getLoc().x, t.getLoc().y);
  for ( Obstacle o : obstacles )
    image(grassImages.get(levelNumber), o.getLoc().x, o.getLoc().y);
}

void runSprinklerAnimation() {
  sprinklerSound.loop();
  for ( Sprinkler s : sprinklers )
    s.play();
}

void stopSprinklerAnimation() {
  sprinklerSound.pause();
  sprinklerSound.rewind();
  for ( Sprinkler s : sprinklers )
    s.stop();
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
    squirrel = squirrelSprite;
  }
}

void dropNut() {
  if (stunEnemies) return;
  int randomIndex = (int)(random(0, tiles.size()));
  PVector randomPosition = tiles.get(randomIndex).getLoc();
  nut = new Nut(randomPosition, nutSprite);
  isNut = true;
}

int stunTimer = 0;
void stunTheEnemies() {
  if (stunTimer == 150) {
    stunTimer = 0;
    stunEnemies = false; 
    squirrel = null;
    player.setInvincible(false);
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
  player.setInvincible(true);
  stunTimer++;
}

void keyPressed() {
  switch(key) {
  case 'r':
  case 'R':
    //    if (!where.equals("menu") && !where.equals("scores")) {
    //      
    //      resetGame();
    //    }
    break;
  case 'w':
  case 'W':
    if (where.equals("game")) {
      if (!player.willHit(NORTH)) {
        player.move(NORTH);
        checkIfOnTile();
        moves++;
      }
    }
    break;
  case 's':
  case 'S':
    if (where.equals("game")) {
      if (!player.willHit(SOUTH)) {
        player.move(SOUTH);
        checkIfOnTile();
        moves++;
      }
    }
    break;
  case 'a':
  case 'A':
    if (where.equals("game")) {
      if (!player.willHit(WEST)) {
        player.move(WEST);
        checkIfOnTile();
        moves++;
      }
    }
    break;
  case 'd':
  case 'D':
    if (where.equals("game")) {
      if (!player.willHit(EAST)) {
        player.move(EAST);
        checkIfOnTile();
        moves++;
      }
    }
    break;
  default:
    break;
  }
}

void keyReleased() {
}

