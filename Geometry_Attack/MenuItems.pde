interface MenuItem {
  void drawMenuItem();
}

// The potential functions of buttons (allows for a switch saying which each button does).
enum ButtonFn {
  PLAY1,
  PLAY2,
  PT_BASIC, // PT stands for place tower.
  PT_MACHINE,
  PT_AOE,
  BACK_TO_MENU
}

abstract class BasicButton implements MenuItem {
  float x, y, bWidth, bHeight;
  String label;
  ButtonFn function;
  color colour;
  color outlineColour;
  
  boolean isMouse() {
    return (x < mouseX && mouseX < (x+bWidth) && y < mouseY && mouseY < (y+bHeight));
  }
  
  ButtonFn getFn() {
    return function;
  }
  
  void drawMenuItem() {
    fill(colour);//200
    strokeWeight(1);
    stroke(outlineColour);//150
    rectMode(CORNER);
    rect(x, y, bWidth, bHeight, 15);
    textAlign(CENTER, CENTER);
    textSize(18);
    fill(0);
    text(label, x + (bWidth / 2), y + (bHeight / 2));
  }
}

class Button extends BasicButton {
  public Button(float x, float y, float bWidth, float bHeight, color colour, color outlineColour, String label, ButtonFn function) {
    this.x = x;
    this.y = y;
    this.bWidth = bWidth;
    this.bHeight = bHeight;
    this.label = label;
    this.function = function;
    this.colour = colour;
    this.outlineColour = outlineColour;
  }
}

class MenuButton extends BasicButton {
  public MenuButton(float x, float y, float bWidth, float bHeight, color colour, color outlineColour, String label, ButtonFn function) {
    this.x = x;
    this.y = y;
    this.bWidth = bWidth;
    this.bHeight = bHeight;
    this.label = label;
    this.function = function;
    this.colour = colour;
    this.outlineColour = outlineColour;
  }
  
  void drawMenuItem() {
    fill(colour);
    strokeWeight(1);
    stroke(outlineColour);
    rectMode(CENTER);
    rect(x, y, bWidth, bHeight, 15);
    textAlign(CENTER, CENTER);
    textSize(18);
    fill(0);
    text(label, x, y);
  }
  
  boolean isMouse() {
    float w = bWidth/2;
    float h = bHeight/2;
    return (x-w < mouseX && mouseX < x+w && y-h < mouseY && mouseY < y+h);
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
    content = new ArrayList<MenuItem>();
    
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
    rectMode(CORNER);
    rect(x, y, w, h, curve);
    for( MenuItem element : content ) {
      element.drawMenuItem();
    }
  }
  
  void addMenuItem(MenuItem element) {
    content.add(element);
  }
  
  boolean isMouse() {
    return (x < mouseX && mouseX < x+w && y < mouseY && mouseY < y+h); 
  }
  
  ButtonFn doButton() {
    for(MenuItem element : content) {
      if(element instanceof Button && ((Button)element).isMouse()) {
        return ((Button)element).getFn();
      }
    }
    return null;
  }
}

class RightMenu extends ContextMenu {
  
  float spaceBetween = 15;
  float leftMargin = 15;
  float rightMargin = 15;
  float topMargin = 15;
  float nextY;
  float bHeight = 40;
  
  public RightMenu(color colour) {
    super(1300, 0, 300, 900, colour, false);
    nextY = y + topMargin + bHeight/2;
  }
  
  void addButton(color fill,color stroke,String label, ButtonFn function) {
    addMenuItem(new Button(x+leftMargin, nextY, (w - (leftMargin + rightMargin)), bHeight,fill,stroke, label, function));
    nextY += spaceBetween + bHeight;
  }
  
  void addMoneyCounter() {
    addMenuItem(new MoneyCounter(x+leftMargin, nextY, (w - (leftMargin + rightMargin)), bHeight));
    nextY += spaceBetween + bHeight;
  }
  
  void addPointsCounter() {
    addMenuItem(new PointsCounter(x+leftMargin, nextY, (w - (leftMargin + rightMargin)), bHeight));
    nextY += spaceBetween + bHeight;
  }
  
  void addHPCounter() {
    addMenuItem(new HPCounter(x+leftMargin, nextY, (w - (leftMargin + rightMargin)), bHeight));
    nextY += spaceBetween + bHeight;
  }
  
  float getX() {
    return x;
  }
  
  void update() {
    for(MenuItem element : content) {
      if(element instanceof MoneyCounter) {
        ((MoneyCounter)element).update();
      }else if(element instanceof PointsCounter) {
        ((PointsCounter)element).update();
      }else if(element instanceof HPCounter) {
        ((HPCounter)element).update();
      }
    }
  }
}

class MoneyCounter extends BasicButton {
  public MoneyCounter(float x, float y, float bWidth, float bHeight) {
    this.function = null;
    this.label = "Coins: " + playerMoney;
    this.x = x;
    this.y = y;
    this.bWidth = bWidth;
    this.bHeight = bHeight;
    this.function = null;
    this.colour = color(241, 196, 15);
    this.outlineColour = color(243, 156, 18);
  }
  
  void update() {
    label = "Coins: " + playerMoney;
  }
  
}

class PointsCounter extends BasicButton {
  public PointsCounter(float x, float y, float bWidth, float bHeight) {
    this.function = null;
    this.label = "Points: " + playerScore;
    this.x = x;
    this.y = y;
    this.bWidth = bWidth;
    this.bHeight = bHeight;
    this.function = null;
    this.colour = color(230, 126, 34);
    this.outlineColour = color(211, 84, 0);
  }
  
  void update() {
    label = "Points: " + playerScore;
  }
  
}

class HPCounter extends BasicButton {
  public HPCounter(float x, float y, float bWidth, float bHeight) {
    this.function = null;
    this.label = "HP: " + playerHP;
    this.x = x;
    this.y = y;
    this.bWidth = bWidth;
    this.bHeight = bHeight;
    this.function = null;
    this.colour = color(46, 204, 113);
    this.outlineColour = color(39, 174, 96);
  }
  
  void update() {
    label = "HP: " + playerHP;
  }
  
}

class MainMenu extends ContextMenu {
  
  float nextY, bWidth, bHeight;
  
  public MainMenu() {
    super(0, 0, 1600, 900, color(35,35,54), false);
    nextY = height/3;
    bWidth = width/4;
    bHeight = 60;
  }
  
  void addButton(color fill, color outline, String label, ButtonFn fn) {
    content.add(new MenuButton(width/2, nextY, bWidth, bHeight, fill, outline, label, fn));
    nextY += bHeight + 30;
  }
  
  void drawMenuItem() {
    noStroke();
    fill(colour);
    rectMode(CORNER);
    rect(x, y, w, h, curve);
    for( MenuItem element : content ) {
      textSize(40);
      element.drawMenuItem();
    }
  }
  
  ButtonFn doButton() {
    for(MenuItem element : content) {
      if(element instanceof MenuButton && ((MenuButton)element).isMouse()) {
        return ((MenuButton)element).getFn();
      }
    }
    return null;
  }
}