class ball {

  float r = 30;
  float x = 640;  //(video.width / 2);
  float y = (height - detail - r);
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

  ball() {
  }


  void motion() {
    float newX;
    acceleration = 0;
    if (wallL && mx > 0 && abs(velocity) < 0.5) {
      x = r;
    } else if (wallR && mx < 0 && abs(velocity) < 0.5) {
      x = width - r;
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
    ellipse(x, y, r * 2, r * 2);
  }

  void calcPos() {
    mx = (trackMovement.posLeft - trackMovement.posRight) / width;
    y = trackMovement.posLeft - (x * mx) - r;
  }


  void sound() {
    float sound = abs(acceleration * velocity);
    //println("SOUND: " +sound);
    
    //Sound des Balls
    if (sound > 0.005) {
      volumeStone = map(sound, 0.005, 30, 0.0001, 0.5);
    } else {
      volumeStone = 0;
      soundRollingStone.stop();
    }

    panStone = map(x, r, width - r, -1, 1);
    panStone = constrain(panStone, -1, 1);
    soundRollingStone.pan(panStone);
    volumeStone = constrain(volumeStone, 0.1, 1);
    soundRollingStone.amp(volumeStone);
    if (!soundRollingStone.isPlaying() && sound > 0.005) {
      soundRollingStone.play();
    }
  }

  void bounceWall() {
    if (!wallL && x - r < 0) {
      wallL = true;
      velocity *= -1;
      velocity *= damping;
    } else if (!wallR && x > width - r) {
      wallR = true;
      velocity *= -1;
      velocity *= damping;
    } else if (x > 1.5*r && x < width - 1.5*r) {
      wallR = false;
      wallL = false;
    }
  }

  void collisionHole() {
    velocity *= -1;
    velocity *= damping;
  }
}
