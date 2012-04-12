class Nivel2 {
  int numElementos;
  int prefixo;
  int ver_estudo;
  int subidas;
  int descidas;
  int[] ec_ant;
  int[] ec_novo;
  ArrayList<MudancaProteina> mudancaProteinaList;
  
  Nivel2 (Nivel1 nivel1, String ec_ant, String ec_novo, int numElementos) {
    this.numElementos = numElementos;
    this.prefixo      = nivel1.prefixo;
    this.ver_estudo   = nivel1.ver_estudo;
    this.subidas      = nivel1.subidas;
    this.descidas     = nivel1.descidas;
    this.ec_ant       = new int[4];
    this.ec_novo      = new int[4];
    for(int count=0; count<4; count++) {
      this.ec_ant[count] = getIntFromEcPosition(ec_ant, count);
      this.ec_novo[count] = getIntFromEcPosition(ec_novo, count);
    }
  }

  void preencheMudancaProteinaLista() {
    if(numElementos != 0) {
      String ec_antS =  ec_ant[0] + "." + ec_ant[1] + "." +
                        ec_ant[2] + "." + ec_ant[3];
      String ec_novoS = ec_novo[0] + "." + ec_novo[1] + "." +
                        ec_novo[2] + "." + ec_novo[3];
      ec_antS = ec_antS.replaceAll("-1", "-");
      ec_novoS = ec_novoS.replaceAll("-1", "-");
      print("ECS: " + ec_antS + ", " + ec_novoS + "\n");
      String selQuery = "select iduniprot, rp_antes, oc_antes, kw_antes, " +
                        "rp_depois, oc_depois, kw_depois " +
                        "from id_ec_atributo " +
                        "where ver_estudo = " + this.ver_estudo + " and " +
                              "prefixo    = " + this.prefixo + " and " +
                              "subidas    = " + this.subidas + " and " +
                              "descidas   = " + this.descidas + " and " +
                              "ec_ant     = " + "'" + ec_antS + "'"; // + " and " +
                              // "ec_novo    = " + "'" + ec_novoS + "'";
      db.query(selQuery);
      print("Finalizou Query!\n");
      while(db.next()) {
        MudancaProteina mp = new MudancaProteina( this, 
                                                  db.getString("iduniprot"),
                                                  db.getString("rp_antes"),
                                                  db.getString("oc_antes"),
                                                  db.getString("kw_antes"),
                                                  db.getString("rp_depois"),
                                                  db.getString("oc_depois"),
                                                  db.getString("kw_depois"));
        this.mudancaProteinaList.add(mp);
      }
    }
    print("Finalizou\n");
  }
}
