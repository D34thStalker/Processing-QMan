class Enemy extends MoveableObject {
  private int moveTimer;
  private Map<Float, Integer> moveUtilityMap = new TreeMap<Float, Integer>();
  private final int TIME_UNTIL_MOVE = 30;

  public Enemy(PVector _loc, Sprite _s) {
    super(_loc, _s);

    moveTimer = 0;
  }

  public boolean readyToMove() {
    return (moveTimer == TIME_UNTIL_MOVE);
  }

  public void incrementMoveTimer() {
    moveTimer++;
    if (moveTimer > TIME_UNTIL_MOVE) moveTimer = 0;
  }

  public boolean hasNextMove() {
    return (!moveUtilityMap.isEmpty());
  }

  public void chase(MoveableObject object) {
    // chase(object.getLoc());

    int nextMove;
    if (moveUtilityMap.isEmpty())
      nextMove = setNextMove(object);
    else
      nextMove = getMoveWithGreatestUtility();

    move(nextMove);

    clearUtilityMap();
  }

  public PVector getNextPosition() {
    if (moveUtilityMap.isEmpty()) return null;

    int nextMove = getMoveWithGreatestUtility();
    return getNextPosition(nextMove);
  }

  public Integer getNextMove() {
    if (moveUtilityMap.isEmpty()) return null;

    int nextMove = getMoveWithGreatestUtility();
    return nextMove;
  }

  public PVector getNextPosition(int nextMove) {
    PVector currentPosition = pointToTileMapPosition.get(this.getLoc());
    PVector newPosition = currentPosition.get();

    switch(nextMove) {
      case NORTH:
        newPosition.add(0, -1, 0);
        break;
      case SOUTH:
        newPosition.add(0, 1, 0);
        break;
      case EAST:
        newPosition.add(1, 0, 0);
        break;
      case WEST:
        newPosition.add(-1, 0, 0);
        break;
    }
    return newPosition;
  }

  public void removeMove(int move) {
    for (Float utility : moveUtilityMap.keySet()) {
      if (moveUtilityMap.get(utility).equals(move)) {
        moveUtilityMap.remove(utility);
        break;
      }
    }
  }

  private void clearUtilityMap() {
    moveUtilityMap.clear();
  }

  private int getMoveWithGreatestUtility() {
    Float maxUtility = Collections.max(moveUtilityMap.keySet());
    return moveUtilityMap.get(maxUtility);
  }

  public int setNextMove(MoveableObject object) {
    clearUtilityMap();

    PVector currentPosition = pointToTileMapPosition.get(this.getLoc());
    PVector objectPosition = pointToTileMapPosition.get(object.getLoc());
    Float currentDistance = PVector.dist(currentPosition, objectPosition);

    Float newDistance;
    PVector newPosition;
    Obstacle obstacleToTest;

    // SOUTH
    newPosition = getNextPosition(SOUTH);
    if (newPosition.y < MAX_Y_MAP) {
      obstacleToTest = new Obstacle(tileMap[(int)newPosition.x][(int)newPosition.y]);
      if (!obstacles.contains(obstacleToTest)) {
        newDistance = PVector.dist(newPosition, objectPosition);
        moveUtilityMap.put(currentDistance - newDistance, SOUTH);
      }
    }

    // NORTH
    newPosition = getNextPosition(NORTH);
    if (newPosition.y > 0) {
      obstacleToTest = new Obstacle(tileMap[(int)newPosition.x][(int)newPosition.y]);
      if (!obstacles.contains(obstacleToTest)) {
        newDistance = PVector.dist(newPosition, objectPosition);
        moveUtilityMap.put(currentDistance - newDistance, NORTH);
      }
    }

    // EAST
    newPosition = getNextPosition(EAST);
    if (newPosition.x < MAX_X_MAP) {
      obstacleToTest = new Obstacle(tileMap[(int)newPosition.x][(int)newPosition.y]);
      if (!obstacles.contains(obstacleToTest)) {
        newDistance = PVector.dist(newPosition, objectPosition);
        moveUtilityMap.put(currentDistance - newDistance, EAST);
      }
    }

    // WEST
    newPosition = getNextPosition(WEST);
    if (newPosition.x > 0) {
      obstacleToTest = new Obstacle(tileMap[(int)newPosition.x][(int)newPosition.y]);
      if (!obstacles.contains(obstacleToTest)) {
        newDistance = PVector.dist(newPosition, objectPosition);
        moveUtilityMap.put(currentDistance - newDistance, WEST);
      }
    }
    return getMoveWithGreatestUtility();
  }

/*
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
*/
}
