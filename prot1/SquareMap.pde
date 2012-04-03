class SquareMap {
	int mapWidth;
	int mapHeight;
	float[][] matrix;
  float decresceLog = 0.85;
  int mLength;
  boolean drawn = false;
  PVector pos;
  float[] maioresValoresX;
  float[] maioresValoresY;
  float[][] auxMatrix;

  SquareMap(float[][] matrix) {
    this.matrix = new float[matrix.length][];
    for(int i=0; i<matrix[0].length; i++) {
      this.matrix[i] = matrix[i];
    }
    this.mLength = matrix.length;
    this.mapWidth = 60;
    this.mapHeight = 60;
    this.maioresValoresX = new float[mLength];
    this.maioresValoresY = new float[mLength];
    this.auxMatrix = new float[mLength][];
    setAuxMatrix();
    setMaxValues();
  }

  void setAuxMatrix() {
    for(int i=0; i<this.auxMatrix.length; i++) {
      auxMatrix[i] = new float[this.matrix[i].length];
      for(int j=0; j<auxMatrix[i].length; j++) {
        auxMatrix[i][j] = this.matrix[i][j] + (log(this.matrix[i][j]) - this.matrix[i][j])*decresceLog;
        print(auxMatrix[i][j] + " ");
        float falso = 1.0;
        if(i==4 && j==0) auxMatrix[i][j] = -1;
      }
      print("\n");
    }
  }

  void setMaxValues() {
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
  }

  boolean mouseOver() {
    if((mouseX > pos.x && mouseX < pos.x+mapWidth) &&
        (mouseY > pos.y && mouseY < pos.y+mapHeight))
      return true;
    else return false;
  }

  void onMouseOverShowRealScale() {
    if(this.mouseOver() && decresceLog>0.01) decresceLog -= 0.01;
    if(decresceLog < 1) {
      this.drawn = false;
      if(!this.mouseOver()) decresceLog += 0.01;
    }
    //if(!this.mouseOver()) decresceLog = 1;
  }

  void drawMap(PVector pos) {
    //this.drawn = true;
    this.pos = pos;
    float constanteX, constanteY, comp = 0, altura = 0;
    onMouseOverShowRealScale();    

    for(int i=0; i<mLength; i++) {
      comp    += maioresValoresY[i];
      altura  += maioresValoresX[i];
    }
    constanteY = mapHeight/altura;
    constanteX = mapWidth/comp;

    fill(200);
    stroke(0);
    rect(pos.x, pos.y, mapWidth, mapHeight);
    fill(12, 106, 17, 95);
    float acumulaX = 0;
    for (int i=0; i<mLength; i++) {
      float acumulaY = 0;
      for(int j=0; j<mLength; j++) {
        // Alinha no canto superior direito
        rect(pos.x+acumulaY+((acumulaY+maioresValoresY[j]*constanteX)-(acumulaY+auxMatrix[i][j]*constanteX)), pos.y+acumulaX, auxMatrix[i][j]*constanteX, auxMatrix[i][j]*constanteY);
        // Alinha no canto superior esquerdo
        //rect(pos.x+acumulaY, pos.y+acumulaX, auxMatrix[i][j]*constanteX, auxMatrix[i][j]*constanteY);
        acumulaY += maioresValoresY[j]*constanteX;
      }
      acumulaX += maioresValoresX[i]*constanteY;
    }
    fill(106,78,19);
    stroke(106,78,19);
  }

}