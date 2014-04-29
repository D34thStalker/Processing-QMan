class DroppableObject {
  protected PVector loc;
  protected int w;
  protected int h;
  protected Sprite sprite;

  public DroppableObject(PVector _loc, Sprite _s) {
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
}
