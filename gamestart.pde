class gamestart {

  int count = 0;
  int testsPassed = 0;
  pixel frozenPixel;
  boolean calibrated = false;
  boolean readyLeft = false;
  boolean readyRight = false;
  boolean humanDetected = false;
  float d;
  int pixelMin = 10;
  int pixelMax = 3;
  float timerAnimation = 0;
  gamestart() {
  }

  void reset() {
    calibrated = false;
    timerAnimation = 0;
    humanDetected = false;
    readyRight = false;
    readyLeft = false;
  }

  //Zaehlt wieviele Pixel in der Naehe eines Buttons aktiv sind (beruehrt werden)
  void pixelTouched(pixel p, guiCircle button) {
    if (dist(p.x, p.y, button.x, button.y) <= button.r / 2) {
      button.pixelCount++;
    }
  }
  
  boolean touchArea(pixel p, float r) {
    float d = dist(width/2 - detail/2, height/2, p.x, p.y);
    return (d > r);
  }

  void show() {
    
    stroke(255);
    strokeWeight(5);
    rect(50, 50, 100, 100);
    ellipse(640, 360, 600, 300);
    
    guiStartLeft.pixelCount = 0;
    guiStartRight.pixelCount = 0;
    background(backgroundCol);
    int pixelIndex = 0;
    count = 0;

    for (pixel p : raster) {
      //Pixel die kontrolliert werden
      frozenPixel = rasterFrozen.get(pixelIndex);
      d = calcColorDifference(p, frozenPixel.col);
      float dotSize = map(brightness(p.col), 255, 0, 0.2, 1);
      dotSize *= p.size;

      if (!calibrated && touchArea(p, width * 0.4)) {
        if (!humanDetected && d > 2 * threshold) {
          humanDetected = true;
        }
        if (d > threshold && (p.y < timerAnimation)) {
          count++;
          fill(red);
        } else if (p.y < timerAnimation) {
          if (humanDetected) {
            fill(green);
          } else {
            fill(red);
          }
        } else {
          fill(brightness(p.col));
        }
        noStroke();
        ellipse(p.x + p.size / 2, p.y + p.size / 2, dotSize, dotSize);
        if (timerAnimation < height) {
          timerAnimation += 0.025;
        }
      } else {
        //Pixel außerhalb der Messfelder bekommen die Farbe des Kamerabildes
        fill(brightness(p.col));
        noStroke();
        ellipse(p.x + p.size / 2, p.y + p.size / 2, dotSize, dotSize);
      }
      
      if (calibrated && (d > threshold)) {
        //Berechnung der Touchfelder für startLeft und startRight
        pixelTouched(p, guiStartLeft);
        pixelTouched(p, guiStartRight);
      }
      if (calibrated && touchArea(p, width * 0.4)) {
        if ((p.y < timerAnimation)) {
          fill(green);
          ellipse(p.x + p.size / 2, p.y + p.size / 2,  dotSize, dotSize);
        }
        if (timerAnimation >= 0) {
          timerAnimation -= 0.025;
        }
      }
      pixelIndex++;
    }

    if (humanDetected && !calibrated && (count < 5)) {
      if (guiCalibration.done()) {
        soundCollect.play();
        calibrated = true;
      }
    } else if (!calibrated && guiCalibration.running()) {
      guiCalibration.show();
      humanDetected = false;
      guiCalibration.reset();
    } else if (!humanDetected) {
      guiNoHuman.show();
    }

    if (!calibrated && humanDetected) {
      guiCalibration.show();
      if (frameCount % 60 == 0) {
        rasterFrozen = generateFrozen();
      }
    } else if (humanDetected && guiStart.done()) {
      calibrated = false;
      humanDetected = false;
    } else if (humanDetected) {
      guiStart.show();
      guiStartLeft.show();
      guiStartRight.show();
    }

    if (calibrated && (guiStartLeft.pixelCount > pixelMin) && (guiStartRight.pixelCount > pixelMin)) {
      if (guiStart.running()) {
        guiStart.reset();
      }
      if (!soundButton.isPlaying()) {
        soundButton.play();
      }
      if (guiStartLeft.done()) {
        readyLeft = true;
      }
      if (guiStartRight.done()) {
        readyRight = true;
      }
      if (readyRight && readyLeft) {
        resetCalibrationProcess();
        gh.playing();
      }
    } else if (guiStartLeft.running() || guiStartRight.running()) {
      resetCalibrationProcess();
      soundButton.stop();
    }
  }

  void resetCalibrationProcess() {
    guiStartLeft.reset();
    guiStartRight.reset();
    readyLeft = false;
    readyRight = false;
  }
}
