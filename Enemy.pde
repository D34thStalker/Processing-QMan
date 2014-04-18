class Enemy extends MoveableObject {
  private int moveTimer;

  public Enemy(PVector _loc, Sprite _s) {
    super(_loc, _s);

    moveTimer = 0;
  }

  public int getMoveTimer() {
    return moveTimer;
  }

  public void setMoveTimer(int value) {
    moveTimer = value;
  }

  public void chase(MoveableObject object) {
    chase(object.getLoc());
  }

  public void chase(PVector other) {
    if (other.x < loc.x) {
      if (!willHit(WEST))
        move(WEST);
    }
    if (other.x > loc.x) {
      if (!willHit(EAST))
        move(EAST);
    }
    if (other.y < loc.y) {
      if (!willHit(NORTH))
        move(NORTH);
    }
    if (other.y > loc.y) {
      if (!willHit(SOUTH))
        move(SOUTH);
    }
  }
}

