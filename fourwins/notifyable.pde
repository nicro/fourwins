static enum MouseEvent {
 Clicked,
 Pressed,
 Released,
 Moved
};

ArrayList<Notifyable>  mouseEventObjects = new ArrayList<Notifyable>();

void registerMouseEvents(Notifyable obj) {
  mouseEventObjects.add(obj);
}

interface Notifyable { 
  void mouseEvent(MouseEvent e); 
}

void handleForAll(MouseEvent e) {
    for (int i = 0; i < mouseEventObjects.size(); i++) {
      mouseEventObjects.get(i).mouseEvent(e);
    }
}

void mousePressed () { handleForAll(MouseEvent.Pressed ); }
void mouseClicked () { handleForAll(MouseEvent.Clicked ); }
void mouseMoved   () { handleForAll(MouseEvent.Moved   ); }
void mouseReleased() { handleForAll(MouseEvent.Released); }
