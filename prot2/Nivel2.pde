class Nivel2 {
  int numElementos;
  int prefixo;
  int ver_estudo;
  int subidas;
  int descidas;
  int[] ec_ant;
  int[] ec_novo;
  ArrayList<MudancaProteina> mudancaProteinaList;
  
  Nivel2 (Nivel1 nivel1, int ec_ant0, int ec_novo0, int numElementos) {
    this.numElementos = numElementos;
    this.prefixo      = nivel1.prefixo;
    this.ver_estudo   = nivel1.ver_estudo;
    this.subidas      = nivel1.subidas;
    this.descidas     = nivel1.descidas;
    this.ec_ant       = new int[4];
    this.ec_novo      = new int[4];
    this.ec_ant[0]    = ec_ant0;
    this.ec_novo[0]   = ec_novo0;
  }

  void preencheMudancaProteinaList() {
    final long startTime = System.nanoTime();
    final long endTime;

    mudancaProteinaList = new ArrayList<MudancaProteina>();
    if(numElementos != 0) {
      String selQuery = "select iduniprot, rp_antes, oc_antes, kw_antes, " +
                        "rp_depois, oc_depois, kw_depois, " +
                        "ec_ant0, ec_ant1, ec_ant2, ec_ant3, " +
                        "ec_novo0, ec_novo1, ec_novo2, ec_novo3 " +
                        "from id_ec_atributo_num " +
                        "where ver_estudo = " + this.ver_estudo + " and " +
                              "prefixo    = " + this.prefixo + " and " +
                              "subidas    = " + this.subidas + " and " +
                              "descidas   = " + this.descidas + " and " +
                              "ec_ant0    = " + this.ec_ant[0] + " and " +
                              "ec_novo0   = " + this.ec_novo[0] + "";
      db.query(selQuery);
      while(db.next()) {
        MudancaProteina mp = new MudancaProteina( this, 
                                                  db.getString("iduniprot"),
                                                  db.getString("rp_antes"),
                                                  db.getString("oc_antes"),
                                                  db.getString("kw_antes"),
                                                  db.getString("rp_depois"),
                                                  db.getString("oc_depois"),
                                                  db.getString("kw_depois"),
                                                  db.getInt("ec_ant0"),
                                                  db.getInt("ec_ant1"),
                                                  db.getInt("ec_ant2"),
                                                  db.getInt("ec_ant3"),
                                                  db.getInt("ec_novo0"),
                                                  db.getInt("ec_novo1"),
                                                  db.getInt("ec_novo2"),
                                                  db.getInt("ec_novo3"));
        this.mudancaProteinaList.add(mp);
      }
    }
    endTime = System.nanoTime();
    if(gl.timing) println("Tempo gasto para preencheMudancaProteinaList: " + (endTime - startTime)/pow(10,9));
  }

  int draw(int x, int y) {
    this.preencheMudancaProteinaList();
    int espacamentoHorizontal = 12;
    int espacamentoVertical = 12;
    int numProteinasLinha = (int) ((width-x-260)/10);
    int i;
    fill(cHistogramText);
    textFont(font, 12);
    text(ecList[ec_ant[0]+1] + " to\n" + ecList[ec_novo[0]+1] + " (" + this.numElementos + ")", x, y+5);
    for(i=0; i<mudancaProteinaList.size(); i++) {
      mudancaProteinaList.get(i).drawParticle(x+130+(i%numProteinasLinha)*espacamentoHorizontal, y+(i/numProteinasLinha)*espacamentoVertical);      
    }
    int ultimoYDesenhado = ((i/numProteinasLinha)+1)*espacamentoVertical;
    return ultimoYDesenhado;
  }
}
