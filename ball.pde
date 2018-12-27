class ball {

  float r = 25;
  float x;
  float y;
  float acc = 0;
  float mx;
  float tar = x;
  boolean coll = true;
  boolean wallL = false;
  boolean wallR = false;
  float mass = 1.5;

  ball() {
  }

  void update() {
    calcPos();
    //calcPos2();
    collision();
    //move2();
    move();
  }

  void show() {
    pushMatrix();
    translate(0, -(r + l.lheight / 2));
    noStroke();
    fill(0, 102, 204);
    strokeWeight(6);
    ellipseMode(CENTER);
    ellipse(x, y, r * 2, r * 2);
    popMatrix();
  }
  
  void move2() {
    if (mx > -0.005 && mx < 0.005) {
      if (acc > 0) {
        acc -= 0.08;
        x += acc;
      } else if (acc < 0) {
        acc += 0.08;
        x += acc;
      }
    } else if (mx > 0) {
      acc -= (mx * mx * mass);
      x += acc;
    } else if (mx < 0) {
      acc -= (mx * mx * mass);
      x += acc;
    }
  }

  void calcPos() {
    float tmpx = video.width;
    float tmpy = posLeft - posRight;
    mx = tmpy / tmpx;
    y = posLeft - (x * mx);
  }

  void move() {
    if (mx > -0.005 && mx < 0.005) {
      if (acc > 0) {
        acc -= 0.08;
        x += acc;
      } else if (acc < 0) {
        acc += 0.08;
        x += acc;
      }
    } else if (mx > 0 && !wallL) {
      acc -= (mx * mass);
      x += acc;
    } else if (mx < 0 && !wallR) {
      acc -= (mx * mass);
      x += acc;
    }
  }

  void calcPos2() {
    float tmpx = video.width;
    float tmpy = posLeft - posRight;
    
    if(x < -r) x = video.width + r;
    if(x > video.width + r) x = -r;
    
    mx = tmpy / tmpx;
    y = posLeft - (x * mx);
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
    } else if (x > 2*r && x < video.width - 2*r) {
      wallR = false;
      wallL = false;
    }
  }
}
