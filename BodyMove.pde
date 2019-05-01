import processing.video.*;
import processing.sound.*;

//Spielvriablen
int holeAmount = 5;
float threshold = 50;
float scaleWidth = 0;
float scaleHeight = 0;
float circleSize = 60;
int detail = 8;
int frames = 60;

color colorChange = color(0, 0, 0);
color backgroundCol = color(120);
color green = color(98, 252, 2);
color red = color(252, 1, 31);
color orange = color(255, 178, 56);
color textCol = color(50);
color lineAndBall = color(50);
float points = 0;

ArrayList<pixel> rasterFrozen;
ArrayList<pixel> raster;
ArrayList<hole> holes;
ArrayList<hole> deadHoles;
ArrayList<circleAnimation> circleAnimations;
ArrayList<explosion> explosions;
boolean hideInput;
boolean tracking = false;
rainbow rainbow;
Capture video;
trackMovement trackMovement;
ball b;
line l;
gui g;
gamehandler gh = new gamehandler();
gamestart gs = new gamestart();

//Gui Elemente
guiCircle guiPause, guiExit, guiAgain, guiMore, guiLess, guiWinner, guiForceExit, guiCalibration, guiStart, guiStartLeft, guiStartRight, guiLoading, guiNoHuman;
float nwX, nwY, noX, noY, soX, soY, swX, swY, centerX, centerY, border, radiusM;

//Sound
SoundFile soundCollect, soundError, soundButton, soundMusic, soundClock, soundScream, soundWinner, soundSuck;

void setup() {
  //Laden der Soundfiles
  soundCollect = new SoundFile(this, "collect.wav");
  soundError = new SoundFile(this, "error.wav");
  soundButton = new SoundFile(this, "button.mp3");
  soundClock = new SoundFile(this, "clock.mp3");
  soundMusic = new SoundFile(this, "mine.mp3");
  soundScream = new SoundFile(this, "scream.mp3");
  soundWinner = new SoundFile(this, "winner.mp3");
  soundSuck = new SoundFile(this, "suck.wav");
  soundButton.amp(0.5);
  soundMusic.amp(0.3);
  soundScream.amp(0.3);
  soundWinner.amp(0.3);
  soundMusic.loop();

  fullScreen();
  //size(1280, 720);
  //printArray(Capture.list());
  video = new Capture(this, Capture.list()[3]);
  video.start();
  b = new ball(width / 2, height - 150, circleSize);
  l = new line();
  g = new gui();
  circleAnimations = new ArrayList<circleAnimation>();
  explosions = new ArrayList<explosion>();
  raster = new ArrayList<pixel>();
  rasterFrozen = new ArrayList<pixel>();
  holes = new ArrayList<hole>();
  deadHoles = new ArrayList<hole>();
  trackMovement = new trackMovement();
  rainbow = new rainbow();

  //Gui Elemente
  border = 150;
  radiusM = 80;
  nwX = border + 30;
  nwY = border;
  noX = width - border - 30;
  noY = border;
  soX = width - border - 30;
  soY = height - border;
  swX = border + 30;
  swY = height - border;
  centerX = width / 2;
  centerY = height / 2;
  guiLoading = new guiCircle(centerX, centerY, 200, ("LOADING"), 52, orange, color(100), orange, 10, 2, false);
  guiPause = new guiCircle(centerX, centerY, 200, "PAUSED\n\nIf time's up, you're\nout. To continue\nspread your arms\n", 32, textCol, color(100), red, 10, 15, true);
  guiWinner = new guiCircle(centerX, centerY, 200, ("WINNER TEXT"), 32, lineAndBall, color(100), lineAndBall, 10, 15, false);
  guiCalibration = new guiCircle(centerX, centerY, 200, "CALIBRATING\n\nPlace yourself in the\nmiddle of the screen\n Lower your arms\nDon't move", 32, orange, color(100), orange, 10, 1.5, false);
  guiNoHuman = new guiCircle(centerX, centerY, 200, "MISSING PLAYER\n\nCan't detect any motion\nStep in the middle of\nthe screen and\nwave your arms", 32, red, color(100), red, 10, 1, false);
  guiStart = new guiCircle(centerX, centerY, 200, ("READY\n\nTo start, hover\neach hand over the\nleft and right\ncircle"), 32, green, color(100), green, 10, 10, true);
  guiForceExit = new guiCircle(nwX, nwY, radiusM, "LEAVING", 32, red, color(100), red, 8, 15, true);
  guiExit = new guiCircle(nwX, nwY, radiusM, "EXIT", 32, red, color(100), red, 8, 0.75, false);
  guiAgain = new guiCircle(noX, noY, radiusM, "AGAIN", 32, green, color(100), green, 8, 0.75, false);
  guiMore = new guiCircle(soX, soY, radiusM, "MORE", 32, orange, color(100), orange, 8, 0.5, false);
  guiLess = new guiCircle(swX, swY, radiusM, "LESS", 32, orange, color(100), orange, 8, 0.5, false);
  guiStartRight = new guiCircle(soX, soY, radiusM, "RIGHT", 32, green, color(100), green, 8, 0.5, false);
  guiStartLeft = new guiCircle(swX, swY, radiusM, "LEFT", 32, green, color(100), green, 8, 0.5, false);
  initHoles();
}

