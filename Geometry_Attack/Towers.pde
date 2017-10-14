/**
 * The generic tower interface.
 * This will be used in arrays/queues etc (rather than specifying individual classes).
 */
interface Tower {
  double getX();
  double getY();
  double getRad();
  double getRange();
  color getColour();
  color getProjectileColour();
  boolean isGeneric();
  Enemy getTarget();
  boolean newTarget();
  Projectile shoot();
  void drawTower();
}

/**
 * This should be the most "Generic" form of enemy. It will define regular things, but speed and the default sprite.
 */
abstract class TowerAbstract implements Tower {
  float x;
  float y;
  float rad;
  float range;
  color colour;
  color projectileColour;
  boolean isGeneric;
  Enemy target;
  
  double getX() {
    return x;
  }
  
  double getY() {
    return y;
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
  
  color getProjectileColour() {
    return projectileColour;
  }
  
  boolean isGeneric() {
    return isGeneric;
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
      if(inRange(enemy)) {
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
}

class BasicTower extends TowerAbstract {
  public BasicTower(float x, float y, float range, color colour, color projectileColour) {
    this.x = x;
    this.y = y;
    this.range = range;
    this.colour = colour;
    this.projectileColour = projectileColour;
    isGeneric = true;
  }
}