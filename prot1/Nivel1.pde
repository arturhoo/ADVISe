class Nivel1 {
  int numElementos;
  int prefixo;
  int ver_estudo;
  int subidas;
  int descidas;
  ArrayList<Nivel2> nivel2List;
  
  Nivel1 (int ver_estudo, int prefixo, int subidas, int descidas, int numElementos) {
    this.numElementos = numElementos;
    this.prefixo      = prefixo;
    this.ver_estudo   = ver_estudo;
    this.subidas      = subidas;
    this.descidas     = descidas;
    this.nivel2List   = new ArrayList<Nivel2>();
  }
  
  void preencheLista() {
    if(this.numElementos != 0) {
      String selQuery = "select ec_ant, ec_novo, count(*) " +
                        "from id_ec " +
                        "where ver_estudo = " + this.ver_estudo + " and " +
                        "prefixo = " + this.prefixo + " and " +
                        "subidas = " + this.subidas + " and " +
                        "descidas = " + this.descidas + " " +
                        "group by ec_ant, substr(ec_novo,1,1)";
      db.query(selQuery);
      while(db.next()) {
        Nivel2 nivel2 = new Nivel2(this,
                                   db.getString("ec_ant"),
                                   db.getString("ec_novo"),
                                   db.getInt("count(*)"));                                 
        this.nivel2List.add(nivel2);
        print(nivel2.numElementos + "\n");
      }
    }
  }

  void ordenaLista() {
    Collections.sort(nivel2List, new Compartor() {
      public int compare(Object o1, Object o2) {
        Nivel2 n1 = (Nivel2) o1;
        Nivel2 n2 = (Nivel2) o2;
        return n1.numElementos > n2.numElementos ? -1 : (n1.numElementos < n2.numElementos ? +1 : 0);
      }
    });
  }   
}
