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

ArrayList<Gif> winSceneImages;
ArrayList<PImage> winSceneSImages;

PImage brooklynCollegeBackgroundImage;
PImage brickBackgroundImage;

// Sounds
AudioSnippet sprinklerSound;
AudioSnippet nut_sfx;

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

  minim = new Minim(this);

  f = createFont("Verdana", 34, true);

  InstantiateSounds();
  InstantiateLists();
  LoadImages();

  //showMenu();
  showCredits();
  background(brooklynCollegeBackgroundImage);
}


void switchToLevel(int level) {
  obstacleCount = level+1;
  /*
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
   */
}

void InstantiateSounds() {
  sprinklerSound = minim.loadSnippet("sprinkler.wav");
  theme = minim.loadSnippet("theme.mp3");
  song = minim.loadSnippet("song.mp3");
  credit = minim.loadSnippet("credits.mp3");
  nut_sfx = minim.loadSnippet("nut_sfx.mp3");
  
  theme.setGain(-10);
  song.setGain(-10);
  credit.setGain(-10);
}

void InstantiateLists() {
  tiles = new ArrayList<Tile>();
  enemies = new ArrayList<Enemy>();
  obstacles = new ArrayList<Obstacle>();
  sprinklers = new ArrayList<Sprinkler>();

  obstacleImages = new ArrayList<PImage>();
  grassImages = new ArrayList<PImage>();
  sprinklerImages = new ArrayList<Gif>();

  winSceneImages = new ArrayList<Gif>();
  winSceneSImages = new ArrayList<PImage>();
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

  for (int i = 0; i < 7; i++)
    winSceneImages.add(new Gif(this, "win/p"+i+".gif"));

  for (int i = 0; i < 4; i++)
    winSceneSImages.add(loadImage("win/s"+i+".png"));

  brooklynCollegeBackgroundImage = loadImage("backgrounds/bg.jpg");
  brickBackgroundImage = loadImage("backgrounds/brick-background.jpg");
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
  scoresBtn.setVisible(false);
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
  loadingCounter++;
  if (loadingCounter >= 15) {
    setScene(setWhere);
    loadingCounter = 0;
  }
}

void menu() {
  background(brooklynCollegeBackgroundImage);
}

