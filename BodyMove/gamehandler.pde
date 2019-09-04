class gamehandler {

  boolean loading = true;
  boolean startScreen = false;
  boolean playing = false;
  boolean paused = false;
  boolean endScreen = false;
  boolean restart = false;
  boolean refreshBackground = true;
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
    status = "loading";
    loading = true;
    startScreen = false;
    playing = false;
    paused = false;
    endScreen = false;
    restart = false;
  }

  void startScreen() {
    if (soundScream.isPlaying()) {
      soundScream.stop();
    }
    loading = false;
    hideInput = false;
    startScreen = true;
    playing = false;
    paused = false;
    endScreen = false;
    restart = false;
    gs.reset();
    trackMovement.reset();   
    g.reset();
    b.reset();
    initHoles();    
    status = "startScreen";
  }

  void playing() {
    status = "playing";
    refreshBackground = true;
    hideInput = true;
    loading = false;
    startScreen = false;
    playing = true;
    paused = false;
    endScreen = false;
    restart = false;
  }

  void paused() {
    if(!gh.endScreen && refreshBackground) {
      refreshBackground = false;
      rasterFrozen = generateFrozen();
    }
    status = "paused";
    hideInput = false;
    loading = false;
    startScreen = false;
    playing = false;
    paused = true;
    endScreen = false;
    restart = false;
  }

  void endScreen() {
    status = "endScreen";
    hideInput = false;
    loading = false;
    startScreen = false;
    playing = false;
    paused = false;
    endScreen = true;
    restart = false;
  }

  void restart() {
    refreshBackground = false;
    hideInput = true;
    
    if (soundScream.isPlaying()) {
      soundScream.stop();
    }
    status = "playing";
    loading = false;
    startScreen = false;
    playing = true;
    paused = false;
    endScreen = false;
    trackMovement.reset();
    g.reset();
    b.reset();
    initHoles();
  }
}
