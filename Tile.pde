class Tile {

  PVector loc;
  int w;
  int h;
  boolean flipped;
  color tileColor;

  Tile(PVector _loc) {
    loc = _loc;
    w = 64;
    h = 64;
    flipped = false;
    tileColor = #ff0000;
  }

  void draw() {
    rectMode(CORNER);
    stroke(#000000);
    fill(tileColor);
    rect(loc.x, loc.y, w, h);
  }

  PVector getLoc() {
    return loc;
  }

  int getWidth() {
    return w;
  }

  int getHeight() {
    return h;
  }

  boolean isFlipped() {
    return flipped;
  }

  void setFlipped(boolean value) {
    flipped = value;
  }

  color getColor() {
    return tileColor;
  }

  void setColor(color value) {
    tileColor = value;
  }

  void flipTile() {
    flipped = !flipped;
    if (flipped) {
      setColor(#00ff00);
      tilesFlipped++;
    }
    else {
      setColor(#ff0000);
      tilesFlipped--;
    }
  }
}

