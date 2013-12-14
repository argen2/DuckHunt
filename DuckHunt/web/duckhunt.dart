library duckhunt;

import 'dart:html';
import 'dart:math';

part 'game/driver.dart';
part 'game/state.dart';
part 'game/duck.dart';
part 'game/gun.dart';

//Dimensions
final WIDTH = 640;
final HEIGHT = 400;

final CanvasElement canvas = querySelector("#canvas");
final CanvasRenderingContext2D ctx = canvas.context2D;
var updateTimer = 1000.0 / 3.0;

var lastUp = 0.0;


Driver driver;

var eventClicked = false;
var eventClickedX = 0;
var eventClickedY = 0;

void main() {
  driver = new Driver();
  //var duck = new Duck();

  ctx.canvas.onClick.listen((e) {
    eventClicked = true;
    eventClickedX = e.clientX;
    eventClickedY = e.clientY - 80; //don't know why got 80 more here ...
  });
  
  querySelector("#startGameSound").play();
  
  window.requestAnimationFrame(run);
}

void run(time) {
  if (time == null) {
    time = new DateTime.now().millisecond;
  }

  update(time);
  render();
  window.requestAnimationFrame(run);
}

void update(time) {
  if (time - lastUp > updateTimer) {
    //Reinitialise timer
    lastUp = new DateTime.now().millisecond;

    driver.update(eventClicked, eventClickedX, eventClickedY);
    eventClicked = false;
  }
}

void render(){
  ctx.clearRect(0, 0, WIDTH, HEIGHT);
  
  ImageElement bg = querySelector("#bg");
  ctx.drawImage(bg, 0, 0);
  
  driver.render();
}