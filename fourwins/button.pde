class Button implements Notifyable {
  
  int _x, _y, _size;
  String _text;
  
  boolean _hovered = false;
  boolean _clicked = false;
  boolean _visible = true;
    
  Button(int x, int y, int size, String text) {
    registerMouseEvents(this);
    _x = x; _y = y; _size = size; _text = text;
  }
  
  void mouseEvent(MouseEvent e) {
    switch (e) {
     case Clicked: _clicked = mouseCaptured(); break;
     case Moved:   _hovered = mouseCaptured(); break;
     case Draw:
       if (!_visible) return;
       if (_hovered) fill(127);
       else if (_clicked) fill(64);
       else fill(255);
       rect(_x, _y, _size, _size,    10, 10, 10, 10);
       textSize(_size / 5);
       fill(255, 0, 0);
       text(_text, _x + _size / 5, _y + _size / 2);
       break;
     default: break;
    }
  }
  
  void clearEvents() {
    _clicked = false;
    _visible = true;
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