void game() {
  // background(#0000ff);
  background(brickBackgroundImage);
  rectMode(CORNER);
  drawObstacles();
  drawTiles();
  drawSprinklers();

  fill(#ffffff);
  textAlign(CENTER);
  textFont(f, 28);
  text("Level " + levelNumber, width/2, 75);

  if (levelNumber > 2) {
    if (isNut) nut.draw();
    else {
      double nut_probability = 0.005;
      int randomNumber = (int)(random(0, 1000));

      if (randomNumber <= nut_probability*1000) dropNut();
    }
  }

  player.draw();


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

  fill(#ffffff);
  textAlign(CENTER);
  textFont(f, 24);
  text("Total Steps: " + moves, width/2, height-50);

  if (stunEnemies) stunTheEnemies();
  checkIfHitNut();
  checkIfWon();
  checkIfLost();
}

void winScreen() {
  background(brickBackgroundImage);
  // background(#0000ff);
  if (levelNumber < 4) {
    drawObstacles();
    drawSprinklers();

    fill(#ffffff);
    textAlign(CENTER);
    textFont(f, 30);
    text("The grass is growing!", width/2, 60);

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
    drawSprinklers();
    drawGrass();

    // PEOPLE
    image(winSceneImages.get(0), tileMap[1][0].x, tileMap[1][0].y);
    image(winSceneImages.get(1), tileMap[7][5].x, tileMap[7][5].y);
    image(winSceneImages.get(2), tileMap[5][1].x, tileMap[5][1].y);
    image(winSceneImages.get(3), tileMap[2][6].x, tileMap[2][6].y);

    // QMAN
    image(winSceneImages.get(4), tileMap[2][2].x, tileMap[2][2].y);

    // GUARDS
    image(winSceneImages.get(5), tileMap[6][6].x, tileMap[6][6].y);
    image(winSceneImages.get(6), tileMap[5][6].x, tileMap[5][6].y);

    // SQUIRRELS
    drawWinSquirrels();

    // OBSTACLES
    image(obstacleImages.get(0), tileMap[3][2].x, tileMap[3][2].y);
    image(obstacleImages.get(1), tileMap[6][5].x, tileMap[6][5].y);
    image(obstacleImages.get(2), tileMap[2][5].x, tileMap[2][5].y);
    image(obstacleImages.get(3), tileMap[1][1].x, tileMap[1][1].y);
    image(obstacleImages.get(4), tileMap[6][1].x, tileMap[6][1].y);

    fill(#ffffff);
    textAlign(CENTER);
    textFont(f, 30);
    text("Congratulations!", width/2, height/2-100);
    text("You've restored campus unity and \n Brooklyn College thanks you!", width/2, height/2);

    continueBtn.setVisible(true);
  }
}

int wsCounter = 0;
int wsCounter2 = 0;
int wsX = 0;
int wsY = 0;
int wSquirrel = 0;
int wSquirrel2 = 0;
void drawWinSquirrels() {
  switch(wSquirrel) {
  case 0:
    if (wsCounter == 15 && wsX < 6) {
      wsCounter = 0;
      wsX++;
    }

    wsCounter++;

    image(winSceneSImages.get(0), tileMap[wsX][4].x, tileMap[wsX][4].y);
    if (wsX == 6) wSquirrel = 1;
    break;
  case 1:
    if (wsCounter == 15 && wsX > 1) {
      wsCounter = 0;
      wsX--;
    }

    wsCounter++;
    image(winSceneSImages.get(1), tileMap[wsX][4].x, tileMap[wsX][4].y);
    if (wsX == 1) wSquirrel = 0;
    break;
  }
  switch(wSquirrel2) {
  case 0:
    if (wsCounter2 == 15 && wsY < 5) {
      wsCounter2 = 0;
      wsY++;
    }

    wsCounter2++;

    image(winSceneSImages.get(3), tileMap[0][wsY].x, tileMap[0][wsY].y);
    if (wsY == 5) wSquirrel2 = 1;
    break;
  case 1:
    if (wsCounter2 == 15 && wsY > 1) {
      wsCounter2 = 0;
      wsY--;
    }

    wsCounter2++;
    image(winSceneSImages.get(2), tileMap[0][wsY].x, tileMap[0][wsY].y);
    if (wsY == 1) wSquirrel2 = 0;
    break;
  }
}


float loseTextY = -150;
float loseText2Y = 0;
float loseIncrementY = 10;
void loseScreen() {
  // background(#0000ff);
  background(brickBackgroundImage);

  rectMode(CORNER);
  drawObstacles();
  drawTiles();
  drawSprinklers();

  player.draw();

  for (Enemy e : enemies)
    e.draw();

  resetBtn.setVisible(true);

  fill(#ffffff);
  textAlign(CENTER);
  textFont(f, 30);
  text("Oh No! \n You've been thrown off campus!", width/2, loseTextY);
  text("Try Again?", width/2, loseText2Y);
  if (loseTextY < height/2-100) loseTextY += loseIncrementY;
  if (loseText2Y > height/2) loseText2Y -= loseIncrementY;
}

void scoresScreen() {
  // Show the top scores
  // background(#0000ff);
  background(brickBackgroundImage);

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
float creditIncrement = 0.75;
void credits() {
  // background(brooklynCollegeBackgroundImage);
  background(brickBackgroundImage);
  fill(#ffffff);
  textAlign(CENTER);

  textFont(f, 32);
  text("QMAN", width/2, height-creditY);
  textFont(f, 30);
  text("Developed by \n Michael Squitieri \n Julius Btesh", width/2, height+75-creditY);

  // Images
  textFont(f, 32);
  text("Images", width/2, height+300-creditY);
  textFont(f, 20);
  text("Guitar \n http://piq.codeus.net/u/nessie", width/2, height+340-creditY);
  text("Nut \n http://7soul1.deviantart.com/art/ \n 420-Pixel-Art-Icons-for-RPG-129892453", width/2, height+410-creditY);
  text("Macbook \n http://piq.codeus.net/u/joseki", width/2, height+510-creditY);
  text("Skateboard \n http://piq.codeus.net/u/LouisxD", width/2, height+580-creditY);
  text("Pokeball \n http://piq.codeus.net/u/pixellord", width/2, height+650-creditY);
  text("Batman \n http://piq.codeus.net/u/THEPIXELMAN11", width/2, height+720-creditY);
  text("Shroom \n http://piq.codeus.net/u/students", width/2, height+790-creditY);
  text("Mario \n http://piq.codeus.net/u/mario%20fan47", width/2, height+860-creditY);
  text("Link \n http://piq.codeus.net/u/NoobMaker2000", width/2, height+930-creditY);
  text("Book \n http://sharandula.deviantart.com/art/book-262383889", width/2, height+1000-creditY);
  text("Sword \n http://piq.codeus.net/u/TheAMS64", width/2, height+1070-creditY);
  text("Sonic \n http://piq.codeus.net/u/Bossdude101", width/2, height+1140-creditY);
  text("Pencil \n http://piq.codeus.net/u/Spencer", width/2, height+1210-creditY);

  // Songs
  textFont(f, 32);
  text("Music", width/2, height+1400-creditY);
  textFont(f, 20);
  text("Legend of Zelda Theme Song (8-Bit) \n (Youtube) : supersamster50", width/2, height+1440-creditY);
  text("Get Lucky - Daft Punk (8-Bit) \n (Youtube) : rakohus", width/2, height+1510-creditY);
  text("Radioactive - Imagine Dragons (8-Bit) \n (Youtube) : bisXIII", width/2, height+1580-creditY);

  textFont(f, 32);
  text("THANK YOU FOR PLAYING!", width/2, finalTextY);

  if (finalTextY > height/2) {
    creditY += creditIncrement;
    finalTextY -= creditIncrement;
  }
  else
    backBtn.setVisible(true);
}

void showCredits() {
  setLoadUp("credits");

  song.cue(0);
  song.pause();
  credit.play();

  finalTextY = height+2000;
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

  title.setVisible(true);
  startBtn.setVisible(true);
  scoresBtn.setVisible(true);
  backBtn.setVisible(false);
  continueBtn.setVisible(false);
  resetBtn.setVisible(false);

  score1.setVisible(false);
  score2.setVisible(false);
  score3.setVisible(false);
  score4.setVisible(false);
}

public void startGame() {
  println("started");
  background(#0000ff);

  // WIN SCENE VARIABLES RESET
  wsCounter = 0;
  wsCounter2 = 0;
  wsX = 0;
  wsY = 0;
  wSquirrel = 0;
  wSquirrel2 = 0;


  levelNumber = 1;
  playGame();

  theme.cue(0);
  theme.pause();
  song.loop();

  title.setVisible(false);
  startBtn.setVisible(false);
  scoresBtn.setVisible(false);
  backBtn.setVisible(true);
}

void checkIfWon() {
  if (tilesFlipped == tiles.size()) {
    setLoadUp("win");

    readTopScores(levelNumber);
    writeTopScores(levelNumber);

    if (levelNumber == 4) {
      for (Gif g : winSceneImages)
        g.play();
    }
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
  background(brooklynCollegeBackgroundImage);

  if (where.equals("credits")) {
    credit.pause();
    credit.cue(0);
    theme.loop();
  }
  else if (!where.equals("scores")) {
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
  backBtn.setVisible(false);
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
      backBtn.setVisible(true);
      loseTextY = -150;
      loseText2Y = height + 500;
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

    nut_sfx.play();
    nut_sfx.cue(0);

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

