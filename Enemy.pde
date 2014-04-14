class Enemy {
  PVector loc;
  int w;
  int h;
  Sprite s;

  int moveTimer;

  Enemy(PVector _loc, Sprite _s) {
    loc = _loc;
    w = 48;
    h = 48;
    s = _s;
    
    moveTimer = 0;
  }

  void draw() {
    s.setXY(loc.x+32,loc.y+32);
    s.draw();
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

  int getMoveTimer() {
    return moveTimer;
  }

  void setMoveTimer(int value) {
    moveTimer = value;
  }

  void move(int direction) {
    switch(direction) {
      //north
    case NORTH:
      if (loc.y - h < min_y) {
        return;
      }
      for ( PVector o : allAvailableTilesOnMap ) {
        if (checkIfWillCollide(loc.x, loc.y-grid_size, o)) return;
      }
      println("North");
      loc.y-=grid_size;
      break;
      //south
    case SOUTH:
      if (loc.y + h > max_y) {
        return;
      }
      for ( PVector o : allAvailableTilesOnMap ) {
        if (checkIfWillCollide(loc.x, loc.y+grid_size, o)) return;
      }
      println("South");
      loc.y+=grid_size;
      break;
      //west
    case WEST:
      if (loc.x - grid_size - w < 0) {
        return;
      }
      for ( PVector o : allAvailableTilesOnMap ) {
        if (checkIfWillCollide(loc.x-grid_size, loc.y, o)) return;
      }
      println("West");
      loc.x-=grid_size;
      break;
      //east
    case EAST:
      if (loc.x + grid_size + w > width - grid_size) {
        return;
      }
      for ( PVector o : allAvailableTilesOnMap ) {
        if (checkIfWillCollide(loc.x+grid_size, loc.y, o)) return;
      }
      println("East");
      loc.x+=grid_size;
      break;
    }
  }

  boolean checkIfWillCollide(float x, float y, PVector o) {
    if ((( x > o.x )           && ( x < o.x + 64 )           && ( y > o.y )           && ( y < o.y + 64 )) ||
      (( x > o.x )           && ( x < o.x + 64 )           && ( y + h > o.y ) && ( y + h < o.y + 64)) ||
      (( x + w > o.x ) && ( x + player.w < o.x + 64 ) && ( y + h > o.y ) && ( y + h < o.y + 64 )) ||
      (( x + w > o.x ) && ( x + player.w < o.x + 64 ) && ( y > o.y )           && ( y < o.y + 64 ))) {
      return true;
    }
    return false;
  }

  void chase(PVector other) {
    if (other.x < loc.x)
      move(WEST);
    if (other.x > loc.x)
      move(EAST);
    if (other.y < loc.y)
      move(NORTH);
    if (other.y > loc.y)
      move(SOUTH);
  }
}

