class trackMovement {

  float avgLeft, avgRight, posLeft, posRight;
  float centerX = width/2  - detail/2;
  float centerY = height/2;
  int countLeft, countRight, rainbowIndex;
  pixel frozenPixel;
  float anteilAnGesamt, drawSize;
  boolean movement = false;
  boolean error = false;
  boolean goal = false;

  trackMovement() {
    reset();
  }

  void reset() {
    avgLeft = (height - detail);
    avgRight = (height - detail);
    posLeft = (height - detail);
    posRight = (height - detail);
  }

  //Zaehlt wieviele Pixel in der Naehe eines Buttons aktiv sind (beruehrt werden)
  void pixelTouched(pixel p, guiCircle button) {
    if (dist(p.x, p.y, button.x, button.y) <= button.r / 2) {
      button.pixelCount++;
    }
  }

  boolean touchArea(pixel p, float r) {
    float d = dist(centerX, centerY, p.x, p.y);
    return (d > r);
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
      float pixelWeight = (d / (detail * scaleWidth));
      pixelWeight = constrain(pixelWeight, 0, (detail * scaleWidth));

      if (d > threshold) {
        if (!hideInput) {
          fill(brightness(p.col));
          pixelWeight = map(brightness(p.col), 255, 0, 0, 1);
          pixelWeight *= p.size;
        } else {
          fill(rainbow.rainbow[(rainbowIndex + floor(p.y * 5)) % 60000]);
        }

        //Berechnung im Spiel. Linker und rechter Streifen zur Berechnung der Handposition
        if (p.x < width / 2 && touchArea(p, width * 0.4)) {
          countLeft++;
          avgLeft += p.y;
          if(hideInput)
            fill(red);
        } else if (p.x > width / 2 && touchArea(p, width * 0.4)) {
          countRight++;
          avgRight += p.y;
          if(hideInput)
            fill(green);
        }

        //Berechnung der Touchfelder für EXIT, AGAIN, MORE and LESS wenn der End-Screen angezeigt wird
        if (gh.endScreen) {
          pixelTouched(p, guiAgain);
          pixelTouched(p, guiExit);
          pixelTouched(p, guiMore);
          pixelTouched(p, guiLess);
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
        if (!hideInput) {
          fill(brightness(p.col));
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

    //Berechnet die Position der linken und rechten Koordinate für den Balken
    if (!b.shrinks && !gh.paused && !gh.endScreen && avgLeft != 1) {
      posLeft = lerp(posLeft, avgLeft, 0.7);
    }
    if (!b.shrinks && !gh.paused && !gh.endScreen && avgRight != 1) {
      posRight = lerp(posRight, avgRight, 0.7);
    }

    //Indikator wie gut jeder Arm erkannt wird. Wird mit der Taste "t" getoggelt
    if (tracking) {
      fill(100);
      noStroke();
      ellipse(100, posLeft, countLeft, countLeft);
      ellipse(video.width * scaleWidth - 100, posRight, countRight, countRight);
    }
    error = false;
    goal = false;
  }
}
