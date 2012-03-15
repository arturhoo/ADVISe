import de.bezier.data.sql.*;

MySQL db;

String host;
String database;
String user;
String pass;

int width = 800;
int height = 600;

ArrayList<Nivel1> nivel1List;

void setup() {
  
  String slines[] = loadStrings("mysql_settings.txt");
  host = slines[0]; database = slines[1]; user = slines[2]; pass = slines[3];
  db = new MySQL(this, host, database, user, pass);
  
  if(db.connect()) {
    print("Conectou\n");
    nivel1List = new ArrayList<Nivel1>();
    db.query("select version, prefix, subidas, descidas, count from nivel1 order by version, prefix, subidas, descidas");
    while(db.next()) {
      Nivel1 nivel1 = new Nivel1(db.getInt("version"), db.getInt("prefix"), db.getInt("subidas"), db.getInt("descidas"), db.getInt("count"));
      nivel1List.add(nivel1);
    }
  }
  for(int i=0; i<nivel1List.size(); i++) {
    print("Versao: " + nivel1List.get(i).versao + 
          " Prefixo: " + nivel1List.get(i).prefixLength + 
          " Subidas: " + nivel1List.get(i).subidas +
          " Descidas: " + nivel1List.get(i).descidas +
          " numElementos: " + nivel1List.get(i).numElementos + "\n");
  }
  
  size(width, height);
  frameRate (60);
  smooth();
  
}

void draw() {


}
