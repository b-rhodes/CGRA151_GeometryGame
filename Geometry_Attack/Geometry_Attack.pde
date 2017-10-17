//ArrayDeque
import java.util.ArrayDeque;
import java.util.Arrays;
import java.util.Collections;
// COLOURS https://flatuicolors.com/

GameState state;
CurrentMenu whichMenu;

// The menus
MainMenu topMenu;
MainMenu losingMenu;
RightMenu rightMenu;

ArrayList<MenuItem> menuElements; // Probably empty most of the time (only used if there are context menus on the screen).



// The menu is 300x900, on the right.
int menuWidth = 300;
// The main viewing pane is 1300x900, on the left.
int screenBreak = 1300;


// Game Variables
String mapFile; // Possibly not used.
ArrayList<Float> chosenMapArray; // stores the path like so: {x1,y1, x2,y2, x3,y3..... xEnd,yEnd}
PVector spawnLoc;

int playerMoney;
int playerScore;
int playerHP;

// The following are listed in the order which they are drawn.
ArrayList<MapLines> mapPoints;
EndPoint ending;
ArrayDeque<Enemy> enemies;/* fill this*/
ArrayList<Projectile> projectiles;
ArrayList<Tower> towers;

// Used in creation of enemies.
ArrayDeque<PVector> path; // Only a queue because it needs to be passed into all enemies.
int basicEnemyHP;

//holdingTower is the tower which is "held" (the player is about to place it).
Tower holdingTower;

