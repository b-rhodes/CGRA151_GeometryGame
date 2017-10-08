class EndPoint {

  float x, y;
  
  public EndPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void drawThis() {
    rectMode(CENTER);
    noStroke();
    fill(225,225,225);
    rect(x,y,200,200);
    fill(224,34,34);
    rect(x,y,100,100);
  }
  
}