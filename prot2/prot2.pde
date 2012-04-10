import de.bezier.data.sql.*;

MySQL db;

String host;
String database;
String user;
String pass;

ArrayList<Nivel1> nivel1List;
Matriz[][] superMatriz;

int numChave = 5;
int numPrefixos = 4;
int numEstudos = 14;

String linhasConfig[];

int hmw = 80, hmh = 80;

Global gl;

int squareSize = 1;
//color[] colors = {#FFD000, #FF9A00, #FF7B00, #FF4A00, #FF0000}; //heat
//color[] colors = {#E5FCC2, #9DE0AD, #45ADA8, #547980, #594F4F}; // green1
//color[] colors = {#FFF5BC, #D6EDBD, #B8D9B8, #7FA6A1, #5D7370, #D8D8D8, #CECECE}; // green2
color[] colors = {#E1F5C4, #EDE574, #F9D423, #FC913A, #FF4E50, #D8D8D8, #C1C1C1}; // heat-greenish

void setup() {
  size(1280, 720);
  smooth();
  background(colors[6]);

  linhasConfig = loadStrings("mysql_settings.txt");
  host = linhasConfig[0]; database = linhasConfig[1]; user = linhasConfig[2]; pass = linhasConfig[3];
  db = new MySQL(this, host, database, user, pass);

  gl = new Global();

  superMatriz = new Matriz[numPrefixos][numEstudos];
  preencheListaNivel1();
  preencheSuperMatriz();
  //preencheSuperMatrizHeatSquareList();
  //print(superMatriz[3][1].quadrados[4][0].numElementos + "\n");
  
  //drawSuperMatrizHeatMap(); 
  drawSuperMatrizSquareMap();

}

void preencheListaNivel1() {
  if(db.connect()) {
    print("Conectou\n");
    nivel1List = new ArrayList<Nivel1>();
    String selQuery = "select ver_estudo, prefixo, subidas, descidas, count " +
                      "from nivel1 " +
                      "order by ver_estudo, prefixo, subidas, descidas";
    db.query(selQuery);
    while(db.next()) {
      Nivel1 nivel1 = new Nivel1(db.getInt("ver_estudo"), 
                                 db.getInt("prefixo"), 
                                 db.getInt("subidas"), 
                                 db.getInt("descidas"), 
                                 db.getInt("count"));
      nivel1List.add(nivel1);
    }
  }
}

void preencheSuperMatriz() {
  int count = 0;
  for(int i1=0; i1<numEstudos; i1++) {
    for(int i2=numPrefixos-1; i2>=0; i2--) {
      superMatriz[i2][i1] = new Matriz( 30+(hmw+5)*i1, 
                                        height-180-(hmh+15)*(numPrefixos-1-i2), 
                                        hmw, 
                                        hmh);
      for(int i3=numChave-1; i3>=0; i3--) {
        for(int i4=0; i4<numChave; i4++) {
          if((i4>i2+1) || (i3<numChave-i2-2)) {
          }
          else {
            superMatriz[i2][i1].quadrados[i3][i4] = nivel1List.get(count);
            //print("SM: " + i2 + "-" + i1 + " Q: " + i3 + "-" + i4 + " Value: " + nivel1List.get(count).numElementos + "\n");
            count++;
          }
        }
      }
      int mv = superMatriz[i2][i1].identificaMaiorValor();
      int smv = superMatriz[i2][i1].identificaSegundoMaiorValor();
      if(gl.maiorValor < mv) gl.maiorValor = mv;
      if(gl.segundoMaiorValor < smv) gl.segundoMaiorValor = smv;

      superMatriz[i2][i1].identificaMaioresValores();

      for(int i5=0; i5<numChave; i5++) {
        if(gl.maioresValoresX[i5] < superMatriz[i2][i1].maioresValoresX[i5])
          gl.maioresValoresX[i5] = superMatriz[i2][i1].maioresValoresX[i5];
        if(gl.maioresValoresY[i5] < superMatriz[i2][i1].maioresValoresY[i5])
          gl.maioresValoresY[i5] = superMatriz[i2][i1].maioresValoresY[i5];
      }
    }
  }
  print("MVG: " + gl.maiorValor + " SMVG: " + gl.segundoMaiorValor + "\n");
  for(int i=0; i<numChave; i++) {
    print("GX: " + gl.maioresValoresX[i] + " GY: " + gl.maioresValoresY[i] + "\n");
  }
}

void preencheSuperMatrizHeatSquareList() {
  for(int i=0; i<numEstudos; i++) {
    for(int j=numPrefixos-1; j>=0; j--) {
      superMatriz[j][i].preencheHeatSquareList(); 
    }
  }
}

void drawSuperMatrizHeatMap() {
  for(int i=0; i<numEstudos; i++) {
    for(int j=numPrefixos-1; j>=0; j--) {
      superMatriz[j][i].drawHeatMap();      
    }
  }
}

void drawSuperMatrizSquareMap() {
  for(int i=0; i<numEstudos; i++) {
    for(int j=numPrefixos-1; j>=0; j--) {
      superMatriz[j][i].drawSquareMap();
    }
  }
}

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

class Global {
  int maiorValor = 0;
  int segundoMaiorValor = 0;
  float[] maioresValoresX;
  float[] maioresValoresY;

  Global() {
    maioresValoresY = new float[numChave];
    maioresValoresX = new float[numChave];
    for(int i=0; i<numChave; i++) {
      maioresValoresY[i] = 0;
      maioresValoresX[i] = 0;
    }
  }
}
