class HeatSquare {
  int x, y, w, h;
  float ratio;

  HeatSquare(int x, int y, int w, int h, float ratio) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.ratio = ratio;
    // if(ratio == -1.0) this.ratio = -1.0;
    // else {
    //   if(ratio == 0.0) this.ratio = 40.0;
    //   else {
    //     this.ratio = 30.0 - ratio*30.0;
    //     if(this.ratio < 1.0) this.ratio = 0.5 + ratio; // Deixa mais bonito
    //   }
    // }
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
        // Cor fundo quadrado valido
        fill(cValidos);
        rect(x+i, y+j, squareSize, squareSize);
        int colorCounter = 1;
        for(int k=numColors-1; k>0; k--) {
          if(i<(w/2+(frac[colorCounter-1]*w/2)-0) && i>(w/2-(frac[colorCounter-1]*w/2)-0) &&
             j<(h/2+(frac[colorCounter-1]*h/2)-0) && j>(h/2-(frac[colorCounter-1]*h/2)-0) ) {
            // Cor dos invalidos
            if(this.ratio == -1.0) {
              fill(cInvalidos);
            }
            else fill(cPallete[colorCounter++]);
            rect(x+i, y+j, squareSize, squareSize);
          }
        }
      }
    }
  }

  void draw2() {
    fill(cValidos);
    if(ratio > 0.0 && ratio <= 0.2) fill(cPallete[0]);
    else if(ratio > 0.2 && ratio <= 0.4) fill(cPallete[1]);
    else if(ratio > 0.4 && ratio <= 0.6) fill(cPallete[2]);
    else if(ratio > 0.6 && ratio <= 0.8) fill(cPallete[3]);
    else if(ratio > 0.8 && ratio <= 1.0) fill(cPallete[4]);
    else if(ratio == -1.0) fill(cInvalidos);
    rect(x, y, w, h);
  }
}
