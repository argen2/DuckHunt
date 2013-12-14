part of duckhunt;

class Driver {
  State state = new Start();
  
  void update(clicked, clickedX, clickedY) {
    state = state.update(clicked, clickedX, clickedY);
  }

  void render() {
    state.render();
  }
}