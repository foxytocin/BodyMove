class trackMovement {

  float avgLeft = (height - detail);
  float avgRight = (height - detail);
  int countLeft = 0;
  int countRight = 0;
  float posLeft = (height - detail);
  float posRight = (height - detail);
  pixel frozenPixel;
  int rainbowIndex = 0;

  float anteilAnGesamt = 0;
  float drawSize = 0;
  boolean movement = false;
  boolean error = false;
  boolean goal = false;

  trackMovement() {
  }

  void reset() {
    avgLeft = (height - detail);
    avgRight = (height - detail);
    posLeft = (height - detail);
    posRight = (height - detail);
  }

  void pixelTouched(pixel p, guiCircle button) {
    if (p.x > (button.x - button.r) &&  p.x < (button.x + button.r) && p.y > (button.y - button.r) && p.y < (button.y + button.r)) {
      button.pixelCount++;
    }
  }

  void show() {

    avgLeft = 1;
    avgRight = 1;
    countLeft = 1;
    countRight = 1;

    guiAgain.pixelCount = 0;
    guiExit.pixelCount = 0;
    guiMore.pixelCount = 0;
    guiLess.pixelCount = 0;

    rainbowIndex += 50;
    rainbowIndex %= 60000;

    int pixelIndex = 0;
    int pixelNotChanged = 0;

    for (pixel p : raster) {
      frozenPixel = rasterFrozen.get(pixelIndex);
      float d = calcColorDifference(p, frozenPixel.col);
      float pixelWeight = (d / detail) * scaleWidth;
      pixelWeight = constrain(pixelWeight, 0, detail * scaleWidth);

      if (d > threshold) {
        fill(rainbow.rainbow[(rainbowIndex + floor(p.y * 5)) % 60000]);

        //Berechnung im Spiel. Linker und Rechner Streifen zu berechnung der Handposition
        if (p.x > 50 && p.x < width / 5) {
          countLeft++;
          avgLeft += p.y;
          //fill(30);
        } else if ((p.x > ((width / 5) * 4) - detail) && p.x < width - 70) {
          countRight++;
          avgRight += p.y;
          //fill(30);
        }

        //Berechnung der Touchfelder für EXIT, AGAIN, MORE and LESS
        pixelTouched(p, guiAgain);
        pixelTouched(p, guiExit);
        pixelTouched(p, guiMore);
        pixelTouched(p, guiLess);

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

    //Anzeige und Steuerung
    anteilAnGesamt = pixelNotChanged / (float)raster.size();
    drawSize = map(anteilAnGesamt, 0.6, 1, 0, detail * scaleWidth);

    avgLeft /= countLeft;
    avgRight /= countRight;

    if (!gh.startScreen && !b.shrinks) {
      if (!gh.endScreen && (countLeft < 4 || countRight < 4)) {
        gh.paused();
      } else if (!gh.endScreen) {
        gh.playing();
      }
    }

    if (!b.shrinks && !gh.paused && !gh.endScreen && avgLeft != 1) {
      posLeft = lerp(posLeft, avgLeft, 0.7);
    }

    if (!b.shrinks && !gh.paused && !gh.endScreen && avgRight != 1) {
      posRight = lerp(posRight, avgRight, 0.7);
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
