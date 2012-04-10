import de.bezier.data.sql.*;

MySQL db;

String host;
String database;
String user;
String pass;

ArrayList<Nivel1> nivel1List;
Matriz[][] superMatriz;

int numChave = 5;
int numPrefixos = 5;
int numEstudos = 14;

String linhasConfig[];

void setup() {
  linhasConfig = loadStrings("mysql_settings.txt");
  host = linhasConfig[0]; database = linhasConfig[1]; user = linhasConfig[2]; pass = linhasConfig[3];
  db = new MySQL(this, host, database, user, pass);

  superMatriz = new Matriz[numEstudos][numPrefixos-1];

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
  // Para cada versao
  for(int i1=0; i1<numEstudos; i1++) {
    // Para cada prefixo
    for(int i2=numPrefixos-1; i2>=1; i2--) {
      // 
      superMatriz[i1][i2] = new Matriz();
      for(int i3=i2; i3>=0; i3--) {
        //
        for(int i4=0; i4<i2+1; i4++) {
          superMatriz[i1][i2].quadrados[i3][i4] = nivel1List.get(count);
          count++;
        }
      }
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
