class MudancaProteina {
  int x, y, realx, realy;
  float radius;

  int prefixo;
  int ver_estudo;
  int ver_estudo_navegacao;
  int subidas;
  int descidas;
  int[] ec_ant;
  int[] ec_novo;
  String iduniprot;
  String rp_antes;
  String oc_antes;
  String kw_antes;
  String rp_depois;
  String oc_depois;
  String kw_depois;

  HScrollbar hs1, hs2;
  TriangleButton tb1 = null, tb2 = null;
  int detalheH      = 130;
  int detalheHReal  = detalheH - 10;
  int linhasW       = 175;
  int tituloH       = 20;
  int hsH           = 10;
  float recuoNovo   = -1; // para compensar o valor nao 0.0 da hs
  float recuoAntigo = -1; // para compensar o valor nao 0.0 da hs

  boolean detalhe = false;

  ArrayList<MudancaProteina> mpList = null;

  MudancaProteina(MudancaProteina mp, int ver_estudo,
                  String rp_antes,  String oc_antes,  String kw_antes,
                  String rp_depois, String oc_depois, String kw_depois,
                  int ec_ant0, int ec_ant1, int ec_ant2, int ec_ant3,
                  int ec_novo0, int ec_novo1, int ec_novo2, int ec_novo3) {
    this.prefixo      = mp.prefixo;
    this.ver_estudo   = mp.ver_estudo;
    this.subidas      = mp.subidas;
    this.descidas     = mp.descidas;
    this.iduniprot    = mp.iduniprot;

    this.ver_estudo = ver_estudo;
    this.rp_antes   = rp_antes;
    this.oc_antes   = oc_antes;
    this.kw_antes   = kw_antes;
    this.rp_depois  = rp_depois;
    this.oc_depois  = oc_depois;
    this.kw_depois  = kw_depois;

    this.ec_ant     = new int[4];
    this.ec_novo    = new int[4];
    this.ec_ant[0]  = ec_ant0;
    this.ec_ant[1]  = ec_ant1;
    this.ec_ant[2]  = ec_ant2;
    this.ec_ant[3]  = ec_ant3;
    this.ec_novo[0] = ec_novo0;
    this.ec_novo[1] = ec_novo1;
    this.ec_novo[2] = ec_novo2;
    this.ec_novo[3] = ec_novo3;
  }

  MudancaProteina(Nivel2 nivel2,    String iduniprot, 
                  String rp_antes,  String oc_antes,  String kw_antes,
                  String rp_depois, String oc_depois, String kw_depois,
                  int ec_ant0, int ec_ant1, int ec_ant2, int ec_ant3,
                  int ec_novo0, int ec_novo1, int ec_novo2, int ec_novo3) {

    this.prefixo      = nivel2.prefixo;
    this.ver_estudo   = nivel2.ver_estudo;
    this.subidas      = nivel2.subidas;
    this.descidas     = nivel2.descidas;

    this.iduniprot  = iduniprot;
    this.rp_antes   = rp_antes;
    this.oc_antes   = oc_antes;
    this.kw_antes   = kw_antes;
    this.rp_depois  = rp_depois;
    this.oc_depois  = oc_depois;
    this.kw_depois  = kw_depois;

    this.ec_ant     = new int[4];
    this.ec_novo    = new int[4];
    this.ec_ant[0]  = ec_ant0;
    this.ec_ant[1]  = ec_ant1;
    this.ec_ant[2]  = ec_ant2;
    this.ec_ant[3]  = ec_ant3;
    this.ec_novo[0] = ec_novo0;
    this.ec_novo[1] = ec_novo1;
    this.ec_novo[2] = ec_novo2;
    this.ec_novo[3] = ec_novo3;

    this.radius = 10.0;

    this.ver_estudo_navegacao = ver_estudo;
    hs1 = new HScrollbar(linhasW, detalheHReal-10, (width-linhasW)/2, hsH, 10);
    hs2 = new HScrollbar((width-linhasW)/2+linhasW, detalheHReal-10, (width-linhasW)/2, hsH, 10);
    tb1 = new TriangleButton(linhasW+4, tituloH/2, linhasW+tituloH-4, 4, linhasW+tituloH-4, tituloH-4);
    tb2 = new TriangleButton(width-4, tituloH/2, width-tituloH+4, 4, width-tituloH+4, tituloH-4);
  }

  void drawParticleSquare(int x, int y, PGraphics pg, int pgX, int pgY) {
    this.x     = x;
    this.y     = y;
    this.realx = x+pgX;
    this.realy = y+pgY;
    pg.noStroke();
    pg.fill(100);
    pg.rect(x, y, radius, radius);
  }

