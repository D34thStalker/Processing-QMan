/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here
 } //_CODE_:button1:12356:

 * Do not rename this tab!
 * =========================================================
 */

public void startBtn_click1(GImageButton source, GEvent event) { //_CODE_:startBtn:903391:
  startGame();
  println("startBtn - GImageButton event occured " + System.currentTimeMillis()%10000000 );
} //_CODE_:startBtn:903391:

public void scoresBtn_click1(GImageButton source, GEvent event) { //_CODE_:scoresBtn:591759:
  showScores();
  println("scoresBtn - GImageButton event occured " + System.currentTimeMillis()%10000000 );
} //_CODE_:scoresBtn:591759:

public void score1_click1(GButton source, GEvent event) { //_CODE_:score1:748380:
  scoreLevel = 1;
  loadTopScores();
  println("score1 - GButton event occured " + System.currentTimeMillis()%10000000 );
} //_CODE_:score1:748380:

public void score2_click1(GButton source, GEvent event) { //_CODE_:score2:527961:
  scoreLevel = 2;
  loadTopScores();
  println("score2 - GButton event occured " + System.currentTimeMillis()%10000000 );
} //_CODE_:score2:527961:

public void score3_click1(GButton source, GEvent event) { //_CODE_:score3:327866:
  scoreLevel = 3;
  loadTopScores();
  println("score3 - GButton event occured " + System.currentTimeMillis()%10000000 );
} //_CODE_:score3:327866:

public void score4_click1(GButton source, GEvent event) { //_CODE_:score4:905590:
  scoreLevel = 4;
  loadTopScores();
  println("score4 - GButton event occured " + System.currentTimeMillis()%10000000 );
} //_CODE_:score4:905590:

public void backBtn_click1(GImageButton source, GEvent event) { //_CODE_:backBtn:418467:
  if (!where.equals("scores")) clearGame();
  showMenu();
  println("backBtn - GImageButton event occured " + System.currentTimeMillis()%10000000 );
} //_CODE_:backBtn:418467:

public void continueBtn_click1(GImageButton source, GEvent event) { //_CODE_:continueBtn:782909:
  if (levelNumber < 4) {
    levelNumber++;
    resetGame();
  } else showCredits();
  println("continueBtn - GImageButton event occured " + System.currentTimeMillis()%10000000 );
} //_CODE_:continueBtn:782909:

public void resetBtn_click1(GImageButton source, GEvent event) { //_CODE_:resetBtn:286580:
  resetGame();
  println("resetBtn - GImageButton event occured " + System.currentTimeMillis()%10000000 );
} //_CODE_:resetBtn:286580:



// Create all the GUI controls.
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  if(frame != null)
    frame.setTitle("QMan");
  title = new GLabel(this, 0, 40, 640, 40);
  title.setText("Adventures of QMan");
  title.setTextBold();
  title.setLocalColorScheme(GCScheme.RED_SCHEME);
  title.setOpaque(false);
  startBtn = new GImageButton(this, 240, 220, 160, 60, new String[] { "start.png", "start.png", "start.png" } );
  startBtn.addEventHandler(this, "startBtn_click1");
  scoresBtn = new GImageButton(this, 240, 300, 160, 60, new String[] { "scores.png", "scores.png", "scores.png" } );
  scoresBtn.addEventHandler(this, "scoresBtn_click1");
  score1 = new GButton(this, 120, 140, 80, 30);
  score1.setText("Level 1");
  score1.addEventHandler(this, "score1_click1");
  score2 = new GButton(this, 220, 140, 80, 30);
  score2.setText("Level 2");
  score2.addEventHandler(this, "score2_click1");
  score3 = new GButton(this, 320, 140, 80, 30);
  score3.setText("Level 3");
  score3.addEventHandler(this, "score3_click1");
  score4 = new GButton(this, 420, 140, 80, 30);
  score4.setText("Level 4");
  score4.addEventHandler(this, "score4_click1");
  backBtn = new GImageButton(this, 20, 560, 120, 60, new String[] { "homeBtn.png", "homeBtn.png", "homeBtn.png" } );
  backBtn.addEventHandler(this, "backBtn_click1");
  continueBtn = new GImageButton(this, 500, 560, 120, 60, new String[] { "continueBtn.png", "continueBtn.png", "continueBtn.png" } );
  continueBtn.addEventHandler(this, "continueBtn_click1");
  resetBtn = new GImageButton(this, 500, 560, 120, 60, new String[] { "resetBtn.png", "resetBtn.png", "resetBtn.png" } );
  resetBtn.addEventHandler(this, "resetBtn_click1");
}

// Variable declarations
// autogenerated do not edit
GLabel title;
GImageButton startBtn;
GImageButton scoresBtn;
GButton score1;
GButton score2;
GButton score3;
GButton score4;
GImageButton backBtn;
GImageButton continueBtn;
GImageButton resetBtn;

