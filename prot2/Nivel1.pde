class Nivel1 {
  int numElementos;
  int prefixo;
  int ver_estudo;
  int subidas;
  int descidas;
  ArrayList<Nivel2> nivel2List;
  ArrayList<ParticleSystem> psList;
  boolean preenchida = false, ordenada = false, psCriado = false;
  
  Nivel1 (int ver_estudo, int prefixo, int subidas, int descidas, int numElementos) {
    this.numElementos = numElementos;
    this.prefixo      = prefixo;
    this.ver_estudo   = ver_estudo;
    this.subidas      = subidas;
    this.descidas     = descidas;    
  }
  
  void preencheLista() {
    this.nivel2List   = new ArrayList<Nivel2>();
    if(this.numElementos != 0) {
      String selQuery = "select ec_ant0, ec_novo0, count(*) " +
                        "from id_ec_num " +
                        "where ver_estudo = " + this.ver_estudo + " and " +
                              "prefixo    = " + this.prefixo + " and " +
                              "subidas    = " + this.subidas + " and " +
                              "descidas   = " + this.descidas + " " +
                        "group by ec_ant0, ec_novo0";
      db.query(selQuery);
      while(db.next()) {
        Nivel2 nivel2 = new Nivel2(this,
                                   db.getInt("ec_ant0"),
                                   db.getInt("ec_novo0"),
                                   db.getInt("count(*)"));                                 
        this.nivel2List.add(nivel2);
        // print(nivel2.numElementos + "\n");
      }
    }
    preenchida = true;
  }

  void destroiObjetos() {
    this.nivel2List = null;
    preenchida      = false;
    ordenada        = false;
    psCriado        = false;
  }

  void ordenaLista() {
    Collections.sort(nivel2List, new Comparator() {
      public int compare(Object o1, Object o2) {
        Nivel2 n1 = (Nivel2) o1;
        Nivel2 n2 = (Nivel2) o2;
        return n1.numElementos > n2.numElementos ? -1 : (n1.numElementos < n2.numElementos ? +1 : 0);
      }
    });
    ordenada = true;
  }

  void drawHistogram() {
    this.preencheLista();
    this.ordenaLista();
    int escapeVertical = 0;
    for(int i=0; i<nivel2List.size(); i++) {
      if(nivel2List.get(i).numElementos > 0) {
        print("Imprimindo elemento: " + i + " cujo y é: " + escapeVertical + "\n");
        int ultimoYDesenhado = nivel2List.get(i).draw(100+((int)(3*height/5))+50, 160+escapeVertical);
        escapeVertical += ultimoYDesenhado + 35;
      }      
    }
  }
}
