class Button {
  String ttext;
  PVector loc;
  int fontSize;
  PFont font;
  color ccolor;
  boolean active = false;  

  Button (String ttext, PVector loc, int fontSize) {
    this.ttext = ttext;
    this.fontSize = fontSize;
    this.loc = loc;
    this.ccolor = cButtonText;
    font = createFont("LucidaGrande", 24);
  }

  void draw(int align) {
    textFont(font, fontSize);
    if (align == 0) textAlign(CENTER);
    if (align == 1) textAlign(LEFT);
    if (this.isIn()) fill(cButtonMouseOver);
    else if (this.active) fill(cButtonActive);
    else fill(ccolor);
    text(this.ttext, loc.x, loc.y);
    textAlign(LEFT);
  }

  void draw(int align, int x, int y) {
    loc.x = x;
    loc.y = y;
    this.draw(align);
  }

  boolean isIn() {
    if ((mouseX > (loc.x - textWidth(ttext)/2)) && (mouseX  < (loc.x + textWidth(ttext)/2))) {
      if ((mouseY > loc.y - fontSize/2) && (mouseY < loc.y + fontSize/2)) return true;
    }
    return false;
  }

  
}
