class trackMovement {

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

  boolean error = false;
  boolean goal = false;

  trackMovement() {
  }

  trackMovement(ArrayList<pixel> array) {
    rasterFrozen = array;
  }

  void show() {

    avgLeft = 1;
    avgRight = 1;
    countLeft = 1;
    countRight = 1;

    rainbowIndex += 100;
    rainbowIndex %= 60000;

    int pixelIndex = 0;
    int pixelNotChanged = 0;
    for (pixel p : raster) {
      frozenPixel = rasterFrozen.get(pixelIndex);
      float d = calcColorDifference(p, frozenPixel.col);
      float pixelWeight = d / detail;

      if (d > thresholdFreze) {
        if (p.x > 100 && p.x < video.width / 6) {
          countLeft++;
          avgLeft += p.y;
        } else if ((p.x > (video.width / 6) * 5) && p.x < video.width - 100) {
          countRight++;
          avgRight += p.y;
        }
        //Pixel die sich im Verhaeltniss zum rasterFreze geaendert haben
        fill(rainbow.rainbow[rainbowIndex]);
        noStroke();
        ellipse(p.x + detail / 2, p.y + detail / 2, pixelWeight, pixelWeight);
      } else {

        //Pixel bei denen keine Veraenderung erkannt wurde
        pixelNotChanged++;
        //fill(75);
        if (!error && !goal) {
          fill(75);
        } else if (error) {
          fill(color(252, 1, 31));
        } else if (goal) {
          fill(color(98, 252, 2));
        }

        noStroke();
        ellipse(p.x + detail / 2, p.y + detail / 2, drawSize, drawSize);
      }
      pixelIndex++;
    }
    anteilAnGesamt = pixelNotChanged / ((float)video.width / (float)detail * (float)video.height / (float)detail);
    drawSize = map(anteilAnGesamt, 0.6, 1, 0, detail);

    avgLeft /= countLeft;
    avgRight /= countRight;

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
    error = false;
    goal = false;
  }
}
