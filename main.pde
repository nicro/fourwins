interface Service {
  void setup();
  void draw();
}

Service service;
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
}

void draw() {
  if (menuEnabled) {
    show_menu();
    return;
  }  
  service.draw();
}

void mouseClicked() {
  serverBtn.click_handler();
  clientBtn.click_handler();
}

void mouseMoved() {
  serverBtn.move_handler();
  clientBtn.move_handler();
}

void show_menu() {
    serverBtn.render();
    clientBtn.render();
    
    if (serverBtn.clicked) { 
      menuEnabled = false; 
      isServer = true;
      service = new Server();
      service.setup();
    }
    if (clientBtn.clicked) { 
      menuEnabled = false; 
      isServer = false;
      service = new Client();
      service.setup();
    }
}