void setup() {
  size(1600,900);
  state = GameState.MENU;
  whichMenu = CurrentMenu.TOP_MENU;
  frameRate(60);
  
  rightMenu = new RightMenu(color(35,35,54));
  
  // Track points/money
  rightMenu.addHPCounter();
  rightMenu.addPointsCounter();
  rightMenu.addMoneyCounter();
  
  rightMenu.addButton(color(35,35,54), color(35,35,54),"", null);
  // Place Towers
  rightMenu.addButton(color(155, 89, 182), color(142, 68, 173),"Basic Tower (5c)", ButtonFn.PT_BASIC);
  rightMenu.addButton(color(26, 188, 156), color(22, 160, 133),"Machine Gun Tower (40c)", ButtonFn.PT_MACHINE);
  rightMenu.addButton(color(231, 76, 60), color(192, 57, 43),"AoE Tower (25c)", ButtonFn.PT_AOE);
  
  // Space Maker
  rightMenu.addButton(color(35,35,54), color(35,35,54),"", null);
  
  // Quit Button
  rightMenu.addButton(color(46, 204, 113), color(39, 174, 96),"MAIN MENU", ButtonFn.BACK_TO_MENU);
  
  
  topMenu = new MainMenu();
  topMenu.addButton(color(52, 152, 219), color(41, 128, 185), "GEOMETRY ATTACK", null);
  topMenu.addButton(color(46, 204, 113), color(39, 174, 96), "Level 1", ButtonFn.PLAY1);
  topMenu.addButton(color(46, 204, 113), color(39, 174, 96), "Level 2", ButtonFn.PLAY2);
  
  losingMenu = new MainMenu();
  losingMenu.addButton(color(52, 152, 219), color(41, 128, 185), "YOU LOSE", null);
  losingMenu.addButton(color(46, 204, 113), color(39, 174, 96), "Back to Main Menu", ButtonFn.BACK_TO_MENU);
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

void mouseClicked() {
  if(state == GameState.PLAYING && holdingTower != null) {
    if(holdingTower.validPlacement() && holdingTower.getX()+holdingTower.getRad() < rightMenu.getX()) {
      if(holdingTower instanceof BasicTower) {
        placeBasicTower();
      } else if(holdingTower instanceof MachineGunTower) {
        placeMachineTower();
      }else if(holdingTower instanceof AOETower) {
        placeAOETower();
      }
    }
    holdingTower = null;
  } else if(state == GameState.PLAYING && rightMenu.isMouse()) {
    ButtonFn fn = rightMenu.doButton();
    doButton(fn);
  } else if(state == GameState.MENU && whichMenu == CurrentMenu.TOP_MENU) {
    ButtonFn fn = topMenu.doButton();
    doButton(fn);
  } else if(state == GameState.MENU && whichMenu == CurrentMenu.YOU_LOSE) {
    ButtonFn fn = losingMenu.doButton();
    doButton(fn);
  }
}

void mouseMoved() {
  if(holdingTower != null) {
    holdingTower.setX(mouseX);
    holdingTower.setY(mouseY);
    if(holdingTower.validPlacement() && holdingTower.getX()+holdingTower.getRad() < rightMenu.getX()) {
      holdingTower.setColour(color(0,255,0,100));
    } else {
      holdingTower.setColour(color(255,0,0,100));
    }
  }
}

void doMenu() {
  if(whichMenu == CurrentMenu.TOP_MENU) {
    topMenu.drawMenuItem();
  } else {
    losingMenu.drawMenuItem();
  }
}

void doGame() {
  /*move the enemies, shoot turrets etc*/
  spawnEnemy();
  moveEnemies();
  checkEnd();
  shootTowers();
  moveProjectiles();
  checkHits(); // Checks if the enemies are hit by projectiles.
  
  rightMenu.update();
  drawAll();
  
  rightMenu.drawMenuItem();
  if(holdingTower != null) {
    holdingTower.drawTower();
    holdingTower.drawRange();
  }
}

void doPaused() {
  /*just draw the map and towers and enemies in place, with a pause button somewhere.*/
}

/**
 * Loads the map up. This is it's own sepparate function/game state so that we can set a loading screen.
 */
void doLoad() {
  background(255);
  fill(0);
  textSize(40);
  textAlign(CENTER, CENTER);
  text("LOADING", width/2, height/2);
  //getMap(mapFile);
  makeMapLines(chosenMapArray);
  spawnLoc = path.getFirst();
  ending = new EndPoint(path.getLast().x, path.getLast().y);
  drawMap();
  
  // Initalise game variables
  enemies = new ArrayDeque<Enemy>();
  projectiles = new ArrayList<Projectile>();
  towers = new ArrayList<Tower>();
  
  playerScore = 0;
  holdingTower = null;
  
  
  state = GameState.PLAYING;
}

void checkHits() {
  ArrayList<Projectile> removingP = new ArrayList<Projectile>();
  for(Projectile proj : projectiles) {
    if(proj.isGeneric() && proj.isHit(proj.getTarget())) {
      proj.getTarget().takeDamage(1);
      removingP.add(proj);
    } else if(proj instanceof AOEProjectile) {
      ((AOEProjectile)proj).doDamage();
      if(proj.getRad() > 150) { // 150 is the range.
        removingP.add(proj);
      }
    }
  }
  for(Projectile proj : removingP) {
    projectiles.remove(proj);
  }
  ArrayList<Enemy> removingE = new ArrayList<Enemy>();
  for(Enemy enemy : enemies) {
    if(enemy.isDead()) {
      removingE.add(enemy);
    }
  }
  for(Enemy enemy : removingE) {
    enemies.remove(enemy);
    if(enemy.isBoss()) {
      playerMoney += basicEnemyHP;
      playerScore += basicEnemyHP;
    } else {
      playerScore++;
      playerMoney++;
    }
  }
}

void shootTowers() {
  for(Tower tower : towers) {
    Projectile shooting = tower.shoot();
    if(shooting != null) {
      projectiles.add(shooting);
    }
  }
}

void moveProjectiles() {
  for(Projectile projectile : projectiles) {
    projectile.moveNext();
  }
}

void getMap(String fname) {
  /* This needs to accesss the file. using loadStrings();*/
  // will create chosenMapArray
}

void doButton(ButtonFn fn) {
  if(fn == null) {return;}
  switch(fn) {
    case PT_BASIC: placeBasicTower();
                            break;
    
    case PT_MACHINE: placeMachineTower();
                            break;
                            
    case PT_AOE: placeAOETower();
                            break;
                            
    case BACK_TO_MENU:      state = GameState.MENU;
                            whichMenu = CurrentMenu.TOP_MENU;
                            break;
                            
    case PLAY1:             chosenMapArray = new ArrayList<Float>() {{
                              add(0.0); add(225.0);
                              add(275.0); add(225.0);
                              add(275.0); add(675.0);
                              add(475.0); add(675.0);
                              add(475.0); add(425.0);
                              add(1075.0); add(425.0);
                              add(1075.0); add(700.0);
                            }};
                            state = GameState.LOADING;
                            playerHP = 15;
                            basicEnemyHP = 1;
                            playerMoney = 10;
                            break;
    
    case PLAY2:             chosenMapArray = new ArrayList<Float>() {{
                              add(125.0); add(0.0);
                              add(125.0); add(125.0);
                              add(1200.0); add(125.0);
                              add(1200.0); add(775.0);
                              add(1050.0); add(775.0);
                              add(1050.0); add(275.0);
                              add(900.0); add(275.0);
                              add(900.0); add(775.0);
                              add(750.0); add(775.0);
                              add(750.0); add(275.0);
                              add(125.0); add(275.0);
                              add(125.0); add(475.0);
                              add(425.0); add(475.0);
                              add(425.0); add(400.0);
                              add(600.0); add(400.0);
                              add(600.0); add(775.0);
                              add(425.0); add(775.0);
                              add(425.0); add(700.0);
                              add(200.0); add(700.0);
                            }};
                            state = GameState.LOADING;
                            playerHP = 20;
                            basicEnemyHP = 3;
                            playerMoney = 15;
                            break;
  }
}

void placeBasicTower() {
  if(holdingTower == null) { // If not placing a tower, set it so we're placing one
    holdingTower = new BasicTower(mouseX, mouseY, 150, color(255,0,0,100), color(52, 152, 219));
  } else { // if we're placing a tower, finalise placement.
    towers.add(new BasicTower(mouseX, mouseY, 150, color(142, 68, 173), color(52, 152, 219)));
    playerMoney -= holdingTower.getCost();
  }
}

void placeMachineTower() {
  if(holdingTower == null) { // If not placing a tower, set it so we're placing one
    holdingTower = new MachineGunTower(mouseX, mouseY, 100, color(255,0,0,100), color(52, 152, 219));
  } else { // if we're placing a tower, finalise placement.
    towers.add(new MachineGunTower(mouseX, mouseY, 100, color(26, 188, 156), color(52, 152, 219)));
    playerMoney -= holdingTower.getCost();
  }
}

void placeAOETower() {
  if(holdingTower == null) { // If not placing a tower, set it so we're placing one
    holdingTower = new AOETower(mouseX, mouseY, 150, color(255,0,0,100), color(52, 152, 219));
  } else { // if we're placing a tower, finalise placement.
    towers.add(new AOETower(mouseX, mouseY, 150, color(231, 76, 60), color(230, 126, 34)));
    playerMoney -= holdingTower.getCost();
  }
}

/**
 * Fills the mapPoints arraylist and the path arraydeque.
 */
void makeMapLines(ArrayList<Float> pathArray) {
  //mapPoints MapLines
  float xPrev = 0;
  float yPrev = 0;
  mapPoints = new ArrayList<MapLines>();
  path = new ArrayDeque<PVector>();
  
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

/**
 * Draws the mapLines in the mapPoints arraylist, and also draws the end point.
 */
void drawMap() {
  background(35,35,54);
  for(MapLines line : mapPoints) {
    line.drawLine();
  }
  ending.drawEnd();
}

/**
 * Spawns an enemy every 60 frames.
 */
void spawnEnemy() {
  if(frameCount % 60 == 0) {
    if(random(1) < 0.9){
      enemies.offer(new BasicEnemy(spawnLoc.x, spawnLoc.y, 2, basicEnemyHP, color(46, 204, 113), path.clone(), false));
    } else {
      enemies.offer(new BasicEnemy(spawnLoc.x, spawnLoc.y, 2, 2*basicEnemyHP, color(241, 196, 15), path.clone(), true));
    }
  }
  if(frameCount % 780 == 0) {
    basicEnemyHP++;
  }
}

/**
 * Moves the enemies one step towards their target location.
 */
void moveEnemies() {
  if(enemies.isEmpty()) {
    return;
  }
  for(Enemy enemy : enemies) {
    enemy.move();
  }
}

void checkEnd() {
  if(enemies.isEmpty()) {
    return;
  }
  if(enemies.peek().atEnd()) {
    enemies.poll();
    playerHP--;
    if(playerHP <= 0) {
      state = GameState.MENU;
      whichMenu = CurrentMenu.YOU_LOSE;
    }
  }
}

/**
 * Draws the enemies
 */
void drawEnemies() {
  if(enemies.isEmpty()) {
    return;
  }
  for(Enemy enemy : enemies) {
    enemy.drawEnemy();
  }
}

/**
 * Draw the towers
 */
void drawTowers() {
  if(towers.isEmpty()) {
    return;
  }
  for(Tower tower : towers) {
    tower.drawTower();
  }
}

/**
 * Draw the projectiles
 */
void drawProjectiles() {
  if(projectiles.isEmpty()) {
    return;
  }
  for(Projectile projectile : projectiles) {
    projectile.drawProjectile();
  }
}


/**
 * Draws everything.
 */
void drawAll() {
  drawMap();
  drawEnemies();
  drawProjectiles();
  drawTowers();
}