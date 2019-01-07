class ball {

  float circleSize = 10;
  float x = width / 2;
  float y = (height - detail - circleSize / 2);
  float mx;
  float speed = 1.5;
  float velocity = 0.0;
  float acceleration = 0.0;
  float damping = 0.8;
  boolean wallR = false;
  boolean wallL = false;
  float volumeStone;
  float panStone = 0.5;
  int rainbowIndex = 0;

  ball(float x_, float y_, float circleSize_) {
    x = x_;
    y = y_;
    circleSize = circleSize_;
  }

  void motion() {
    float newX;
    acceleration = 0;
    if (wallL && mx > 0 && abs(velocity) < 0.5) {
      x = circleSize / 2;
    } else if (wallR && mx < 0 && abs(velocity) < 0.5) {
      x = width - circleSize / 2;
    } else {
      acceleration = (-mx * speed);
      velocity += acceleration;
      newX = x += velocity;
      x = lerp(x, newX, 0.8);
    }
  }

  void update() {
    calcPos();
    bounceWall();
    motion();
    sound();
    rainbowIndex = (int)map(g.qual, 100, 0, 2000, 20000);
  }

  void show() {
    stroke(100);
    strokeWeight(3);
    fill(rainbow.rainbow[rainbowIndex]);
    ellipseMode(CENTER);
    ellipse(x, y, circleSize, circleSize);
  }

  void calcPos() {
    mx = (trackMovement.posLeft - trackMovement.posRight) / width;
    y = trackMovement.posLeft - (x * mx) - (circleSize / 2);
  }


  void sound() {
    float sound = abs(acceleration * velocity);
    //Sound des Balls
    if (sound > 0.005) {
      volumeStone = map(sound, 0.005, 30, 0.0001, 0.5);
    } else {
      volumeStone = 0;
      soundRollingStone.stop();
    }
    panStone = map(x, (circleSize / 2), width - circleSize / 2, -1, 1);
    panStone = constrain(panStone, -1, 1);
    soundRollingStone.pan(panStone);
    volumeStone = constrain(volumeStone, 0.1, 1);
    soundRollingStone.amp(volumeStone);
    if (!soundRollingStone.isPlaying() && sound > 0.005) {
      soundRollingStone.play();
    }
  }

  void bounceWall() {
    if (!wallL && x - circleSize / 2 < 0) {
      wallL = true;
      velocity *= -1;
      velocity *= damping;
    } else if (!wallR && x > width - circleSize / 2) {
      wallR = true;
      velocity *= -1;
      velocity *= damping;
    } else if (x > 1.5 * circleSize / 2 && x < width - 1.5 * circleSize / 2) {
      wallR = false;
      wallL = false;
    }
  }

  void collisionHole() {
    velocity *= -1;
    velocity *= damping;
  }
}