void draw() {
  frameRate(frames);
  //println(frameRate);
  noCursor();
  background(backgroundCol);
  scaleWidth = width / (float)video.width;
  scaleHeight = height / (float)video.height;
  raster = calcRaster();
  if (rasterFrozen.size() <= 0) {
    rasterFrozen = generateFrozen();
  }
  
  //Elemente abhängig vom Gamestate
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
    circleAnimation();
    explosionAnimation();
    deadHoles();
    l.show();
    b.show();
    holes();
    break;
  case "paused":
    trackMovement.show();
    circleAnimation();
    explosionAnimation();
    deadHoles();
    l.show();
    b.show();
    holes();
    break;
  case "endScreen":
    trackMovement.show();
    circleAnimation();
    explosionAnimation();
    deadHoles();
    l.show(); 
    b.show();
    holes();
    break;
  }
  g.show();
}

//Erstellt das neutrale Hintergrundbild
ArrayList<pixel> generateFrozen() {
  ArrayList<pixel> rasterFrozen = new ArrayList<pixel>();
  rasterFrozen.addAll(raster);
  return rasterFrozen;
}

//Ueberprueft ob ein Hole vom Ball beruehrt wir, ob ein Target-Hole erfolgreich gesammelt wurde und ob ein neuen Target-Hole erzeugt werden muss.
//Durchlauft des Array rueckwaerts um beim Entfernen eines Holes kein Error zur erzeugen
void holes() {
  for (int i = holes.size() - 1; i >= 0; i--) {
    hole h = holes.get(i);
    String todo = h.ballMatchHole();
    if (todo != null) {
      circleAnimations.add(new circleAnimation(h, todo));
      explosions.add(new explosion(h.x, h.y, circleSize, todo));
    }
    if (h.collected) {
      h.deadHole = true;
      h.circleSize *= 1.5;
      deadHoles.add(h);
      holes.remove(h);
      pickTarget();
    }
    h.update();
    h.show();
  }
}

//Updated und zeichnet alle deadHoles
void deadHoles() {
  for (hole dh : deadHoles) {
    dh.ballMatchHole();
    dh.update();
    dh.show();
  }
}

//Zeichnet noch nicht beendete circleAnimations und entfernt beendete Animationen aus dem Array
void circleAnimation() {
  for (int i = circleAnimations.size() - 1; i >= 0; i--) {
    circleAnimation ca = circleAnimations.get(i);
    if (ca.finished) {
      circleAnimations.remove(i);
    } else {
      ca.update();
      ca.show();
    }
  }
}

//Zeichnet noch nicht beendete exploaionAnimations und entfernt beendete Animationen aus dem Array
void explosionAnimation() {
  for (int i = explosions.size() - 1; i >= 0; i--) {
    explosion e = explosions.get(i);
    if (e.finished) {
      explosions.remove(i);
    } else {
      e.show();
    }
  }
}

//Manueller Steuerung ueber Tasten
void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      if (threshold < 100)
        threshold += 1;
      println(threshold);
    } else if (keyCode == LEFT) {
      if (threshold >= 0)
        threshold -= 1;
      println(threshold);
    }
  }
  if (key == 'h' && !hideInput) {
    hideInput = true;
  } else if (key == 'h' && hideInput) {
    hideInput = false;
  }
  if (key == 't' && !tracking) {
    tracking = true;
  } else if (key == 't' && tracking) {
    tracking = false;
  }
  if (key=='r') {
    gh.restart();
  }
  if (key=='s') {
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

//Ueberprueft ob es ein neues Videoframe gibt
void captureEvent(Capture video) {
  video.read();
}

//Berechnet das Inputvideo und rastert es in als "detail" festgelegte groessen
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

//Berrechnet die "Entfernung" zwischen zwei Farben
float calcColorDifference(pixel p, color trackCol) {
  float r1 = p.col >> 020 & 0xFF;
  float g1 = p.col >> 010 & 0xFF;
  float b1 = p.col        & 0xFF;
  float r2 = trackCol >> 020 & 0xFF;
  float g2 = trackCol >> 010 & 0xFF;
  float b2 = trackCol        & 0xFF;
  return dist(r1, g1, b1, r2, g2, b2);
}

//Errechnet den durchschnittlichen Farbwert aller Pixel innerhalb von "img"
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

//Erzeugt die Holes und ueberwacht das es keinerlei Ueberlappungen gibt
void initHoles() {
  holes.clear();
  deadHoles.clear();
  int noFreeSpaceCounter = 0;
  points = 100 / holeAmount;
  while (holes.size() < holeAmount && noFreeSpaceCounter < 1000) {
    float x = random(75, width - 75);
    float y = random(150, height - 250);
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

//Waehlt aus allen Holes zufaellig eines aus das als nachstes / aktuelles Ziel markiert wird
//Wenn kein weiteres Hole mehr verfuegbar ist, wird der WINNER-Screen angezeigt
void pickTarget() {
  if (holes.size() > 0) {
    int r = (int)random(holes.size());
    holes.get(r).target = true;
  } else {
    soundWinner.play();
    g.endReason = "YOU WIN";
    gh.endScreen();
  }
}

//Kontrolliert ob das zu erzeugende Hole sich nicht mit einem anderen uberschneidet
boolean noOverlap(float x, float y) {
  for (hole h : holes) {
    if (dist(x, y, h.x, h.y) > circleSize * 1.7) {
      continue;
    } else {
      return false;
    }
  }
  return true;
}
