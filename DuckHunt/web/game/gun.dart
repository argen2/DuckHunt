part of duckhunt;

class Gun {
  int round;
  
  void init () {
    round = 3;
    querySelector("#shot").innerHtml = "SHOT: ${round}";
  }
  
  void reloadIt() {
    round = 3;
    querySelector("#shot").innerHtml = "SHOT: ${round}";
  }
  
  bool shoot() {
    if (round <= 0)
      return false;
    
    querySelector("#shootSound").play();
    round--;
    querySelector("#shot").innerHtml = "SHOT: ${round}";
    return true;
  }
}