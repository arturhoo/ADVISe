class MudancaProteina {
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

  MudancaProteina ( Nivel2 nivel2,    String iduniprot, 
                    String rp_antes,  String oc_antes,  String kw_antes,
                    String rp_depois, String oc_depois, String kw_depois) {
    this.prefixo      = nivel2.prefixo;
    this.ver_estudo   = nivel2.ver_estudo;
    this.subidas      = nivel2.subidas;
    this.descidas     = nivel2.descidas;
    this.ec_ant       = nivel2.ec_ant;
    this.ec_novo      = nivel2.ec_novo;

    this.iduniprot  = iduniprot;
    this.rp_antes   = rp_antes;
    this.oc_antes   = oc_antes;
    this.kw_antes   = kw_antes;
    this.rp_depois  = rp_depois;
    this.oc_depois  = oc_depois;
    this.kw_depois  = kw_depois;
  }
}
