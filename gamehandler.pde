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
    
    gs.testsPassed = 0;

    trackMovement.avgLeft = (video.height - detail);
    trackMovement.avgRight = (video.height - detail);
    trackMovement.posLeft = (video.height - detail);
    trackMovement.posRight = (video.height - detail);
    b.x = (video.width / 2);
    b.y = (video.height - detail - b.r);
    
    g.error = 0;
    g.target = 0;
    g.qual = 100;
    g.note = 1;
    b.acceleration = 0;
    b.velocity = 0;
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

    trackMovement.avgLeft = (video.height - detail);
    trackMovement.avgRight = (video.height - detail);
    trackMovement.posLeft = (video.height - detail);
    trackMovement.posRight = (video.height - detail);
    b.x = (video.width / 2);
    b.y = (video.height - detail - b.r);

    g.error = 0;
    g.target = 0;
    g.qual = 100;
    g.note = 1;
    b.acceleration = 0;
    b.velocity = 0;
    initHoles();
  }
}
