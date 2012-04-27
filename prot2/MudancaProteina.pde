class MudancaProteina {
  int x, y, realx, realy;
  float radius;

  int prefixo;
  int ver_estudo;
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
  int detalheH      = 130;
  int detalheHReal  = detalheH - 10;
  int linhasW       = 175;
  int tituloH       = 20;
  int hsH           = 10;
  float recuoNovo   = -1; // para compensar o valor nao 0.0 da hs
  float recuoAntigo = -1; // para compensar o valor nao 0.0 da hs

  boolean detalhe = false;

  ArrayList<MudancaProteina> mpList;

  MudancaProteina ( Nivel2 nivel2,    String iduniprot, 
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

    hs1 = new HScrollbar(linhasW, detalheHReal-10, (width-linhasW)/2, hsH, 10);
    hs2 = new HScrollbar((width-linhasW)/2+linhasW, detalheHReal-10, (width-linhasW)/2, hsH, 10);

    this.mpList = new ArrayList<MudancaProteina>();
  }

  void preencheMPList() {
    for(int i=0; i<numEstudos; i++) {
            
    }
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

  void drawDetailTitulo() {
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
    textAlign(LEFT);
    // fill(cDetailProteinNovo);
    fill(cDetailUniprot);
    rect(linhasW, 0, rectX-linhasW, rectH);
    // fill(cDetailProteinAnt);
    rect(rectX+textW+2*offset, 0, width-(rectX+textW+2*offset), rectH);
  }

  void drawDetailAnt() {
    textFont(font, 12);
    String ec_antS = "";
    for(int i=0; i<ec_ant.length; i++) {
      ec_antS  += ec_ant[i] == -1 ? "-" : ec_ant[i];
      if(i<ec_ant.length-1) {
        ec_antS += ".";
      }
    }

    float textW = textWidth(rp_antes);
    if(textWidth(oc_antes)>textW) textW = textWidth(oc_antes);
    if(textWidth(kw_antes)>textW) textW = textWidth(kw_antes);
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
    pg.text(rp_antes, 3-hsRecuo+recuoAntigo, (areaLivreH/5)*2-5);
    pg.text(oc_antes, 3-hsRecuo+recuoAntigo, (areaLivreH/5)*3-5);
    pg.text(kw_antes, 3-hsRecuo+recuoAntigo, (areaLivreH/5)*4-5);
    pg.endDraw();
    image(pg, linhasW+20, tituloH);
  }

  /* Pode ser refatorado pois é uma grande cópia do
   * método acima
   */
  void drawDetailNovo() {
    textFont(font, 12);
    String ec_novoS = "";
    for(int i=0; i<ec_novo.length; i++) {
      ec_novoS  += ec_novo[i] == -1 ? "-" : ec_novo[i];
      if(i<ec_novo.length-1) {
        ec_novoS += ".";
      }
    }

    float textW = textWidth(rp_depois);
    if(textWidth(oc_depois)>textW) textW = textWidth(oc_depois);
    if(textWidth(kw_depois)>textW) textW = textWidth(kw_depois);
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
    pg.text(rp_depois, 3-hsRecuo+recuoNovo, (areaLivreH/5)*2-5);
    pg.text(oc_depois, 3-hsRecuo+recuoNovo, (areaLivreH/5)*3-5);
    pg.text(kw_depois, 3-hsRecuo+recuoNovo, (areaLivreH/5)*4-5);
    pg.endDraw();
    image(pg, (width-linhasW)/2+linhasW+20, tituloH);
  }

  void drawDetail() {
    noStroke();
    fill(cDetailProteinNovo);
    rect(0, 0, width, detalheHReal);
    fill(cDetailProteinAnt);
    rect(0, 0, (width-linhasW)/2+linhasW, detalheHReal);

    textFont(font, 12);
    fill(cHistogramText);

    drawDetailLinhas();
    drawDetailTitulo();

    String ec_antS = "", ec_novoS = "";
    for(int i=0; i<ec_ant.length; i++) {
      ec_antS  += ec_ant[i] == -1 ? "-" : ec_ant[i];
      ec_novoS += ec_novo[i] == -1 ? "-" : ec_novo[i];
      if(i<ec_ant.length-1) {
        ec_antS += ".";
        ec_novoS += ".";
      }
    }

    drawDetailAnt();
    drawDetailNovo();

    hs1.display();
    hs2.display();
    if(!hs2.locked) {
      hs1.update();
    }
    if(!hs1.locked) {
      hs2.update();
    }
  }

  boolean mouseOver() {
    if((mouseX > realx && mouseX < realx+radius) &&
        (mouseY > realy && mouseY < realy+radius))
      return true;
    else return false;
  }
}
