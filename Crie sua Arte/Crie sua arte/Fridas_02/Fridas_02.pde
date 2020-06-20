// Preload images for js
// Sticker array and IntList for layers
Sticker[] stickers = new Sticker[50];
ArrayList<Integer> layers;

// Canvas and toolbar
public PGraphics canvas, tools;
PImage template;
Button EDIT, ADD_STICKER, SAVE, CLEAR, BACK, SELECT_DOWN, SELECT_UP, LAYER_DOWN, LAYER_UP, ROTATE, REMOVE;

// States
boolean editing = false;
boolean dragging = false;
boolean rotating = false;

// Edit variables
int currentSelection = 0;
PVector draggingStartedAt;

// ********
// Setup
// ********

void setup() {
  size(800, 700);
  background(255);


  // Initialize the stickers
  for (int i = 0; i < stickers.length; i++) {
    stickers[i] = new Sticker("Sticker" + nf(i+1, 2) + ".gif");
  }

  // Initialize the layers
  layers = new ArrayList<Integer>();

  // Initialize the canvas
  canvas = createGraphics(800, 550);
  template = loadImage("Fridas.jpg");



  // Initialize the tools
  tools = createGraphics(800, 675);
  draggingStartedAt = new PVector(0, 0);
  EDIT = new Button(100, 600, "crie.gif");
  SAVE = new Button(350, 600, "baixe.gif");
  CLEAR = new Button(600, 600, "apagar.gif");
  BACK = new Button(20, 600, "voltar.gif");
  SELECT_DOWN = new Button(150, 600, "antes.gif");
  ADD_STICKER = new Button(300, 600, "clique.gif");
  SELECT_UP = new Button(450, 600, "depois.gif");
 // LAYER_DOWN = new Button(400, 600, "um.gif");
 // LAYER_UP = new Button(500, 600, "dois.gif");
  ROTATE = new Button(600, 600, "gira.gif");
  REMOVE = new Button(700, 600, "apaga2.gif");
}

// ********
// Draw
// ********

void draw() {
  dragAndRotate();
  displayTools();
  displayCanvas();
  image(tools, 0, 0);
  image(canvas, 0, 0);
}

void mouseClicked() {
  PVector mousePos = new PVector(mouseX, mouseY);
  checkTools(mousePos);
}

void mousePressed() {
  if (editing) {
    PVector mousePos = new PVector(mouseX, mouseY);

    // Hold to rotate
    if (ROTATE.isClicked(mousePos) && !rotating) rotating = true;

    // Dragging an active sticker
    else if (mouseY < canvas.height && !dragging) {
      draggingStartedAt.set(mouseX, mouseY);
      dragging = true;
    }
  }
}

void mouseReleased() {
  dragging = false;
  rotating = false;
}












// ********
// Toolbar
// ********

// Display buttons in the toolbar and the drag icon
void displayTools() {
  tools.beginDraw();
  tools.background(255);
  tools.endDraw();

  if (!editing) {
    EDIT.display();
  // ADD_STICKER.display();
    SAVE.display();
    CLEAR.display();
  } else {
    BACK.display();
    SELECT_DOWN.display();
    ADD_STICKER.display();
    SELECT_UP.display();
   // LAYER_DOWN.display();
   // LAYER_UP.display();
    ROTATE.display();
    REMOVE.display();
  }
}

// Check if buttons are pressed and run actions
void checkTools(PVector _mouse) {
  if (!editing) {
    if (EDIT.isClicked(_mouse)) editing = true;
    // else if (ADD_STICKER.isClicked(_mouse)) addActiveSticker();
    else if (SAVE.isClicked(_mouse)) saveCanvas();
    else if (CLEAR.isClicked(_mouse)) clearCanvas();
  } else {
    if (BACK.isClicked(_mouse)) editing = false;
    else if (ADD_STICKER.isClicked(_mouse)) addActiveSticker();
    else if (SELECT_DOWN.isClicked(_mouse)) selectDown();
    else if (SELECT_UP.isClicked(_mouse)) selectUp();
    //else if (LAYER_DOWN.isClicked(_mouse)) moveStickerDown();
   // else if (LAYER_UP.isClicked(_mouse)) moveStickerUp();
    else if (REMOVE.isClicked(_mouse)) removeSticker();
  }
}

//********
// Saving
//********
void saveCanvas() {
   canvas.save ("export/" + "fridas"+year()+month()+day()+hour()+minute()+second()+".jpg"); 
}


