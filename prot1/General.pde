int getIntFromEcPosition(String ec, int pos) {
  int prev_pos = 0;
  int ccursor = 0;
  int counter = 0;
  String ec_mod = ec + ".";
  while(true) {
    if(ec_mod.charAt(ccursor) == '.') {
      if(counter == pos) {
        String ssubstring = "" + ec_mod.substring(prev_pos, ccursor);
        if(ssubstring.equals("-")) return -1;
        else return Integer.parseInt(ssubstring);
      }
      prev_pos = ccursor+1;
      counter++;      
    }
    ccursor++;
  }
}

void createSquareMapList() {
  int tt = 5;

  squareMapListP1 = new ArrayList<SquareMap>();
  squareMapListP2 = new ArrayList<SquareMap>();
  squareMapListP3 = new ArrayList<SquareMap>();
  squareMapListP4 = new ArrayList<SquareMap>();

  float[] maioresValoresX = new float[5];
  float[] maioresValoresY = new float[5];

  for(int cc=0; cc<tt; cc++) {
    maioresValoresY[cc] = 0;
    maioresValoresX[cc] = 0;
  }

  int count = 0;
  // Through each version
  for(int i1=0; i1<numVersoes; i1++) {
    // Through each prefix
    for(int i2=tt-1; i2>=1; i2--) {
      // Create corresponding matrix of current version, prefix
      float[][] matrix = new float[i2+1][];
      // Build matrix
      for(int i=i2; i>=0; i--) {
        matrix[i] = new float[i2+1];
        for(int j=0; j<i2+1; j++) {
          // Get area value
          matrix[i][j] = nivel1List.get(count).numElementos > 0 
            ? pow(nivel1List.get(count).numElementos, 0.5) : 0;
          count++;
        }
      }
      SquareMap sm = new SquareMap(matrix);
      if(i2 == tt-1) squareMapListP1.add(sm);
      if(i2 == tt-2) squareMapListP2.add(sm);
      if(i2 == tt-3) squareMapListP3.add(sm);
      if(i2 == tt-4) squareMapListP4.add(sm);

      //while(nivel1List.get(count).ver_estudo < i1+3 && i1 != 13) count++;

      // Get general max values
      for(int c=0; c<i2+1; c++){
        if(sm.maioresValoresX[c] > maioresValoresX[c]) maioresValoresX[c] = sm.maioresValoresX[c];
        if(sm.maioresValoresY[c] > maioresValoresY[c]) maioresValoresY[c] = sm.maioresValoresY[c];
      }
    }   
  }
  
  for(int ii=0; ii<squareMapListP1.size(); ii++) {
    squareMapListP1.get(ii).maioresValoresX = maioresValoresX;
    squareMapListP1.get(ii).maioresValoresY = maioresValoresY;
    squareMapListP2.get(ii).maioresValoresX = maioresValoresX;
    squareMapListP2.get(ii).maioresValoresY = maioresValoresY;
    squareMapListP3.get(ii).maioresValoresX = maioresValoresX;
    squareMapListP3.get(ii).maioresValoresY = maioresValoresY;
    squareMapListP4.get(ii).maioresValoresX = maioresValoresX;
    squareMapListP4.get(ii).maioresValoresY = maioresValoresY;
  }
}
      
    
    
  
