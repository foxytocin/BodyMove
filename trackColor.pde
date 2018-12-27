class trackColor {

  float worldRecord;
  color trackCol;
  pixel refPixel = new pixel();

  trackColor(color col) {
    trackCol = col;
  }

  void findColor() {
    worldRecord = 500;

    for (pixel p : raster) {
      float d = calcColorDifference(p, trackCol);
      if (d < worldRecord) {
        worldRecord = d;
        refPixel = p;
        closestX = p.x + detail / 2;
        closestY = p.y + detail / 2;
      }
    }

    fill(trackCol);
    noStroke();
    ellipse(closestX, closestY, detail, detail);

    for (pixel p : raster) {
      float diff = calcColorDifference(p, refPixel.col);
      if (diff < threshold) {
        fill(trackCol);
        noStroke();
        ellipse(p.x + detail / 2, p.y + detail / 2, diff, diff);
      }
    }
  }
}