// ********
// Selection functions
// ********

// Highlight the selected sticker
void showSelectedSticker() {
  stickers[layers.get(currentSelection)].showSelection();
}

// Select down a layer
void selectDown() {
  if (currentSelection > 0) currentSelection--;
  else currentSelection = layers.size() - 1;
}

// Select up a layer
void selectUp() {
  if (currentSelection < layers.size() - 1) currentSelection++;
  else currentSelection = 0;
}


// ********
// Editing functions
// ********

// Drag and rotate
void dragAndRotate() {
  if (dragging) {
    PVector mousePos = new PVector(mouseX, mouseY);
    PVector mouseMovedBy = PVector.sub(mousePos, draggingStartedAt);
    stickers[layers.get(currentSelection)].loc.add(mouseMovedBy);
    draggingStartedAt.set(mouseX, mouseY);
  } else if (rotating) rotateSticker();
}

// Rotate a sticker clockwise
void rotateSticker() {
  stickers[layers.get(currentSelection)].rotateBy(PI * 0.02);
}

// ********
// Layer functions
// ********

// Display all active stickers and the template
void displayCanvas() {
  canvas.beginDraw();
  canvas.image(template, 0, 0);
  canvas.endDraw();
  if (layers.size() > 0) {
    for (int i = 0; i < layers.size(); i++) {
      stickers[layers.get(i)].display();
    }
    if (editing) showSelectedSticker();
  }
}

// Add a random inactive sticker index to layers
void addActiveSticker() {
  if (layers.size() < stickers.length) {
    int newStickerIndex;
    do {
      newStickerIndex = int(random(stickers.length));
    } while (layers.contains(newStickerIndex));
    layers.add(newStickerIndex);
    currentSelection = layers.size() - 1;
    editing = true;
  }
}

// Remove a sticker index from layers
void removeSticker() {
  layers.remove(currentSelection);
  if (layers.size() == 0) editing = false;
  else if (currentSelection >= layers.size()) currentSelection--;
}

// Remove all sticker indexes from layers
void clearCanvas() {
  layers.clear();
}

// Move a sticker index down a layer
void moveStickerDown() {
  if (currentSelection > 0) {
    int[] thisStickerIndex = new int[1];
    thisStickerIndex[0] = layers.get(currentSelection);
    layers.remove(currentSelection);
    currentSelection--;
    // layers.add(currentSelection, thisStickerIndex);
  }
}

// Move a sticker index up a layer
void moveStickerUp() {
  if (currentSelection < layers.size() - 1) {
    int[] thisStickerIndex = new int[1];
    thisStickerIndex[0] = layers.get(currentSelection);
    layers.remove(currentSelection);
    currentSelection++;
    //layers.add(currentSelection, thisStickerIndex);
  }
}
class Button {

  PVector loc, center;
  boolean inUse;
  PImage img;

  Button(int _x, int _y, String _imageLabel) {
    loc = new PVector(_x, _y);
    inUse = false;
    img = loadImage(_imageLabel);
    center = new PVector(img.width * 0.5 + loc.x, img.height * 0.5 + loc.y);
  }

  void display() {
    tools.beginDraw();
    tools.image(img, loc.x, loc.y);
    tools.endDraw();
  }

  boolean isClicked(PVector _mouse) {
    if (center.dist(_mouse) < img.width * 0.5 - 5) return true;
    else return false;
  }
}
class Sticker {

  PVector loc, center;
  float rotation;
  PImage img;

  Sticker(String _imageLabel) {
    loc = new PVector(width * 0.5, height * 0.5);
    rotation = 0.0;
    img = loadImage(_imageLabel);
    center = new PVector(img.width * 0.5, img.height * 0.5);
  }

  void display() {
    canvas.beginDraw();
    canvas.pushMatrix();
    canvas.translate(loc.x, loc.y);
    canvas.rotate(rotation);
    canvas.image(img, -center.x, -center.y);
    canvas.popMatrix();
    canvas.endDraw();
  }

  void rotateBy(float _rad) {
    rotation += _rad;
    rotation = rotation % TWO_PI;
  }

  void showSelection() {
    canvas.beginDraw();
    canvas.pushMatrix();
    canvas.translate(loc.x, loc.y);
    canvas.rotate(rotation);
    canvas.fill(255, 100, 100, 50);
    canvas.noStroke();
    canvas.rect(-center.x, -center.y, img.width, img.height);
    canvas.popMatrix();
    canvas.endDraw();
  }
}
