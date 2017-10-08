import java.util.LinkedList;
// COLOURS https://flatuicolors.com/

GameState state;
CurrentMenu whichMenu;
ArrayList<MapLines> mapPoints;

// The menu is 300x900, on the right.
int menuWidth = 300;
// The main viewing pane is 1300x900, on the left.
int screenBreak = 1300;


// Game Variables
float startPoint[];
EndPoint endPoint;

void setup() {
  size(1600,900);
  state = GameState.MENU;
  whichMenu = CurrentMenu.TOP_MENU;
}

void draw() { 
  // Check the state of the game.
  switch (state) {
    case MENU:      doMenu();
                    break;
    case PLAYING:   doGame();
                    break;
    case PAUSED:    doPaused();
                    break;
  }
}

void doMenu() {
  /*do some stuff*/
}

void doGame() {
  /*move the enemies, shoot turrets etc*/
}

void doPaused() {
  /*just draw the map and towers and enemies in place, with a pause button somewhere.*/
}

void getMap(String fname) {
  /* This needs to accesss the file. using loadStrings();*/
}