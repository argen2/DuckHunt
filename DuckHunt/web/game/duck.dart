part of duckhunt;

class Duck {
  int posX;
  int posY;
  int gotoX;
  int gotoY;
  double speed;
  int repeat;
  int loop;
  var direction;
  var number;
  bool isDead;
  bool isFinished;
  bool isFlyOff;
  int directionChange;
  
  void init(round) {
    speed = round + round / 2;
    var random = new Random();
    number = random.nextInt(3) + 1;
    posX = random.nextInt(600);
    posY = random.nextInt(280);
    isDead = false;
    isFinished = false;
    isFlyOff = false;
    directionChange = 0;
    
    changeDirection();
  }
  
  void update() {
    if (loop % repeat == 0) {
      if (isDead || isFlyOff) {
        isFinished = true;
      }
      else {
        changeDirection();
      }
    }
    if (!isFinished) {
      posX += gotoX;
      posY += gotoY;
      if (posX > 600)
        posX = 600;
      if (posY > 280)
        posY = 280;
    }
    ++loop;
  }
  
  void render() {
    ImageElement pigeon;
    
    if (isDead)
      pigeon = querySelector("#pigeon${number}_dead");
    else if (isFlyOff)
      pigeon = querySelector("#pigeon${number}_flyOff");
    else
      pigeon = querySelector("#pigeon${number}_${direction}");
    if (pigeon != null)
      ctx.drawImage(pigeon, posX, posY);
  }
  
  void flyOff() {
    gotoX = 0;
    gotoY = -6;
    isFlyOff = true;
    loop = 1;
    repeat = 100;
    querySelector("#flyOffSound").play();
  }
  
  bool isShot(x, y) {
    print("${x} ${y} ${posX} ${posY}");
    if (!isDead && x > posX - 10 && x < posX + 55 && y > posY && y - 10 < posY + 55) {
      isDead = true;
      querySelector("#killSound").play();
      gotoX = 0;
      gotoY = 6;
      loop = 1;
      repeat = 100;
      return true;
    }
    return false;
  }
  
  void changeDirection() {
    var random = new Random();
    int x = (random.nextDouble() * speed).ceil();
    int y = (random.nextDouble() * speed).ceil();
    loop = 0;
    repeat = random.nextInt(10) + 10;
    
    if (x > 100)
        x = 100;
    if (y > 60)
      y = 60;
    
    if ((posX + x * repeat) > 600) {
      gotoX = -x;
      direction = "left";
    }
    else if ((posX - x * repeat) < 0) {
      gotoX = x;
      direction = "right";
   }
    else {
      var d = random.nextInt(2);
      if (d == 1) {
        gotoX = -x;
        direction = "left";        
      }
      else {
        gotoX = x;
        direction = "right";        
      }
    }

    if ((posY + y * repeat) > 280) {
      gotoY = -y;
    }
    else if ((posY - y * repeat) < 0) {
      gotoY = y;
    }
    else {
      var d = random.nextInt(2);
      if (d == 1) {
        gotoY = -y;
      }
      else {
        gotoY = y;
      }
    }
    ++directionChange;
    if (directionChange >= 30)
       flyOff();
  }
}