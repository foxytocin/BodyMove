class particle {

  float x, y, w, a;
  color col;
  float velocityX, velocityY, speed;
  
  particle(float x, float y, float w, color col) {
    this.x = x;
    this.y = y;
    this.w = random(w/3, w);
    this.col = col;
    this.a = 255;
    speed = map(this.w, w/3, w, 1.25, 1.1);
    velocityX = random(-3, 3);
    velocityY = random(-3, 3);
  }

  void update() {
    speed -= 0.01;
    a = map(speed, 1.15, 0.8, 255, 0);
    velocityX *= speed;
    velocityY *= speed;
    this.x += velocityX;
    this.y += velocityY;
  }
  
  void show() {
    fill(col, a);
    noStroke();
    ellipse(x, y, w, w);
  }
}
