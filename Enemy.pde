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
    int num = (int)random(0, 2);
    switch(num) {
    case 0:
      if (other.x < loc.x) {
        if (!willHit(WEST))
          move(WEST);
      }
      else if (other.x > loc.x) {
        if (!willHit(EAST))
          move(EAST);
      }
      else if (other.y < loc.y) {
        if (!willHit(NORTH))
          move(NORTH);
      }
      else if (other.y > loc.y) {
        if (!willHit(SOUTH))
          move(SOUTH);
      }
      break;
    case 1:
      if (other.y < loc.y) {
        if (!willHit(NORTH))
          move(NORTH);
      }
      else if (other.y > loc.y) {
        if (!willHit(SOUTH))
          move(SOUTH);
      }
      else if (other.x < loc.x) {
        if (!willHit(WEST))
          move(WEST);
      }
      else if (other.x > loc.x) {
        if (!willHit(EAST))
          move(EAST);
      }
      break;
    }
  }
}

