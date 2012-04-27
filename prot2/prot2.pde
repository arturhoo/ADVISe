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

int hmw = 80, hmh = 80;

PFont font, fontBold;

boolean drawn = false;
boolean drawnFocada = false;
Matriz matrizFocada = null;
MudancaProteina mudancaProteinaFocada = null;

int squareSize = 1;

// color[] colorsHeat = {#FFD000, #FF9A00, #FF7B00, #FF4A00, #FF0000}; //heat
// color[] colorsStrongGreen = {#E5FCC2, #9DE0AD, #45ADA8, #547980, #594F4F}; // green1
// color[] colors = {#FFF5BC, #D6EDBD, #B8D9B8, #7FA6A1, #5D7370, #D8D8D8, #CECECE}; // green2
// color[] colorsGreenHeat = {#E1F5C4, #EDE574, #F9D423, #FC913A, #FF4E50, #D8D8D8, #C1C1C1}; // heat-greenish
// color[] colorsGray = {#8D7966, #A8A39D, #D8C8B8, #E2DDD9, #F8F1E9};
// color[] colorsContrast = {#EBE3AA, #CAD7B2, #A8CABA, #838689, #5D4157};

color[] cPallete              = {#d5d50b, #a7a70b, #8e8e0b, #6a6a0b, #4c4c11};
color[] cPallete2             = {#c7103b, #cfb998, #00749d};
color cBackground             = #FFFFFF;
color cInvalidos              = #C8C8C8;
color cValidos                = #F0F0F0;
color cBackgroundMapaTitle    = #C8C8C8;
color cBackgroundFiltrosTitle = #AAAAAA;
color cBackgroundMapa         = #F0F0F0;
color cBackgroundFiltros      = #E6E6E6;
color cButtonTitleText        = #000000;
color cButtonText             = #AAAAAA;
color cButtonMouseOver        = #818181;
color cButtonActive           = #1F1F1F;
color cHighlightedSquare      = #3F00B7;
color cHistogramText          = #000000;
color cElipse                 = #FF0000;
color cSparkLine              = #000000;
color cProteinAnt             = #E6E6E6;
color cProteinNovo            = #BEBEBE;
color cUpperBar               = #CECECE;
color cDetailProteinAnt       = #E6E6E6;
color cDetailProteinNovo      = #BEBEBE;
color cDetailUniprot          = 150;


void setup() {
  size(1280, 720);
  frameRate(30);
  smooth();
  background(cBackground);

  font     = createFont("LucidaGrande", 20);
  fontBold = createFont("LucidaGrande-Bold", 20);

  linhasConfig = loadStrings("mysql_settings.txt");
  host         = linhasConfig[0]; database = linhasConfig[1]; user = linhasConfig[2]; pass = linhasConfig[3];
  db           = new MySQL(this, host, database, user, pass);

  gl = new Global();

  criaButtons();

  superMatriz = new Matriz[numPrefixos][numEstudos];
  preencheListaNivel1();
  preencheSuperMatriz();
  nivel1List = null;
  gl.smx = 50;
  gl.smy = 100;
  gl.smw = width-50-gl.smx;
  gl.smh = (int) (width/4.5);
  gl.smEspacamentoX = 15;
  gl.smEspacamentoY = 5;
  posicionaSuperMatriz();
  
  sl = new SparkLine(gl.smx, height-150, gl.smw, 50);
}

void draw() {
  if(!drawn) {
    background(cBackground);
    if(matrizFocada == null) {
      sl.drawSparkLine();
      if(heatMapButton.active) {
        //preencheSuperMatrizHeatSquareList();
        drawSuperMatrizHeatMap();
      }
      if(squareMapButton.active) drawSuperMatrizSquareMap();  
      drawUpperBar();    
    } else {
      if(!drawnFocada) matrizFocada.preencheHeatSquareList(); // Vai recalcular as dimensoes
      if(heatMapButton.active) matrizFocada.drawHeatMap();
      if(squareMapButton.active) matrizFocada.drawSquareMap();
      // if(matrizFocada.quadradoFocado != null) matrizFocada.quadradoFocado.drawHistogram();
      // if(mudancaProteinaFocada != null) mudancaProteinaFocada.drawDetail();
      drawnFocada = true;
    }
    drawn = true;
  }
  if(matrizFocada != null && matrizFocada.quadradoFocado != null) matrizFocada.quadradoFocado.drawHistogram();
  if(mudancaProteinaFocada != null) mudancaProteinaFocada.drawDetail();
  drawButtons();
}

void criaButtons() {
  heatMapButton   = new Button("HeatMap", new PVector(0, 0), 13);
  squareMapButton = new Button("QuadMap", new PVector(0, 0), 13);
  exibeLogButton  = new Button("Log Scale on Frequency", new PVector(0, 0), 12);
  exibe00Button   = new Button("Show Conserved Elements", new PVector(0, 0), 12);
  mvgButton       = new Button("Global Normalization", new PVector(0, 0), 12);
}

void drawButtons() {
  noStroke();
  int wMenuMapa = (int) (0.4*width);
  int wMenuRestricoes = width - wMenuMapa;
  int hMenu = 25;
  fill(cBackgroundMapa);
  rect(0, height-hMenu, wMenuMapa, hMenu);
  fill(cBackgroundFiltros);
  rect(wMenuMapa, height-hMenu, wMenuRestricoes, hMenu);

  fill(cBackgroundMapaTitle);  
  rect(0, height-hMenu*2, wMenuMapa, hMenu);
  fill(cBackgroundFiltrosTitle);
  rect(wMenuMapa, height-hMenu*2, wMenuRestricoes, hMenu);
  textAlign(CENTER);
  textFont(font, 14);
  fill(cButtonTitleText);
  text("Visualization", wMenuMapa/2, (height-hMenu*2)+(hMenu)/1.5);
  text("Filters", wMenuMapa+wMenuRestricoes/2, (height-hMenu*2)+(hMenu)/1.5);
  
  heatMapButton.draw(0, (int)(1*wMenuMapa/3), (int) ((height-hMenu)+(hMenu)/1.5));
  squareMapButton.draw(0, (int)(2*wMenuMapa/3), (int) ((height-hMenu)+(hMenu)/1.5));
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

      superMatriz[i2][i1].identificaNumTotalElementos();
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
  // print("MVG: " + gl.maiorValor + " SMVG: " + gl.segundoMaiorValor + "\n");
  // for(int i=0; i<numChave; i++) {
  //   print("GX: " + gl.maioresValoresX[i] + " GY: " + gl.maioresValoresY[i] + "\n");
  // }
}

void posicionaSuperMatriz() {
  int x = gl.smx, y = gl.smy, w = gl.smw, h = gl.smh;
  int quadradoX = (int) (w-((numEstudos-1)*gl.smEspacamentoX))/numEstudos;
  int quadradoY = (int) (h-((numPrefixos-1)*gl.smEspacamentoY))/numPrefixos;
  // print("QuadradoX :" + quadradoX + ", QuadradoY: " + quadradoY + "\n"); 
  for(int i=0; i<numEstudos; i++) {
    for(int j=0; j<numPrefixos; j++) {
      superMatriz[j][i].x = x+(quadradoX+gl.smEspacamentoX)*i;
      superMatriz[j][i].y = y+(quadradoY+gl.smEspacamentoY)*j; 
      superMatriz[j][i].w = quadradoX;
      superMatriz[j][i].h = quadradoY;
      superMatriz[j][i].grown = false;
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

void preencheSuperMatrizTotalNumElementos() {
  for(int i=0; i<numEstudos; i++) {
    for(int j=0; j<numPrefixos; j++) {
      superMatriz[j][i].identificaNumTotalElementos();
    }
  }
}

void preencheSuperMatrizHeatSquareList() {
  final long startTime = System.nanoTime();
  final long endTime;
  for(int i=0; i<numEstudos; i++) {
    for(int j=numPrefixos-1; j>=0; j--) {
      superMatriz[j][i].preencheHeatSquareList(); 
    }
  }

  endTime = System.nanoTime();
  if(gl.timing) println("Tempo gasto preencheSuperMatrizHeatSquareList: " + (endTime - startTime));
}

void drawSuperMatrizHeatMap() {
  for(int i=0; i<numEstudos; i++) {
    for(int j=numPrefixos-1; j>=0; j--) {
      superMatriz[j][i].drawHeatMap();      
    }
  }
  drawSuperMatrizAxis();
  drawHeatMapLegend();
}

void drawSuperMatrizSquareMap() {
  for(int i=0; i<numEstudos; i++) {
    for(int j=numPrefixos-1; j>=0; j--) {
      superMatriz[j][i].drawSquareMap();
    }
  }
  drawSuperMatrizAxis();
  drawSquareMapLegend();
}

void drawSuperMatrizAxis() {
  int quadradoW = superMatriz[0][0].w;
  int quadradoH = superMatriz[0][0].h;
  fill(cHistogramText);
  textFont(font, 11);
  textAlign(CENTER);
  for(int i=0; i<numEstudos; i++) {
    int textX = gl.smx+i*(quadradoW+gl.smEspacamentoX)+(quadradoW/2);
    int textY = gl.smy-7;
    text((i+1) + "-" + (i+2), textX, textY);
  }
  for(int i=0; i<numPrefixos; i++) {
    int textX = gl.smx - 10;
    int textY = gl.smy+i*(quadradoH+gl.smEspacamentoY)+(quadradoH/2);
    text((numPrefixos-i-1), textX, textY);
  }
  text("Release", gl.smx+(gl.smw/2), gl.smy-17);
  translate(gl.smx-20, gl.smy+(gl.smh/2));
  rotate(3*PI/2);
  text("Prefix Length", 0, 0);
  rotate(PI/2);
  resetMatrix();
  textAlign(LEFT);
}

void drawRegionLegend(int x, int y) {
  int rectW = 50;
  int rectH = 12;
  fill(cHistogramText);
  textFont(font, 11);
  int regionX = x;
  int regionY = y;
  text("No changes", regionX, regionY+8);
  text("Invalid Region", regionX, regionY+20);
  noStroke();
  fill(cValidos);
  rect(regionX+90, regionY, rectW, rectH);
  fill(cInvalidos);
  rect(regionX+90, regionY+rectH, rectW, rectH);
}

void drawSquareMapLegend() {
  fill(cHistogramText);
  textFont(font, 11);
  int rectX = gl.smx+170;
  text("Upper Left entries", rectX, gl.smy+gl.smh+20);
  text("Diagonal entries", rectX, gl.smy+gl.smh+32);
  text("Lower right entries", rectX, gl.smy+gl.smh+44);
  int rectW = 50;
  int rectH = 12;
  noStroke();
  fill(cPallete2[0]);
  rect(rectX+120, gl.smy+gl.smh+12, rectW, rectH);
  fill(cPallete2[1]);
  rect(rectX+120, gl.smy+gl.smh+24, rectW, rectH);
  fill(cPallete2[2]);
  rect(rectX+120, gl.smy+gl.smh+36, rectW, rectH);

  // int quadX = gl.smx+200;
  // int quadY = gl.smy+gl.smh+12;
  // textLeading(12);
  // fill(cPallete2[1]);
  // rect(quadX, quadY, 36, 36);
  // rect(quadX+100, quadY+6, 24, 24);
  // rect(quadX+188, quadY+12, 12, 12);
  // fill(0);
  // text("Many\nChanges", quadX+40, quadY+16);
  // text("Several\nChanges", quadX+128, quadY+16);
  // text("Few\nChanges", quadX+202, quadY+16);

  int quadX = gl.smx+10;
  int quadY = gl.smy+gl.smh+40;
  fill(cPallete2[1]);
  rect(quadX, quadY, 32, 32);
  rect(quadX+8, quadY+40, 16, 16);
  rect(quadX+12, quadY+68, 8, 8);
  fill(0);
  textLeading(11);
  text("Number of Changes\nindicated by quad size", gl.smx, gl.smy+gl.smh+20);
  text("Many", quadX+36, quadY+20);
  text("Some", quadX+36, quadY+56);
  text("Few", quadX+36, quadY+76);

  drawRegionLegend(gl.smx+370, gl.smy+gl.smh+12);
}

void drawHeatMapLegend() {
  noStroke();
  int sw = 65, sh = 16;  
  int legendX = gl.smx;
  textFont(font, 11);
  textAlign(LEFT);
  fill(0);
  text("Number of changes", legendX, gl.smy+gl.smh+20);
  for(int i=0; i<cPallete.length; i++) {
    fill(cPallete[i]);
    rect(legendX+i*sw, gl.smy+gl.smh+26, sw, sh);
    if(i == 0) {
      fill(0);
      text("1", legendX+6, gl.smy+gl.smh+38);
    }
    if(i == cPallete.length-1) {
      textAlign(RIGHT);
      fill(cBackground);
      String num;
      if(mvgButton.active) {
        num = "" + (exibe00Button.active ? gl.maiorValor : gl.segundoMaiorValor);
      } else num = "Frame Max";
      text(num, legendX+(i+1)*sw-3, gl.smy+gl.smh+38);
    }
    textAlign(LEFT);
  }

  drawRegionLegend(gl.smx+370, gl.smy+gl.smh+20);
}

void drawUpperBar(){
  noStroke();
  fill(cUpperBar);
  rect(0, 0, width, 35);
  textFont(font, 22);
  fill(0);
  text("ADVISe", 10, 25);
  int tw = (int) (textWidth("ADVISe"));
  for(int i=0; i<numChave; i++) {
    fill(cPallete[i]);
    rect(10+i*(tw/numChave), 27, (tw/numChave), 3);
  }
}

void mousePressed() {
  drawn = false;
  if(heatMapButton.isIn()) {
    posicionaSuperMatriz();
    heatMapButton.active = true;
    squareMapButton.active = false;
    if(matrizFocada != null) matrizFocada.quadradoFocado = null;
    matrizFocada = null;
    mudancaProteinaFocada = null;
  }
  if(squareMapButton.isIn()) {
    posicionaSuperMatriz();
    heatMapButton.active = false;
    squareMapButton.active = true;
    if(matrizFocada != null) matrizFocada.quadradoFocado = null;
    matrizFocada = null;
    mudancaProteinaFocada = null;
  }

  if(mvgButton.isIn() || exibeLogButton.isIn() || exibe00Button.isIn()) {
    if(mvgButton.isIn()) mvgButton.active           = !mvgButton.active;
    if(exibe00Button.isIn()) exibe00Button.active   = !exibe00Button.active;
    if(exibeLogButton.isIn()) exibeLogButton.active = !exibeLogButton.active;
    defineParametrosSuperMatriz();
    preencheSuperMatrizTotalNumElementos();
    if(heatMapButton.active) preencheSuperMatrizHeatSquareList();
  }

  if(matrizFocada == null) {
    for(int i=0; i<numEstudos; i++) {
      for(int j=numPrefixos-1; j>=0; j--) {
        if(superMatriz[j][i].mouseOver()) {
          superMatriz[j][i].onMouseClickGrowBig();
          matrizFocada = superMatriz[j][i];
          drawnFocada = false;
        }
      }
    }
  } else {
    if(matrizFocada.mouseOver()) {
      if(squareMapButton.active) matrizFocada.identificaQuadradoFocadoSM();
      else matrizFocada.identificaQuadradoFocadoHM();
      mudancaProteinaFocada = null;
    }
    
    // Pesquisa detalhe proteina
    if(matrizFocada.quadradoFocado != null) {
      ArrayList<Nivel2> nivel2List = matrizFocada.quadradoFocado.nivel2List;
      if(nivel2List != null) {
        for(int i=0; i<nivel2List.size(); i++) {
          for(int j=0; j<nivel2List.get(i).mudancaProteinaList.size(); j++) {
            if(nivel2List.get(i).mudancaProteinaList.get(j).mouseOver()) {
              matrizFocada.quadradoFocado.limpaNivel2MudancaProteinaDetalhe();
              nivel2List.get(i).limpaMudancaProteinaDetalhe();
              mudancaProteinaFocada = nivel2List.get(i).mudancaProteinaList.get(j);
              mudancaProteinaFocada.detalhe = true;
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
  boolean timing = true;
  int smx, smy, smw, smh;
  int smEspacamentoX, smEspacamentoY;

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
