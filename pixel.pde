class pixel {

  float x;
  float y;
  int col;
  float size;

  pixel() {
  };

  pixel(float x_, float y_, float size_, int col_) {
    x = x_;
    y = y_;
    col = col_;
    size = size_;
  }

  void show() {

    float r = col >> 020 & 0xFF;
    float g = col >> 010 & 0xFF;
    float b = col        & 0xFF;

    r *= adjustBrightness;
    g *= adjustBrightness;
    b *= adjustBrightness;
    
    // Constrain RGB to between 0-255
    r = constrain(r, 0, 255);
    g = constrain(g, 0, 255);
    b = constrain(b, 0, 255);
    
    // Make a new color and set pixel in the window
    col = color(r, g, b);

    fill(col);
    noStroke();
    rect(x, y, size, size);
  }
}
