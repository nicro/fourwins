import processing.net.*;

class Server implements Service {

Field[][] fields;
int columns = 7;
int rows = 6;

void initialize_fields() {
  fields = new Field[columns][rows];
  for (int column = 0; column < columns; column++) 
  {
    fields[column] = new Field[rows];
    for (int row = 0; row < rows; row++)
      fields[column][row] = new Field(column, row); // default
  }
}

void draw_fields() {
  for (int column = 0; column < columns; column++) 
  {
    for (int row = 0; row < rows; row++)
      fields[column][row].render();
  }
}

void setup() {
  size(800, 600);
  initialize_fields();
}

void draw() {
  background(0);
  draw_fields();
}

}
