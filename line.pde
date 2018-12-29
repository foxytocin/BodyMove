class line {

  float lheight = 10;

  line() {
  }

  void show() {
    //stroke(colorChange);
    stroke(0, 102, 204);
    strokeWeight(lheight);
    line(0, trackMovement.posLeft, video.width, trackMovement.posRight);
  }
}
