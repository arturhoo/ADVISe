class SquareMap {
	int mapWidth;
	int mapHeight;
	float[][] matrix;
  float decresceLog = 1;
  int mLength;
  boolean drawn = false;
  PVector pos;

  SquareMap(float[][] matrix) {
    this.matrix = new float[matrix.length][];
    for(int i=0; i<matrix[0].length; i++) {
      this.matrix[i] = matrix[i];
    }
    this.mLength = matrix.length;
    this.mapWidth = 60;
    this.mapHeight = 60;
  }

  boolean mouseOver() {
    if((mouseX > pos.x && mouseX < pos.x+mapWidth) &&
        (mouseY > pos.y && mouseY < pos.y+mapHeight))
      return true;
    else return false;
  }

  void onMouseOverShowRealScale() {
    if(this.mouseOver() && decresceLog>0.01) decresceLog -= 0.01;
    if(decresceLog < 1) this.drawn = false;
    if(!this.mouseOver()) decresceLog = 1;
  }

  void drawMap(PVector pos) {
    this.drawn = true;
    this.pos = pos;
    float[][] auxMatrix = new float[mLength][];
    float[] maioresValoresX = new float[mLength];
    float[] maioresValoresY = new float[mLength];
    float constanteX, constanteY, comp = 0, altura = 0;

    onMouseOverShowRealScale();

    for(int i=0; i<auxMatrix.length; i++) {
      auxMatrix[i] = new float[this.matrix[i].length];
      for(int j=0; j<auxMatrix[i].length; j++) {
        auxMatrix[i][j] = matrix[i][j] + (log(matrix[i][j]) - matrix[i][j])*decresceLog;
        print(auxMatrix[i][j] + " ");
      }
      print("\n");
    }

    for(int i=0; i<mLength; i++) {
      maioresValoresY[i] = 0;
      maioresValoresX[i] = 0;
      for(int j=0; j<mLength; j++) {
        if(maioresValoresY[i] < auxMatrix[j][i]) {
          maioresValoresY[i] = auxMatrix[j][i];
        }
        if(maioresValoresX[i] < auxMatrix[i][j]) {
          maioresValoresX[i] = auxMatrix[i][j];
        }
      }
    }

    for(int i=0; i<mLength; i++) {
      comp    += maioresValoresY[i];
      altura  += maioresValoresX[i];
    }
    constanteY = mapHeight/altura;
    constanteX = mapWidth/comp;

    fill(255);
    stroke(0);
    rect(pos.x, pos.y, mapWidth, mapHeight);
    fill(153);
    float acumulaX = 0;
    for (int i=0; i<mLength; i++) {
      float acumulaY = 0;
      for(int j=0; j<mLength; j++) {
        rect(pos.x+acumulaY+((acumulaY+maioresValoresY[j]*constanteX)-(acumulaY+auxMatrix[i][j]*constanteX)), pos.y+acumulaX, auxMatrix[i][j]*constanteX, auxMatrix[i][j]*constanteY);
        //rect(pos.x+acumulaY, pos.y+acumulaX, auxMatrix[i][j]*constanteX, auxMatrix[i][j]*constanteY);
        acumulaY += maioresValoresY[j]*constanteX;
      }
      acumulaX += maioresValoresX[i]*constanteY;
    }
    fill(106,78,19);
    stroke(106,78,19);
  }

}