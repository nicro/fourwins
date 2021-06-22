MainLoop mainLoop;
int columns = 7;
int rows = 6;


void settings() { size(101 * columns, 101 * rows + 100); }
void setup   () { mainLoop = new MainLoop(this);   }

class MainLoop implements Notifyable {
  PApplet _window;
  Game _game;
  
  Button _serverBtn = new Button(100, 30, 250, "server");
  Button _clientBtn = new Button(400, 30, 250, "client");
  Button _localBtn = new Button (100, 330, 250, "local\ngame");
  boolean _gameInited = false;
  
  MainLoop(PApplet window) {
    _window = window;
    registerMouseEvents(this);
    registerMouseEvents(_serverBtn);
    registerMouseEvents(_clientBtn);
    registerMouseEvents(_localBtn);
  }
  
  void initIfNeeded(PlayerMode mode) {
    if (_gameInited) return;
    
    _serverBtn.visible = false;
    _clientBtn.visible = false;
    _localBtn.visible = false;
    
    switch (mode) {
     case Client: 
       _game = new ClientGame(_window, "127.0.0.1", 5204, 7, 6);
       break;
     case Server:
       _game = new ServerGame(_window, 5204, 7, 6);
       break;
     case Local:
       _game = new LocalGame(7, 6);
       break;
     default:
       print("init error!");
       break;
    }
    
    registerMouseEvents(_game);
    _game.mode = mode;
    _gameInited = true;
  }
  
  void quitGame() {
    if (!_gameInited) return;    
    _game.exit();
    removeMouseEvents(_game);   
    
    _serverBtn.visible = true; _serverBtn.clicked = false;
    _clientBtn.visible = true; _clientBtn.clicked = false;
    _localBtn.visible  = true;  _localBtn.clicked = false;
    _gameInited = false;
  }
  
  void mouseEvent(MouseEvent e) {
    if (e == MouseEvent.Draw) {
      background(20);
      if (keyPressed && key == 'q') quitGame();
      if (_serverBtn.clicked) initIfNeeded(PlayerMode.Server);
      if (_clientBtn.clicked) initIfNeeded(PlayerMode.Client);
      if ( _localBtn.clicked) initIfNeeded(PlayerMode.Local);
    }
  }
}
