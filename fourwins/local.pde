class LocalGame extends Game {

PlayerData[] _players;
int _currentTurn = 0;

boolean gameEnded = false;

LocalGame(int columns, int rows) {
  super(columns, rows);
  _players = new PlayerData[2];
  _players[0] = new PlayerData("player 1", color(0, 255, 0));
  _players[1] = new PlayerData("player 2", color(0, 0, 255));
  overlay.textLog("game started in offline mod");
}

void nextTurn() {
  _currentTurn = 1 - _currentTurn;
}

void winnerFound(color clr, Field field0, Field field1, Field field2, Field field3) {
  super.winnerFound(clr, field0, field1, field2, field3);
  gameEnded = true;
}


String statusLine() {
  return super.statusLine() + " - " + 
  (gameEnded ? "\nPress (n) to start new game\n" : "");
}

int makeMove(color _, int column) {
  super.makeMove(_players[_currentTurn]._color, column);
  checkForWinner();
  nextTurn();
  return 0;
}

void exit() {
  super.exit();
}


void draw() {
  super.draw();
  if (keyPressed && key == 'n') {
    gameEnded = false;
    reset();
  }
}

}
