class pixel {

  float x;
  float y;
  int col;
  float size;

  pixel(float x_, float y_, float size_, int col_) {
    x = x_;
    y = y_;
    col = col_;
    size = size_;
  }

  void show() {
    fill(col);
    noStroke();
    rect(x, y, size, size);
  }
}
