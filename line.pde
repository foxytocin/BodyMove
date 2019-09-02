class line {

  int lheight = 10;
  float posLeft = 0;
  float posRight = 0;

  line() {
  }

  void show() {
    stroke(lineAndBall);
    strokeWeight(lheight);
    line(0, posLeft, width, posRight);
  }
}
