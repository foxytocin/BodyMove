import processing.video.*;
import processing.sound.*;

//Spielvriablen
int holeAmount = 10;
float contrast = 0.735;
float threshold = 20;
float scaleWidth;
float scaleHeight;
float circleSize = 60;
int detail = 10;

color colorChange = color(0, 0, 0);
color backgroundCol = color(100);
color green = color(98, 252, 2);
color red = color(252, 1, 31);
color orange = color(255, 178, 56);
color textCol = color(50);

ArrayList<pixel> rasterFrozen;
ArrayList<pixel> raster;
ArrayList<hole> holes;
ArrayList<circleAnimation> circleAnimations;
boolean hideInput;
color trackCol;
int closestX, closestY;
boolean trackMov = false;
rainbow rainbow;
Capture video;
trackMovement trackMovement;
ball b;
line l;
gui g;
gamehandler gh = new gamehandler();
gamestart gs = new gamestart();

//Gui Elemente
guiCircle guiPause, guiExit, guiAgain, guiMore, guiLess, guiWinner, guiForceExit, guiCalibration, guiStart, guiStartLeft, guiStartRight, guiLoading;
float nwX, nwY, noX, noY, soX, soY, swX, swY, centerX, centerY, border, radiusM;

//Sound
SoundFile soundCollect, soundError, soundRollingStone, soundButton, soundMusic, soundClock;

void setup() {
  // Load a soundfile from the /data folder of the sketch and play it back
  soundCollect = new SoundFile(this, "collect.wav");
  soundError = new SoundFile(this, "error.wav");
  soundRollingStone = new SoundFile(this, "rollingstone.wav");
  soundButton = new SoundFile(this, "button.mp3");
  soundClock = new SoundFile(this, "clock.mp3");
  soundMusic = new SoundFile(this, "music.mp3");
  soundButton.amp(0.5);
  soundMusic.amp(0.3);
  soundMusic.loop();

  fullScreen();
  //size(1280, 720);
  //printArray(Capture.list());
  video = new Capture(this, Capture.list()[3]);
  video.start();
  trackCol = color(255, 0, 0);
  hideInput = true;

  b = new ball(width / 2, height - 150, circleSize);
  l = new line();
  g = new gui();
  circleAnimations = new ArrayList<circleAnimation>();
  raster = new ArrayList<pixel>();
  rasterFrozen = new ArrayList<pixel>();
  holes = new ArrayList<hole>();
  trackMovement = new trackMovement();
  rainbow = new rainbow();

  //Gui Elemente
  border = 150;
  radiusM = 80;
  nwX = border;
  nwY = border;
  noX = width - border;
  noY = border;
  soX = width - border;
  soY = height - border;
  swX = border;
  swY = height - border;
  centerX = width / 2;
  centerY = height / 2;
  guiLoading = new guiCircle(centerX, centerY, 200, ("LOADING"), 1, 52, orange, color(100), orange, 10, 2, false);
  guiPause = new guiCircle(centerX, centerY, 200, "PAUSED\n\nIf time's up, you're\nout. To continue\nspread your arms", 7, 32, textCol, color(100), red, 10, 15, true);
  guiWinner = new guiCircle(centerX, centerY, 200, ("WINNER TEXT"), 7, 32, rainbow.rainbow[b.rainbowIndex], color(100), rainbow.rainbow[b.rainbowIndex], 10, 15, false);
  guiCalibration = new guiCircle(centerX, centerY, 200, "CALIBRATING\n\nPlace yourself in the\nmiddle of the screen\nDon't move", 6, 32, orange, color(100), orange, 10, 1.5, false);
  guiStart = new guiCircle(centerX, centerY, 200, ("READY\n\nTo start, hover\neach hand over the\nleft and right\ncircle"), 7, 32, rainbow.rainbow[b.rainbowIndex], color(100), rainbow.rainbow[b.rainbowIndex], 10, 15, true);
  guiForceExit = new guiCircle(nwX, nwY, radiusM, "LEAVING", 1, 32, red, color(100), red, 6, 15, true);
  guiExit = new guiCircle(nwX, nwY, radiusM, "EXIT", 1, 32, red, color(100), red, 6, 1, false);
  guiAgain = new guiCircle(noX, noY, radiusM, "AGAIN", 1, 32, green, color(100), green, 6, 1, false);
  guiMore = new guiCircle(soX, soY, radiusM, "MORE", 1, 32, orange, color(100), orange, 6, 0.5, false);
  guiLess = new guiCircle(swX, swY, radiusM, "LESS", 1, 32, orange, color(100), orange, 6, 0.5, false);
  guiStartRight = new guiCircle(soX, soY, radiusM, "RIGHT", 1, 32, green, color(100), green, 6, 0.5, false);
  guiStartLeft = new guiCircle(swX, swY, radiusM, "LEFT", 1, 32, green, color(100), green, 6, 0.5, false);

  initHoles();
}

void draw() {
  frameRate(60);
  background(backgroundCol);
  scaleWidth = width / (float)video.width;
  scaleHeight = height / (float)video.height;
  raster = calcRaster();

  if (rasterFrozen.size() <= 0) {
    rasterFrozen = generateFrozen();
  }

  switch(gh.status) {
  case "loading":
    if (guiLoading.done()) {
      gh.startScreen();
    };
    guiLoading.show();
    break;
  case "startScreen":
    gs.show();
    break;
  case "playing":
    trackMovement.show();
    b.update();
    l.show(); 
    b.show();
    gameplay();
    break;
  case "paused":
    trackMovement.show();
    l.show(); 
    b.show();
    gameplay();
    break;
  case "endScreen":
    trackMovement.show();
    l.show(); 
    b.show();
    gameplay();
    break;
  }
  g.show();
}

ArrayList<pixel> generateFrozen() {
  ArrayList<pixel> rasterFrozen = new ArrayList<pixel>();
  rasterFrozen.addAll(raster);
  return rasterFrozen;
}

void calcThreshold() {
  if (trackMovement.anteilAnGesamt < contrast - 0.02 || trackMovement.anteilAnGesamt > contrast + 0.02) {
  } else if (trackMovement.anteilAnGesamt < contrast) {
    threshold += 1;
  } else if (trackMovement.anteilAnGesamt > contrast) {
    threshold -= 1;
  }
  println("AUTO: Contrast: " +contrast+ " / NotTracked: " +trackMovement.anteilAnGesamt+ " / thresholdFreze: " +threshold);
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
    if (keyCode == RIGHT) {
      if (contrast < 0.95)
        contrast += 0.05;
    } else if (keyCode == LEFT) {
      if (contrast >= 0.1)
        contrast -= 0.05;
    }
  }
  if (key == 't' && !trackMov) {
    trackMov = true;
  } else if (key == 'r' && trackMov) {
    trackMov = false;
  }
  if (key == 'h' && !hideInput) {
    hideInput = true;
  } else if (key == 'h' && hideInput) {
    hideInput = false;
  }
  if (key==' ') {
    gh.restart();
  }
  if (key=='r') {
    gh.startScreen();
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
      raster.add(new pixel(xPosPixel * scaleWidth, i * scaleHeight, (detail * scaleWidth), extractColorFromImage(newImg)));
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
      hole h = new hole(x, y, circleSize);
      holes.add(h);
    } else {
      if (noOverlap(x, y)) {
        hole h = new hole(x, y, circleSize);
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
    for (hole h: holes) {
      if (dist(x, y, h.x, h.y) > 2 * circleSize) {
        continue;
      } else {
        return false;
      }
    }
  return true;
}
