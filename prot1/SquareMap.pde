class SquareMap {
	int mapWidth;
	int mapHeight;
	float[][] matrix;
  int mLength;

  SquareMap(float[][] matrix) {
    this.matrix = new float[matrix.length][];
    for(int i=0; i<matrix[0].length; i++) {
      this.matrix[i] = matrix[i];
    }
    this.mLength = matrix.length;
    this.mapWidth = 60;
    this.mapHeight = 60;
  }

  void drawMap(PVector pos) {
    float[][] auxMatrix = new float[mLength][];
    float[] maioresValoresX = new float[mLength];
    float[] maioresValoresY = new float[mLength];
    float constanteX, constanteY, decresceLog, comp = 0, altura = 0;

    for(int i=0; i<auxMatrix.length; i++) {
      auxMatrix[i] = new float[this.matrix[i].length];
      for(int j=0; j<auxMatrix[i].length; j++) {
        auxMatrix[i][j] = log(this.matrix[i][j]);
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

    fill(153);
    stroke(0);
    float acumulaX = 0;
    for (int i=0; i<mLength; i++) {
      float acumulaY = 0;
      for(int j=0; j<mLength; j++) {
        //rect(pos.x+acumulaY+((acumulaY+maioresValoresY[j]*constanteX)-(acumulaY+auxMatrix[i][j]*constanteX)), pos.y+acumulaX, auxMatrix[i][j]*constanteX, auxMatrix[i][j]*constanteY);
        rect(acumulaY, acumulaX, auxMatrix[i][j]*constanteX, auxMatrix[i][j]*constanteY);
        acumulaY += maioresValoresY[j]*constanteX;
      }
      acumulaX += maioresValoresX[i]*constanteY;
    }
    fill(106,78,19);
    stroke(106,78,19);


  }

}