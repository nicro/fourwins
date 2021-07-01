color defaultFieldColor = color(200, 200, 200);
color noColor = color(0, 0, 0);
color whiteColor = color(255);
color blackColor = color(0);


class Field implements Notifyable {
  color _color;
  int _x, _y;
  float _size = 100;
  boolean _winAnimation = false;
  boolean _fallAnimation = false;
  int _animIteration = 0;
  int _fallIteration = 0;
  
  void setGlColor(color clr) {
    fill(red(clr), green(clr), blue(clr));
  }
  
  
  Field(int x, int y)
  {
    registerMouseEvents(this);
    _x = x; _y = y;
    clear();
  }
  
  void mouseEvent(MouseEvent e) {
    if (e == MouseEvent.Draw) {
          // rendering a cell
      setGlColor(defaultFieldColor);
      rect(_x * (_size + 1), _y * (_size + 1), _size, _size);
    
      // rendering a piece
      if (!this.isEmpty()) {
        setGlColor(_winAnimation ? getWinAnimColor() : _color);
        float expectedHeight = _y * (_size + 1) + _size / 2;
        if (_fallAnimation) {
          if (_fallIteration == expectedHeight) _fallAnimation = false;
          if (_fallIteration < expectedHeight) {
            _fallIteration += 20;
            expectedHeight = _fallIteration;
          }
        }
        ellipse(_x * (_size + 1) + _size / 2, expectedHeight, _size * 0.9, _size * 0.9);
      }
    }
  }
  
  boolean isEmpty() { return _color == defaultFieldColor; }
  
  color getWinAnimColor() {
    if (_animIteration > 255555) {
      _animIteration = 0;
    }
    _animIteration++;
    if (_animIteration % 7 == 0) {
      if (_color == blackColor) return whiteColor;
      if (_color == whiteColor) return blackColor;
      else return whiteColor;
    } 
    return _color;
  }
  
  void unbind() {
    removeMouseEvents(this);
  }
  
  void clear() {
    _color = defaultFieldColor;
    _winAnimation = false;
    _fallAnimation = false;
    _animIteration = 0;
    _fallIteration = 0;
  }
  
  void setColor(color clr) {
    if (clr != defaultFieldColor) _fallAnimation = true;
    _color = clr;
  }
  
  boolean mouseCaptured() {
    boolean checks = true;
    checks &= (mouseX > _x * (_size + 1)        );
    checks &= (mouseX < _x * (_size + 1) + _size);
    checks &= (mouseY > _y * (_size + 1)        );
    checks &= (mouseY < _y * (_size + 1) + _size);
    return checks;
  }
  
};
