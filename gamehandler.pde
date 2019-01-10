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
    status = "loading";
    loading = true;
    startScreen = false;
    playing = false;
    paused = false;
    endScreen = false;
    restart = false;
  }

  void startScreen() {
    loading = false;
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
    loading = false;
    startScreen = false;
    playing = true;
    paused = false;
    endScreen = false;
    restart = false;
  }

  void paused() {
    status = "paused";
    loading = false;
    startScreen = false;
    playing = false;
    paused = true;
    endScreen = false;
    restart = false;
    soundRollingStone.stop();
  }

  void endScreen() {
    status = "endScreen";
    loading = false;
    startScreen = false;
    playing = false;
    paused = false;
    endScreen = true;
    restart = false;
    soundRollingStone.stop();
  }

  void restart() {
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
