enum PlayerMode {
  NotSelected,
  Client,
  Server,
  Local,
}

class Player {
  
  String _name;
  color _color;
  Player(String name, color clr) {
    _name = name; _color = clr;
  }
  boolean isEmpty() {
    return _name == "";
  }
}

class Game implements Notifyable {
  int _rows;
  int _columns;
  Field[][] _fields;
  ArrayList<Player> _players;
  Player _winner;
  boolean gameEnded = false;
  
  StringList _logText   = new StringList();
  boolean visible = true;
  boolean visible_overlay = false;
  PlayerMode mode = PlayerMode.NotSelected;
  
  Game(int columns, int rows) {
    _rows = rows; _columns = columns;
    _players = new ArrayList<Player>();
    initFields();
    registerMouseEvents(this);
  }
  
  Player getPlayerByName(String name) {
   for (int i = 0; i < _players.size(); i++) {
     if (_players.get(i)._name.equals(name))
       return _players.get(i);
   }
   return new Player("", noColor);
  }
  
  Player getPlayerByColor(color clr) {
   for (int i = 0; i < _players.size(); i++) {
     if (_players.get(i)._color == clr)
       return _players.get(i);
   }
   return new Player("", noColor);
  }
  
  void log(String line) { // overlay log
    if (_logText.size() > 9)
      _logText.remove(0);
    _logText.append(line);
  }
  
  void render_overlay() {
    if (!visible_overlay) return;
    fill(20);
    rect(400, 0, 400, 800);    
    fill(0, 255, 255);
    textSize(20);
    text("Logs: \n" + _logText.join("\n"), 420, 200);
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

  void winnerFound(Player player, Field field0, Field field1, Field field2, Field field3) {
    field0._winAnimation = true;
    field1._winAnimation = true;
    field2._winAnimation = true;
    field3._winAnimation = true;
    _winner = player;
    gameEnded = true;
    log(player._name + " won");
  }

  boolean checkForWinner() {
  // check horizontally  
    for (int row = 0; row < _rows; row++)
    {
      for (int column = 0; column < _columns - 3; column++) {
        boolean checks = true;
        checks &= _fields[column][row]._color != defaultFieldColor;
        checks &= _fields[column][row]._color == _fields[column + 1][row]._color;
        checks &= _fields[column][row]._color == _fields[column + 2][row]._color;
        checks &= _fields[column][row]._color == _fields[column + 3][row]._color;
        if (checks) {
          winnerFound(
            getPlayerByColor(_fields[column][row]._color), 
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
      for (int column = 0; column < _columns; column++) {
        boolean checks = true;
        checks &= _fields[column][row]._color != defaultFieldColor;
        checks &= _fields[column][row]._color == _fields[column][row + 1]._color;
        checks &= _fields[column][row]._color == _fields[column][row + 2]._color;
        checks &= _fields[column][row]._color == _fields[column][row + 3]._color;
        if (checks) {
          winnerFound(
            getPlayerByColor(_fields[column][row]._color), 
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
        checks &= _fields[column][row]._color != defaultFieldColor;
        checks &= _fields[column][row]._color == _fields[column - 1][row - 1]._color;
        checks &= _fields[column][row]._color == _fields[column - 2][row - 2]._color;
        checks &= _fields[column][row]._color == _fields[column - 3][row - 3]._color;
        if (checks) {
          winnerFound(
            getPlayerByColor(_fields[column][row]._color), 
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
        checks &= _fields[column][row]._color != defaultFieldColor;
        checks &= _fields[column][row]._color == _fields[column + 1][row - 1]._color;
        checks &= _fields[column][row]._color == _fields[column + 2][row - 2]._color;
        checks &= _fields[column][row]._color == _fields[column + 3][row - 3]._color;
        if (checks) {
          winnerFound(
            getPlayerByColor(_fields[column][row]._color), 
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

  void exit() {
    removeMouseEvents(this);
  
     for (int column = 0; column < _columns; column++) {
       for (int row = 0; row < _rows; row++) {
         _fields[column][row].clear();
         _fields[column][row].unbind();
       }
     }
  }

  void reset() {
    for (int column = 0; column < _columns; column++) {
      for (int row = 0; row < _rows; row++) {
        _fields[column][row].clear();
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
        if (!visible) return;
        if (keyPressed && key == 's') visible_overlay = true;
        if (keyPressed && key == 'h') visible_overlay = false;
        render_overlay();
        fill(255, 0, 0);
        textSize(20);
        text(statusLine() + 
          (gameEnded ? " -> " + _winner._name + " won!\n" : "\n") +
          "Press (s/h) to show/hide overlay\n" +
          "Press (n/q) to restart/quit game\n",
          20, height * 0.9);
      } break;
    }
  }
}
