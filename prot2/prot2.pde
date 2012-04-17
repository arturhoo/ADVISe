import de.bezier.data.sql.*;

MySQL db;

String host;
String database;
String user;
String pass;

String[] ecList = { "Undefined", "", "Oxidoreductase", "Transferase", "Hydrolase", 
                    "Lyase", "Isomerase", "Ligase"};
ArrayList<Nivel1> nivel1List;
Matriz[][] superMatriz;

int numChave = 5;
int numPrefixos = 4;
int numEstudos = 14;

Button  heatMapButton, squareMapButton,
        exibeLogButton, exibe00Button, mvgButton;
SparkLine sl;
Global gl;

String linhasConfig[];

boolean alreadyDrawn = false;

int hmw = 80, hmh = 80;

PFont font;

Matriz matrizFocada = null;
MudancaProteina mudancaProteinaFocada = null;

int squareSize = 1;

// color[] colorsHeat = {#FFD000, #FF9A00, #FF7B00, #FF4A00, #FF0000}; //heat
// color[] colorsStrongGreen = {#E5FCC2, #9DE0AD, #45ADA8, #547980, #594F4F}; // green1
// color[] colors = {#FFF5BC, #D6EDBD, #B8D9B8, #7FA6A1, #5D7370, #D8D8D8, #CECECE}; // green2
// color[] colorsGreenHeat = {#E1F5C4, #EDE574, #F9D423, #FC913A, #FF4E50, #D8D8D8, #C1C1C1}; // heat-greenish
// color[] colorsGray = {#8D7966, #A8A39D, #D8C8B8, #E2DDD9, #F8F1E9};
// color[] colorsContrast = {#EBE3AA, #CAD7B2, #A8CABA, #838689, #5D4157};

