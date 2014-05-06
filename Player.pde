class Player extends MoveableObject {

  boolean isInvincible;

  Player(PVector loc, Sprite sprite) {
    super(loc, sprite);
  }

  public void setInvincible(boolean b) {
    isInvincible = b;
  }

  public boolean getInvincible() {
    return isInvincible;
  }
}

