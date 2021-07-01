class LocalGame extends Game {
  
  int _currentTurn = 0;

  LocalGame(int columns, int rows) {
    super(columns, rows);
    _players.add(new Player("green player", color(0, 255, 0)));
    _players.add(new Player("blue player", color(0, 0, 255)));
    log("game started in offline mod");
  }

  void nextTurn() {
    _currentTurn = 1 - _currentTurn;
  }

  void winnerFound(Player player, Field field0, Field field1, Field field2, Field field3) {
    super.winnerFound(player, field0, field1, field2, field3);
  }

  int makeMove(color _, int column) {
    super.makeMove(_players.get(_currentTurn)._color, column);
    checkForWinner();
    nextTurn();
    return 0;
  }

  void mouseEvent(MouseEvent e) {
    switch (e) {
      case Draw: {
        if (keyPressed && key == 'n') {
          gameEnded = false;
          reset();
        }
      } break;
      default: break;
    }
    super.mouseEvent(e);
  }
}