color[] cPallete         = {#FFD000, #FF9A00, #FF7B00, #FF4A00, #FF0000};
color cBackground        = #FFFFFF;
color cInvalidos         = #E6E6E6;
color cValidos           = #F0F0F0;
color cBackgroundMapa    = #BEBEBE;
color cBackgroundFiltros = #E6E6E6;
color cButtonText        = #5D4157;
color cButtonMouseOver   = #FFF5BC;
color cButtonActive      = #FF4E50;
color cHistogramText     = #5D4157;
color cElipse            = #FF0000;
color cSparkLine         = #5D4157;
color cProteinAnt        = #E6E6E6;
color cProteinNovo       = #BEBEBE;


void setup() {
  size(1280, 720);
  frameRate(30);
  smooth();
  background(cBackground);

  font = createFont("Arial Bold", 20);

  linhasConfig = loadStrings("mysql_settings.txt");
  host         = linhasConfig[0]; database = linhasConfig[1]; user = linhasConfig[2]; pass = linhasConfig[3];
  db           = new MySQL(this, host, database, user, pass);

  gl = new Global();

  criaButtons();

  superMatriz = new Matriz[numPrefixos][numEstudos];
  preencheListaNivel1();
  preencheSuperMatriz();
  posicionaSuperMatriz(25, 200, width-50, (int) (width/4.5));
  
  sl = new SparkLine(50, height-150, width-100, 50);

  // superMatriz[3][0].quadrados[4][1].preencheLista();
  // superMatriz[3][0].quadrados[4][1].ordenaLista();
  // for(int i=0; i<superMatriz[3][0].quadrados[4][1].nivel2List.size(); i++) {
  //   superMatriz[3][0].quadrados[4][1].nivel2List.get(i).preencheMudancaProteinaLista();
  //   // for(int j=0; j<superMatriz[3][0].quadrados[4][1].nivel2List.get(i).mudancaProteinaList.size(); j++) {
  //     // print(superMatriz[3][0].quadrados[4][1].nivel2List.get(i).mudancaProteinaList.get(j).iduniprot + "\n");      
  //   // }    
  // }
  // // sl.imprimeValoresNormalizados();
}

void draw() {
  if(!alreadyDrawn) {
    background(cBackground);
    if(matrizFocada == null) {
      sl.drawSparkLine();
      if(heatMapButton.active) {
        preencheSuperMatrizHeatSquareList();
        drawSuperMatrizHeatMap();
      }
      if(squareMapButton.active) drawSuperMatrizSquareMap();      
    } else {
      if(heatMapButton.active) {
        preencheSuperMatrizHeatSquareList(); // Vai recalcular as dimensoes
        matrizFocada.drawHeatMap();
      }
      if(squareMapButton.active) matrizFocada.drawSquareMap();
      if(matrizFocada.quadradoFocado != null) matrizFocada.quadradoFocado.drawHistogram();
      if(mudancaProteinaFocada != null) mudancaProteinaFocada.drawDetail();
    }
    alreadyDrawn = true;
  }
  drawButtons();
}

void criaButtons() {
  heatMapButton   = new Button("HeatMap", new PVector(0, 0), 13);
  squareMapButton = new Button("SquareMap", new PVector(0, 0), 13);
  exibeLogButton  = new Button("Log", new PVector(0, 0), 12);
  exibe00Button   = new Button("Elemento 00", new PVector(0, 0), 12);
  mvgButton       = new Button("Valores Globais", new PVector(0, 0), 12);
}

void drawButtons() {
  noStroke();
  int wMenuMapa = (int) (0.4*width);
  int wMenuRestricoes = width - wMenuMapa;
  int hMenu = 30;
  fill(cBackgroundMapa);
  rect(0, height-hMenu, wMenuMapa, hMenu);
  fill(cBackgroundFiltros);
  rect(wMenuMapa, height-hMenu, wMenuRestricoes, hMenu);
  heatMapButton.draw(0, (int)(0.13*width), (int) ((height-hMenu)+(hMenu)/1.5));
  squareMapButton.draw(0, (int)(0.26*width), (int) ((height-hMenu)+(hMenu)/1.5));
  exibeLogButton.draw(0, (int)(1*wMenuRestricoes/4)+wMenuMapa, (int) ((height-hMenu)+(hMenu)/1.5));
  exibe00Button.draw(0, (int)(2*wMenuRestricoes/4)+wMenuMapa, (int) ((height-hMenu)+(hMenu)/1.5));
  mvgButton.draw(0, (int)(3*wMenuRestricoes/4)+wMenuMapa, (int) ((height-hMenu)+(hMenu)/1.5));
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
      superMatriz[i2][i1] = new Matriz(0, 0, 0, 0);
      for(int i3=numChave-1; i3>=0; i3--) {
        for(int i4=0; i4<numChave; i4++) {
          if((i4>i2+1) || (i3<numChave-i2-2)) {
            // Valores em branco, nao faca nada
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
      superMatriz[i2][i1].identificaMaioresValoresExceto00();

      for(int i5=0; i5<numChave; i5++) {
        if(gl.maioresValoresX[i5] < superMatriz[i2][i1].maioresValoresX[i5])
          gl.maioresValoresX[i5] = superMatriz[i2][i1].maioresValoresX[i5];
        if(gl.maioresValoresY[i5] < superMatriz[i2][i1].maioresValoresY[i5])
          gl.maioresValoresY[i5] = superMatriz[i2][i1].maioresValoresY[i5];
        if(gl.maioresValoresXE00[i5] < superMatriz[i2][i1].maioresValoresXE00[i5])
          gl.maioresValoresXE00[i5] = superMatriz[i2][i1].maioresValoresXE00[i5];
        if(gl.maioresValoresYE00[i5] < superMatriz[i2][i1].maioresValoresYE00[i5])
          gl.maioresValoresYE00[i5] = superMatriz[i2][i1].maioresValoresYE00[i5];
      }
    }
  }
  print("MVG: " + gl.maiorValor + " SMVG: " + gl.segundoMaiorValor + "\n");
  for(int i=0; i<numChave; i++) {
    print("GX: " + gl.maioresValoresX[i] + " GY: " + gl.maioresValoresY[i] + "\n");
  }
}

void posicionaSuperMatriz(int x, int y, int w, int h) {
  int espacamentoX = 15, espacamentoY = 5;
  int quadradoX = (int) (w-(numEstudos*espacamentoX))/numEstudos;
  int quadradoY = (int) (h-(numPrefixos*espacamentoY))/numPrefixos;
  print("QuadradoX :" + quadradoX + ", QuadradoY: " + quadradoY + "\n"); 
  for(int i=0; i<numEstudos; i++) {
    for(int j=0; j<numPrefixos; j++) {
      superMatriz[j][i].x = x+(quadradoX+espacamentoX)*i;
      superMatriz[j][i].y = y+(quadradoY+espacamentoY)*j; 
      superMatriz[j][i].w = quadradoX;
      superMatriz[j][i].h = quadradoY;
    }
  }
  preencheSuperMatrizHeatSquareList();
}

void defineParametrosSuperMatriz() {
  for(int i=0; i<numEstudos; i++) {
    for(int j=0; j<numPrefixos; j++) {
      superMatriz[j][i].exibe00 = exibe00Button.active;
      superMatriz[j][i].mvg = mvgButton.active;
      superMatriz[j][i].exibeLog = exibeLogButton.active;
    }
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

void mousePressed() {
  alreadyDrawn = false;
  if(heatMapButton.isIn()) {
    posicionaSuperMatriz(25, 200, width-50, (int) (width/4.5));
    heatMapButton.active = true;
    squareMapButton.active = false;
    matrizFocada = null;
    mudancaProteinaFocada = null;
  }
  if(squareMapButton.isIn()) {
    posicionaSuperMatriz(25, 200, width-50, (int) (width/4.5));
    heatMapButton.active = false;
    squareMapButton.active = true;
    matrizFocada = null;
    mudancaProteinaFocada = null;
  }

  if(mvgButton.isIn() || exibeLogButton.isIn() || exibe00Button.isIn()) {
    if(mvgButton.isIn()) mvgButton.active           = !mvgButton.active;
    if(exibe00Button.isIn()) exibe00Button.active   = !exibe00Button.active;
    if(exibeLogButton.isIn()) exibeLogButton.active = !exibeLogButton.active;
    defineParametrosSuperMatriz();
  }

  if(matrizFocada == null) {
    for(int i=0; i<numEstudos; i++) {
      for(int j=numPrefixos-1; j>=0; j--) {
        if(superMatriz[j][i].mouseOver()) {
          superMatriz[j][i].onMouseClickGrowBig();
          matrizFocada = superMatriz[j][i];
        }
      }
    }
  } else {
    matrizFocada.identificaQuadradoFocadoHM();
    
    // Pesquisa detalhe proteina
    if(matrizFocada.quadradoFocado != null) {
      ArrayList<Nivel2> nivel2List = matrizFocada.quadradoFocado.nivel2List;
      if(nivel2List != null) {
        for(int i=0; i<nivel2List.size(); i++) {
          for(int j=0; j<nivel2List.get(i).mudancaProteinaList.size(); j++) {
            if(nivel2List.get(i).mudancaProteinaList.get(j).mouseOver()) {
              mudancaProteinaFocada = nivel2List.get(i).mudancaProteinaList.get(j);
              println("Cliquei em proteina");
            }          
          }
        }
      }
    }
  }
}

class Global {
  int maiorValor = 0;
  int segundoMaiorValor = 0;
  float[] maioresValoresX;
  float[] maioresValoresY;
  float[] maioresValoresXE00;
  float[] maioresValoresYE00;

  Global() {
    this.maioresValoresY    = new float[numChave];
    this.maioresValoresX    = new float[numChave];
    this.maioresValoresXE00 = new float[numChave];
    this.maioresValoresYE00 = new float[numChave];
    for(int i=0; i<numChave; i++) {
      maioresValoresY[i] = 0;
      maioresValoresX[i] = 0;
      maioresValoresYE00[i] = 0;
      maioresValoresXE00[i] = 0;
    }
  }
}
