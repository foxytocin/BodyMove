class gui {

  float error = 0;
  float target = 0;
  float collectedPoints = 0;
  float qual = 0;
  int note = 1;
  int moreOrLessHoles = 0;
  boolean countDown = false;
  int pixelMin = 10;
  int pixelMax = 3;
  String endReason = "";
  int max = 30;
  int min = 5;

  String convertNoteToGrade(int note) {
    switch(String.valueOf(note)) {
    case "1": return "A";
    case "2": return "B";
    case "3": return "C";
    case "4": return "D";
    case "5": return "E";
    case "6": return "F";
    default: return "ERROR";
    }
  }

  void reset() {
    error = 0;
    target = 0;
    qual = 0;
    note = 1;
    countDown = false;
    collectedPoints = 0;
  }

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

    //Ende Screen WINNER / LOSER
    if (gh.endScreen) {
      //WINNER LABEL  
      String grade = convertNoteToGrade(note);
      color qualCol = rainbow.rainbow[b.rainbowIndex];
      guiWinner.colRing = qualCol;
      guiWinner.colText = qualCol;
      guiWinner.label = endReason+ "\n\nYou reached\n" +(int)qual+ "%\nin quality\n\nGrade: " +grade;

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
      } else if (guiExit.running() && gh.endScreen) {
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
      } else if (guiAgain.running() && gh.endScreen) {
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
    
    //Berechnet die Punkte
    if (target > 0 || error > 0) {
        qual = (target / (target + error)) * collectedPoints;
        note = (int)map(qual - points, 0, 100, 6, 1);
      }

    //Wenn der Gamestatus = playing ist, wird in der linken oberen Ecke der aktuelle Punktestand angezeigt
    if (gh.playing) {
      noStroke();
      fill(backgroundCol);
      rectMode(CORNER);
      rect(0, 0, detail * scaleWidth * 8, detail * scaleHeight * 3, 10);
      pushMatrix();
      translate(20, 25);
      textAlign(LEFT);
      textSize(22);
      fill(textCol);
      text("Errors:", 0, 0);
      textSize(22);
      fill(textCol);
      text("Points:", 0, 29);
      textAlign(RIGHT);
      textSize(22);
      fill(textCol);
      text((int)error, 105, 0);
      textSize(22);
      fill(textCol);
      text((int)target, 105, 29);
      popMatrix();
    }
  }
}
