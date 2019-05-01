class circleAnimation {

  float x, y, r, alpha, circleSize, circleAcc;
  color col;
  boolean finished = false;
  
  circleAnimation(hole h, String reason) {
    circleAcc = 0;
    circleSize = 0;
    x = h.x;
    y = h.y;
    r = h.circleSize;
    switch(reason) {
      case "error":
        col = red;
        break;
      case "goal":
        col = green;
        break;
      default: break;
    }
  }

  void update() {
    circleAcc += 4;
    circleSize += circleAcc;
    alpha = map(circleSize, r, width / 2, 255, 0);  
    if (circleSize > (width / 2))
      finished = true;
  }

  void show() {
    noStroke();
    fill(col, alpha);
    ellipseMode(CENTER);
    ellipse(x, y, circleSize, circleSize);
  }
}
