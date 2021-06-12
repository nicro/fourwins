Game game;
Button serverBtn;
Button clientBtn;

boolean isServer = true;
boolean menuEnabled = true;

void settings() {
  size(800, 600);
}

void setup() {
  serverBtn = new Button(90, 100, 300, "server");
  clientBtn = new Button(410, 100, 300, "client");
  registerMouseEvents(serverBtn);
  registerMouseEvents(clientBtn);
}

void draw() {
  if (!menuEnabled)
  {
    game.draw();
    return;
  }
  
  serverBtn.render();
  clientBtn.render();
  if (serverBtn.clicked || clientBtn.clicked) {
    menuEnabled = false;
    isServer = serverBtn.clicked;
    game = isServer ? new ServerGame(this, 7, 6) : new ClientGame(this, 7, 6);
    game.setup();
    registerMouseEvents(game);
  }
}
