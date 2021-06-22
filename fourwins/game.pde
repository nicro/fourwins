// todo: make an animation of falling circles

enum PlayerMode {
  NotSelected,
  Client,
  Server,
  Local,
}

class PlayerData {
  color _color;
  String _name;
  PlayerData(String name, color c) {
    _name = name;
    _color = c;
  }
}

class Overlay {
  boolean visible = false;
  StringList logText   = new StringList();
  
  int _x;
  Overlay(int x) {_x = x; }
  
  void textLog(String line) {
    if (logText.size() > 9)
      logText.remove(0);
    logText.append(line);
  }

  void drawLogs() {
    fill(0, 255, 255);
    textSize(20);
    text("Logs: \n" + logText.join("\n"), _x, 200);
  }
  
  void render() {
    if (!visible) return;
    fill(20);
    rect(400, 0, 400, 800);
    drawLogs();
  }
}

class Game implements Notifyable {
  int _rows;
  int _columns;
  Field[][] _fields;
  color _winner;
  
  boolean visible = true;
  PlayerMode mode = PlayerMode.NotSelected;
  Overlay overlay = new Overlay(420);
  
  Game(int columns, int rows) {
    if (columns < 4 || rows < 4) print("4x4 is required");
    _rows = rows; _columns = columns;
    initFields();
  }
  
  void initFields() {
    _fields = new Field[_columns][_rows];
    for (int column = 0; column <_columns; column++) 
    {
      _fields[column] = new Field[_rows];
      for (int row = 0; row < _rows; row++)
        _fields[column][row] = new Field(column, row); // default
    }
  }

void drawFields() {
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

void winnerFound(color clr, Field field0, Field field1, Field field2, Field field3) {
  field0.winAnimation = true;
  field1.winAnimation = true;
  field2.winAnimation = true;
  field3.winAnimation = true;
}

void restart() {
 for (int column = 0; column < _columns; column++) {
   for (int row = 0; row < _rows; row++) {
     _fields[column][row]._color = default_field_color;
   }
 }
}

boolean checkForWinner() {
  
  // check horizontally  
  for (int row = 0; row < _rows; row++)
  {
      for (int column = 0; column < _columns - 3; column++) {
        boolean checks = true;
        checks &= _fields[column][row]._color != default_field_color;
        checks &= _fields[column][row]._color == _fields[column + 1][row]._color;
        checks &= _fields[column][row]._color == _fields[column + 2][row]._color;
        checks &= _fields[column][row]._color == _fields[column + 3][row]._color;
        if (checks) {
          winnerFound(
            _fields[column][row]._color, 
            _fields[column][row], 
            _fields[column + 1][row],
            _fields[column + 2][row],
            _fields[column + 3][row]
          );
          return true;
        }
      }
  }
  
  // check vertically
  for (int row = 0; row < _rows - 3; row++)
  {
      for (int column = 0; column < _columns - 3; column++) {
        boolean checks = true;
        checks &= _fields[column][row]._color != default_field_color;
        checks &= _fields[column][row]._color == _fields[column][row + 1]._color;
        checks &= _fields[column][row]._color == _fields[column][row + 2]._color;
        checks &= _fields[column][row]._color == _fields[column][row + 3]._color;
        if (checks) {
          winnerFound(
            _fields[column][row]._color, 
            _fields[column][row], 
            _fields[column][row + 1],
            _fields[column][row + 2],
            _fields[column][row + 3]
          );
          return true;
        }
      }
  }
  
  //check diagonal from right down to left up
  for (int column = _columns - 1; column > 3; column--)
  {
      for (int row = _rows - 1; row > 3; row--) {
        boolean checks = true;
        checks &= _fields[column][row]._color != default_field_color;
        checks &= _fields[column][row]._color == _fields[column - 1][row - 1]._color;
        checks &= _fields[column][row]._color == _fields[column - 2][row - 2]._color;
        checks &= _fields[column][row]._color == _fields[column - 3][row - 3]._color;
        if (checks) {
          winnerFound(
            _fields[column][row]._color, 
            _fields[column][row], 
            _fields[column - 1][row - 1],
            _fields[column - 2][row - 2],
            _fields[column - 3][row - 3]
          );
          return true;
        }
      }
  }
  
  // check diagonal from left down to right up
  for (int row = _rows - 1; row >= 3; row--) {
    for (int column = 0; column < _columns - 3; column++) {
        boolean checks = true;
        checks &= _fields[column][row]._color != default_field_color;
        checks &= _fields[column][row]._color == _fields[column + 1][row - 1]._color;
        checks &= _fields[column][row]._color == _fields[column + 2][row - 2]._color;
        checks &= _fields[column][row]._color == _fields[column + 3][row - 3]._color;
        if (checks) {
          winnerFound(
            _fields[column][row]._color, 
            _fields[column][row], 
            _fields[column + 1][row - 1],
            _fields[column + 2][row - 2],
            _fields[column + 3][row - 3]
          );
          return true;
        }
    }
  }
  return false;
}

int makeMove(color clr, int column) {
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

String statusLine() {
  return "" + mode + " " + _columns + "x" + _rows;
}

void draw() {
  if (!visible) return;
  drawFields();
  if (keyPressed && key == 's')
    overlay.visible = true;
  if (keyPressed && key == 'h')
    overlay.visible = false;
    
  overlay.render();
  fill(255, 0, 0);
  textSize(20);
  text(statusLine() + "\n" +
       "Press (s/h) to show/hide overlay\n" +
       "Press (q) to quit to main menu\n",
       20, height * 0.9);
}

void exit() {
  
}

void reset() {
  for (int column = 0; column < _columns; column++) {
    for (int row = 0; row < _rows; row++) {
      _fields[column][row]._color = default_field_color;
      _fields[column][row].winAnimation = false;
    }
  }
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
        makeMove(color(255, 0, 0), column);
      }
    } break;
  case Released: {
  } break;
  case Draw: {
      draw();
  } break;
  
  }
}

}
