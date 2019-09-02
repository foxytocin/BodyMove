class guiCircle {

  String label;
  int x, y, r, size, stroke, timer, steps, pixelCount;
  color colText, colText_Backup, colRing, colRing_Backup, colFill;
  float angel = TWO_PI;
  float sec, offset;
  boolean ticks;

  //Constructor für die Circle-Elemente
  guiCircle(int x, int y, int r, String label, int size, color colText, color colFill, color colRing, int stroke, float sec, boolean ticks) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.size = size;
    this.label = label;
    this.colText = colText;
    this.colText_Backup = colText;
    this.colRing = colRing;
    this.colRing_Backup = colRing;
    this.colFill = colFill;
    this.stroke = stroke;
    this.sec = sec;
    this.ticks = ticks;
    timer = 0;
    steps = 0;
    pixelCount = 0;
  }

  void reset() {
    angel = TWO_PI;
    timer = 0;
    steps = 0;
  }

  boolean running() {
    return (timer != 0) ? true : false;
  }

  boolean done() {
    if (timer < (sec * frames)) {
      timer++;
      if (!ticks) {
        angel = map(timer, 0, (sec * frames), TWO_PI, 0);
      } else {  
        colRing = rainbow.rainbow[floor(map(timer, 0, (sec * frames), 2000, 20000))];
        colText = colRing;
        if (timer % frames == 0) {
          if (!soundClock.isPlaying()) {
            soundClock.amp(0.5);
            soundClock.play();
          }
          steps += frames;
        }
        angel = map(steps, 0, (sec * frames), TWO_PI, 0);
      }
      return false;
    } else {
      reset();
      return true;
    }
  }

  void show() {
    pushMatrix();
    translate(x, y);
    noStroke();
    fill(colFill);
    ellipse(0, 0, 2 * r, 2 * r);
    textSize(size);
    textAlign(CENTER, CENTER);
    fill(colText);
    text(label, 0, 0);
    rotate(-PI/2);
    noFill();
    stroke(colRing);
    strokeWeight(stroke);
    arc(0, 0, 2 * r + (stroke / 2), 2 * r + (stroke / 2), 0, angel);
    popMatrix();
  }
}
