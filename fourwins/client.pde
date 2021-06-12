import processing.net.*;

class ClientGame extends Game {

Client _client;
String _host = "127.0.0.1";
int _port = 5204;

boolean _clientTurn = false;
color _clientColor;

ClientGame(PApplet parent, int columns, int rows) {
  super(columns, rows);
  _client = new Client(parent, _host, _port);
  _client.write("connected");
  textLog("connect request sent\n");
}

int make_move(color clr, int column) {
  if (!_clientTurn) return -1;
  _client.write("move " + column);
  textLog("move request " + _clientColor + " " + column + " sent\n");
  return 0;
}

void setup() {
  super.setup();
}

void processMessage(String msg) {
     if (msg.isEmpty()) return;
     String []chunks = msg.split(" ");
     if (chunks.length < 1) {
       return;
     }
     String firstWord = chunks[0];
     switch (firstWord) {
       case "await-move": {
         if (chunks.length < 2) return;
         _clientTurn = true;
         _clientColor = Integer.parseInt(chunks[1]);
         
       } break;
       case "move": {
         if (chunks.length < 3) return;
         color clr = Integer.parseInt(chunks[1]);
         int column = Integer.parseInt(chunks[2]);
         super.make_move(clr, column);
       } break;
       default: break;
     }
}

void draw() {
  background(0);
  String msg = _client.readString();
  if (msg != null)
    processMessage(msg);
  super.draw();
}

}
