class Button {
  int _x;
  int _y;
  int _size;
  String _text;
  
  boolean hovered;
  boolean clicked;
    
  Button(int x, int y, int size, String text) {
    _x = x; _y = y; _size = size; _text = text;
  }
  
  void render() {
    if (hovered) fill(127);
    else if (clicked) fill(64);
    else fill(255);
    rect(_x, _y, _size, _size);
    textSize(64);
    fill(255, 0, 0);
    text(_text, _x + _size / 5, _y + _size/2);
  }
  
  void click_handler() {
    if (mouseCaptured()) clicked = true;
    else clicked = false;
  }
  
  void move_handler() {
    if (mouseCaptured()) hovered = true;
    else hovered = false;
  }
  
  boolean mouseCaptured() {
    boolean checks = true;
    checks &= (mouseX > _x        );
    checks &= (mouseX < _x + _size);
    checks &= (mouseY > _y        );
    checks &= (mouseY < _y + _size);
    return checks;
  }
}
