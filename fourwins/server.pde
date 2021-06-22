import processing.net.*;
import java.util.Map;

class ServerGame extends Game {

Server _server;
HashMap<String, PlayerData> _ipColorMap = new HashMap<String, PlayerData>();
PlayerData _currentTurn;
boolean _gameEnded = false;

ServerGame(PApplet parent, int port, int column, int row) {
  super(column, row);
  _server = new Server(parent, port);
  _ipColorMap.put("localhost", new PlayerData("", color(255, 0, 0)));
  _currentTurn = _ipColorMap.get("localhost");
  overlay.textLog("Server started");
}

void exit() {
  super.exit();
  _server.stop();
}

String statusLine() {
  return super.statusLine() + " - "+ _server.clientCount + " clients connected"
  + (_gameEnded ? "\nPress (n) to start new game\n" : "");
}

void winnerFound(color clr, Field field0, Field field1, Field field2, Field field3) {
  super.winnerFound(clr, field0, field1, field2, field3);
  _gameEnded = true;
  String message = " win " + clr + " ";
  message += field0._x + " " + field0._y + " ";
  message += field1._x + " " + field1._y + " ";
  message += field2._x + " " + field2._y + " ";
  message += field3._x + " " + field3._y + " ";
  print(message);
  broadcast(message);
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

void connectHandler(Client client) {
  overlay.textLog(client.ip() + " has just connected\n");
  color clr = color(random(255), random(255), random(255));
  _ipColorMap.put(client.ip(), new PlayerData("", clr));
  if (client.active())
    client.write("await-move " + clr);
}

int makeMove(int _, int column) {
  moveHandler("localhost", column);
  return 0;
}

void broadcast(String msg) {
  for (int i = 0; i < _server.clientCount; i++) {
    if (_server.clients[i].active())
      _server.clients[i].write(msg);
  }
}

void moveHandler(String ip, int column) {
  PlayerData pd = _ipColorMap.get(ip);
  if (_currentTurn == pd) {
      overlay.textLog("move confirmed: " + pd._color + " " + column);
      super.makeMove(pd._color, column);
      broadcast("move " + pd._color + " " + column);
      checkForWinner();
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
  // listen for clients
  Client thisClient = _server.available();
  if (thisClient !=null) {
    processMessage(thisClient);
  }
  
  if (keyPressed && key == 'n') {
    _gameEnded = false;
    reset();
    broadcast("reset");
  }
  
  super.draw();
}

}
