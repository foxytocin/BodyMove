class ball {

  float x, y, circleSize, circleSizeFix;
  float mx = 0;
  float speed = 2;
  float velocity = 0.0;
  float acceleration = 0.0;
  float damping = 0.8;
  int rainbowIndex = 20000;
  int timer = 1;
  float sec = 0.5;
  boolean shrinks = false;
  float value = 0;

  ball(float x, float y, float circleSize) {
    this.x = x;
    this.y = y;
    this.circleSize = circleSize;
    this.circleSizeFix = circleSize;
  }

  void motion() {
    float newX;
    acceleration = 0;
    acceleration = (-mx * speed);
    velocity += acceleration;
    newX = x += velocity;
    x = lerp(x, newX, 0.8);
    x = constrain(x, circleSize/2, width-circleSize/2);
  }

  void update() {
    if (!shrinks) {
      colorFade();
      calcPos();
      bounceWall();
      motion();
    }
  }

  //Berechnet die Farbe von "lineAndBall" anhand der aktuellen Punktzahl
  void colorFade() {
    value = lerp(value, g.qual, 0.01);
    rainbowIndex = (int)map(value, 100, 0, 2000, 20000);
    lineAndBall = rainbow.rainbow[rainbowIndex];
  }

  void show() {
    stroke(100);
    strokeWeight(3);
    fill(lineAndBall);
    ellipseMode(CENTER);
    ellipse(x, y, circleSize, circleSize);
  }

  //Berechnet die Position des Balls ueber der Line (Balken der von dem Spieler gesteuert wird)
  //Berechnung ueber Lineare Funktion
  void calcPos() {
    mx = (trackMovement.posLeft - trackMovement.posRight) / width;
    y = trackMovement.posLeft - (x * mx) - (circleSize / 2);
  }

  //Abprallverhalten beim auftreffen an einer Bildschirmkante
  void bounceWall() {
    if (x - circleSize / 2 <= 0) {
      velocity *= -1;
      velocity *= damping;
    } else if (x >= width - circleSize / 2) {
      velocity *= -1;
      velocity *= damping;
    }
  }

  //Abprallverhalten beim auftreffen auf ein Hole
  void collisionHole() {
    velocity *= -1;
    velocity *= damping;
  }

  //Schrumpfanimation wenn der Ball in ein deadHole gesaugt wird
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
