static enum MouseEvent {
 Clicked,
 Pressed,
 Released,
 Moved,
 Draw
};

ArrayList<Notifyable>  mouseEventReceivers = new ArrayList<Notifyable>();

void registerMouseEvents(Notifyable obj) {
  mouseEventReceivers.add(obj);
}

void removeMouseEvents(Notifyable obj) {
  mouseEventReceivers.remove(obj);
}

interface Notifyable { 
  void mouseEvent(MouseEvent e); 
}

void handleForAll(MouseEvent e) {
    for (int i = 0; i < mouseEventReceivers.size(); i++) {
      mouseEventReceivers.get(i).mouseEvent(e);
    }
}

void mousePressed () { handleForAll(MouseEvent.Pressed ); }
void mouseClicked () { handleForAll(MouseEvent.Clicked ); }
void mouseMoved   () { handleForAll(MouseEvent.Moved   ); }
void mouseReleased() { handleForAll(MouseEvent.Released); }
void draw()          { handleForAll(MouseEvent.Draw    ); }
