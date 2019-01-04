class ball {

  float r = 30;
  float x = (video.width / 2);
  float y = (video.height - detail - r);
  float mx;
  float mass = 2.5;
  float acc = 1;
  int bounce = 1;

  float volumeStone;
  float panStone = 0.5;

  int rainbowIndex = 0;

  ball() {
  }

  void update() {
    calcPos();
    bounceWall();
    move();
    rainbowIndex = (int)map(g.qual, 100, 0, 2000, 20000);
  }

  void show() {
    stroke(100);
    strokeWeight(3);
    fill(rainbow.rainbow[rainbowIndex]);
    ellipseMode(CENTER);
    ellipse(x, y, r * 2, r * 2);
  }

  void calcPos() {
    mx = (trackMovement.posLeft - trackMovement.posRight) / video.width;
    y = trackMovement.posLeft - (x * mx) - r;
  }

  void move() {
    float newX = 0;

    if (mx < 0 && bounce == 1) {
      acc += abs(mx) * mass;
    } else if (mx > 0 && bounce == -1) {
      acc += abs(mx) * mass;
    } else if (mx < 0 && bounce == -1) {
      acc -= abs(mx) * mass;
    } else if (mx > 0 && bounce == 1) {
      acc -= abs(mx) * mass;
    }

    if (acc < 0) {
      acc = 0;
      bounce = -bounce;
    }

    newX = x + (acc * bounce);
    x = lerp(x, newX, 0.8);


    //Sound des Balls
    if (acc > 2) {
      volumeStone = map(acc, 0, 27, 0.01, 0.5);
    } else if (acc < -2) {
      volumeStone = map(acc, -27, 0, 0.5, 0.01);
    } else {
      soundRollingStone.stop();
    }

    panStone = map(x, r, video.width - r, -1, 1);
    panStone = constrain(panStone, -1, 1);
    soundRollingStone.pan(panStone);
    volumeStone = constrain(volumeStone, 0.1, 1);
    soundRollingStone.amp(volumeStone);
    if (!soundRollingStone.isPlaying() && (acc > 2 || acc < -2)) {
      soundRollingStone.play();
    }
  }

  void bounceWall() {
    if (x - r < 0) {
      bounce = 1;
      acc *= 0.7;
      if (acc < 0.1)
        acc = 0;
    } else if (x > video.width - r) {
      bounce = -1;
      acc *= 0.7;
      if (acc < 0.1)
        acc = 0;
    }
  }

  void collisionHole() {
    bounce = -bounce;
    acc *= 0.7;
    if (acc < 0.1)
      acc = 0;
  }
}
