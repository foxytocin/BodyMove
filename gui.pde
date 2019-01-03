class gui {

  float error = 0;
  float target = 0;
  float qual = 100;
  int note = 1;
  int breite = detail * 7;
  int hoehe = detail * 3;

  void show() {

    if (gh.paused) {
      pushMatrix();
      translate(video.width / 2, video.height / 2);

      noStroke();
      fill(100);
      rectMode(CENTER);
      rect(0, 0, 680, 240, 15);
      textAlign(CENTER);
      textSize(32);
      fill(252, 1, 31);
      text("Spiel pausiert", 0, -70);
      textSize(46);
      text("Breite deine Arme weiter aus", 0, 0);
      text("Sie bilden die Stange", 0, 50);
      popMatrix();
    }

    if (gh.endScreen) {
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

    if (gh.playing) {
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
}
