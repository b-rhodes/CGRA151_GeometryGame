//ArrayDeque
import java.util.ArrayDeque;
// COLOURS https://flatuicolors.com/

GameState state;
CurrentMenu whichMenu;

// The menus
RightMenu rightMenu;
ArrayList<MenuItem> menuElements; // Probably empty most of the time (only used if there are context menus on the screen).



// The menu is 300x900, on the right.
int menuWidth = 300;
// The main viewing pane is 1300x900, on the left.
int screenBreak = 1300;


// Game Variables
String mapFile; // Possibly not used.
ArrayList<Float> chosenMapArray; // stores the path like so: {x1,y1, x2,y2, x3,y3..... xEnd,yEnd}

// The following are listed in the order which they are drawn.
ArrayList<MapLines> mapPoints;
EndPoint ending;
ArrayDeque<Enemy> enemies;/* fill this*/
ArrayList<Projectile> projectiles;
ArrayList<Tower> towers;

// Used in creation of enemies.
ArrayDeque<PVector> path; // Only a queue because it needs to be passed into all enemies.

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
    case LOADING:   doLoad();
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
  // will create chosenMapArray
}

void doLoad() {
  //getMap(mapFile);
  makeMapLines(chosenMapArray);
}

void makeMapLines(ArrayList<Float> pathArray) {
  //mapPoints MapLines
  float xPrev = 0;
  float yPrev = 0;
  ArrayList<MapLines> mapPoints = new ArrayList<MapLines>();
  
  for(int i=0; i < pathArray.size(); i++) {
    
    if(i%2 == 0) { // the current co-ord is an x
    
      if(i > 1) {
        mapPoints.add(new MapLines(xPrev, yPrev, pathArray.get(i), pathArray.get(i+1)));
      }
      
      xPrev = pathArray.get(i);
      
    } else { // the current co-ord is a y
      yPrev = pathArray.get(i);
      path.offer(new PVector(xPrev, yPrev));
    }
    
  }
}