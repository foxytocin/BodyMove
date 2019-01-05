class hole {

  float r = 25;
  float x = 0;
  float y = 0;
  color fillCol = color(255, 255, 255);
  color strokeCol = color(100);
  boolean a = false;
  boolean target = false;
  boolean touched = false;
  boolean collected = false;
  float panStone = 0.5;
  
  hole() {
  }

  hole(float x_, float y_) {
    x = x_;
    y = y_;
  }

  void update() {
    if (a) {
      strokeWeight(3);
      strokeCol = color(252, 1, 31);
      fillCol = color(252, 1, 31, 150);
    } else if (target) {
      fillCol = color(98, 252, 2);
    } else if (!a) {
      strokeWeight(3);
      strokeCol = color(100);
      fillCol = color(255, 255, 255);
    }
  }

  void show() {
    stroke(strokeCol);
    fill(fillCol);
    strokeWeight(3);
    ellipseMode(CENTER);
    ellipse(x, y, r * 2, r * 2);
  }

  void calStereo(float x_) {
    panStone = map(x_, r, width - r, -1, 1);
    panStone = constrain(panStone, -1, 1);
    soundError.pan(panStone);
    soundCollect.pan(panStone);
  }

  String ballMatchHole() {
    if (dist(b.x, b.y, x, y) < 2 * b.r) {
      calStereo(x);
      if (!touched && !target) {
        b.collisionHole();
        soundError.play();
        trackMovement.error = true;
        touched = true;
        a = true;
        g.error++;
        return "error";
      } else if (!touched && target) {
        soundCollect.play();
        trackMovement.goal = true;
        touched = true;
        collected = true;
        g.target++;
        return "goal";
      }
    } else if (touched && a) {
      touched = false;
      a = false;
      return null;
    }
    return null;
  }
}
