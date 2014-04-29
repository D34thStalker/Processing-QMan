class MoveableObject {
  protected PVector loc;
  protected int w;
  protected int h;
  protected Sprite sprite;

  public MoveableObject(PVector _loc, Sprite _s) {
    loc = _loc;
    w = 48;
    h = 48;
    sprite = _s;
  }

  public void draw() {
    sprite.setXY(loc.x+32, loc.y+32);
    sprite.draw();
  }

  public Sprite getSprite() {
    return sprite;
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

  public void move(int direction) {
    switch(direction) {
      //north
    case NORTH:
      println("North");
      loc.y-=grid_size;
      break;
      //south
    case SOUTH:
      println("South");
      loc.y+=grid_size;
      break;
      //west
    case WEST:
      println("West");
      loc.x-=grid_size;
      break;
      //east
    case EAST:
      println("East");
      loc.x+=grid_size;
      break;
    }
  }

  // FOR NON SPRITE COLLISION
  public boolean checkIfWillCollide(float x, float y, PVector o) {
    if ((( x > o.x )           && ( x < o.x + 64 )           && ( y > o.y )           && ( y < o.y + 64 )) ||
      (( x > o.x )           && ( x < o.x + 64 )           && ( y + h > o.y ) && ( y + h < o.y + 64)) ||
      (( x + w > o.x ) && ( x + player.w < o.x + 64 ) && ( y + h > o.y ) && ( y + h < o.y + 64 )) ||
      (( x + w > o.x ) && ( x + player.w < o.x + 64 ) && ( y > o.y )           && ( y < o.y + 64 ))) {
      return true;
    }
    return false;
  }

  public boolean willHit(int direction) {
    switch(direction) {
      //north
    case NORTH:
      if (loc.y - h < min_y) {
        return true;
      }
      for ( PVector o : allAvailableTilesOnMap ) {
        if (checkIfWillCollide(loc.x, loc.y-grid_size, o)) return true;
      }
      return false;
      //south
    case SOUTH:
      if (loc.y + h > max_y) {
        return true;
      }
      for ( PVector o : allAvailableTilesOnMap ) {
        if (checkIfWillCollide(loc.x, loc.y+grid_size, o)) return true;
      }
      return false;
      //west
    case WEST:
      if (loc.x - grid_size - w < 0) {
        return true;
      }
      for ( PVector o : allAvailableTilesOnMap ) {
        if (checkIfWillCollide(loc.x-grid_size, loc.y, o)) return true;
      }
      return false;
      //east
    case EAST:
      if (loc.x + grid_size + w > width - grid_size) {
        return true;
      }
      for ( PVector o : allAvailableTilesOnMap ) {
        if (checkIfWillCollide(loc.x+grid_size, loc.y, o)) return true;
      }
      return false;
    }
    return false;
  }
}

