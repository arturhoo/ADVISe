import de.bezier.data.sql.*;

MySQL db;

String host;
String database;
String user;
String pass;

int width = 960;
int height = 540;

ArrayList<Nivel1> nivel1List;

void setup() {
  size(width, height);
  frameRate(60);
  smooth();

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
    if(nivel1List.get(i).ver_estudo == 2 && !(nivel1List.get(i).subidas == 0 && nivel1List.get(i).descidas == 0)) {
      //nivel1List.get(i).preencheLista();
    }
  }

  float[][] matrix = new float[5][];
  int count = 0;
  for(int i=4; i>=0; i--) {
    matrix[i] = new float[5];
    for(int j=0; j<5; j++) {
      matrix[i][j] = pow(nivel1List.get(count++).numElementos, 0.5);
    }
  }

  SquareMap sm = new SquareMap(matrix);
  sm.drawMap(new PVector(0,0)); 
  
}

void draw() {


}
