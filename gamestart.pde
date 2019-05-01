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

  void pixelTouched(pixel p, guiCircle button) {
    if (p.x > (button.x - button.r) &&  p.x < (button.x + button.r) && p.y > (button.y - button.r) && p.y < (button.y + button.r)) {
      button.pixelCount++;
    }
  }

  void show() {
    guiStartLeft.pixelCount = 0;
    guiStartRight.pixelCount = 0;
    background(backgroundCol);
    int pixelIndex = 0;
    count = 0;

    for (pixel p : raster) {
      //Pixel die kontrolliert werden
      frozenPixel = rasterFrozen.get(pixelIndex);
      d = calcColorDifference(p, frozenPixel.col);

      if (!calibrated && (p.x > 50 && p.x < width / 5 || (p.x > ((width / 5) * 4) - detail) && p.x < width - 70)) {
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
          fill(p.col);
        }
        noStroke();
        ellipse(p.x + p.size / 2, p.y + p.size / 2, p.size * 0.8, p.size * 0.8);
        if (timerAnimation < height) {
          timerAnimation += 0.025;
        }
      } else {
        //Pixel bei denen eine Veraenderung erkannt wurde
        fill(p.col);
        noStroke();
        ellipse(p.x + p.size / 2, p.y + p.size / 2, p.size * 0.8, p.size * 0.8);
      }
      if (calibrated && (d > threshold)) {
        //Berechnung der Touchfelder für startLeft und startRight
        pixelTouched(p, guiStartLeft);
        pixelTouched(p, guiStartRight);
      }
      if (calibrated && (p.x > 50 && p.x < width / 5 || (p.x > ((width / 5) * 4) - detail) && p.x < width - 70)) {
        if ((p.y < timerAnimation)) {
          fill(green);
          ellipse(p.x + p.size / 2, p.y + p.size / 2, p.size * 0.8, p.size * 0.8);
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
