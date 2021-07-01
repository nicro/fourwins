color default_field_color = color(200, 200, 200);
color no_color = color(0, 0, 0);

void set_gl_color(color clr) {
  fill(red(clr), green(clr), blue(clr));
}
color whiteColor = color(255);
color blackColor = color(0);


class Field implements Notifyable {
  color _color;
  int _x, _y;
  float _size = 100;
  boolean winAnimation = false;
  boolean fallAnimation = false;
  int animIteration = 0;
  int fallIteration = 0;
  
  
  Field(int x, int y)
  {
    registerMouseEvents(this);
    _x = x; _y = y;
    clear();
  }
  
  void mouseEvent(MouseEvent e) {
    if (e == MouseEvent.Draw) {
          // rendering a cell
      set_gl_color(default_field_color);
      rect(_x * (_size + 1), _y * (_size + 1), _size, _size);
    
      // rendering a piece
      if (!this.isEmpty()) {
        set_gl_color(winAnimation ? getWinAnimColor() : _color);
        float expectedHeight = _y * (_size + 1) + _size / 2;
        if (fallAnimation) {
          if (fallIteration == expectedHeight) fallAnimation = false;
          if (fallIteration < expectedHeight) {
            fallIteration += 20;
            expectedHeight = fallIteration;
          }
        }
        ellipse(_x * (_size + 1) + _size / 2, expectedHeight, _size * 0.9, _size * 0.9);
      }
    }
  }
  
  boolean isEmpty() { return _color == default_field_color; }
  
  color getWinAnimColor() {
    if (animIteration > 255555) {
      animIteration = 0;
    }
    animIteration++;
    if (animIteration % 7 == 0) {
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
    _color = default_field_color;
    winAnimation = false;
    fallAnimation = false;
    animIteration = 0;
    fallIteration = 0;
  }
  
  void setColor(color clr) {
    if (clr != default_field_color) fallAnimation = true;
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
