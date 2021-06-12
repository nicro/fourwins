import processing.net.*;
import java.util.Map;

class PlayerData {
  color _color;
  PlayerData(color c) {
    _color = c;
  }
}

class ServerGame extends Game {

Server _server;
int _port = 5204;
HashMap<String, PlayerData> _ipColorMap = new HashMap<String, PlayerData>();
PlayerData _currentTurn;

ServerGame(PApplet parent, int column, int row) {
  super(column, row);
  _server = new Server(parent, _port);
  _ipColorMap.put("localhost", new PlayerData(color(255, 0, 0)));
  _currentTurn = _ipColorMap.get("localhost");
}

void nextTurn() {
  boolean previousFound = false;
  for (Map.Entry entry : _ipColorMap.entrySet()) {
    PlayerData data = (PlayerData)entry.getValue();
    if (previousFound) {
      _currentTurn = data;
      return;
    }
    if (data._color == _currentTurn._color) {
      previousFound = true;
    };
  }
  _currentTurn = _ipColorMap.get("localhost");
}

void setup() {
  textLog("Server started");
  super.setup();
}

void connectHandler(Client client) {
  textLog(client.ip() + " has just connected\n");
  color clr = color(random(255), random(255), random(255));
  _ipColorMap.put(client.ip(), new PlayerData(clr));
  client.write("await-move " + clr);
}

int make_move(int _, int column) {
  moveHandler("localhost", column);
  return 0;
}

void broadcast(String msg) {
  for (int i = 0; i < _server.clientCount; i++) {
    _server.clients[i].write(msg);
  }
}

void moveHandler(String ip, int column) {
  PlayerData pd = _ipColorMap.get(ip);
  if (_currentTurn == pd) {
      textLog("move confirmed: " + pd._color + " " + column);
      super.make_move(pd._color, column);
      broadcast("move " + pd._color + " " + column);
      nextTurn();
  }
}

void processMessage(Client client) {
  String str = client.readString();
  print("debug::msg " + str + "\n");
  if (str == null) {
    return;
  }
  String []chunks = str.split(" ");
  if (chunks.length < 1) {
    return;
  }
  String firstWord = chunks[0];
  switch (firstWord) {
    case "connected": connectHandler(client); break;
    case "move": if (chunks.length > 1) moveHandler(client.ip(), Integer.parseInt(chunks[1])); break;
    default: break;
  }
}

void draw() {
  background(20);
  
  // listen for clients
  Client thisClient = _server.available();
  if (thisClient !=null) {
    processMessage(thisClient);
  }
  
  super.draw();
}

}
