class EndPoint {

  float x, y;
  
  public EndPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void drawEnd() {
    rectMode(CENTER);
    noStroke();
    fill(225,225,225);
    rect(x,y,200,200,30);
    fill(224,34,34);
    rect(x,y,100,100,15);
  }
  
  boolean isOn(double xT, double yT, double rad) {
    return (y-100-rad < yT && yT < y+100+rad && x-100-rad < xT && xT < x+100+rad);
  }
  
}