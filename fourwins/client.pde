import processing.net.*;

class ClientGame extends Game {

Client _client;

boolean _clientTurn = false;
color _clientColor;

ClientGame(PApplet parent, String host, int port, int columns, int rows) {
  super(columns, rows);
  _client = new Client(parent, host, port);
  if (_client.active())
    _client.write("connected");
  overlay.textLog("connect request sent\n");
}

String statusLine() {
  return super.statusLine() + " - "+ (_client.active() ? " connected to host" : " not connected");
}

int makeMove(color clr, int column) {
  if (!_clientTurn) return -1;
  if (_client.active())
    _client.write("move " + column);
  overlay.textLog("sending move " + _clientColor + " " + column);
  return 0;
}

void exit() {
  super.exit();
  _client.stop();
}

void processMessage(String msg, int offset) {
     if (msg.isEmpty()) return;
     String []chunks = msg.split(" ");
     if (chunks.length < 1 || chunks.length <= offset) {
       return;
     }
     String firstWord = chunks[offset];
     switch (firstWord) {
       case "await-move": {
         if (chunks.length < 2 + offset) return;
         _clientTurn = true;
         _clientColor = Integer.parseInt(chunks[1 + offset]);
         processMessage(msg, 2 + offset);
       } break;
       case "move": {
         if (chunks.length < 3 + offset) return;
         color clr = Integer.parseInt(chunks[1 + offset]);
         int column = Integer.parseInt(chunks[2 + offset]);
         super.makeMove(clr, column);
         processMessage(msg, 3 + offset);
       } break;
       case "reset": {
         reset();
         overlay.textLog("reset signal");
       } break;
       case "win": {
         if (chunks.length < 10 + offset) return;
         color clr = Integer.parseInt(chunks[1 + offset]);
         int c0x = Integer.parseInt(chunks[2 + offset]);
         int c0y = Integer.parseInt(chunks[3 + offset]);
         int c1x = Integer.parseInt(chunks[4 + offset]);
         int c1y = Integer.parseInt(chunks[5 + offset]);
         int c2x = Integer.parseInt(chunks[6 + offset]);
         int c2y = Integer.parseInt(chunks[7 + offset]);
         int c3x = Integer.parseInt(chunks[8 + offset]);
         int c3y = Integer.parseInt(chunks[9 + offset]);
         print(msg);
         winnerFound(clr, _fields[c0x][c0y], _fields[c1x][c1y], _fields[c2x][c2y],_fields[c3x][c3y]);
         processMessage(msg + offset, 10);
         overlay.textLog("win signal");
       } break;
       default: break;
     }
}

void draw() {
  String msg = _client.readString();
  if (msg != null)
    processMessage(msg, 0);
  super.draw();
}

}
