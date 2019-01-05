class trackMovement {

  float avgLeft = (height - detail);
  float avgRight = (height - detail);
  int countLeft = 0;
  int countRight = 0;
  float posLeft = (height - detail);
  float posRight = (height - detail);
  pixel frozenPixel = new pixel();
  int rainbowIndex = 0;

  float anteilAnGesamt = 0;
  float drawSize = 0;

  boolean movement = false;
  boolean error = false;
  boolean goal = false;

  int countRightButton = 0;
  int timerRightButton = 0;
  int countLeftButton = 0;
  int timerLeftButton = 0;

  int countDiffButtonPlus = 0;
  int timerDiffButtonPlus = 0;
  int countDiffButtonMinus = 0;
  int timerDiffButtonMinus = 0;

  int setDiffwithButton = 0;
  boolean activButtons = false;

  trackMovement() {
  }

  void show() {

    avgLeft = 1;
    avgRight = 1;
    countLeft = 1;
    countRight = 1;
    countRightButton = 0;
    countLeftButton = 0;
    countDiffButtonPlus = 0;
    countDiffButtonMinus = 0;

    rainbowIndex += 50;
    rainbowIndex %= 60000;

    int pixelIndex = 0;
    int pixelNotChanged = 0;
    for (pixel p : raster) {
      frozenPixel = rasterFrozen.get(pixelIndex);
      float d = calcColorDifference(p, frozenPixel.col);
      float pixelWeight = (d / detail) * scaleWidth;
      pixelWeight = constrain(pixelWeight, 0, detail * scaleWidth);

      if (d > thresholdFreze) {
        fill(rainbow.rainbow[(rainbowIndex + floor(p.y * 5)) % 60000]);

        //Berechnung im Spiel. Linker und Rechner Streifen zu berechnung der Handposition
        if (p.x > 100 && p.x < width / 5) {
          countLeft++;
          avgLeft += p.y;
          fill(30);
        } else if ((p.x > ((width / 5) * 4) - detail) && p.x < width - 120) {
          countRight++;
          avgRight += p.y;
          fill(30);
        }

        //Berechnung der Steuerelemente RESTART und ENDE
        if (gh.endScreen) {
          if ((p.x > ((width / 5) * 4) - detail) && p.x < width - 120 && p.y > 84 && p.y < (84 + 200)) {
            countRightButton++;
          }
          if ((p.x > 100 && p.x < width / 5) && p.y > 84 && p.y < (84 + 200)) {
            countLeftButton++;
          }
        }

        //Berechnung der Steuerelemente SCHWIERIGKEIT
        if (gh.endScreen) {
          if ((p.x > ((width / 5) * 4) - detail) && p.x < width - 120 && p.y < height - 84 && p.y > height - (84 + 200)) {
            countDiffButtonPlus++;
          }
          if ((p.x > 100 && p.x < width / 5) && p.y < height - 84 && p.y > height - (84 + 200)) {
            countDiffButtonMinus++;
          }
        }

        //Pixel die sich im Verhaeltniss zum rasterFreze geaendert haben
        noStroke();
        ellipse(p.x + p.size / 2, p.y + p.size / 2, pixelWeight, pixelWeight);
      } else {

        //Pixel bei denen keine Veraenderung erkannt wurde
        pixelNotChanged++;
        if (error) {
          fill(color(red));
        } else if (goal) {
          fill(color(green));
        } else {
          fill(75);
        }

        noStroke();
        ellipse(p.x + p.size / 2, p.y + p.size / 2, drawSize, drawSize);
      }
      pixelIndex++;
    }

    //Berechnungen nachdem alle Pixel gezaehlt wurden

    //Aktiviert die Buttons erst, wenn keinerlei Bewegung mehr erkannt wurde. Verhindert ungewollte Eingaben
    if (gh.endScreen && countLeft < 5 && countRight < 5) {
      activButtons = true;
    }

    //Timer Circle-Menu Right-Button NOCHMAL
    if (activButtons) {
      if (countRightButton > 10 && countLeftButton < 5 && countDiffButtonPlus < 5 && countDiffButtonMinus < 5) {

        if (timerRightButton < 50) {
          timerRightButton++;
        } else {
          activButtons = false;
          timerRightButton = 0;
          gh.restart();
        }
      } else {
        timerRightButton = 0;
      }

      //Timer Circle-Menu Left-Button ENDE
      if (countLeftButton > 10 && countRightButton < 5 && countDiffButtonPlus < 5 && countDiffButtonMinus < 5) {

        if (timerLeftButton < 50) {
          timerLeftButton++;
        } else {
          activButtons = false;
          timerLeftButton = 0;
          gh.startScreen();
        }
      } else {
        timerLeftButton = 0;
      }

      //Timer Circle-Menu DIFF-Button PLUS
      if (countDiffButtonPlus > 10 && countRightButton < 5 && countLeftButton < 5 && countDiffButtonMinus < 5) {

        if (timerDiffButtonPlus < 50) {
          timerDiffButtonPlus++;
        } else {
          timerDiffButtonPlus = 0;

          if (holeAmount + setDiffwithButton < 26) {
            soundCollect.play();
            setDiffwithButton++;
          }
        }
      } else if (setDiffwithButton == 0) {
        timerDiffButtonPlus = 0;
      } else if (setDiffwithButton != 0) {
        timerDiffButtonPlus = 0;
        holeAmount += setDiffwithButton;
        setDiffwithButton = 0;
      }

      //Timer Circle-Menu DIFF-Button MINUS
      if (countDiffButtonMinus > 10 && countRightButton < 5 && countLeftButton < 5 && countDiffButtonPlus < 5) {

        if (timerDiffButtonMinus < 50) {
          timerDiffButtonMinus++;
        } else {
          timerDiffButtonMinus = 0;

          if ((holeAmount + setDiffwithButton) > 1) {
            soundError.play();
            setDiffwithButton--;
          }
        }
      } else if (setDiffwithButton == 0) {
        timerDiffButtonMinus = 0;
      } else if (setDiffwithButton != 0) {
        timerDiffButtonMinus = 0;
        holeAmount += setDiffwithButton;
        setDiffwithButton = 0;
      }


      if (timerLeftButton > 0 || timerRightButton > 0 || timerDiffButtonPlus > 0 || timerDiffButtonMinus > 0) {
        if (!soundButton.isPlaying())
          soundButton.play();
      } else if (gh.endScreen) {
        soundButton.stop();
      }
    }


    //Anzeige und Steuerung
    anteilAnGesamt = pixelNotChanged / (float)raster.size();
    drawSize = map(anteilAnGesamt, 0.6, 1, 0, detail * scaleWidth);

    avgLeft /= countLeft;
    avgRight /= countRight;

    if (!gh.startScreen) {
      if (!gh.endScreen && (countLeft < 4 || countRight < 4)) {
        gh.paused();
      } else if (!gh.endScreen) {
        gh.playing();
      }
    }

    if (!gh.paused && !gh.endScreen && avgLeft != 1) {
      posLeft = lerp(posLeft, avgLeft, 0.5);
    }

    if (!gh.paused  && !gh.endScreen && avgRight != 1) {
      posRight = lerp(posRight, avgRight, 0.5);
    }

    //Indikator gut jeder Arm erkannt wird
    //fill(100);
    //noStroke();
    //ellipse(100, posLeft, countLeft, countLeft);
    //ellipse(video.width - 100, posRight, countRight, countRight);

    error = false;
    goal = false;
  }
}
