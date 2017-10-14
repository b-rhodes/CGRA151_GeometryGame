/**
 * The generic projectile interface.
 * This will be used in arrays/queues etc (rather than specifying individual classes).
 */
interface Projectile {
  void move(double xTarget, double yTarget);
  double getX();
  double getY();
  double getRad();
  color getColour();
  Enemy getTarget();
  boolean isAOE();
  boolean isGeneric();
  boolean isHit(Enemy enemy);
  void drawProjectile();
  // May need a doEffect() method, but not yet.
}

/**
 * This should be the most "Generic" form of projectile. It will define regular things, but speed and the default
 * sprite for bullets.
 */
abstract class ProjectileAbstract implements Projectile{
  float x;
  float y;
  float rad;
  color colour;
  boolean isAOE;
  boolean isGeneric;
  Enemy target;
  
  public ProjectileAbstract(float x, float y, float rad, color colour, Enemy target) {
    this.x = x;
    this.y = y;
    this.rad = rad;
    this.colour = colour;
    this.target = target;
    isGeneric = true;
    isAOE = false;
  }
  
  void move(double dx, double dy) {
    x += dx;
    y += dy;
  }
  
  double getX() {
    return x;
  }
  
  double getY() {
    return y;
  }
  
  double getRad() {
    return rad;
  }
  
  color getColour() {
    return colour;
  }
  
  Enemy getTarget() {
    return target;
  }
  
  boolean isAOE() {
    return isAOE;
  }
  
  boolean isGeneric() {
    return isGeneric;
  }
  
  boolean isHit(Enemy enemy) {
    // "isGeneric" just means you can compare the distance between them, and rad1 + rad2 to see if the projectile has hit.
    if(this.isGeneric() && enemy.isGeneric()) { 
      double distance = (double)sqrt( sq((float)( this.getX() - enemy.getX() )) + sq(((float)( this.getY() - enemy.getY() ))) ); // sqrt(xDist^2 + yDist^2)
      double minDist = this.getRad() +  enemy.getRad();
      if(minDist > distance) {
        return true;
      } else {
        return false;
      }
    }
  }
  
  void drawProjectile() {
    // The generic projectile will be a circle with a triangle pointing away from it, like the tail of a comet.
    noStroke();
    fill(this.getColour());
    ellipse((float)this.getX(), (float)this.getY(), rad, rad);
    PVector dir = new PVector(abs(this.getX() - target.getX()), abs(this.getY - target.getY));
    PVector loc = new PVector((float)this.getX(), (float)this.getY());
    float angle = dir.heading();
    PVector v = new PVector(rad*cos(angle),rad*sin(angle)); // This is the "base" points of the triangle
    PVector base1 = new PVector(0,0);
    base1.add(loc);
    base1.add(v);
    PVector base2 = new PVector(0,0);
    base2.add(loc);
    base2.sub(v);
    PVector base3 = new PVector(0,0);
    base3.sub(loc);
    base3.limit((float)(2*rad));
    base3.add(loc);
    triangle(base1.x, base1.y, base2.x, base2.y, base3.x, base3.y);
  }
}

/**
 * The default projectile (test towers, and the basic ones, will use this).
 */
class BasicProjectile extends ProjectileAbstract{
  
  public BasicProjectile(float x, float y, color colour, Enemy target) {
    this.x = x;
    this.y = y;
    this.colour = colour;
    this.target = target;
    isGeneric = true;
    isAOE = false;
    rad = 5;
  }
  
}