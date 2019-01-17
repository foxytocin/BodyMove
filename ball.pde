class ball {

  float x, y, circleSize, circleSizeFix;
  float mx = 0;
  float speed = 2;
  float velocity = 0.0;
  float acceleration = 0.0;
  float damping = 0.8;
  float volumeStone = 0;
  float panStone = 0.5;
  int rainbowIndex = 20000;
  int timer = 1;
  float sec = 0.5;
  boolean shrinks = false;
  float value = 0;

  ball(float x_, float y_, float circleSize_) {
    x = x_;
    y = y_;
    circleSize = circleSize_;
    circleSizeFix = circleSize_;
  }

  void motion() {
    float newX;
    acceleration = 0;
    acceleration = (-mx * speed);
    velocity += acceleration;
    newX = x += velocity;
    x = lerp(x, newX, 0.7);
    x = constrain(x, circleSize/2, width-circleSize/2);
  }

  void update() {
    if (!shrinks) {
      calcPos();
      bounceWall();
      motion();
      sound();
      colorFade();
    }
  }

  void colorFade() {
    value = lerp(value, g.qual, 0.01);
    rainbowIndex = (int)map(value, 100, 0, 2000, 20000);
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
    if (x - circleSize / 2 <= 0) {
      velocity *= -1;
      velocity *= damping;
    } else if (x >= width - circleSize / 2) {
      velocity *= -1;
      velocity *= damping;
    }
  }

  void collisionHole() {
    velocity *= -1;
    velocity *= damping;
  }

  boolean done() {
    if (timer < (sec * frames)) {
      shrinks = true;
      timer++;
      acceleration = 0;
      velocity = 0;
      circleSize = map(timer, 0, (sec * frames), circleSizeFix, 0);
      return false;
    }
    circleSize = 0;
    return true;
  }

  void reset() {
    value = 0;
    shrinks = false;
    acceleration = 0;
    velocity = 0;
    circleSize = circleSizeFix;
    timer = 3;
    x = (width / 2);
    y = (height - detail - circleSize / 2);
  }
}
