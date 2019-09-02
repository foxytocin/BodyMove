class trackMovement {

  float avgLeft, avgRight, posLeft, posRight;
  float centerX = width/2 - detail/2;
  float centerY = height/2 + 50;
  int countLeft, countRight, rainbowIndex;
  pixel frozenPixel;
  float anteilAnGesamt, drawSize;
  boolean movement = false;
  float touchAreaRadius = width * 0.35;

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

      if (d > threshold) {
        float pixelWeight = (d / (detail * scaleWidth));
        pixelWeight = constrain(pixelWeight, 0, (detail * scaleWidth));

        if (!hideInput) {
          fill(brightness(p.col));
          pixelWeight = map(brightness(p.col), 255, 0, 0, 1);
          pixelWeight *= p.size;
        } else {
          fill(rainbow.rainbow[(rainbowIndex + floor(p.y * 5)) % 60000]);
        }

        //Berechnung im Spiel. Linker und rechter Streifen zur Berechnung der Handposition
        if (touchArea(p, touchAreaRadius)) {
          if (tracking && hideInput)
            fill(red);

          if (p.x < centerX) {
            countLeft++;
            avgLeft += p.y;
          } else {
            countRight++;
            avgRight += p.y;
          }
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
        float pixelFactor = p.size / 2;
        ellipse(p.x + pixelFactor, p.y + pixelFactor, pixelWeight, pixelWeight);
        
      } else if (!hideInput) {
        pixelNotChanged++;
        fill(brightness(p.col));
        noStroke();
        float pixelFactor = p.size / 2;
        ellipse(p.x + pixelFactor, p.y + pixelFactor, drawSize, drawSize);
      }
      pixelIndex++;
    }

    if (!hideInput) {
      anteilAnGesamt = pixelNotChanged / (float)raster.size();
      drawSize = map(anteilAnGesamt, 0.6, 1, 0, detail * scaleWidth);
    }

    //Anzeige und Steuerung
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
    if (!b.shrinks && !gh.paused && !gh.endScreen) {
      if (avgLeft != 1) {
        posLeft = lerp(posLeft, avgLeft, 0.65);
      }
      if (avgRight != 1) {
        posRight = lerp(posRight, avgRight, 0.65);
      }
    }

    //Indikator wie gut jeder Arm erkannt wird. Wird mit der Taste "t" getoggelt
    if (tracking) {
      fill(100);
      noStroke();
      ellipse(100, posLeft, countLeft, countLeft);
      ellipse(video.width * scaleWidth - 100, posRight, countRight, countRight);
    }
  }
}
