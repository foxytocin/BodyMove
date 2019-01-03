class gamehandler {

  boolean loading = true;
  boolean startScreen = false;
  boolean playing = false;
  boolean paused = false;
  boolean endScreen = false;
  boolean restart = false;
  String status = "loading";

  gamehandler() {
    startScreen = false;
    playing = false;
    paused = false;
    endScreen = false;
    restart = false;
    status = "loading";
  }

  void loading() {
    loading = true;
    startScreen = false;
    playing = false;
    paused = false;
    endScreen = false;
    restart = false;
    status = "loading";
  }

  void startScreen() {
    status = "startScreen";
    loading = false;
    startScreen = true;
    playing = false;
    paused = false;
    endScreen = false;
    restart = false;
  }

  void playing() {
    loading = false;
    startScreen = false;
    playing = true;
    paused = false;
    endScreen = false;
    restart = false;
    status = "playing";
  }

  void paused() {
    loading = false;
    startScreen = false;
    playing = false;
    paused = true;
    endScreen = false;
    restart = false;
    
    soundRollingStone.stop();
    
    status = "paused";
  }
  
  void unpause() {
    loading = false;
    startScreen = false;
    playing = true;
    paused = false;
    endScreen = false;
    restart = false;
    status = "playing";
  }

  void endScreen() {
    loading = false;
    startScreen = false;
    playing = false;
    paused = false;
    endScreen = true;
    restart = false;
    status = "endScreen";
  }

  void restart() {
    loading = false;
    startScreen = true;
    playing = false;
    paused = false;
    endScreen = false;
    status = "loading";
    
    gs.testsPassed = 0;
    rasterFrozen = generateFrozen();
    
    g.error = 0;
    g.target = 0;
    g.qual = 100;
    g.note = 1;
    initHoles();
  }
}
