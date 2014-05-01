class NonMoveableObject {
  protected PVector loc;
  protected int w;
  protected int h;

  public NonMoveableObject(PVector _loc) {
    loc = _loc;
    w = 48;
    h = 48;
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
}

