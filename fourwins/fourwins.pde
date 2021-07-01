FourWins game;
int columns = 7;
int rows = 6;


void settings() { size(101 * columns, 101 * rows + 100); }
void setup   () { game = new FourWins(this);   }

class FourWins implements Notifyable {
  PApplet _window;
  Game _game;
  Button _serverBtn, _clientBtn, _localBtn;
  boolean _gameInited = false;
  
  FourWins(PApplet window) {
    registerMouseEvents(this);
    _window = window;
    _serverBtn = new Button(100, 30, 250, "server");
    _clientBtn = new Button(400, 30, 250, "client");
    _localBtn = new Button (100, 330, 250, "local\ngame");
  }
  
  void initIfNeeded(PlayerMode mode) {
    if (_gameInited) return;
    
    _serverBtn._visible = false;
    _clientBtn._visible = false;
    _localBtn._visible = false;
    
    switch (mode) {
     case Client: _game = new ClientGame(_window, "127.0.0.1", 5204, columns, rows); break;
     case Server: _game = new ServerGame(_window, 5204, columns, rows); break;
     case Local:  _game = new LocalGame( columns, rows); break;
     case NotSelected: print("mode not selected!"); break;
    }
    _game.mode = mode;
    _gameInited = true;
  }
  
  void quitGame() {
    if (!_gameInited) return;    
    _game.exit();
    _serverBtn.clearEvents();
    _clientBtn.clearEvents();
    _localBtn.clearEvents();
    _gameInited = false;
  }
  
  void mouseEvent(MouseEvent e) {
    if (e == MouseEvent.Draw) {
      background(20);
      if (keyPressed && key == 'q') quitGame();
      if (_serverBtn._clicked) initIfNeeded(PlayerMode.Server);
      if (_clientBtn._clicked) initIfNeeded(PlayerMode.Client);
      if ( _localBtn._clicked) initIfNeeded(PlayerMode.Local);
    }
  }
}
