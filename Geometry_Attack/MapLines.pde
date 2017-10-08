class MapLines {
  float x1, y1, x2, y2;
  float left, top, right, bottom;
  
  public MapLines(float x1, float y1, float x2, float y2) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    
    // Find xLeft/xRight
    left = ( (x1 < x2) ? x1 : x2) - 25;
    right = ( (x2 > x1) ? x2 : x1 ) + 25;
    
    // Find yTop/yBottom
    top = ( (y1 < y2) ? y1 : y2 ) - 25;
    bottom = ( (y2 > y1) ? y2 : y1 ) + 25;
  }
  
  void drawLine() {
    rectMode(CORNER);
    noStroke();
    fill(225,225,225);
    rect(left, top, right, bottom);
  }
  
  float[] getP1() {
    float p1[] = {x1, y1};
    return p1;
  }
  
  float[] getP2() {
    float p2[] = {x2, y2};
    return p2;
  }
  
  float getLeft() {return left;}
  float getRight() {return right;}
  float getTop() {return top;}
  float getBottom() {return bottom;}
  
}