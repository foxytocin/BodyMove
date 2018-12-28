class hole {

  float r = 25;
  float x = 0;
  float y = 0;
  color fillCol = color(255, 255, 255);
  color strokeCol = color(0,0,0);
  boolean a = false;
  boolean target = false;
  boolean touched = false;
  boolean collected = false;

  hole(float x_, float y_) {
    x = x_;
    y = y_;
  }

  void update() {
    if (a) {
      strokeCol = color(204,0,0);
    } else if (target) {
      fillCol = color(51, 153, 0);
    } else if (!a) {
      strokeCol = color(0,0,0);
    }
  }

  void show() {
    stroke(strokeCol);
    fill(fillCol);
    strokeWeight(5);
    ellipseMode(CENTER);
    ellipse(x, y, r * 2, r * 2);
    
    textSize(20);
    fill(255,0,0);
    //text(holes.indexOf(this), x-10, y+10);
  }

  void ballMatchHole(float mX, float mY) {
    if (dist(mX, mY, x, y) < 2 * b.r) {

      if (!touched && !target) {
        touched = true;
        a = true;
        g.error++;
      } else if (!touched && target) {
        touched = true;
        collected = true;
        g.target++;
      }
    } else {
      touched = false;
      a = false;
    }
  }
}