class line {

  float lheight = 10;

  line() {
  }

  void show() {
    stroke(lineAndBall);
    strokeWeight(lheight);
    line(0, trackMovement.posLeft, width, trackMovement.posRight);
  }
}
