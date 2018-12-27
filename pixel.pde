class pixel {

  int x;
  int y;
  int col;
  int detail;

  pixel() {
  };

  pixel(int x_, int y_, int detail_, int col_) {
    x = x_;
    y = y_;
    col = col_;
    detail = detail_;
  }

  void show() {

    float r = col >> 020 & 0xFF;
    float g = col >> 010 & 0xFF;
    float b = col        & 0xFF;

    // Change brightness according to the mouse here
    //float adjustBrightness = ((float) mouseX / width) * 8.0;
    r *= adjustBrightness;
    g *= adjustBrightness;
    b *= adjustBrightness;
    // Constrain RGB to between 0-255
    r = constrain(r, 0, 255);
    g = constrain(g, 0, 255);
    b = constrain(b, 0, 255);
    // Make a new color and set pixel in the window
    color c = color(r, g, b);
    col = c;

    fill(col);
    //stroke(0);
    noStroke();
    rect(x, y, detail, detail);
    //fill(0);
    //text(raster.indexOf(this), x + detail / 3, y + detail / 3);
    //text(col, x + detail / 4, y + detail / 4);
  }
}
