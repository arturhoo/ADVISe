class HeatSquare {
  int x, y, w, h;
  float ratio;

  HeatSquare(int x, int y, int w, int h, float ratio) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    if(ratio == -1.0) this.ratio = -1.0;
    else {
      if(ratio == 0.0) this.ratio = 40.0;
      else {
        this.ratio = 30.0 - ratio*30.0;
        if(this.ratio < 1.0) this.ratio = 0.5 + ratio; // Deixa mais bonito
      }
    }
  }

  boolean mouseOver() {
    if((mouseX > x && mouseX < x+w) &&
        (mouseY > y && mouseY < y+h))
      return true;
    else return false;
  }

  void draw() {
    int numColors = numChave;
    float[] frac = {1.0-0.0256*ratio, 1.0-0.064*ratio, 1.0-0.16*ratio, 1.0-0.4*ratio};
    /*for(int i=0; i<numColors-1; i++) {
      frac[i] = frac[i]*=ratio;
    }*/

    for(int i=0; i<w; i+=squareSize) {
      for(int j=0; j<h; j+=squareSize) {
        fill(colors[0]);
        rect(x+i, y+j, squareSize, squareSize);
        int colorCounter = 1;
        for(int k=numColors-1; k>0; k--) {
          if(i<(w/2+(frac[colorCounter-1]*w/2)-0) && i>(w/2-(frac[colorCounter-1]*w/2)-0) &&
             j<(h/2+(frac[colorCounter-1]*h/2)-0) && j>(h/2-(frac[colorCounter-1]*h/2)-0) ) {
            // Cor dos invalidos
            if(this.ratio == -1.0) {
              fill(colors[5]);
            }
            else fill(colors[colorCounter++]);
            rect(x+i, y+j, squareSize, squareSize);
          }
        }
      }
    }
  }
}
