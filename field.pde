color default_field_color = color(200, 200, 200);

void set_gl_color(color clr) {
  fill(red(clr), green(clr), blue(clr));
}

class Field {
  color _color;
  int _x, _y;
  Field(int x, int y)
  {
    _x = x; _y = y;
    _color = default_field_color;
  }
  boolean isEmpty() { return _color == default_field_color; }
  void render() {
    // rendering a cell
    set_gl_color(default_field_color);
    rect(_x * 51, _y * 51, 50, 50);
    
    // rendering a piece
    if (!this.isEmpty()) {
      set_gl_color(_color);
      ellipse(_x * 51 + 25, _y * 51 + 25, 45, 45);
    }
  }
};
