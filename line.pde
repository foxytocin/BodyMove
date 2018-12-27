class line {

  float lheight = 6;
  
  line() {
  }

  void show() {
    stroke(0,102, 204);
    strokeWeight(lheight);
    line(0, posLeft, video.width, posRight);
  }
}