  void drawDetailLinhas() {
    noStroke();
    fill(cDetailUniprot);
    rect(0, 0, linhasW, detalheHReal);

    int areaLivre = detalheH - tituloH - hsH;
    int recuoTexto = 15;
    textFont(font, 13);
    fill(cDetailProteinNovo);
    rect(0, tituloH+(areaLivre/5)*0, linhasW, (areaLivre/5));
    // fill(cDetailUniprot);
    rect(0, tituloH+(areaLivre/5)*1, linhasW, (areaLivre/5));
    // fill(cDetailProteinNovo);
    rect(0, tituloH+(areaLivre/5)*2, linhasW, (areaLivre/5));
    // fill(cDetailUniprot);
    rect(0, tituloH+(areaLivre/5)*3, linhasW, (areaLivre/5));
    // fill(cDetailProteinNovo);
    rect(0, tituloH+(areaLivre/5)*4, linhasW, (areaLivre/5));
    fill(0);
    text("EC Number", recuoTexto, tituloH+(areaLivre/5)*1-5);
    text("Reference Position", recuoTexto, tituloH+(areaLivre/5)*2-5);
    text("Organism Classification", recuoTexto, tituloH+(areaLivre/5)*3-5);
    text("Keyword", recuoTexto, tituloH+(areaLivre/5)*4-5);
  }

  void drawDetailTitulo(MudancaProteina mp) {
    textFont(font, 15);
    float textW = textWidth(iduniprot);
    int offset = 20;
    int rectX = (int) ((width-linhasW)/2 - textW/2 - offset)+linhasW;
    int rectH = tituloH;
    fill(cDetailUniprot);
    rect(rectX, 0, textW+2*offset, rectH);
    textAlign(CENTER);
    fill(0);
    text(iduniprot, rectX+textW/2+offset, 15);
    fill(cDetailProteinNovo);
    // fill(cDetailUniprot);
    rect(linhasW, 0, rectX-linhasW, rectH);
    fill(cDetailProteinAnt);
    rect(rectX+textW+2*offset, 0, width-(rectX+textW+2*offset), rectH);
    fill(cHistogramText);
    textFont(font, 12);
    text("Release " + (ver_estudo_navegacao-1), linhasW+(rectX-linhasW)/2, rectH/2+6);
    text("Release " + ver_estudo_navegacao, rectX+textW+2*offset+(width-(rectX+textW+2*offset))/2, rectH/2+6);
    textAlign(LEFT);
    color ctb1 = ver_estudo_navegacao == 2 ? cDetailProteinNovo : color(0);
    color ctb2 = ver_estudo_navegacao == 15 ? cDetailProteinAnt : color(0);
    tb1.draw(ctb1);
    tb2.draw(ctb2);
  }

  void drawDetailAnt(MudancaProteina mp) {
    textFont(font, 12);
    String ec_antS = "";
    for(int i=0; i<mp.ec_ant.length; i++) {
      ec_antS  += mp.ec_ant[i] == -1 ? "-" : mp.ec_ant[i];
      if(i<mp.ec_ant.length-1) {
        ec_antS += ".";
      }
    }

    float textW = textWidth(mp.rp_antes);
    if(textWidth(oc_antes)>textW) textW = textWidth(mp.oc_antes);
    if(textWidth(kw_antes)>textW) textW = textWidth(mp.kw_antes);
    textW += 0; // recuo do texto
    int areaLivreH = detalheH - tituloH - hsH;
    int areaLivreW = (width-linhasW)/2-20;
    float hsRecuo;
    if(textW > areaLivreW) hsRecuo = hs1.getPos()*((textW-areaLivreW+40));
    else hsRecuo = 0;
    if(recuoAntigo == -1) recuoAntigo = hsRecuo;
    // println("HS1P: " + hs2.getPos() + "\nALW: " + areaLivreW + "\nTw: " + textW +"\nRecuo: " + hsRecuo);
    PGraphics pg = createGraphics(areaLivreW, areaLivreH, JAVA2D);
    pg.beginDraw();
    pg.background(cDetailProteinAnt);
    pg.smooth();
    pg.fill(0);
    pg.textFont(font, 12);
    pg.text(ec_antS,  3, (areaLivreH/5)*1-5);
    pg.text(mp.rp_antes, 3-hsRecuo+recuoAntigo, (areaLivreH/5)*2-5);
    pg.text(mp.oc_antes, 3-hsRecuo+recuoAntigo, (areaLivreH/5)*3-5);
    pg.text(mp.kw_antes, 3-hsRecuo+recuoAntigo, (areaLivreH/5)*4-5);
    pg.endDraw();
    image(pg, linhasW+20, tituloH);

    if(hsRecuo > 0) {
      hs1.display();
      if(!hs2.locked) {
        hs1.update();
      }
    }
  }

