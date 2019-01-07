class circleAnimation {

  float circleSize = 0;
  float circleAcc = 0;
  float x, y;
  float r;
  color col;
  float alpha;
  color errorCol = color(252, 1, 31);
  color goalCol = color(98, 252, 2);
  boolean finished = false;

  circleAnimation() {}

  circleAnimation(hole h_, String reason) {
    x = h_.x;
    y = h_.y;
    r = h_.circleSize;

    if (reason == "error")
      col = errorCol;

    if (reason == "goal")
      col = goalCol;
  }

  void update() {
    circleAcc += 4;
    circleSize += circleAcc;
    alpha = map(circleSize, r, 600, 250, 0);
    
    if(circleSize > 600)
      finished = true;
  }

  void show() {
    noStroke();
    fill(col, alpha);
    ellipseMode(CENTER);
    ellipse(x, y, circleSize, circleSize);
  }
}
