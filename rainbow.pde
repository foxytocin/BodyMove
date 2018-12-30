class rainbow {

  color[] rainbow;
  int c;
  
  rainbow() {

    rainbow = new color[60000];
    c = 0;
    
    // Starts as green, becomes yellow
    for (int r = 0; r < 10000; r++) {
      rainbow[c] = color(r*255/10000, 255, 0);
      c++;
    }

    // Starts as yellow, becomes red
    for (int g = 10000; g > 0; g--) {
      rainbow[c] = color(255, g*255/10000, 0);
      c++;
    }

    // Starts as red, becomes magenta
    for (int b = 0; b < 10000; b++) {
      rainbow[c]= color(255, 0, b*255/10000);
      c++;
    }

    // Starts as magenta, becomes blue
    for (int r = 10000; r > 0; r--) {
      rainbow[c] = color(r*255/10000, 0, 255);
      c++;
    }

    // Stars as blue, becomes cyan
    for (int g = 0; g < 10000; g++) {
      rainbow[c] = color(0, g*255/10000, 255);
      c++;
    }

    // Starts as cyan, becomes green
    for (int b = 10000; b > 0; b--) {
      rainbow[c] = color(0, 255, b*255/1000);
      c++;
    }
  }
}
