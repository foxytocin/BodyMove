class trackMovement {

  color col = color(random(50, 255), random(50, 255), random(50, 255));
  float r = col >> 020 & 0xFF;
  float g = col >> 010 & 0xFF;
  float b = col        & 0xFF;
  float avgLeft = 0;
  float avgRight = 0;
  int countLeft = 0;
  int countRight = 0;

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

    for (pixel p : raster) {
      int actIndex = raster.indexOf(p);
      pixel frozenPixel = new pixel();
      frozenPixel = rasterFrozen.get(actIndex);
      float d = calcColorDifference(p, frozenPixel.col);

      //println(thresholdFreze );

      if (d > thresholdFreze && (p.x < video.width / 5 || p.x > (video.width / 5) * 4)) {

        if (p.x < video.width / 5) {
          countLeft++;
          avgLeft += p.y;
        } else if (p.x > (video.width / 5) * 4) {
          countRight++;
          avgRight += p.y;
        }

        fill(col);
        noStroke();
        //rect(p.x, p.y, detail, detail);
        ellipse(p.x + detail / 2, p.y + detail / 2, detail, detail);
      }
    }

    avgLeft /= countLeft;
    avgRight /= countRight;

    if (avgLeft != 1)
      posLeft = lerp(posLeft, avgLeft, 0.5);

    if (avgRight != 1)
      posRight = lerp(posRight, avgRight, 0.5);
  }
}
