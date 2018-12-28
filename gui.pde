class gui {

  float error = 0;
  float target = 0;
  int qual = 0;

  void show() {
    pushMatrix();
      translate(10, 10);
  
      noStroke();
      fill(0, 0, 0, 125);
      rect(0, 0, 140, 66, 10);
  
      if (target > 0 || error > 0) {
        qual = floor(target / (target + error) * 100);
        qual = (int)map(qual, 0, 100, 6, 1);
      }
  
      pushMatrix();
        translate(10, 20);
        textAlign(LEFT);
        textSize(20);
        fill(204, 0, 0);
        text("Fehler:", 0, 0);
        textSize(20);
        fill(51, 153, 0);
        text("Punkte:", 0, 20);
        textSize(20);
        fill(249, 166, 2);
        text("Note:", 0, 40);
    
        textAlign(RIGHT);
        textSize(20);
        fill(204, 0, 0);
        text((int)error, 120, 0);
        textSize(20);
        fill(51, 153, 0);
        text((int)target, 120, 20);
        textSize(20);
        fill(249, 166, 2);
        text(qual, 120, 40);
      popMatrix();
    popMatrix();
  }
}
