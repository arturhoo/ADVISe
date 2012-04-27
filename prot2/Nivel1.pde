class Nivel1 {
  int numElementos;
  int prefixo;
  int ver_estudo;
  int subidas;
  int descidas;
  ArrayList<Nivel2> nivel2List;
  ArrayList<ParticleSystem> psList;
  boolean preenchida = false, ordenada = false, psCriado = false;
  VScrollbar vs1;
  int histogramX, histogramY, histogramW, histogramH;
  
  Nivel1 (int ver_estudo, int prefixo, int subidas, int descidas, int numElementos) {
    this.numElementos = numElementos;
    this.prefixo      = prefixo;
    this.ver_estudo   = ver_estudo;
    this.subidas      = subidas;
    this.descidas     = descidas;

    this.histogramX = 150+((int)(3*height/5)); // de acordo com o metodo onClickGrowBig
    this.histogramY = (height/5);
    this.histogramW = width-histogramX;
    this.histogramH = height-histogramY-50; // 50 vem do metodo drawButtons();
    this.vs1 = new VScrollbar(width-10, this.histogramY, 10, this.histogramH, 10);
  }
  
  void preencheLista() {
    final long startTime = System.nanoTime();
    final long endTime;

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
    endTime = System.nanoTime();
    if(gl.timing) println("Tempo gasto para preencher nivel2List: " + (endTime - startTime)/pow(10,9));
  }

  void destroiObjetos() {
    this.nivel2List = null;
    preenchida      = false;
    ordenada        = false;
    psCriado        = false;
  }

  void ordenaLista() {
    final long startTime = System.nanoTime();
    final long endTime;

    Collections.sort(nivel2List, new Comparator() {
      public int compare(Object o1, Object o2) {
        Nivel2 n1 = (Nivel2) o1;
        Nivel2 n2 = (Nivel2) o2;
        return n1.numElementos > n2.numElementos ? -1 : (n1.numElementos < n2.numElementos ? +1 : 0);
      }
    });
    ordenada = true;
    endTime = System.nanoTime();
    if(gl.timing) println("Tempo gasto para ordernar nivel2List: " + (endTime - startTime)/pow(10,9));
  }

  void limpaNivel2MudancaProteinaDetalhe() {
    if(preenchida) {
      for(int i=0; i<nivel2List.size(); i++) {
        if(nivel2List.get(i).numElementos > 0) {
          nivel2List.get(i).limpaMudancaProteinaDetalhe();
        }
      }
    }
  }

  void drawHistogram() {
    final long startTime = System.nanoTime();
    final long endTime;

    if(!preenchida) this.preencheLista();
    if(!ordenada) this.ordenaLista();

    int areaLivreW = histogramW-50; // -50 para caber a scrollbar
    int areaLivreH = histogramH-18; // do titulo

    // Só simulando
    PGraphics pgs = createGraphics(areaLivreW, areaLivreH, JAVA2D);
    pgs.beginDraw();
    int escapeVertical = 0;
    for(int i=0; i<nivel2List.size(); i++) {
      if(nivel2List.get(i).numElementos > 0) {
        int ultimoYDesenhado = nivel2List.get(i).draw(0, escapeVertical+33, pgs, 0, 0, areaLivreW);
        escapeVertical += ultimoYDesenhado + 35;
      }
    }
    pgs.endDraw();
    pgs = null;

    int vsRecuo = 0;
    if(escapeVertical > areaLivreH) vsRecuo = (int) (vs1.getPos()*(escapeVertical-areaLivreH+50));
    PGraphics pg = createGraphics(areaLivreW, areaLivreH, JAVA2D);
    int pgX = histogramX, pgY = histogramY+30;
    pg.beginDraw();
    pg.background(cBackground);
    pg.smooth();

    // Pra valer
    escapeVertical = 0;
    for(int i=0; i<nivel2List.size(); i++) {
      if(nivel2List.get(i).numElementos > 0) {
        int ultimoYDesenhado = nivel2List.get(i).draw(0,
                                                      escapeVertical+15-vsRecuo,
                                                      pg,
                                                      pgX,
                                                      pgY,
                                                      areaLivreW);
        escapeVertical += ultimoYDesenhado + 35;
      }
    }
    textFont(font, 14);
    // Para apagar o texto antigo
    fill(cBackground);
    noStroke();
    rect(histogramX, histogramY-5, histogramW, 20);
    fill(cHistogramText);
    text("Number of Proteins: " + this.numElementos, histogramX, histogramY+11);
    endTime = System.nanoTime();
    // if(gl.timing) println("Tempo gasto para drawHistogram: " + (endTime - startTime)/pow(10,9));
    pg.endDraw();
    image(pg, pgX, pgY);

    vs1.update();
    vs1.display();
  }
}
