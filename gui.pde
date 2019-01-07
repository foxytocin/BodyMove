class gui {

  float error = 0;
  float target = 0;
  float qual = 100;
  int note = 1;
  int moreOrLessHoles = 0;
  
  int pixelMin = 10;
  int pixelMax = 3;

  void show() {

    //Pause
    if (gh.paused) {

      if (guiPause.done()) {
        gh.startScreen();
      }
      guiPause.show();   
    } else if (guiPause.running()) {
      guiPause.reset();
    }

    //Ende Screen WINNER
    if (gh.endScreen) {

      guiCircle guiWinner = new guiCircle(centerX, centerY, 200, ("WINNER\n\nYou reached " +(int)qual+ "%\nin quality\n\nGrade: " +note), 7, 32, rainbow.rainbow[b.rainbowIndex], color(100), rainbow.rainbow[b.rainbowIndex], 5, false);
      guiWinner.show();

      if ((guiExit.pixelCount > pixelMin) && (guiAgain.pixelCount < pixelMax) && (guiMore.pixelCount < pixelMax) && (guiLess.pixelCount < pixelMax)) {
        if (!soundButton.isPlaying()) {
          soundButton.play();
        }
        if (guiExit.done()) {
          gh.startScreen();
        }
      } else if (guiExit.running()) {
        guiExit.reset();
        soundButton.stop();
      }

      if ((guiAgain.pixelCount > pixelMin) && (guiExit.pixelCount < pixelMax) && (guiMore.pixelCount < pixelMax) && (guiLess.pixelCount < pixelMax)) {
        if (!soundButton.isPlaying()) {
          soundButton.play();
        }
        if (guiAgain.done()) {
          gh.restart();
        }
      } else if (guiAgain.running()) {
        guiAgain.reset();
        soundButton.stop();
      }

      int max = 5;
      if ((guiMore.pixelCount > pixelMin) && (guiAgain.pixelCount < pixelMax) && (guiExit.pixelCount < pixelMax) && (guiLess.pixelCount < pixelMax)) {
        guiMore.label = String.valueOf(holeAmount + moreOrLessHoles);
        if ((holeAmount + moreOrLessHoles) < max && guiMore.done()) {
          moreOrLessHoles++;
          soundCollect.play();
        } else if ((holeAmount + moreOrLessHoles) == max) {
          guiMore.label = String.valueOf(holeAmount + moreOrLessHoles);
          if (!soundError.isPlaying()) {
            soundError.play();
          }
        }
      } else if (moreOrLessHoles != 0) {
        guiMore.label = "MORE";
        holeAmount += moreOrLessHoles;
        moreOrLessHoles = 0;
        guiMore.reset();
      } else if ((holeAmount + moreOrLessHoles) == max) {
        guiMore.label = "MAX";
        guiMore.reset();
      } else {
        guiMore.label = "MORE";
        guiMore.reset();
      }

      int min = 1;
      if ((guiLess.pixelCount > pixelMin) && (guiAgain.pixelCount < pixelMax) && (guiMore.pixelCount < pixelMax) && (guiExit.pixelCount < pixelMax)) {
        guiLess.label = String.valueOf(holeAmount + moreOrLessHoles);
        if ((holeAmount + moreOrLessHoles) > min && guiLess.done()) {
          moreOrLessHoles--;
          soundCollect.play();
        } else if ((holeAmount + moreOrLessHoles) == min) {
          guiLess.label = String.valueOf(holeAmount + moreOrLessHoles);
          if (!soundError.isPlaying()) {
            soundError.play();
          }
        }
      } else if ( moreOrLessHoles != 0) {
        guiLess.label = "LESS";
        holeAmount += moreOrLessHoles;
        moreOrLessHoles = 0;
        guiLess.reset();
      } else if ((holeAmount + moreOrLessHoles) == min) {
        guiLess.label = "MIN";
        guiLess.reset();
      } else {
        guiLess.label = "LESS";
        guiLess.reset();
      }
      
      guiExit.show();
      guiAgain.show();
      guiMore.show();
      guiLess.show();
    }

    if (gh.playing) {
      pushMatrix();
      translate(detail, detail);

      noStroke();
      fill(100);
      rectMode(CORNER);
      rect(0, 0, detail * scaleWidth * 5, detail * scaleHeight * 2);

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
