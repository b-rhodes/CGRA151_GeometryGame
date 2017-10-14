/**
 * The generic enemy interface.
 * This will be used in arrays/queues etc (rather than specifying individual classes).
 */
interface Enemy {
  void move(double xTarget, double yTarget);
  double getX();
  double getY();
  double getRad();
  color getColour();
  boolean isGeneric();
  boolean isHit(Projectile proj);
  boolean atEnd();
  void drawEnemy();
  void doEnding();
}