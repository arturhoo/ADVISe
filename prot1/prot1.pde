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
    for (int i=2; i<=15; i++) {
      for (int j=0; j<4; j++) {
        for(int k=0; k<=4-j; k++) {
          for(int l=0; l<=4-j; l++) {
            String query = "select count(*) from id_ec where ver_estudo =\"" + i + "\"and prefixo =\"" + j + "\"and subidas =\"" + k + "\"and descidas =\"" + l + "\"";
            db.query(query);
            //Nivel1 nivel1 = new
            db.next();
            print("V: " + i + " P: " + j + " S: " + k + " D: " + l + " Count: " + db.getString("count(*)") + "\n");
          }
        }
      }
    }
  }
  
  size(width, height);
  frameRate (60);
  smooth();
  
}

void draw() {


}
