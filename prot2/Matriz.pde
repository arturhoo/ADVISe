class Matriz {
  Nivel1[][] quadrados;
  int x, y, w, h;  
  ArrayList<HeatSquare> heatSquareList;
  int maiorValor = 0, segundoMaiorValor = 0;
  boolean exibeLog = false, exibe00 = false, mvg=false;
  boolean grown = false;
  Nivel1 quadradoFocado = null;

  float[] maioresValoresX;
  float[] maioresValoresY;
  float[] maioresValoresXE00;
  float[] maioresValoresYE00;

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
    this.heatSquareList     = new ArrayList<HeatSquare>();
    this.maioresValoresX    = new float[numChave];
    this.maioresValoresY    = new float[numChave];
    this.maioresValoresXE00 = new float[numChave];
    this.maioresValoresYE00 = new float[numChave];
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

  void identificaMaioresValoresExceto00() {
    for(int i=0; i<numChave; i++) {
      maioresValoresYE00[i] = 0;
      maioresValoresXE00[i] = 0;
      for(int j=0; j<numChave; j++) {
        if(this.quadrados[j][i] != null && !(j==numChave-1 && i==0)) {
          float numElementosRaiz = quadrados[j][i].numElementos > 0.0 
            ? pow(quadrados[j][i].numElementos, 0.5) : 0;
          if(maioresValoresYE00[i] < numElementosRaiz) {
            maioresValoresYE00[i] = numElementosRaiz;
          }
        }
        if(this.quadrados[i][j] != null && !(i==numChave-1 && j==0)) {
          float numElementosRaiz = quadrados[i][j].numElementos > 0.0 
            ? pow(quadrados[i][j].numElementos, 0.5) : 0;
          if(maioresValoresXE00[i] < numElementosRaiz) {
            maioresValoresXE00[i] = numElementosRaiz;
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
    // print("Maior valor: " + this.maiorValor + "\n");
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
    // print("Segundo Maior valor: " + this.segundoMaiorValor + "\n");
    return this.segundoMaiorValor;
  }

  void drawSquareMap() {
    float numElementos;
    float[] maioresValoresLocaisY = new float[numChave];
    float[] maioresValoresLocaisX = new float[numChave];
    int countNulls = 0;

    // Toma conta das variaveis booleanas
    for(int i=0; i<numChave; i++) {
      if(exibe00) {
        maioresValoresLocaisX[i] = this.mvg ? gl.maioresValoresX[i] : this.maioresValoresX[i];
        maioresValoresLocaisY[i] = this.mvg ? gl.maioresValoresY[i] : this.maioresValoresY[i];
        
        if(this.quadrados[numChave-1][i] == null) {
          maioresValoresLocaisX[numChave-1-i] = log(gl.maioresValoresX[i]);
          maioresValoresLocaisY[i] = log(gl.maioresValoresY[i]);
          countNulls++;
        }
      } else {
        maioresValoresLocaisX[i] = this.mvg ? gl.maioresValoresXE00[i] : this.maioresValoresXE00[i];
        maioresValoresLocaisY[i] = this.mvg ? gl.maioresValoresYE00[i] : this.maioresValoresYE00[i];
        
        if(this.quadrados[numChave-1][i] == null) {
          maioresValoresLocaisX[numChave-1-i] = log(gl.maioresValoresXE00[i]);
          maioresValoresLocaisY[i] = log(gl.maioresValoresYE00[i]);
          countNulls++;
        }
      }

      if(this.exibeLog) {
        if(maioresValoresLocaisX[i] != 0.0) maioresValoresLocaisX[i] = log(maioresValoresLocaisX[i]);
        // else maioresValoresLocaisX[i] = log(gl.maioresValoresX[i]);
        if(maioresValoresLocaisY[i] != 0.0) maioresValoresLocaisY[i] = log(maioresValoresLocaisY[i]);
        // else maioresValoresLocaisY[i] = log(gl.maioresValoresY[i]);
      }
    }

    // Calcula fator de compensação
    float constanteX, constanteY, comp = 0, altura = 0;
    for(int i=0; i<numChave; i++) {
      comp    += maioresValoresLocaisY[i];
      altura  += maioresValoresLocaisX[i];
    }
    constanteY = h/altura;
    constanteX = w/comp;

    // Desenha quadrado
    fill(cValidos);
    stroke(0);
    rect(x, y, w, h);

    // Desenha regiao invalida
    if(countNulls !=0 ) {
      float acumulaX1 = 0, acumulaY1 = 0;
      for(int i=0; i<countNulls; i++) {
        acumulaX1 += maioresValoresLocaisX[i];
      }
      for(int i=0; i<numChave-countNulls; i++) {
        acumulaY1 += maioresValoresLocaisY[i];
      }
      fill(cInvalidos);
      noStroke();
      rect(x+1, y+1, w-1, acumulaX1*constanteY-2);
      rect( acumulaY1*constanteX+x+1, 
            y+acumulaX1*constanteY-2, 
            x+w-(acumulaY1*constanteX+x+1), 
            y+h-(y+acumulaX1*constanteY));
    }

    // Desenha os squaremaps
    for(int i=numChave-1; i>=0; i--) {
      // Calcula o deslocamento na vertical
      float acumulaX = 0;
      for(int k=0; k<i; k++) {
        acumulaX += maioresValoresLocaisX[k];
      }
      acumulaX *=constanteY;
      float acumulaY = 0;
      for(int j=0; j<numChave; j++) {
        if(!exibe00 && i==numChave-1 && j==0){
        } else {
          if(quadrados[i][j] != null ) {
            numElementos = pow(quadrados[i][j].numElementos, 0.5);
            if(this.exibeLog) numElementos = log(numElementos);
            if(numElementos != 0.0) {
              fill(cPallete[4], 170);
              stroke(100);
              rectMode(CORNER);
              rect( x+acumulaY+((acumulaY+maioresValoresLocaisY[j]*constanteX)-(acumulaY+numElementos*constanteX)),
                    y+acumulaX,
                    numElementos*constanteX, 
                    numElementos*constanteY);
            }
          }
        }
        acumulaY += maioresValoresLocaisY[j]*constanteX;
      }  
    }

    if(grown) drawMatrixInfo();
    // for(int i=0; i<numChave; i++) {
    //   print("MVLX: " + maioresValoresLocaisX[i] + " -MVLY " + maioresValoresLocaisY[i] +"\n");
    // }
  }

  void preencheHeatSquareList() {
    float ratio, mv;
    this.heatSquareList = new ArrayList<HeatSquare>();

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
            if(exibeLog) ratio = log(this.quadrados[i][j].numElementos*2)/log(mv*2);
            else ratio = (float) this.quadrados[i][j].numElementos/mv;
          }
        }
        if(!exibe00 && i==4 && j==0) ratio = 0.0;
        HeatSquare hs = new HeatSquare( this.w/numChave*j+this.x,
                                        this.h/numChave*i+this.y,
                                        this.w/numChave,
                                        this.h/numChave,
                                        ratio);
        // print("HS: " + i + "-" + j + " ratio: " + ratio + "\n");
        heatSquareList.add(hs);
      }
    }
  }

  void identificaQuadradoFocadoHM() {
    int hsmCount = 0;
    for(int i=0; i<numChave; i++) {
      for(int j=0; j<numChave; j++) {
        if(heatSquareList.get(hsmCount).mouseOver()) {
          quadradoFocado = quadrados[i][j];
        }
        hsmCount++;
      }
    }
  }

  void drawHeatMap() {
    int hsmCount = 0;
    for(int i=0; i<numChave; i++) {
      for(int j=0; j<numChave; j++) {
        // if(heatSquareList.get(hsmCount).isIn()) quadradoFocado = heatSquareList.get(hsmCount);
        noStroke();
        //print("Imprimindo: " + i + "-" + j + " ratio: " + heatSquareList.get(hsmCount).ratio + "\n");
        this.heatSquareList.get(hsmCount++).draw();
        stroke(255);
        noFill();   
        rect(w/5*j+this.x, h/5*i+this.y, w/5, h/5);
      }
    }
    if(grown) {
      drawMatrixInfo();
      drawMatrixAxisHM();
    }
  }

  void drawMatrixAxisHM() {
    fill(cHistogramText);
    textAlign(CENTER);
    text("0", x+0*(w/numChave)+(w/numChave/2), y+h+10);
    text("1", x+1*(w/numChave)+(w/numChave/2), y+h+10);
    text("2", x+2*(w/numChave)+(w/numChave/2), y+h+10);
    text("3", x+3*(w/numChave)+(w/numChave/2), y+h+10);
    text("4", x+4*(w/numChave)+(w/numChave/2), y+h+10);
    text("Descidas", x+(w/2), y+h+20);
    text("4", x-10, y+0*(h/numChave)+(h/numChave/2));
    text("3", x-10, y+1*(h/numChave)+(h/numChave/2));
    text("2", x-10, y+2*(h/numChave)+(h/numChave/2));
    text("1", x-10, y+3*(h/numChave)+(h/numChave/2));
    text("0", x-10, y+4*(h/numChave)+(h/numChave/2));
    textAlign(LEFT);
  }

  void drawMatrixInfo() {
    fill(cHistogramText);
    text("Study: " + (quadrados[4][0].ver_estudo-1) + "->" + (quadrados[4][0].ver_estudo), x+2, y+h+50);
    text("Prefix: " + (quadrados[4][0].prefixo), x+2, y+h+65);
  }

  boolean mouseOver() {
    if((mouseX > x && mouseX < x+w) &&
        (mouseY > y && mouseY < y+h))
      return true;
    else return false;
  }

  void onMouseClickGrowBig() {
    x = 100;
    y = (int) (height/5);
    w = y*3;
    h = y*3;
    grown = true;
  }
}
