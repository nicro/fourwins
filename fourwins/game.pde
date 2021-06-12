// todo: make an animation of falling circles

class Game implements Notifyable {
  int _rows;
  int _columns;
  
  Field[][] _fields;
  
  StringList _logText = new StringList();
  
  Game(int rows, int columns) {
    _rows = rows; _columns = columns;
    initialize_fields();
  }
  
  void initialize_fields() {
    _fields = new Field[_columns][_rows];
    for (int column = 0; column <_columns; column++) 
    {
      _fields[column] = new Field[_rows];
      for (int row = 0; row < _rows; row++)
        _fields[column][row] = new Field(column, row); // default
    }
  }

void draw_fields() {
  for (int column = 0; column < _columns; column++)
  {
    for (int row = 0; row < _rows; row++)
      _fields[column][row].render();
  }
}

int getFirstEmptyRow(int column) {
  if (column < 0 || column > _columns) {
    return -1;
  }
  for (int i = _rows - 1; i >= 0; i--){
    if (_fields[column][i].isEmpty()) {
      return i;
    }
  }
  return -1;
}

int make_move(color clr, int column) {
  if (column < 0 || column > _columns) {
    return -1;
  }
  int row = getFirstEmptyRow(column);
  if (row == -1) {
    return -1;
  }
  _fields[column][row].setColor(clr);
  
  return 0;
}

void textLog(String line) {
  if (_logText.size() > 10) {
    _logText.remove(0);
  }
  _logText.append(line);
}

void draw_logs() {
  fill(0, 255, 255);
  textSize(20);
  text(_logText.join("\n"), 400, 50);
}

void draw() {
  draw_fields();
  draw_logs();
}

void setup() {
}

void mouseEvent(MouseEvent e) {
  switch (e) {
  case Clicked: {
  } break;
  case Moved: {
  } break;
  case Pressed: {
    for (int column = 0; column <_columns; column++)
    {
      for (int row = 0; row < _rows; row++)
      if (_fields[column][row].mouseCaptured())
        make_move(color(255, 0, 0), column);
      }
    } break;
  case Released: {
  } break;
  
  }
}

}
