part of duckhunt;

class State {
  State update(clicked, clickedX, clickedY) {}
  void render() {}
}

class Start extends State {
  int loop = 0;
  
  State update(clicked, clickedX, clickedY) {
    ++loop;
    if (clicked == true) {
      State res = new Play();
      res.update(false, clickedX, clickedY);
      return res;
    }
    return this;
  }
  
  void render() {
    if (loop > 8) {
      ImageElement start = querySelector("#start");
      ctx.drawImage(start, 0, 0);
    }
    if (loop > 32)
       loop = 0;
  } 
}

class GameOver extends State {  
  State update(clicked, clickedX, clickedY) {
    if (clicked == true) {
      querySelector("#play").style.display = "none";
      State res = new Start();
      res.update(false, clickedX, clickedY);
      return res;
    }
    return this;
  }
  
  void render() {
      ImageElement gameover = querySelector("#gameover");
      ctx.drawImage(gameover, 0, 0);
  }
}

class Play extends State {
  bool isInit = false;
  int round = 1;
  Gun gun = new Gun();
  Duck duck = new Duck();
  
  var pigeon = 0;
  var killedPigeon = 0;
  var score = 0;
  var posX = 0;
  var posY = 0;
  var gotoX = 0;
  var gotoY = 0;
  
  void init() {
    gun.init();
    duck.init(round);
    querySelector("#play").style.display = "block";
    isInit = true;
    querySelector("#round").innerHtml = "R1";
    querySelector("#shot").innerHtml = "SHOT: 3";
    querySelector("#score").innerHtml = "0 points";
    querySelector("#h1").className = "hit active";
    for (var i = 2; i <= 10; ++i) {
      querySelector("#h${i}").className = "hit";
      querySelector("#h${i}").innerHtml = "X";
    }
    querySelector("#startRoundSound").play();
  }
  
  State update(clicked, clickedX, clickedY) {
    if (!isInit)
       init();
    
    if (clicked && gun.shoot()) {
      print("SHOOT: ${clickedX} ${clickedY} ${duck.number} ${duck.direction}");
      if (duck.isShot(clickedX, clickedY)) {
       score = score + 500 * (gun.round + 1);
       ++killedPigeon;
       querySelector("#score").innerHtml = "${score} points";
       querySelector("#h${pigeon + 1}").innerHtml = "O";
      }
      else if (gun.round <= 0)  
        duck.flyOff();
    }
    duck.update();
    if (duck.isFinished) {
      ++pigeon;
      querySelector("#h${pigeon}").className = "hit";
      if (pigeon < 10)
        querySelector("#h${pigeon + 1}").className = "hit active";
      else
        querySelector("#h1").className = "hit active";
      gun.reloadIt();
      if (pigeon == 10) {
        if (killedPigeon >= 5) {
          ++round;
          querySelector("#round").innerHtml = "R${round}";
          pigeon = 0;
          killedPigeon = 0;
          for (var i = 1; i <= 10; ++i)
            querySelector("#h${i}").innerHtml = "X";
        }
        else {
          State res = new GameOver();
          res.update(false, clickedX, clickedY);
          querySelector("#gameOverSound").play();
          return res;
        }
      }
      duck.init(round);
    }
    return this;
  }
  
  void render() {
    duck.render();
  } 
}
