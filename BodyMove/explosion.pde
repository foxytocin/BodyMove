class explosion {

  ArrayList<particle> particles;
  float x;
  float y;
  float w;
  color col;
  boolean finished = false;

  explosion(float x, float y, float w, String reason) {
    particles = new ArrayList<particle>();
    this.x = x;
    this.y = y;
    this.w = w;
    switch(reason) {
      case "error":
        col = red;
        break;
      case "goal":
        col = green;
        break;
      default: break;
    }
    for (int i = 0; i < 30; i++) {
      particles.add(new particle(x, y, w, col));
    }
  }

  void show() {
    for (particle p : particles) {
      p.update();
      p.show();   
      if (p.a <= 0)
        finished = true;
    }
  }
}
