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

void setup() {
  linhasConfig = loadStrings("mysql_settings.txt");
  host = linhasConfig[0]; database = linhasConfig[1]; user = linhasConfig[2]; pass = linhasConfig[3];
  db = new MySQL(this, host, database, user, pass);

  superMatriz = new Matriz[numPrefixos][numEstudos];
  preencheListaNivel1();
  preencheSuperMatriz();
  print(superMatriz[3][1].quadrados[4][0].numElementos + "\n");

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
      superMatriz[i2][i1] = new Matriz();
      for(int i3=numChave-1; i3>=0; i3--) {
        for(int i4=0; i4<numChave; i4++) {
          if((i4>i2+1) || (i3<numChave-i2-2)) {
            print("escapou\n");            
          }
          else {
            superMatriz[i2][i1].quadrados[i3][i4] = nivel1List.get(count);
            print("SM: " + i2 + "-" + i1 + " Q: " + i3 + "-" + i4 + " Value: " + nivel1List.get(count).numElementos + "\n");
            count++;
          }
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
