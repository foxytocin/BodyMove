import processing.video.*;
import processing.sound.*;

//Spielvriablen
int holeAmount = 10;
float contrast = 0.785;
float thresholdFreze = 40;

rainbow rainbow;
Capture video;
color colorChange = color(0, 0, 0);
color backgroundCol = color(100);
int detail;
ArrayList<pixel> rasterFrozen;
ArrayList<pixel> raster;
ArrayList<hole> holes;
ArrayList<circleAnimation> circleAnimations;
boolean hideInput;
color trackCol;
int closestX;
int closestY;
float threshold;
boolean trackMov = false;
trackMovement trackMovement;
float adjustBrightness;
ball b;
line l;
gui g;
gamehandler gh = new gamehandler();
gamestart gs = new gamestart();

//Sound
SoundFile soundCollect;
SoundFile soundError;
SoundFile soundRollingStone;

void setup() {
  // Load a soundfile from the /data folder of the sketch and play it back
  soundCollect = new SoundFile(this, "collect.wav");
  soundError = new SoundFile(this, "error.wav");
  soundRollingStone = new SoundFile(this, "rollingstone.wav");

  size(1280, 720);
  //printArray(Capture.list());
  video = new Capture(this, Capture.list()[0]);
  video.start();
  detail = 16;
  trackCol = color(255, 0, 0);
  adjustBrightness = 1;
  hideInput = true;
  b = new ball();
  l = new line();
  g = new gui();
  circleAnimations = new ArrayList<circleAnimation>();
  raster = new ArrayList<pixel>();
  rasterFrozen = new ArrayList<pixel>();
  holes = new ArrayList<hole>();
  initHoles();
  trackMovement = new trackMovement();
  threshold = 20;
  rainbow = new rainbow();
}

void draw() {
  //frameRate(30);

  background(backgroundCol);
  raster = calcRaster();

  if (rasterFrozen.size() <= 0) {
    rasterFrozen = generateFrozen();
  }

  switch(gh.status) {

  case "loading":
    showRaster();
    println("LOADING ...");
    gh.startScreen();
    break;
  case "startScreen":
    showRaster();
    gs.testingReady();
    println("STARTSCREEN");
    break;
  case "playing":
    trackMovement.show();
    calcThreshold();
    b.update();
    l.show(); 
    b.show();
    gameplay();
    println("PLAYING");
    break;
  case "paused":
    trackMovement.show();
    l.show(); 
    b.show();
    println("PAUSED");
    break;
  case "endScreen":
    trackMovement.show();
    l.show(); 
    b.show();
    println("ENDSCREEN");
    break;
  }

  g.show();
}

ArrayList<pixel> generateFrozen() {
  ArrayList<pixel> rasterFrozen = new ArrayList<pixel>();
  rasterFrozen.addAll(raster);
  println("Genrated frozenRaster: " +rasterFrozen.size());
  return rasterFrozen;
}

void calcThreshold() {
  if (trackMovement.anteilAnGesamt < contrast - 0.02 || trackMovement.anteilAnGesamt > contrast + 0.02) {
  } else if (trackMovement.anteilAnGesamt < contrast) {
    thresholdFreze += 1;
  } else if (trackMovement.anteilAnGesamt > contrast) {
    thresholdFreze -= 1;
  }
  println("AUTO: Contrast: " +contrast+ " / NotTracked: " +trackMovement.anteilAnGesamt+ " / thresholdFreze: " +thresholdFreze);
}

void gameplay() {
  //CircleAnimation abspielen / aus dem Array entfernen wenn die Animation beendet wurde
  for (int i = circleAnimations.size() - 1; i >= 0; i--) {
    circleAnimation ca = circleAnimations.get(i);
    if (ca.finished) {
      circleAnimations.remove(i);
    } else {
      ca.update();
      ca.show();
    }
  }

  //Ueberprüft ob ein Hole vom Ball beruerht wir, ob ein Target-Hole erfolgreich gesammelt wurde und ob ein neuen Target-Hole erzeugt werden muss.
  for (int i = holes.size() - 1; i >= 0; i--) {
    hole h = holes.get(i);
    String todo = h.ballMatchHole();
    if (todo != null) {
      circleAnimation a = new circleAnimation(h, todo);
      circleAnimations.add(a);
    }
    if (h.collected) {
      holes.remove(h);
      pickTarget();
    }
    h.update();
    h.show();
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT && !trackMov) {
      if (detail < video.height / 2)
        detail += 4;
    } else if (keyCode == LEFT && !trackMov) {
      if (detail >= 10)
        detail -= 4;
    } else if (keyCode == RIGHT && trackMov) {
      if (contrast < 0.95)
        contrast += 0.05;
    } else if (keyCode == LEFT && trackMov) {
      if (contrast >= 0.1)
        contrast -= 0.05;
    } else if (keyCode == UP) {
      if (threshold <= 100)
        threshold += 2;
    } else if (keyCode == DOWN) {
      if (threshold >= 3)
        threshold -= 2;
    }
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
  if (key==' ') {
    gh.restart();
  }
  if (key=='p') {
    if (gh.startScreen) {
      gh.playing();
    } else if (gh.playing) {
      gh.paused();
    } else if (gh.paused) {
      gh.playing();
    }
  }
}

void captureEvent(Capture video) {
  video.read();
}

ArrayList<pixel> calcRaster() {
  ArrayList<pixel> raster = new ArrayList<pixel>();
  for (int i = 0; i < video.height; i += detail) {
    int xPosPixel = 0;
    for (int j = video.width - detail; j >= 0; j -= detail) {
      PImage newImg = video.get(j, i, detail, detail);
      raster.add(new pixel(xPosPixel, i, detail, extractColorFromImage(newImg)));
      xPosPixel += detail;
    }
  }
  return raster;
}

void showRaster() {
  for (pixel p : raster) {
    p.show();
  }
}

float calcColorDifference(pixel p, color trackCol) {
  float r1 = p.col >> 020 & 0xFF;
  float g1 = p.col >> 010 & 0xFF;
  float b1 = p.col        & 0xFF;
  float r2 = trackCol >> 020 & 0xFF;
  float g2 = trackCol >> 010 & 0xFF;
  float b2 = trackCol        & 0xFF;

  return dist(r1, g1, b1, r2, g2, b2);
}

color extractColorFromImage(final PImage img) {
  img.loadPixels();
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

void initHoles() {
  holes.clear();
  int noFreeSpaceCounter = 0;
  while (holes.size() < holeAmount && noFreeSpaceCounter < 50) {
    float x = random(75, width - 75);
    float y = random(75, height - 250);

    if (holes.size() == 0) {
      hole h = new hole(x, y);
      holes.add(h);
    } else {
      if (noOverlap(x, y)) {
        hole h = new hole(x, y);
        holes.add(h);
      } else {
        noFreeSpaceCounter++;
      }
    }
  }
  pickTarget();
}

void pickTarget() {
  if (holes.size() > 0) {
    int r = (int)random(holes.size());
    holes.get(r).target = true;
  } else {
    gh.endScreen();
  }
}

boolean noOverlap(float x, float y) {
  for (hole h : holes) {
    if (dist(x, y, h.x, h.y) > 4 * h.r) {
      continue;
    } else {
      return false;
    }
  }
  return true;
}
