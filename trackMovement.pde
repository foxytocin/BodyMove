class trackMovement {

  color col = color(random(50, 255), random(50, 255), random(50, 255));
  float r = col >> 020 & 0xFF;
  float g = col >> 010 & 0xFF;
  float b = col        & 0xFF;
  float avgLeft = 0;
  float avgRight = 0;
  int countLeft = 0;
  int countRight = 0;
  float posLeft;
  float posRight;
  pixel frozenPixel = new pixel();

  boolean rup = true;
  boolean gup = true;
  boolean bup = true;

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

    if (rup) {
      r++;
    } else if (!rup) {
      r--;
    }
    if (bup) {
      b++;
    } else if (!bup) {
      b--;
    }
    if (gup) {
      g++;
    } else if (!gup) {
      g--;
    }

    if (r == 255) rup = false;
    if (r == 50) rup = true;
    if (b == 255) bup = false;
    if (b == 50) bup = true;
    if (g == 255) gup = false;
    if (g == 50) gup = true;

    col = color(r, g, b);
    colorChange = col;

    int pixelIndex = 0;
    for (pixel p : raster) {
      if ((p.x > 100 && p.x < video.width / 6) || (p.x > (video.width / 6) * 5) && p.x < video.width - 100) {
        frozenPixel = rasterFrozen.get(pixelIndex);
        float d = calcColorDifference(p, frozenPixel.col);
        float pixelWeight = d / detail;

        if (d > thresholdFreze) {
          if (p.x < video.width / 5) {
            countLeft++;
            avgLeft += p.y;
          } else if (p.x > (video.width / 5) * 4) {
            countRight++;
            avgRight += p.y;
          }
          fill(col);
          noStroke();
          ellipse(p.x + detail / 2, p.y + detail / 2, pixelWeight, pixelWeight);
        }
      }
      pixelIndex++;
    }

    avgLeft /= countLeft;
    avgRight /= countRight;

    if (avgLeft != 1)
      posLeft = lerp(posLeft, avgLeft, 0.5);

    if (avgRight != 1)
      posRight = lerp(posRight, avgRight, 0.5);
  }
}
