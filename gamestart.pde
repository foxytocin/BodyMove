class gamestart {

  float count = 0;
  int testsPassed = 0;
  pixel frozenPixel = new pixel();

  gamestart() {
  }

  void show() {

    background(backgroundCol);
    float differenz = 0;
    int pixelIndex = 0;
    count = 0;

    for (pixel p : raster) {
      if ((p.x > 100 && p.x < video.width / 5) || (p.x >= (video.width / 5) * 4) && p.x < video.width - 112 ) {
        //Pixel die kontrolliert werden
        frozenPixel = rasterFrozen.get(pixelIndex);
        float diff = calcColorDifference(p, frozenPixel.col);

        if (diff > 15) {
          fill(255, 0, 0);
        } else {
          fill(98, 252, 2);
        }
        noStroke();
        ellipse(p.x + detail / 2, p.y + detail / 2, detail * 0.8, detail * 0.8);

        differenz += diff;
        count++;
      } else {
        //Pixel bei denen eine Veraenderung erkannt wurde
        //fill(30, 100);
        fill(p.col);
        noStroke();
        ellipse(p.x + detail / 2, p.y + detail / 2, detail * 0.8, detail * 0.8);
      }
      pixelIndex++;
    }

    differenz /= count;
    println("COUNT: " +count+ " / DIFFERENZ: " +differenz);

    if (differenz < 5) {
      testsPassed++;
      println("Bestandene Tests: " +testsPassed);
    } else {
      testsPassed = 0;
      println("RESET - Test nicht Bestanden: " +testsPassed);
    }

    pushMatrix();
    translate(video.width/2, 150);
    noStroke();
    fill(100);
    rectMode(CENTER);
    rect(0, 34, 736, 176, 10);

    textAlign(CENTER);
    textSize(32);
    fill(98, 252, 2);
    textSize(46);
    text("In den grünen Bereichen,", 0, 0);
    text("steuerst Du mit deinen", 0, 50);
    text("Armen die Lage der Stange.", 0, 100);
    popMatrix();

    if (testsPassed < 30) {
      translate(video.width/2, 405);
      pushMatrix();
      fill(100);
      rectMode(CENTER);
      rect(0, 34, 736, 176, 10);

      textAlign(CENTER);
      textSize(32);
      fill(252, 1, 31);
      textSize(46);
      text("Nimm die Hände runter.", 0, 0);
      text("Halte sie so, dass keine", 0, 50);
      text("roten Punkte angezeigt werden", 0, 100);
      popMatrix();
    } else {
      int timer = floor(map(testsPassed, 0, 90, 3, 0)) + 1;
      pushMatrix();
      translate(video.width/2, 405);
      fill(100);
      rectMode(CENTER);
      rect(0, 34, 736, 176, 10); 

      textAlign(CENTER);
      textSize(32);
      fill(98, 252, 2);
      textSize(46);
      text("Perfekt", 0, 0);
      text("Bleib genau so stehen.", 0, 50);
      text("Noch " +timer+ " Sekunden bis zum Start", 0, 100);
      popMatrix();
    }
  }

  boolean testingReady() {

    while (testsPassed < 90) {

      if (frameCount % 90 == 0) {
        rasterFrozen = generateFrozen();
        println("!!! Neuen Freze erstelle !!!");
      }
      show();
      return false;
    }
    gh.paused();
    return true;
  }
}
