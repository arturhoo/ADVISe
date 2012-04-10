class Matriz {
  Nivel1[][] quadrados;
  int x, y, w, h;

  Matriz() {
    this.quadrados = new Nivel1[numChave][numChave];
    for(int i=0; i<numChave; i++) {
      for(int j=0; j<numChave; j++) {
        this.quadrados[i][j] = null;      
      }
    }
  }
}
