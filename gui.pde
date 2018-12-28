class gui {

  float error = 0;
  float target = 0;
  int qual = 0;

  void show() {
    pushMatrix();
      translate(10, 10);
  
      noStroke();
      fill(0, 0, 0, 125);
      rect(0, 0, 150, 66, 10);
  
      if (target > 0 || error > 0) {
        qual = floor(target / (target + error) * 100);
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
        text("Qualität:", 0, 40);
    
        textAlign(RIGHT);
        textSize(20);
        fill(204, 0, 0);
        text((int)error, 130, 0);
        textSize(20);
        fill(51, 153, 0);
        text((int)target, 130, 20);
        textSize(20);
        fill(249, 166, 2);
        text(qual, 130, 40);
      popMatrix();
    popMatrix();
  }
}
