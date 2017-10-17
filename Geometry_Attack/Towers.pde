/**
 * The generic tower interface.
 * This will be used in arrays/queues etc (rather than specifying individual classes).
 */
interface Tower {
  double getX();
  double getY();
  void setX(float x);
  void setY(float y);
  double getRad();
  double getRange();
  color getColour();
  void setColour(color colour);
  color getProjectileColour();
  boolean isGeneric();
  Enemy getTarget();
  boolean newTarget();
  Projectile shoot();
  void drawTower();
  boolean validPlacement();
  void drawRange();
  int getCost();
}

/**
 * This should be the most "Generic" form of enemy. It will define regular things, but speed and the default sprite.
 */
abstract class TowerAbstract implements Tower {
  float x;
  float y;
  float rad;
  float range;
  float reloadTime;
  color colour;
  color projectileColour;
  boolean isGeneric;
  Enemy target;
  int rand;
  int cost;
  
  double getX() {
    return x;
  }
  
  double getY() {
    return y;
  }
  
  void setX(float x) {
    this.x = x;
  }
  
  void setY(float y) {
    this.y = y;
  }
  
  double getRad() {
    return rad;
  }
  
  double getRange() {
    return range;
  }
  
  color getColour() {
    return colour;
  }
  
  void setColour(color colour) {
    this.colour = colour;
  }
  
  color getProjectileColour() {
    return projectileColour;
  }
  
  boolean isGeneric() {
    return isGeneric;
  }
  
  int getCost() {
    return cost;
  }
  
  Enemy getTarget() {
    return target;
  }
  
  void drawTower() {
    noStroke();
    fill(colour);
    beginShape();
      vertex((float)(this.getX() + this.getRad()),(float)(this.getY()));
      vertex((float)(this.getX()), (float)(this.getY() + this.getRad()));
      vertex((float)(this.getX() - this.getRad()),(float)(this.getY()));
      vertex((float)(this.getX()),(float)(this.getY() - this.getRad()));
    endShape();
  }
  
  Projectile shoot() {
    if(target != null && inRange(target) && !target.isDead()) {
      return new BasicProjectile((float)this.getX(), (float)this.getY(), this.getProjectileColour(), this.getTarget());
    } else {
      if(newTarget()) {
        return shoot();
      }
    }
    return null;
  }
  
  boolean newTarget() {
    for(Enemy enemy : enemies) {
      if(inRange(enemy) && !enemy.isDead()) {
        target = enemy;
        return true;
      }
    }
    return false;
  }
  
  boolean inRange(Enemy enemy) {
    PVector dist = new PVector((float)(this.getX() - enemy.getX()), (float)(this.getY() - enemy.getY()));
    if(dist.mag() <= range) {
      return true;
    }
    return false;
  }
  
  boolean validPlacement() {
    for(Tower tower : towers) {
      float distance = (new PVector((float)this.getX() - (float)tower.getX(), (float)this.getY() - (float)tower.getY())).mag();
      if(distance < (this.getRad() + tower.getRad())) {
        return false;
      }
    }
    for(MapLines line : mapPoints) {
      if(line.isOn(getX(),getY(),getRad())) {
        return false;
      }
    }
    if(ending.isOn(getX(),getY(),getRad())) {
      return false;
    }
    if(playerMoney < cost) {
      return false;
    }
    // Maybe a cost thing.
    return true;
  }
  
  void drawRange() {
    fill(255,0,0,20);
    ellipse(x,y,2*range,2*range);
  }
}

class BasicTower extends TowerAbstract {
  public BasicTower(float x, float y, float range, color colour, color projectileColour) {
    this.x = x;
    this.y = y;
    this.rad = 35;
    this.reloadTime = 60;
    this.range = range;
    this.colour = colour;
    this.projectileColour = projectileColour;
    isGeneric = true;
    this.rand = int(random(0,60));
    this.cost = 5;
  }
  
  Projectile shoot() {
    if(!((frameCount+rand) % reloadTime == 0)) {
      return null;
    }
    if(target != null && inRange(target) && !target.isDead()) {
      return new BasicProjectile((float)this.getX(), (float)this.getY(), this.getProjectileColour(), this.getTarget());
    } else {
      if(newTarget()) {
        return shoot();
      }
    }
    return null;
  }
}

class MachineGunTower extends TowerAbstract {
  public MachineGunTower(float x, float y, float range, color colour, color projectileColour) {
    this.x = x;
    this.y = y;
    this.rad = 35;
    this.reloadTime = 10;
    this.range = range;
    this.colour = colour;
    this.projectileColour = projectileColour;
    isGeneric = true;
    this.rand = int(random(0,60));
    this.cost = 40;
  }
  
  Projectile shoot() {
    if(!((frameCount+rand) % reloadTime == 0)) {
      return null;
    }
    if(target != null && inRange(target) && !target.isDead()) {
      return new BasicProjectile((float)this.getX(), (float)this.getY(), this.getProjectileColour(), this.getTarget());
    } else {
      if(newTarget()) {
        return shoot();
      }
    }
    return null;
  }
}

class AOETower extends TowerAbstract {
  public AOETower(float x, float y, float range, color colour, color projectileColour) {
    this.x = x;
    this.y = y;
    this.rad = 35;
    this.reloadTime = 70;
    this.range = range;
    this.colour = colour;
    this.projectileColour = projectileColour;
    isGeneric = true;
    this.rand = int(random(0,60));
    this.cost = 25;
  }
  
  Projectile shoot() {
    if(!((frameCount+rand) % reloadTime == 0)) {
      return null;
    }
    return new AOEProjectile((float)this.getX(), (float)this.getY(), this.getProjectileColour());
  }
}