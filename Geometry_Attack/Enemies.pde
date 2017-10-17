/**
 * The generic enemy interface.
 * This will be used in arrays/queues etc (rather than specifying individual classes).
 */
interface Enemy {
  void move();
  double getX();
  double getY();
  double getRad();
  int getHP();
  PVector getSpeed();
  color getColour();
  boolean isGeneric();
  boolean isHit(Projectile proj);
  boolean atEnd();
  boolean isDead();
  void drawEnemy();
  void takeDamage(int damage);
  boolean isBoss();
}

/**
 * This should be the most "Generic" form of enemy. It will define regular things, but speed and the default sprite.
 */
abstract class EnemyAbstract implements Enemy {
  float x;
  float y;
  float rad;
  int hp;
  PVector speed;
  color colour;
  boolean isGeneric;
  ArrayDeque<PVector> path;
  PVector targetPoint;
  boolean isBoss;
  
  /*
  public EnemyAbstract(double x, double y, double rad, double speed, color colour, ArrayDeque<PVector> path) {
    this.x = (float) x;
    this.y = (float) y;
    this.rad = (float) rad;
    this.colour = colour;
    this.path = path;
    this.isGeneric = true;
    this.targetPoint = this.path.poll();
    
    if(this.path.peek().x - x == 0) {
      this.speed = new PVector(0, (float)speed);
    } else if(this.path.peek().x - x == 0) {
      this.speed = new PVector((float)speed, 0);
    }
  }*/
  
  double getX() {
    return x;
  }
  
  double getY() {
    return y;
  }
  
  double getRad() {
    return rad;
  }
  
  int getHP() {
    return hp;
  }
  
  PVector getSpeed() {
    return speed;
  }
  
  color getColour() {
    return colour;
  }
  
  boolean isGeneric() {
    return isGeneric;
  }
  
  void drawEnemy() {
    noStroke();
    fill(colour);
    ellipse((float)this.getX(), (float)this.getY(), 2*rad, 2*rad);
  }
  
  boolean atEnd() {
    PVector end;
    if(!path.isEmpty()) {
      end = path.getLast();
    } else {
      end = targetPoint;
    }
    return ( abs((float)this.getX()-end.x) <= rad && abs((float)this.getY()-end.y) <= rad );
  }
  
  void move() {
    boolean atTarget = false;
    if(speed.x != 0) { // Moving left/right
      x += speed.x;
    } else if(speed.y != 0) { // Moving up/down
      y += speed.y;
    }
    
    // Check to see if we're at/past the target
    if(speed.x < 0 || speed.y < 0) {
      atTarget = this.getX() <= targetPoint.x && this.getY() <= targetPoint.y;
    } else {
      atTarget = this.getX() >= targetPoint.x && this.getY() >= targetPoint.y;
    }
    
    // If at the target point, set the new target, and the new speed.
    if(!path.isEmpty() && atTarget) {
      x = targetPoint.x;
      y = targetPoint.y;
      float v = abs((speed.x != 0) ? speed.x : speed.y);
      
      targetPoint = path.poll();
      speed = new PVector(targetPoint.x-(float)this.getX(), targetPoint.y-(float)this.getY());
      speed.limit(v);
    }
  }
  
  boolean isHit(Projectile proj) {
    // "isGeneric" just means you can compare the distance between them, and rad1 + rad2 to see if the projectile has hit.
    if(this.isGeneric() && proj.isGeneric()) { 
      double distance = (double)sqrt( sq((float)( this.getX() - proj.getX() )) + sq(((float)( this.getY() - proj.getY() ))) ); // sqrt(xDist^2 + yDist^2)
      double minDist = this.getRad() +  proj.getRad();
      if(minDist > distance) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
  
  boolean isDead() {
    return hp <= 0;
  }
  
  void takeDamage(int damage) {
    hp -= damage;
  }
  
  boolean isBoss() {
    return isBoss;
  }
}

/**
 * The default enemy (tests will use this).
 */
class BasicEnemy extends EnemyAbstract{
  
  public BasicEnemy(double x, double y, double speed, int hp, color colour, ArrayDeque<PVector> path, boolean isBoss) {
    this.x = (float) x;
    this.y = (float) y;
    this.hp = hp;
    this.rad = 15;
    this.colour = colour;
    this.path = path;
    this.isGeneric = true;
    this.targetPoint = this.path.poll();
    this.isBoss = isBoss;
    
    if(this.path.peek().x - x == 0) {
      this.speed = new PVector(0, (float)speed);
    } else if(this.path.peek().y - y == 0) {
      this.speed = new PVector((float)speed, 0);
    }
  }
  
}