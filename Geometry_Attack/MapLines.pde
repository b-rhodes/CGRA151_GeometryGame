class MapLines {
  float x1, y1, x2, y2;
  float left, top, right, bottom;
  
  public MapLines(float x1, float y1, float x2, float y2) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    
    // Find xLeft/xRight
    left = ( (x1 < x2) ? x1 : x2) - 12.5;
    right = ( (x2 > x1) ? x2 : x1 ) + 12.5;
    
    // Find yTop/yBottom
    top = ( (y1 < y2) ? y1 : y2 ) - 12.5;
    bottom = ( (y2 > y1) ? y2 : y1 ) + 12.5;
  }
  
  void drawLine() {
    /*
    rectMode(CORNER);
    //noStroke();
    stroke(255);
    fill(225,225,225);
    rect(left, top, right, bottom);*/
    strokeWeight(50);
    stroke(225,225,225);
    line(x1,y1,x2,y2);
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
  
  boolean isOn(double x, double y, double rad) {
    if((x1-rad <= x && x <= x2+rad) || (x2-rad <= x && x <= x1+rad)) {
      if(y1-25-rad <= y && y <= y1+25+rad) {
        return true;
      }
      if(y2-25-rad <= y && y <= y2+25+rad) {
        return true;
      }
    }
    if((y1-rad <= y && y <= y2+rad) || (y2-rad <= y && y <= y1+rad)) {
      if(x1-25-rad <= x && x <= x1+25+rad) {
        return true;
      }
      if(x2-25-rad <= x && x <= x2+25+rad) {
        return true;
      }
    }
    
    return false;
  }
  
}