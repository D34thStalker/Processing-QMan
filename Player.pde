class Player {
  PVector loc;
  int w;
  int h;

  Player(PVector _loc) {
    loc = _loc;
    w = 48;
    h = 48;
  }

  void draw() {
    rectMode(CENTER);
    stroke(#000000);
    fill(#ff00ff);
    rect(loc.x+32, loc.y+32, w, h);
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

  void move(int direction) {
    switch(direction) {
      //north
    case 1:
      if (loc.y - h < min_y) {
        return;
      }
      println("North");
      loc.y-=grid_size;
      checkIfOnTile();
      break;
      //south
    case 2:
      if (loc.y + h > max_y) {
        return;
      }
      println("South");
      loc.y+=grid_size;
      checkIfOnTile();
      break;
      //west
    case 3:
      if (loc.x - grid_size - w < 0) {
        return;
      }
      println("West");
      loc.x-=grid_size;
      checkIfOnTile();
      break;
      //east
    case 4:
      if (loc.x + grid_size + w > width - grid_size) {
        return;
      }
      println("East");
      loc.x+=grid_size;
      checkIfOnTile();
      break;
    }
  }
}

