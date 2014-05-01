class Obstacle extends NonMoveableObject {

  PImage image;

  public Obstacle(PVector _loc, PImage _image) {
    super(_loc);
    image = _image;
  }
  
  public void draw() {
    imageMode(CORNER);
    image(image, loc.x, loc.y);
  }
}

