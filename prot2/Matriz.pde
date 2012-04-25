class Matriz {
  Nivel1[][] quadrados;
  int x, y, w, h;  
  ArrayList<HeatSquare> heatSquareList;
  ArrayList<SquareMap> squareMapList;
  int maiorValor = 0, segundoMaiorValor = 0;
  boolean exibeLog = false, exibe00 = false, mvg=false;
  boolean grown = false;
  Nivel1 quadradoFocado = null;
  int quadradoFocadoI, quadradoFocadoJ;
  int numTotalElementos;

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
    this.squareMapList      = new ArrayList<SquareMap>();
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
      maioresValoresX[i] = maioresValoresX[i]*2;
      maioresValoresY[i] = maioresValoresY[i]*2;
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
      maioresValoresXE00[i] = maioresValoresXE00[i]*2;
      maioresValoresYE00[i] = maioresValoresYE00[i]*2;
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

  void identificaNumTotalElementos() {
    this.numTotalElementos = 0;
    for(int i=0; i<numChave; i++) {
      for(int j=0; j<numChave; j++) {
        if(this.quadrados[i][j] != null) {
          if(i == numChave-1 && j == 0) {
            if(this.exibe00) {
              this.numTotalElementos += this.quadrados[i][j].numElementos;
            }
          } else this.numTotalElementos += this.quadrados[i][j].numElementos;
        }
      }
    }
  }

  void drawSquareMap() {
    this.squareMapList = new ArrayList<SquareMap>();
    float[] maioresValoresLocaisY = new float[numChave];
    float[] maioresValoresLocaisX = new float[numChave];
    int countNulls = 0;

    for(int i=0; i<numChave; i++) {
      if(exibe00) {
        maioresValoresLocaisX[i] = this.mvg ? gl.maioresValoresX[i] : this.maioresValoresX[i];
        maioresValoresLocaisY[i] = this.mvg ? gl.maioresValoresY[i] : this.maioresValoresY[i];
      } else {
        maioresValoresLocaisX[i] = this.mvg ? gl.maioresValoresXE00[i] : this.maioresValoresXE00[i];
        maioresValoresLocaisY[i] = this.mvg ? gl.maioresValoresYE00[i] : this.maioresValoresYE00[i];
      }

      if(this.exibeLog) {
        if(maioresValoresLocaisX[i] != 0.0) maioresValoresLocaisX[i] = log(maioresValoresLocaisX[i]);
        if(maioresValoresLocaisY[i] != 0.0) maioresValoresLocaisY[i] = log(maioresValoresLocaisY[i]);
      }

      // Preenche fantasmas
      if(maioresValoresLocaisY[i] == 0.0) maioresValoresLocaisY[i] = 1.5;
      if(maioresValoresLocaisX[i] == 0.0) maioresValoresLocaisX[i] = 1.5;

      // Contando os inválidos
      if(this.quadrados[numChave-1][i] == null) countNulls++;
    }

    // Desenha quadrado
    fill(cInvalidos);
    noStroke();
    rect(x, y, w, h);

    // Desenha regiao valida
    fill(cValidos);
    float regiaoInvalidaUnidade = 10;
    int novoW = countNulls == 0 ? w : (int) (w - countNulls*(w/(regiaoInvalidaUnidade)));
    int novoY = (int) (y+countNulls*(h/(regiaoInvalidaUnidade)));
    int novoH = (y+h) - novoY;
    rect(x, novoY, novoW, novoH);

    // Desenha limites regiao invalida
    stroke(255);
    for(int i=0; i<countNulls; i++) {
      line(x, y+i*(w/(regiaoInvalidaUnidade)), x+w, y+i*(w/(regiaoInvalidaUnidade)));
      line(x+novoW+i*(w/(regiaoInvalidaUnidade)), y, x+novoW+i*(w/(regiaoInvalidaUnidade)), y+h);
    }


    // Calcula fator de compensação
    float constanteX, constanteY, comp = 0, altura = 0;
    for(int i=0; i<numChave-countNulls; i++) {
      comp    += maioresValoresLocaisY[i];
      altura  += maioresValoresLocaisX[numChave-i-1];
    }
    constanteY = (true) ? novoH/altura : h/altura;
    constanteX = (true) ? novoW/comp : w/altura;

    for(int i=numChave-1; i>=countNulls; i--) {
      float acumulaX = 0;
      for(int k=countNulls; k<i; k++) acumulaX += maioresValoresLocaisX[k];
      acumulaX *= constanteY;
      float acumulaY = 0;
      for(int j=0; j<numChave-countNulls; j++) {
        if(!exibe00 && i==numChave-1 && j==0){
        } else {
          if(quadrados[i][j] != null ) {
            float numElementosAtual = pow(quadrados[i][j].numElementos, 0.5);
            numElementosAtual = numElementosAtual*2;
            if(this.exibeLog) numElementosAtual = log(numElementosAtual);
            if(numElementosAtual != 0.0) {
              float smx = x+acumulaY+((acumulaY+maioresValoresLocaisY[j]*constanteX)-(acumulaY+numElementosAtual*constanteX));
              float smy = novoY+acumulaX;
              float smw = numElementosAtual*constanteX;
              float smh = numElementosAtual*constanteY;
              SquareMap sm = new SquareMap(smx, smy, smw, smh, i, j);
              squareMapList.add(sm);
              sm.draw();
              if(quadradoFocado != null && 
                 i == quadradoFocadoI && 
                 j == quadradoFocadoJ && 
                 !(i == 4 && j == 0)) {
                fill(255,100);
                rect(smx-1, smy, smw+1, smh);
                strokeWeight(1);
              }
            }
          }
        }
        acumulaY += maioresValoresLocaisY[j]*constanteX;
        stroke(255);
        line(x+acumulaY, y, x+acumulaY, y+h);
        // Draw horizontal axis
        if(i == numChave-1 && grown) {
          textFont(font, 12);
          fill(cHistogramText);
          textAlign(CENTER);
          text(j, x+acumulaY-(maioresValoresLocaisY[j]*constanteX)/2, y-7);
          textAlign(LEFT);
        }
      }
      stroke(255);
      line(x, novoY+acumulaX, x+w, novoY+acumulaX);
      // Draw vertical axis
      if(grown) {
        textFont(font, 12);
        fill(cHistogramText);
        textAlign(CENTER);
        text(numChave-i-1, x-10, novoY+4+acumulaX+(maioresValoresLocaisX[i]*constanteY)/2);
        resetMatrix();
        textAlign(LEFT);
      }
    }
    if(grown) {
      drawMatrixInfoSM();
      drawMatrixAxesSM();
    }
  }

  void identificaQuadradoFocadoSM() {
    for(int i=squareMapList.size()-1; i>=0; i--) {
      if(squareMapList.get(i).mouseOver() ) {
        quadradoFocadoI = squareMapList.get(i).matI;
        quadradoFocadoJ = squareMapList.get(i).matJ;
        if(!(quadradoFocadoI == 4 && quadradoFocadoJ == 0))
          quadradoFocado = quadrados[quadradoFocadoI][quadradoFocadoJ];
        quadradoFocado.limpaNivel2MudancaProteinaDetalhe();
      }
    }
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
            // Multiplica log por 2 para evitar log(1)
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
        if(heatSquareList.get(hsmCount).mouseOver() && !(i == 4 && j == 0)) {
          quadradoFocado = quadrados[i][j];
          quadradoFocadoI = i;
          quadradoFocadoJ = j;
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
        this.heatSquareList.get(hsmCount++).draw2();
        noFill();   
        if(quadradoFocado != null && 
           quadradoFocadoI == i && 
          quadradoFocadoJ == j && 
          !(i == 4 && j == 0)) {
          fill(255,100);
          rect(w/5*j+this.x+1, h/5*i+this.y+1, w/5-1, h/5-1);
          strokeWeight(1);
        }
        stroke(255);
        rect(w/5*j+this.x, h/5*i+this.y, w/5, h/5);
      }
    }
    if(grown) {
      drawMatrixInfoHM();
      drawMatrixAxesHM();
    }
  }

  void drawMatrixAxesHM() {
    textFont(font, 12);
    fill(cHistogramText);
    textAlign(CENTER);
    text("0", x+0*(w/numChave)+(w/numChave/2), y-7);
    text("1", x+1*(w/numChave)+(w/numChave/2), y-7);
    text("2", x+2*(w/numChave)+(w/numChave/2), y-7);
    text("3", x+3*(w/numChave)+(w/numChave/2), y-7);
    text("4", x+4*(w/numChave)+(w/numChave/2), y-7);
    text("Specialization", x+(w/2), y-20);
    text("4", x-10, y+0*(h/numChave)+(h/numChave/2));
    text("3", x-10, y+1*(h/numChave)+(h/numChave/2));
    text("2", x-10, y+2*(h/numChave)+(h/numChave/2));
    text("1", x-10, y+3*(h/numChave)+(h/numChave/2));
    text("0", x-10, y+4*(h/numChave)+(h/numChave/2));
    translate(x-20, y+(h/2));
    rotate(3*PI/2);
    text("Generalization", 0, 0);
    rotate(PI/2);
    resetMatrix();
    textAlign(LEFT);
  }

  void drawMatrixAxesSM() {
    textFont(font, 12);
    fill(cHistogramText);
    textAlign(CENTER);    
    text("Specialization", x+(w/2), y-20);
    translate(x-20, y+(h/2));
    rotate(3*PI/2);
    text("Generalization", 0, 0);
    rotate(PI/2);
    resetMatrix();
    textAlign(LEFT);
  }

  void drawMatrixInfo() {    
    textFont(font, 14);
    fill(cHistogramText);
    String info = "Release: " + (quadrados[4][0].ver_estudo-1) + "-" + (quadrados[4][0].ver_estudo);
    info += ", Prefix: " + (quadrados[4][0].prefixo);
    info += ", Number of proteins: " + numTotalElementos;
    text(info, x, (height/5+13)); // y de acordo com drawhistogram
    // text("Release: " + (quadrados[4][0].ver_estudo-1) + "-" + (quadrados[4][0].ver_estudo), x+2, y-70);
    // text("Prefix: " + (quadrados[4][0].prefixo), x+2, y-55);
    // text("Number of proteins: " + numTotalElementos, x+2, y-40);
  }

  void drawRegionsInfo() {
    fill(cHistogramText);
    textFont(font, 11);
    int textX = x+w/2+40;
    text("No changes", textX, y+h+20);
    text("Invalid Region", textX, y+h+32);
    int rectW = 50;
    int rectH = 12;
    int rectX = x+w-rectW-2;
    noStroke();
    fill(cValidos);
    rect(rectX, y+h+10, rectW, rectH);
    fill(cInvalidos);
    rect(rectX, y+h+22, rectW, rectH);
  }

  void drawMatrixInfoSM() {
    drawMatrixInfo();
    drawRegionsInfo();
    fill(cHistogramText);
    textFont(font, 11);
    int textX = x;
    text("Upper left entries", textX, y+h+20);
    text("Diagonal entries", textX, y+h+32);
    text("Lower right entries", textX, y+h+44);
    int rectW = 50;
    int rectH = 12;
    int rectX = x+120;
    noStroke();
    fill(cPallete2[0]);
    rect(rectX, y+h+10, rectW, rectH);
    fill(cPallete2[1]);
    rect(rectX, y+h+22, rectW, rectH);
    fill(cPallete2[2]);
    rect(rectX, y+h+34, rectW, rectH);
  }

  void drawMatrixInfoHM() {
    drawMatrixInfo();
    drawRegionsInfo();
    noStroke();
    int sw = 40, sh = 20;
    int legendX = x+2;
    textFont(font, 11);
    textAlign(LEFT);
    fill(0);
    text("Number of changes", legendX, y+h+10);
    for(int i=0; i<cPallete.length; i++) {
      fill(cPallete[i]);
      rect(legendX+i*sw, y+h+16, sw, sh);
      if(i == 0) {
        textAlign(LEFT);
        fill(0);
        textFont(font, 11);
        text("1", legendX+6, y+h+30);
      }
      if(i == cPallete.length-1) {
        textAlign(RIGHT);
        fill(cBackground);
        textFont(font, 11);
        int num;
        if(exibe00) {
          num = mvg ? gl.maiorValor : maiorValor;
        } else {
          num = mvg ? gl.segundoMaiorValor : segundoMaiorValor;
        }
        text(num, legendX+(i+1)*sw-3, y+h+30);
      }
      textAlign(LEFT);
    }
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
    w = (int) (y*2.8);
    h = w;
    y += 55; // Move down
    grown = true;
  }
}
