import processing.video.*;

int detail;
ArrayList<pixel> raster;
ArrayList<pixel> rasterFrozen;
ArrayList<trackColor> trackedColors;
trackMovement trackMovement;
boolean hideInput;
color trackCol;
float worldRecord;
int closestX;
int closestY;
Capture video;
//PImage video;
float threshold;
float thresholdFreze;
boolean trackMov = false;
float adjustBrightness;
ball b;
line l;
float posLeft;
float posRight;

void setup() {
  size(1280, 720);
  //size(600, 900);
  //printArray(Capture.list());
  //video = loadImage("wand3.jpg");
  video = new Capture(this, Capture.list()[0]);
  video.start();
  detail = 16;
  trackCol = color(255, 0, 0);
  adjustBrightness = 1;
  hideInput = false;
  b = new ball();
  l = new line();
  raster = new ArrayList<pixel>();
  rasterFrozen = new ArrayList<pixel>();
  trackedColors = new ArrayList<trackColor>();
  trackMovement = new trackMovement();
  threshold = 20;
  thresholdFreze = 45;
}

void draw() {
  frameRate(30);
  //detail = floor(map(mouseX, 0, width, 5, 150));
  //image(video, 0, 0);
  calcRaster();
  invertRaster();

  for (trackColor tc : trackedColors) {
    tc.findColor();
  }

  showRaster(raster);

  if (!trackMov) {
    rasterFrozen.clear();
    rasterFrozen.addAll(raster);
  }

  if (trackMov) {
    trackMovement.show();
    b.update();
    l.show(); 
    b.show();
  }

  if (!mousePressed) {
    raster.clear();
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT && !trackMov) {
      if (detail < video.height / 2)
        detail += 5;
    } else if (keyCode == LEFT && !trackMov) {
      if (detail >= 10)
        detail -= 5;
    } else if (keyCode == RIGHT && trackMov) {
      if (thresholdFreze < 100)
        thresholdFreze += 2;
    } else if (keyCode == LEFT && trackMov) {
      if (thresholdFreze >= 10)
        thresholdFreze -= 2;
    } else if (keyCode == UP) {
      if (threshold <= 100)
        threshold += 2;
    } else if (keyCode == DOWN) {
      if (threshold >= 3)
        threshold -= 2;
    }
  }
  if (key == ' ') {
    trackedColors.clear();
  }
  if (key == 't' && !trackMov) {
    trackMov = true;
  } else if (key == 'r' && trackMov) {
    trackMov = false;
  }
  if (key == 'q') {
    adjustBrightness += 0.1;
  } else if (key == 'a') {
    adjustBrightness -= 0.1;
  }
  if (key == 'h' && !hideInput) {
    hideInput = true;
  } else if (key == 'h' && hideInput) {
    hideInput = false;
  }
}

void captureEvent(Capture video) {
  video.read();
}

void calcRaster() {
  for (int i = 0; i < height; i += detail) {
    for (int j = 0; j < width; j += detail) {
      PImage newImg = video.get(j, i, detail, detail);
      raster.add(new pixel(j, i, detail, extractColorFromImage(newImg)));
    }
  }
}

void showRaster(ArrayList<pixel> raster) {
  if (!hideInput) {
    for (pixel p : raster) {
      p.show();
    }
  } else if (hideInput) {
    background(30);
  }
}

void invertRaster() {
  ArrayList invertedRaster = new ArrayList<pixel>();

  for (int i = 0; i < video.height; i += detail) {
    int xPosPixel = 0;
    for (int j = video.width - detail; j > 0; j -= detail) {
      int index = (int)(j / detail) + (int)(i / detail) * (int)(video.width / detail);
      pixel p = new pixel();
      p = raster.get(index);
      p.x = xPosPixel;
      xPosPixel += detail;
      invertedRaster.add(p);
    }
  }
  raster.clear();
  raster.addAll(invertedRaster);
}

float calcColorDifference(pixel p, color trackCol) {
  float r1 = red(p.col);
  float g1 = green(p.col);
  float b1 = blue(p.col);
  float r2 = red(trackCol);
  float g2 = green(trackCol);
  float b2 = blue(trackCol);

  return dist(r1, g1, b1, r2, g2, b2);
}

void mouseClicked() {
  int index = (int)(mouseX / detail) + (int)(mouseY / detail) * (int)(video.width / detail);
  color trackCol = raster.get(index).col;
  //println(index);

  trackedColors.add(new trackColor(trackCol));
}


color extractColorFromImage(final PImage img) {
  video.loadPixels();
  color r = 0, g = 0, b = 0;

  for (final color c : img.pixels) {
    r += c >> 020 & 0xFF;
    g += c >> 010 & 0xFF;
    b += c        & 0xFF;
  }

  r /= img.pixels.length;
  g /= img.pixels.length;
  b /= img.pixels.length;

  return color(r, g, b);
}
