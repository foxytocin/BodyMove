class trackMovementALT {

  float avgLeft = 0;
  float avgRight = 0;
  int countLeft = 0;
  int countRight = 0;
  float posLeft;
  float posRight;
  pixel frozenPixel = new pixel();
  int rainbowIndex = 0;

  float anteilAnGesamt = 0;
  float drawSize = 0;

  boolean movement = false;
  boolean error = false;
  boolean goal = false;

  trackMovementALT() {
  }

  trackMovementALT(ArrayList<pixel> array) {
    rasterFrozen = array;
  }

  void show() {

    int mstart = millis();
    avgLeft = 1;
    avgRight = 1;
    countLeft = 1;
    countRight = 1;
    
    rainbowIndex += 50;
    rainbowIndex %= 60000;

    int pixelIndex = 0;
    int pixelNotChanged = 0;
    for (pixel p : raster) {
      frozenPixel = rasterFrozen.get(pixelIndex);
      float d = calcColorDifference(p, frozenPixel.col);
      float pixelWeight = d / detail;

      if (d > thresholdFreze) {
        fill(rainbow.rainbow[(rainbowIndex + p.y * 5) % 60000]);
        if (p.x > 100 && p.x < video.width / 5) {
          countLeft++;
          avgLeft += p.y;
          fill(30);
        } else if ((p.x > (video.width / 5) * 4) && p.x < video.width - 100) {
          countRight++;
          avgRight += p.y;
          fill(30);
        }
        //Pixel die sich im Verhaeltniss zum rasterFreze geaendert haben
        noStroke();
        ellipse(p.x + detail / 2, p.y + detail / 2, pixelWeight, pixelWeight);
      } else {

        //Pixel bei denen keine Veraenderung erkannt wurde
        pixelNotChanged++;
        if (error) {
          fill(color(252, 1, 31));
        } else if (goal) {
          fill(color(98, 252, 2));
        } else {
          fill(75);
        }

        noStroke();
        ellipse(p.x + detail / 2, p.y + detail / 2, drawSize, drawSize);
      }
      pixelIndex++;
    }
    anteilAnGesamt = pixelNotChanged / (float)raster.size();
    drawSize = map(anteilAnGesamt, 0.6, 1, 0, detail);

    avgLeft /= countLeft;
    avgRight /= countRight;
    
    if(countLeft < 4 || countRight < 4) {
      movement = false;
    } else {
      movement = true;
    }

    if (movement) {
      if (avgLeft != 1) {
        posLeft = lerp(posLeft, avgLeft, 0.5);
        fill(100);
        noStroke();
        ellipse(100, posLeft, countLeft, countLeft);
      }

      if (avgRight != 1) {
        posRight = lerp(posRight, avgRight, 0.5);
        fill(100);
        noStroke();
        ellipse(video.width - 100, posRight, countRight, countRight);
      }
    }
    error = false;
    goal = false;
    int mend = millis();
    int mdiff = mend - mstart;
    println("Time for calculation: " +mdiff);
  }
}
