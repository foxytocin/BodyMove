class gui {

  float error = 0;
  float target = 0;
  float qual = 0;
  int note = 0;
  int breite = detail * 7;
  int hoehe = detail * 3;
  boolean gameEnd = false;

  void show() {
    
    if (trackMov && !gameEnd && thresholdFreze < 50) {
      pushMatrix();
      translate(video.width / 2, video.height / 2);

      stroke(50);
      fill(100);
      rectMode(CENTER);
      rect(0, 0, 500, 110, 10);
      textAlign(CENTER);
      textSize(32);
      fill(252, 1, 31);
      text("Spiel pausiert", 0, -10);
      text("Schlechte Lichtverhältnisse", 0, 30);
      popMatrix();
    }

    if (gameEnd) {
      pushMatrix();
      translate(video.width / 2, video.height / 2);

      stroke(50);
      fill(100);
      rectMode(CENTER);
      rect(0, 0, 255, 110, 10);
      textAlign(CENTER);
      textSize(32);
      fill(rainbow.rainbow[b.rainbowIndex]);
      text("Spielende", 0, -10);
      text("Note: " +note+ " / " +(int)qual+ "%", 0, 30);
      popMatrix();
    }

    pushMatrix();
    translate(detail, detail);

    noStroke();
    fill(100);
    rectMode(CORNER);
    rect(0, 0, breite, hoehe);

    if (target > 0 || error > 0) {
      qual = target / (target + error) * 100;
      note = (int)map(qual, 0, 100, 6, 1);
    }

    pushMatrix();
    translate(5, 18);
    textAlign(LEFT);
    textSize(20);
    fill(252, 1, 31);
    text("Fehler:", 0, 0);
    textSize(20);
    fill(98, 252, 2);
    text("Punkte:", 0, 25);

    textAlign(RIGHT);
    textSize(20);
    fill(252, 1, 31);
    text((int)error, 105, 0);
    textSize(20);
    fill(98, 252, 2);
    text((int)target, 105, 25);
    popMatrix();
    popMatrix();
  }
}
