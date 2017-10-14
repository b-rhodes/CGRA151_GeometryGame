interface MenuItem {
  void drawMenuItem();
}

// The potential functions of buttons (allows for a switch saying which each button does).
enum ButtonFn {
  PLAY,
  PLACE_BASIC_TOWER
}

abstract class BasicButton implements MenuItem {
  float x, y, bWidth, bHeight;
  String label;
  ButtonFn function;
  
  boolean isMouse() {
    return(x < mouseX && (x+bWidth) < mouseX && y < mouseY && (y+bHeight) < mouseY);
  }
  
  ButtonFn getFn() {
    return function;
  }
  
  void drawMenuItem() {
    fill(200);
    stroke(150);
    rect(x, y, bWidth, bHeight, 15);
    textAlign(CENTER, CENTER);
    fill(0);
    text(label, x + (w / 2), y + (h / 2));
  }
}

class Button extends BasicButton {
  public Button(float x, float y, float bWidth, float bHeight, String label, ButtonFn function) {
    this.x = x;
    this.y = y;
    this.bWidth = bWidth;
    this.bHeight = bHeight;
    this.label = label;
    this.function = function;
  }
}

class ContextMenu implements MenuItem {
  
  float x, y, w, h, curve;
  color colour;
  ArrayList<MenuItem> content;
  boolean floating;
  
  public ContextMenu(float x, float y, float w, float h, color colour, boolean floating) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.colour = colour;
    this.floating = floating;
    curve = (floating ? 10 : 0);
    /*
    x = 1300;
    y = 0;
    w = 300;
    h = 900;
    */
  }
  
  void drawMenuItem() {
    noStroke();
    fill(colour);
    rect(x, y, w, h, curve);
    for( MenuItem element : content ) {
      element.drawMenuItem();
    }
  }
  
  void addMenuItem(MenuItem element) {
    content.add(element);
  }
}

class RightMenu extends ContextMenu {
  
  float spaceBetween = 15;
  float leftMargin = 15;
  float rightMargin = 15;
  float topMargin = 15;
  float nextY;
  float bHeight;
  
  public RightMenu(color colour) {
    super(1300, 0, 300, 900, colour, false);
    nextY = y + topMargin;
  }
  
  void addButton(String label, ButtonFn function) {
    addMenuItem(new Button(x+leftMargin, y+topMargin, (w - (leftMargin + rightMargin), bHeight, label, function));
  }
}