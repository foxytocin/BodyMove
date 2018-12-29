class ball {

  float r = 30;
  float x;
  float y;
  float acc = 0;
  float mx;
  float tar = x;
  boolean coll = true;
  boolean wallL = false;
  boolean wallR = false;
  float mass = 4;
  float volumeStone;

  ball() {
  }

  void update() {
    calcPos();
    collision();
    move();
  }

  void show() {
    stroke(255);
    strokeWeight(3);
    fill(0, 102, 204);
    ellipseMode(CENTER);
    ellipse(x, y, r * 2, r * 2);
  }

  void calcPos() {
    mx = (trackMovement.posLeft - trackMovement.posRight) / video.width;
    y = trackMovement.posLeft - (x * mx) - r;
  }

  void move() {
    if (mx > -0.005 && mx < 0.005) {
      if (acc > 0) {
        acc -= 0.08;
        x = lerp(x, x += acc, 0.8);
      } else if (acc < 0) {
        acc += 0.08;
        x = lerp(x, x += acc, 0.8);
      }
    } else if (mx > 0 && !wallL) {
      acc -= (mx * mass);
      x = lerp(x, x += acc, 0.8);
    } else if (mx < 0 && !wallR) {
      acc -= (mx * mass);
      x = lerp(x, x += acc, 0.8);
    }

    //Sound des Balls
    if (acc > 2 && !wallL) {
      volumeStone = map(acc, 0, 27, 0.01, 1);
    } else if (acc < -2 && !wallR) {
      volumeStone = map(acc, -27, 0, 1, 0.01);
    } else {
      soundRollingStone.stop();
    }

    volumeStone = constrain(volumeStone, 0, 1);
    soundRollingStone.amp(volumeStone);
    if (!soundRollingStone.isPlaying() && (acc > 2 && !wallL || acc < -2 && !wallR)) {
      soundRollingStone.play();
    }
  }

  void collision() {
    if (!wallL && x - r <= 0) {
      wallL = true;
      acc = 0;
      tar = r;
    } else if (!wallR && x >= video.width - r) {
      wallR = true;
      acc = 0;
      tar = video.width - r;
    } else if (x > 1.5*r && x < video.width - 1.5*r) {
      wallR = false;
      wallL = false;
    }
  }
}
