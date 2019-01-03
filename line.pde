class line {

  float lheight = 10;

  line() {
  }

  void show() {
    stroke(rainbow.rainbow[b.rainbowIndex]);
    strokeWeight(lheight);
    line(0, trackMovement.posLeft, video.width, trackMovement.posRight);
  }
}
