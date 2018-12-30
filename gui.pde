class gui {

  float error = 0;
  float target = 0;
  float qual = 0;
  int note = 0;
  int breite = detail * 8;
  int hoehe = detail * 4;

  void show() {
    pushMatrix();
      translate(detail, detail);
  
      noStroke();
      fill(100);
      rect(0, 0, breite, hoehe);
  
      if (target > 0 || error > 0) {
        qual = target / (target + error) * 100;
        note = (int)map(qual, 0, 100, 6, 1);
      }
  
      pushMatrix();
        translate(5, 18);
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
        text(note, 120, 40);
      popMatrix();
    popMatrix();
  }
}
