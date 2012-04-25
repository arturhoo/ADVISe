class MudancaProteina {
  int x, y;
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
  int detalheH = 130;

  boolean detalhe = false;

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

    hs1 = new HScrollbar(0, detalheH-10, width/2, 10, 16);
  }

  void drawParticle(int x, int y) {
    this.x = x;
    this.y = y;
    stroke(10, 10, 10);
    fill(cElipse);
    ellipse(this.x, this.y, radius, radius);
  }

  void drawParticleSquare(int x, int y) {
    this.x = x;
    this.y = y;
    // stroke(10, 10, 10);
    noStroke();
    fill(100);
    rect(x, y, radius, radius);
  }

  void drawDetail() {
    noStroke();
    fill(cProteinNovo);
    rect(0, 0, width, detalheH);
    fill(cProteinAnt);
    rect(0, 0, width/2, detalheH);

    textFont(font, 12);
    fill(cHistogramText);

    String ec_antS = "", ec_novoS = "";
    for(int i=0; i<ec_ant.length; i++) {
      ec_antS  += ec_ant[i] == -1 ? "-" : ec_ant[i];
      ec_novoS += ec_novo[i] == -1 ? "-" : ec_novo[i];
      if(i<ec_ant.length-1) {
        ec_antS += ".";
        ec_novoS += ".";
      }
    }
    textLeading(12);
    float textW = textWidth(rp_antes);
    if(textWidth(oc_antes)>textW) textW = textWidth(oc_antes);
    if(textWidth(kw_antes)>textW) textW = textWidth(kw_antes);
    textW += 100;
    float recuo;
    if(textW > width/2-50) recuo = hs1.getPos()*(textW-width/2);
    else recuo = 0;
    println("Tw: " + textW +"\nRecuo: " + recuo);
    PGraphics pg = createGraphics(width/2, detalheH, JAVA2D);
    pg.beginDraw();
    pg.background(cProteinAnt);
    pg.smooth();
    pg.fill(0);
    pg.textFont(font, 12);
    pg.text("iduniprot: " + iduniprot, 20-recuo, 20);
    pg.text("ec_ant: " + ec_antS, 20-recuo, 32);
    pg.text("rp_antes: " + rp_antes, 20-recuo, 44);
    pg.text("oc_antes: " + oc_antes, 20-recuo, 56);
    pg.text("kw_antes: " + kw_antes, 20-recuo, 68);
    pg.endDraw();
    image(pg, 0, 0);

    text("iduniprot: " + iduniprot, width/2+20, 20, 600, 17);
    text("ec_novo: " + ec_novoS, width/2+20, 32, 600, 17);
    text("rp_depois: " + rp_depois, width/2+20, 44, 600, 17);
    text("oc_depois: " + oc_depois, width/2+20, 56, 600, 17);
    text("kw_depois: " + kw_depois, width/2+20, 68, 600, 17);

    hs1.update();
    hs1.display();
  }

  boolean mouseOver() {
    if((mouseX > x && mouseX < x+radius) &&
        (mouseY > y && mouseY < y+radius))
      return true;
    else return false;
  }
}
