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
          float numElementosRaiz = quadrados[j][i].numElementos > 0.0 
            ? pow(quadrados[j][i].numElementos, 0.5) : 0;
          if(maioresValoresY[i] < numElementosRaiz) {
            maioresValoresY[i] = numElementosRaiz;
          }
        }
        if(this.quadrados[i][j] != null) {
          float numElementosRaiz = quadrados[i][j].numElementos > 0.0 
            ? pow(quadrados[i][j].numElementos, 0.5) : 0;
          if(maioresValoresX[i] < numElementosRaiz) {
            maioresValoresX[i] = numElementosRaiz;
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

  void drawSquareMap() {
    float numElementos;
    float constanteX, constanteY, comp = 0, altura = 0;
    for(int i=0; i<numChave; i++) {
      comp    += log(gl.maioresValoresY[i]);
      altura  += log(gl.maioresValoresX[i]);
    }
    constanteY = h/altura;
    constanteX = w/comp;

    fill(colors[5]);
    rect(x, y, w, h);

    fill(12, 106, 17, 95);
    for(int i=numChave-1; i>=0; i--) {
      // Calcula o deslocamento na vertical
      float acumulaX = 0;
      for(int k=0; k<i; k++) {
        acumulaX += log(gl.maioresValoresX[k]);//*constanteY;
      }
      acumulaX *=constanteY;

      float acumulaY = 0;
      for(int j=0; j<numChave; j++) {        
        if(quadrados[i][j] != null ) {
          numElementos = log(pow(quadrados[i][j].numElementos, 0.5));
          if(numElementos != 0.0) {
            rect( x+acumulaY+((acumulaY+log(gl.maioresValoresY[j])*constanteX)-(acumulaY+numElementos*constanteX)),
                  y+acumulaX,
                  numElementos*constanteX, 
                  numElementos*constanteY);
          }
        }
        acumulaY += log(gl.maioresValoresY[j])*constanteX;
      }
    }
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
