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
      rect(0, 0, 672, 244, 10);
      textAlign(CENTER);
      textSize(32);
      fill(red);
      text("Spiel pausiert", 0, -70);
      textSize(46);
      fill(textCol);
      text("Breite deine Arme weiter aus", 0, 0);
      text("Sie bilden die Stange", 0, 50);
      popMatrix();
    }

    if (gh.endScreen) {
      //Anzeige der Spielerpunkte
      pushMatrix();
      translate(video.width / 2, video.height / 2);
      noStroke();
      fill(100);
      rectMode(CENTER);
      rect(0, 0, 287, 143, 10);
      textAlign(CENTER);
      textSize(32);
      fill(rainbow.rainbow[b.rainbowIndex]);
      text("Spielende", 0, -10);
      text("Note: " +note+ " (" +(int)qual+ "%)", 0, 30);
      popMatrix();
      
      //Auswahl Kreise RECHTS
      pushMatrix();
      translate(width - 184, 184);
      noStroke();
      fill(backgroundCol);
      ellipse(0, 0, 200, 200);
      textSize(32);
      textAlign(CENTER);
      fill(textCol);
      text("Nochmal?", 0, 11);
      rotate(-PI/2);
      noFill();
      stroke(green);
      strokeWeight(15);
      float angel1 = map(trackMovement.timerRightButton, 0, 45, 0, TWO_PI);
      arc(0, 0, 200, 200, 0, angel1);
      popMatrix();
      
      //Auswahl Kreise LINKS
      pushMatrix();
      translate(184, 184);
      noStroke();
      fill(backgroundCol);
      ellipse(0, 0, 200, 200);
      textSize(32);
      textAlign(CENTER);
      fill(textCol);
      text("Ende", 0, 11);
      rotate(-PI/2);
      noFill();
      stroke(red);
      strokeWeight(15);
      float angel2 = map(trackMovement.timerLeftButton, 0, 45, 0, TWO_PI);
      arc(0, 0, 200, 200, 0, angel2);
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
      fill(textCol);
      text("Fehler:", 0, 0);
      textSize(20);
      fill(textCol);
      text("Punkte:", 0, 25);

      textAlign(RIGHT);
      textSize(20);
      fill(textCol);
      text((int)error, 105, 0);
      textSize(20);
      fill(textCol);
      text((int)target, 105, 25);
      popMatrix();
      popMatrix();
    }
  }
}
