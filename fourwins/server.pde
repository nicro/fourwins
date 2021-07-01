import processing.net.*;
import java.util.Map;

class ServerGame extends Game {

Server _server;
Player _currentTurn;
boolean _gameEnded = false;

ServerGame(PApplet parent, int port, int column, int row) {
  super(column, row);
  _server = new Server(parent, port);
  _players.add(new Player("localhost", color(255, 0, 0)));
  _currentTurn = _players.get(0);
  log("Server started");
}

void exit() {
  super.exit();
  _server.stop();
}

String statusLine() {
  return super.statusLine() + " - " +  
  _server.clientCount + " clients connected";
}

void winnerFound(Player player, Field field0, Field field1, Field field2, Field field3) {
  super.winnerFound(player, field0, field1, field2, field3);
  _gameEnded = true;
  String message = " win " + player._color + " ";
  message += field0._x + " " + field0._y + " ";
  message += field1._x + " " + field1._y + " ";
  message += field2._x + " " + field2._y + " ";
  message += field3._x + " " + field3._y + " ";
  broadcast(message);
}

void nextTurn() {
  boolean previousFound = false;
  for (int i = 0; i < _players.size(); i++) {
    Player player = _players.get(i);
    if (previousFound) {
      _currentTurn = player;
      return;
    }
    if (player._color == _currentTurn._color) {
      previousFound = true;
    }
  }
  _currentTurn = _players.get(0);
}

boolean colorsTooSimilar(color c1, color c2) {
  boolean checks = true;
  int factor = 10; // constant
  checks &= abs(red  (c1) - red  (c2)) < factor;
  checks &= abs(green(c1) - green(c2)) < factor;
  checks &= abs(blue (c1) - blue (c2)) < factor;
  return checks;
}

Player newRandomPlayer(String ip) {
  if (_players.size() < 1)
    return new Player(ip, color(random(255), random(255), random(255)));
  color lastColor = _players.get(_players.size() - 1)._color;
  color newColor = color(
    (red  (lastColor) + random(127)) % 256,
    (green(lastColor) + random(127)) % 256,
    (blue (lastColor) + random(127)) % 256
  );
  if (colorsTooSimilar(newColor, lastColor)
   || colorsTooSimilar(newColor, default_field_color))
    return newRandomPlayer(ip);
  return new Player(ip, newColor);
}

void connectHandler(Client client) {
  color clr = color(random(255), random(255), random(255));
  _players.add(new Player(client.ip(), clr));
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
  Player player = getPlayerByName(ip);
  if (!player.isEmpty() && _currentTurn == player) {
      log(player._name + " move confirmed: " + column);
      super.makeMove(player._color, column);
      broadcast("move " + player._color + " " + column);
      checkForWinner();
      nextTurn();
  }
}

void processMessage(Client client) {
  String str = client.readString();
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
    case "move": {
      if (chunks.length > 1)
        moveHandler(client.ip(), Integer.parseInt(chunks[1])); 
      } break;
    default: break;
  }
}

void mouseEvent(MouseEvent e) {
  switch (e) {
    case Draw: {
        Client thisClient = _server.available();
        if (thisClient !=null) {
          processMessage(thisClient);
        }
        if (keyPressed && key == 'n') {
          _gameEnded = false;
          reset();
          broadcast("reset");
        }
    } break;
    default: break;
  }
  super.mouseEvent(e);
}

}
