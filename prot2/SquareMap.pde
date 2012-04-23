class SquareMap {
  int x, y, w, h;
  int matI, matJ;
  color cFill;

  SquareMap(float x, float y, float w, float h, int matI, int matJ) {
    this.x    = (int) (x);
    this.y    = (int) (y);
    this.w    = (int) (w);
    this.h    = (int) (h);
    this.matI = matI;
    this.matJ = matJ;
    defineCor();
  }

  void defineCor() {
    if(this.matI == numChave-1-this.matJ) this.cFill = cAntidiagonal;
    else if(this.matI + this.matJ >= numChave) this.cFill = cSubAntidiagonal;
    else this.cFill = cSuperAntidiagonal;
  }

  boolean mouseOver() {
    if((mouseX > x && mouseX < x+w) &&
        (mouseY > y && mouseY < y+h))
      return true;
    else return false;
  }

  void draw() {
    fill(cFill);
    noStroke();
    rectMode(CORNER);
    rect(x, y, w, h);
  }
}
