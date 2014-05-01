class Obstacle extends NonMoveableObject {

  PImage image;

  public Obstacle(PVector _loc) {
    super(_loc);
  }

  public Obstacle(PVector _loc, PImage _image) {
    super(_loc);
    image = _image;
  }
  
  public void draw() {
    imageMode(CORNER);
    image(image, loc.x, loc.y);
  }

  public boolean equals(Object obj) {
    if (obj instanceof Obstacle) {
      Obstacle obstacle = (Obstacle) obj;
      return obstacle.getLoc().equals(this.getLoc());
    }
    return false;
  }

  public int hashCode() {
    return this.getLoc().hashCode();
  }
}
