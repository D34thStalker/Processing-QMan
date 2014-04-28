import java.util.*;

class Tile {

  private PVector loc;
  private int w;
  private int h;
  private ArrayList<Integer> tileColors = new ArrayList<Integer>();
  private int currentColorIndex;

  public static final color GOAL_COLOR = #00ff00;
  public static final color DEFAULT_COLOR = #ff0000;

  public Tile(PVector _loc) {
    loc = _loc;
    w = 64;
    h = 64;

    currentColorIndex = 0;

    tileColors.add(DEFAULT_COLOR);
    tileColors.add(GOAL_COLOR);
  }

  public Tile(PVector _loc, color additionalColor) {
    this(_loc);
    tileColors.add(1, additionalColor);
  }

  public Tile(PVector _loc, Collection<Integer> colors) {
    this(_loc);
    int index = 1; 
    for (color additionalColor : colors) {
      tileColors.add(index, additionalColor);
      index++;
    }
  }

  public void draw() {
    rectMode(CORNER);
    stroke(#000000);
    fill(tileColors.get(currentColorIndex));
    rect(loc.x, loc.y, w, h);
  }

  public PVector getLoc() {
    return loc;
  }

  public int getWidth() {
    return w;
  }

  public int getHeight() {
    return h;
  }

  public void flip() {
    color previousColor = tileColors.get(currentColorIndex);
    currentColorIndex++;
    if (currentColorIndex == tileColors.size()) currentColorIndex = 0;
    color newColor = tileColors.get(currentColorIndex);

    if (previousColor == GOAL_COLOR) tilesFlipped--;
    else if (newColor == GOAL_COLOR) tilesFlipped++;
  }
}