  /* Pode ser refatorado pois é uma grande cópia do
   * método acima
   */
  void drawDetailNovo(MudancaProteina mp) {
    textFont(font, 12);
    String ec_novoS = "";
    for(int i=0; i<mp.ec_novo.length; i++) {
      ec_novoS  += mp.ec_novo[i] == -1 ? "-" : mp.ec_novo[i];
      if(i<mp.ec_novo.length-1) {
        ec_novoS += ".";
      }
    }

    float textW = textWidth(mp.rp_depois);
    if(textWidth(oc_depois)>textW) textW = textWidth(mp.oc_depois);
    if(textWidth(kw_depois)>textW) textW = textWidth(mp.kw_depois);
    textW += 0; // recuo do texto
    int areaLivreH = detalheH - tituloH - hsH;
    int areaLivreW = (width-linhasW)/2-20;
    float hsRecuo;
    if(textW > areaLivreW) hsRecuo = hs2.getPos()*((textW-areaLivreW+40));
    else hsRecuo = 0;
    if(recuoNovo == -1) recuoNovo = hsRecuo;
    // println("HS2P: " + hs2.getPos() + "\nALW: " + areaLivreW + "\nTw: " + textW +"\nRecuo: " + hsRecuo);
    PGraphics pg = createGraphics(areaLivreW, areaLivreH, JAVA2D);
    pg.beginDraw();
    pg.background(cDetailProteinNovo);
    pg.smooth();
    pg.fill(0);
    pg.textFont(font, 12);
    pg.text(ec_novoS,  3, (areaLivreH/5)*1-5);
    pg.text(mp.rp_depois, 3-hsRecuo+recuoNovo, (areaLivreH/5)*2-5);
    pg.text(mp.oc_depois, 3-hsRecuo+recuoNovo, (areaLivreH/5)*3-5);
    pg.text(mp.kw_depois, 3-hsRecuo+recuoNovo, (areaLivreH/5)*4-5);
    pg.endDraw();
    image(pg, (width-linhasW)/2+linhasW+20, tituloH);

    if(hsRecuo > 0) { 
      hs2.display();
      if(!hs1.locked) {
        hs2.update();
      }
    }
  }

  MudancaProteina buscaProteinaRelease(String iduniprot, int ver_estudo) {
    MudancaProteina mp = null;
    String selQuery = "select iduniprot, rp_antes, oc_antes, kw_antes, " +
                        "rp_depois, oc_depois, kw_depois, " +
                        "ec_ant0, ec_ant1, ec_ant2, ec_ant3, " +
                        "ec_novo0, ec_novo1, ec_novo2, ec_novo3 " +
                        "from id_ec_atributo_num " +
                        "where iduniprot  = '" + iduniprot + "' and " +
                             "ver_estudo  = " + ver_estudo + "";
    db.query(selQuery);
    while(db.next()) {
      mp = new MudancaProteina( this,
                                ver_estudo,
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
      println("Buscou proteina " + iduniprot + ", release " + ver_estudo);
    }
    return mp;
  }

  void drawDetail() {
    noStroke();
    fill(cDetailProteinNovo);
    rect(0, 0, width, detalheHReal);
    fill(cDetailProteinAnt);
    rect(0, 0, (width-linhasW)/2+linhasW, detalheHReal);

    if(mpList == null) {
      mpList = new ArrayList<MudancaProteina>();
      for(int i=0; i<numEstudos; i++) {
        MudancaProteina mp = buscaProteinaRelease(this.iduniprot, i+2);
        mpList.add(mp);
      }
    }

    textFont(font, 12);
    fill(cHistogramText);

    drawDetailLinhas();
    drawDetailTitulo(mpList.get(ver_estudo_navegacao-2));
    drawButtons();

    if(mpList.get(ver_estudo_navegacao-2) != null) {
      drawDetailAnt(mpList.get(ver_estudo_navegacao-2));
      drawDetailNovo(mpList.get(ver_estudo_navegacao-2));
    }
  }

  void isOverButtons() {
    if(tb1.isOver()) {
      if(ver_estudo_navegacao > 2) ver_estudo_navegacao--;
    }
    if(tb2.isOver()) {
      if(ver_estudo_navegacao < 15) ver_estudo_navegacao++;
    }
  }

  void resetVerEstudoNavegacao() {
    ver_estudo_navegacao = ver_estudo;
  }

  boolean mouseOver() {
    if((mouseX > realx && mouseX < realx+radius) &&
        (mouseY > realy && mouseY < realy+radius))
      return true;
    else return false;
  }

  class TriangleButton {
    int x1, y1, x2, y2, x3, y3;
    color cFill;

    TriangleButton(int x1, int y1, int x2, int y2, int x3, int y3) {
      this.x1 = x1;
      this.x2 = x2;
      this.x3 = x3;
      this.y1 = y1;
      this.y2 = y2;
      this.y3 = y3;
    }

    void draw(color cFill) {
      this.cFill = cFill;
      fill(this.cFill);
      triangle(x1, y1, x2, y2, x3, y3);
    }

    boolean isOver() {
      int rx = min(x1, min(x2, x3));
      int ry = min(y1, min(y2, y3));
      int rxMax = max(x1, max(x2, x3));
      int ryMax = max(y1, max(y2, y3));
      int rw = rxMax - rx;
      int rh = ryMax - ry;

      if((mouseX > rx && mouseX < rx+rw) &&
        (mouseY > ry && mouseY < ry+rh))
        return true;
      else return false;
    }
  }
}
