class hole {

  float x, y, circleSize;
  color fillCol = color(255, 255, 255);
  color strokeCol = color(100);
  boolean activ = false;
  boolean target = false;
  boolean touched = false;
  boolean collected = false;
  boolean deadHole = false;
  float panStone = 0.5;

  hole(float x_, float y_, float circleSize_) {
    x = x_;
    y = y_;
    circleSize = circleSize_;
  }

  void update() {
    if (!deadHole) {
      if (activ) {
        strokeCol = color(red);
        fillCol = color(red, 150);
      } else if (target) {
        fillCol = color(green);
      } else if (!activ) {
        strokeCol = color(100);
        fillCol = color(255, 255, 255);
      }
    } else if (deadHole) {
      fillCol = color(0);
    }
  }

  void show() {
    strokeWeight(3);
    stroke(strokeCol);
    fill(fillCol);
    ellipseMode(CENTER);
    ellipse(x, y, circleSize, circleSize);
  }

  void calStereo(float x_) {
    panStone = map(x_, 0, width, -1, 1);
    panStone = constrain(panStone, -1, 1);
    soundError.pan(panStone);
    soundCollect.pan(panStone);
  }

  String ballMatchHole() {
    float dist = dist(b.x, b.y, x, y);
    if (!deadHole) {
      if (dist <= circleSize) {
        calStereo(x);
        if (!touched && !target) {
          b.collisionHole();
          soundError.play();
          trackMovement.error = true;
          touched = true;
          activ = true;
          g.error++;
          return "error";
        } else if (!touched && target) {
          b.collisionHole();
          soundCollect.play();
          trackMovement.goal = true;
          touched = true;
          collected = true;
          g.target++;
          return "goal";
        }
      } else if (touched && activ) {
        touched = false;
        activ = false;
        return null;
      }
    } else if (deadHole) {
      if (gh.playing && !collected && dist < (circleSize / 6)) {
        if (b.done()) {
          if (!soundScream.isPlaying())
            soundScream.play();
          g.endReason = "YOU LOSE";
          gh.endScreen();
          return "dead";
        } else {
          if (!soundSuck.isPlaying()) {
            soundSuck.play();
          }
          b.velocity = 0;
          b.acceleration = 0;
        }
      } else if (collected && dist > circleSize) {
        collected = false;
      }
    }
    return null;
  }
}
