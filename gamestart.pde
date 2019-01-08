class gamestart {

  int count = 0;
  int testsPassed = 0;
  pixel frozenPixel;
  boolean calibrated = false;
  boolean readyLeft = false;
  boolean readyRight = false;
  float d;
  int pixelMin = 10;
  int pixelMax = 3;

  gamestart() {
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
        if (d > threshold) {
          count++;
          fill(red);
        } else {
          fill(green);
        }
        noStroke();
        ellipse(p.x + p.size / 2, p.y + p.size / 2, p.size * 0.8, p.size * 0.8);
      } else {
        //Pixel bei denen eine Veraenderung erkannt wurde
        //fill(30, 100);
        fill(p.col);
        noStroke();
        ellipse(p.x + p.size / 2, p.y + p.size / 2, p.size * 0.8, p.size * 0.8);
      }

      if (calibrated && (d > threshold)) {
        //Berechnung der Touchfelder für StartLeft und startRight
        pixelTouched(p, guiStartLeft);
        pixelTouched(p, guiStartRight);
      }    
      pixelIndex++;
    }

    if (!calibrated && (count < 5)) {
      if (guiCalibration.done()) {
        soundCollect.play();
        calibrated = true;
      }
    } else if (!calibrated && guiCalibration.running()) {
      guiCalibration.reset();
    }

    if (!calibrated) {
      guiCalibration.show();
      if (frameCount % 60 == 0) {
        rasterFrozen = generateFrozen();
      }
    } else if (guiStart.done()) {
      calibrated = false;
    } else {
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
