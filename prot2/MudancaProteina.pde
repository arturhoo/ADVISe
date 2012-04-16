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
  }

  void drawParticle(int x, int y) {
    this.x = x;
    this.y = y;
    stroke(10, 10, 10);
    fill(cElipse);
    ellipse(this.x, this.y, radius, radius);
  }

  boolean mouseOver() {
    if(((mouseX - x)*(mouseX - x) + (mouseY - y)*(mouseY - y)) <= (radius*radius))
      return true;
    else return false;
  }
}
