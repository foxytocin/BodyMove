class hole {

  float r = 25;
  float x = 0;
  float y = 0;
  color fillCol = color(255, 255, 255);
  color strokeCol = color(50);
  boolean a = false;
  boolean target = false;
  boolean touched = false;
  boolean collected = false;
  float panStone = 0.5;


  hole() {
  };

  hole(float x_, float y_) {
    x = x_;
    y = y_;
  }

  void update() {
    if (a) {
      strokeCol = color(252, 1, 31);
      fillCol = color(252, 1, 31, 150);
    } else if (target) {
      fillCol = color(98, 252, 2);
    } else if (!a) {
      strokeCol = color(50);
      fillCol = color(255, 255, 255);
    }
  }

  void show() {
    stroke(strokeCol);
    fill(fillCol);
    strokeWeight(5);
    ellipseMode(CENTER);
    ellipse(x, y, r * 2, r * 2);
  }
  
  void calStereo(float x_) {
    panStone = map(x_, r, video.width - r, -1, 1);
    panStone = constrain(panStone, -1, 1);
    soundError.pan(panStone);
    soundCollect.pan(panStone);
  }

  String ballMatchHole() {
    if (dist(b.x, b.y, x, y) < 2 * b.r) {
      calStereo(x);
      if (!touched && !target) {
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
