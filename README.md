# Fourwins
###### An implementation of fourwins game with a server, client and an offline mode.
To launch the app in two instances for test, you might want to export application to run the second via console (because processing ide does not support launching multiple app instances at once). To do so, click File -> Export Application and select your OS. The binary will be written to the project root directory. Then launch it via terminal.

### If you want to use online mode, you need to: 
- enable port forwarding
- set your IP and port in fourwins.pde

```processing
// fourwins/fourwins.pde

switch (mode) {
     case Client: _game = new ClientGame(_window, "127.0.0.1", 5204, columns, rows); break;
     case Server: _game = new ServerGame(_window, 5204, columns, rows); break;
     case Local:  _game = new LocalGame( columns, rows); break;
     case NotSelected: print("mode not selected!"); break;
}

```
