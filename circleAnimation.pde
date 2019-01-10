class circleAnimation {

  float circleSize = 0;
  float circleAcc = 0;
  float x, y, r, alpha;
  color col;
  boolean finished = false;

  circleAnimation() {
  }

  circleAnimation(hole h_, String reason) {
    x = h_.x;
    y = h_.y;
    r = h_.circleSize;
    if (reason == "error")
      col = red;
    if (reason == "goal")
      col = green;
    if (reason == "dead")
      col = color(0);
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
