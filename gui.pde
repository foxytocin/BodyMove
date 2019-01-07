class gui {

  float error = 0;
  float target = 0;
  float qual = 100;
  int note = 1;
  int moreOrLessHoles = 0;
  boolean countDown = false;
  int pixelMin = 10;
  int pixelMax = 3;
  
  int max = 30;
  int min = 5;

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
      //WINNER LABEL  
      String grade = "";
      switch(note) {
      case 1: grade = "A"; break;
      case 2: grade = "B"; break;
      case 3: grade = "C"; break;
      case 4: grade = "D"; break;
      case 5: grade = "E"; break;
      case 6: grade = "F"; break;
      }
      
      color qualCol = rainbow.rainbow[b.rainbowIndex];
      guiWinner.colRing = qualCol;
      guiWinner.colText = qualCol;
      guiWinner.label = "WINNER\n\nYou reached " +(int)qual+ "%\nin quality\n\nGrade: " +grade;

      //MENU FORCE EXIT
      if ((guiExit.pixelCount < pixelMax) && (guiAgain.pixelCount < pixelMax) && (guiMore.pixelCount < pixelMax) && (guiLess.pixelCount < pixelMax)) {
        if ((frameCount % 300 == 0) && !countDown) {
          countDown = true;
        }
        if (countDown && guiForceExit.done()) {
          gh.startScreen();
        }
      } else if (guiForceExit.running()) {
        countDown = false;
        guiForceExit.reset();
      }

      //MENU EXIT
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

      //MENU AGAIN
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

      //MENU MORE
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
        guiMore.colRing = guiMore.colRing_Backup;
        guiMore.colText = guiMore.colText_Backup;
        guiMore.label = "MORE";
        holeAmount += moreOrLessHoles;
        moreOrLessHoles = 0;
        guiMore.reset();
      } else if ((holeAmount + moreOrLessHoles) == max) {
        guiMore.colRing = color(75);
        guiMore.colText = color(75);
        guiMore.label = "MAX";
        guiMore.reset();
      } else {
        guiMore.colRing = guiMore.colRing_Backup;
        guiMore.colText = guiMore.colText_Backup;
        guiMore.label = "MORE";
        guiMore.reset();
      }

      //MENU LESS
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
        guiLess.colRing = guiLess.colRing_Backup;
        guiLess.colText = guiLess.colText_Backup;
        guiLess.label = "LESS";
        holeAmount += moreOrLessHoles;
        moreOrLessHoles = 0;
        guiLess.reset();
      } else if ((holeAmount + moreOrLessHoles) == min) {
        guiLess.colRing = color(75);
        guiLess.colText = color(75);
        guiLess.label = "MIN";
        guiLess.reset();
      } else {
        guiLess.colRing = guiLess.colRing_Backup;
        guiLess.colText = guiLess.colText_Backup;
        guiLess.label = "LESS";
        guiLess.reset();
      }

      if (countDown) {
        guiForceExit.show();
      } else {
        guiExit.show();
      }
      guiWinner.show();
      guiAgain.show();
      guiMore.show();
      guiLess.show();
    }

    if (gh.playing) {
      noStroke();
      fill(100);
      rectMode(CORNER);
      rect(0, 0, detail * scaleWidth * 6, detail * scaleHeight * 3, 10);
      if (target > 0 || error > 0) {
        qual = target / (target + error) * 100;
        note = (int)map(qual, 0, 100, 6, 1);
      }
      
      pushMatrix();
      translate(20, 30);
      textAlign(LEFT);
      textSize(22);
      fill(textCol);
      text("Errors:", 0, 0);
      textSize(22);
      fill(textCol);
      text("Points:", 0, 31);
      textAlign(RIGHT);
      textSize(22);
      fill(textCol);
      text((int)error, 105, 0);
      textSize(22);
      fill(textCol);
      text((int)target, 105, 31);
      popMatrix();
    }
  }
}
