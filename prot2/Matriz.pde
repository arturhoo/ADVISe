class Matriz {
  Nivel1[][] quadrados;
  int x, y, w, h;  
  ArrayList<HeatSquare> heatSquareList;
  int maiorValor = 0, segundoMaiorValor = 0;
  boolean exibeLog = true, exibe00 = false, mvg=true;
  int original00 = -1;

  float[] maioresValoresX;
  float[] maioresValoresY;

  Matriz(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.quadrados = new Nivel1[numChave][numChave];
    for(int i=0; i<numChave; i++) {
      for(int j=0; j<numChave; j++) {
        this.quadrados[i][j] = null;      
      }
    }
    this.heatSquareList = new ArrayList<HeatSquare>();
    this.maioresValoresX = new float[numChave];
    this.maioresValoresY = new float[numChave];  
  }

  void identificaMaioresValores() {
    for(int i=0; i<numChave; i++) {
      maioresValoresY[i] = 0;
      maioresValoresX[i] = 0;
      for(int j=0; j<numChave; j++) {
        if(this.quadrados[j][i] != null) {
          if(maioresValoresY[i] < quadrados[j][i].numElementos) {
            maioresValoresY[i] = quadrados[j][i].numElementos;
          }
        }
        if(this.quadrados[i][j] != null) {
          if(maioresValoresX[i] < quadrados[i][j].numElementos) {
            maioresValoresX[i] = quadrados[i][j].numElementos;
          }
        }
      }
    }
  }

  int identificaMaiorValor() {
    for(int i=0; i<numChave; i++) {
      for(int j=0; j<numChave; j++) {
        if(this.quadrados[i][j] != null && 
            this.maiorValor < this.quadrados[i][j].numElementos) {
          this.maiorValor = this.quadrados[i][j].numElementos;
        }
      }
    }    
    print("Maior valor: " + this.maiorValor + "\n");
    return this.maiorValor;
  }
  
  int identificaSegundoMaiorValor() {
    for(int i=0; i<numChave; i++) {
      for(int j=0; j<numChave; j++) {
        if(this.quadrados[i][j] != null && 
            this.segundoMaiorValor < this.quadrados[i][j].numElementos &&
            this.quadrados[i][j].numElementos != this.maiorValor) {
          this.segundoMaiorValor = this.quadrados[i][j].numElementos;
        }
      }
    }
    print("Segundo Maior valor: " + this.segundoMaiorValor + "\n");
    return this.segundoMaiorValor;
  }

  void preencheHeatSquareList() {
    float ratio, mv;

    if(this.mvg) {
      if(this.exibe00) mv = gl.maiorValor;
      else mv = gl.segundoMaiorValor;
    } else {
      if(this.exibe00) mv = this.maiorValor;
      else mv = this.segundoMaiorValor;
    }

    for(int i=0; i<numChave; i++) {
      for(int j=0; j<numChave; j++) {
        if(this.quadrados[i][j] == null) {
          ratio = -1.0;
        }
        else {
          if(this.quadrados[i][j].numElementos == 0) ratio = 0.0;
          else {
            if(exibeLog) ratio = log(this.quadrados[i][j].numElementos)/log(mv);
            else ratio = (float) this.quadrados[i][j].numElementos/mv;
          }
        }
        if(!exibe00 && i==4 && j==0) ratio = 0.0;
        HeatSquare hs = new HeatSquare( this.w/numChave*j+this.x,
                                        this.h/numChave*i+this.y,
                                        this.w/numChave,
                                        this.h/numChave,
                                        ratio);
        print("HS: " + i + "-" + j + " ratio: " + ratio + "\n");
        heatSquareList.add(hs);
      }
    }
  }

  void drawHeatMap() {
    int hsmCount = 0;
    for(int i=0; i<numChave; i++) {
      for(int j=0; j<numChave; j++) {
        noStroke();
        print("Imprimindo: " + i + "-" + j + " ratio: " + heatSquareList.get(hsmCount).ratio + "\n");
        this.heatSquareList.get(hsmCount++).draw();
        stroke(120);
        noFill();   
        rect(w/5*j+this.x, h/5*i+this.y, w/5, h/5);
      }
    }
  }
}
