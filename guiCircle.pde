class guiCircle {

  String label;
  float x;
  float y;
  float r;
  float rows;
  float size;
  color colText;
  color colText_Backup;
  color colRing;
  color colRing_Backup;
  color colFill;
  int stroke;
  float angel = TWO_PI;
  int timer = 0;
  int sec;
  float offset;
  boolean ticks;
  int steps = 0;
  int pixelCount = 0;

  guiCircle(float x_, float y_, float r_, String label_, float rows_, float size_, color colText_, color colFill_, color colRing_, int stroke_, int sec_, boolean ticks_) {
    x = x_;
    y = y_;
    r = r_;
    size = size_;
    rows = rows_;
    label = label_;
    colText = colText_;
    colText_Backup = colText_;
    colRing = colRing_;
    colRing_Backup = colRing_;
    colFill = colFill_;
    stroke = stroke_;
    sec = sec_;
    ticks = ticks_;

    if (rows > 1) {
      offset = -((size * rows) / 2);
    } else {
      offset = (size / 2);
    }
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
    if (timer < (sec * 60)) {
      timer++;
      
      if (!ticks) {
        angel = map(timer, 0, (sec * 60), TWO_PI, 0);
      } else {
        
        colRing = rainbow.rainbow[floor(map(timer, 0, (sec * 60), 2000, 20000))];
        colText = colRing;
        if (timer % 60 == 0) {
          if (!soundClock.isPlaying()) {
            soundClock.amp(0.5);
            soundClock.play();
          }
          steps += 60;
        }
        angel = map(steps, 0, (sec * 60), TWO_PI, 0);
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
    textAlign(CENTER);
    fill(colText);
    text(label, 0, offset);
    rotate(-PI/2);
    noFill();
    stroke(colRing);
    strokeWeight(stroke);
    arc(0, 0, 2 * r, 2 * r, 0, angel);
    popMatrix();
  }
}
