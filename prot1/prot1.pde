import de.bezier.data.sql.*;

MySQL db;

String host;
String database;
String user;
String pass;

int width = 960;
int height = 540;

int numVersoes = 14;

ArrayList<Nivel1> nivel1List;
ArrayList<SquareMap> squareMapList;

PFont font;

Button smButton;
Button ps1Button;
Button ps2Button;

void setup() {
  size(width, height);
  frameRate(30);
  smooth();
  font = createFont("Arial Bold", 20);

  smButton = new Button("SquareMap", new PVector(width-40, height-70), 12);
  ps1Button = new Button("PS1", new PVector(width-40, height-50), 12);
  ps2Button = new Button("PS2", new PVector(width-40, height-30), 12);

  String slines[] = loadStrings("mysql_settings.txt");
  host = slines[0]; database = slines[1]; user = slines[2]; pass = slines[3];
  db = new MySQL(this, host, database, user, pass);
  
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
  for(int i=0; i<nivel1List.size(); i++) {
    print("Versao: " + nivel1List.get(i).ver_estudo + 
          " Prefixo: " + nivel1List.get(i).prefixo + 
          " Subidas: " + nivel1List.get(i).subidas +
          " Descidas: " + nivel1List.get(i).descidas +
          " numElementos: " + nivel1List.get(i).numElementos + "\n");
    //if(nivel1List.get(i).ver_estudo == 2 && nivel1List.get(i).prefixo == 0 && nivel1List.get(i).subidas == 0 && nivel1List.get(i).descidas == 2) {
    if(nivel1List.get(i).ver_estudo == 2 && 
        !(nivel1List.get(i).subidas == 0 && 
          nivel1List.get(i).descidas == 0)) {
      //nivel1List.get(i).preencheLista();
    }
  }
  createSquareMapList();
}

void draw() {
  background(180, 180, 180);

  // Exibe FPS
  textFont(font,12);
  fill(255);
  text(frameRate,10,10);

  ps1Button.draw(0);
  ps2Button.draw(0);
  smButton.draw(0);

  if(smButton.active) {
    for(int i=0; i<squareMapList.size(); i++) {
      if(!squareMapList.get(i).drawn || squareMapList.get(i).mouseOver())
        squareMapList.get(i).drawMap(new PVector(40+(i*64),height-150));
    }
  }

  if(ps1Button.active) nivel1List.get(3).runParticleSystems();
  if(ps2Button.active) nivel1List.get(4).runParticleSystems();
}

void createSquareMapList() {
  squareMapList = new ArrayList<SquareMap>();
  float[] maioresValoresX = new float[5];
  float[] maioresValoresY = new float[5];
  for(int cc=0; cc<5; cc++) {
    maioresValoresY[cc] = 0;
    maioresValoresX[cc] = 0;
  }

  int count = 0;
  for(int ii=0; ii<numVersoes; ii++) {
    float[][] matrix = new float[5][];
    for(int i=4; i>=0; i--) {
      matrix[i] = new float[5];
      for(int j=0; j<5; j++) {
        // Get area value
        matrix[i][j] = nivel1List.get(count).numElementos > 0 
          ? pow(nivel1List.get(count).numElementos, 0.5) : 0;
        count++;
      }
    }
    SquareMap sm = new SquareMap(matrix);
    squareMapList.add(sm);
    while(nivel1List.get(count).ver_estudo < ii+3 && ii != 13) count++;

    // Get general max values
    for(int c=0; c<5; c++){
      if(sm.maioresValoresX[c] > maioresValoresX[c]) maioresValoresX[c] = sm.maioresValoresX[c];
      if(sm.maioresValoresY[c] > maioresValoresY[c]) maioresValoresY[c] = sm.maioresValoresY[c];
    }     
  }
  for(int ii=0; ii<squareMapList.size(); ii++) {
    squareMapList.get(ii).maioresValoresX = maioresValoresX;
    squareMapList.get(ii).maioresValoresY = maioresValoresY;
  }
}

void mousePressed() {
  if(ps1Button.isIn() || ps2Button.isIn() || smButton.isIn()) {
    nivel1List.get(4).destroiObjetos();
    ps2Button.active = false;
    nivel1List.get(3).destroiObjetos();
    ps1Button.active = false;
    smButton.active = false;
  }
  
  if(ps1Button.isIn()) {
    ps1Button.active = true;
  }

  if(ps2Button.isIn()) {
    ps2Button.active = true;
  }

  if(smButton.isIn()) {
    smButton.active = true;
  }
}
