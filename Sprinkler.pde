class Sprinkler extends NonMoveableObject {

  Gif image;

  public Sprinkler(PVector _loc, Gif _image) {
    super(_loc);
    image = _image;
  }
  
  public void draw() {
    imageMode(CORNER);
    image(image, loc.x, loc.y);
  }
  
  public void play() {
   image.play(); 
  }
  
  public void stop() {
   image.stop(); 
  }
}

