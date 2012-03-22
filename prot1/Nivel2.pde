class Nivel2 {
  int numElementos;
  int prefixo;
  int ver_estudo;
  int subidas;
  int descidas;
  int[] ec_ant;
  int[] ec_novo;
  
  Nivel2 (Nivel1 nivel1, String ec_ant, String ec_novo, int numElementos) {
    this.numElementos = numElementos;
    this.prefixo      = nivel1.prefixo;
    this.ver_estudo   = nivel1.ver_estudo;
    this.subidas      = nivel1.subidas;
    this.descidas     = nivel1.descidas;
    this.ec_ant       = new int[4];
    this.ec_novo      = new int[4];
    for(int count=0; count<4; count++) {
      if(ec_ant.charAt(count*2) == '-') this.ec_ant[count] = -1;
      else this.ec_ant[count]  = Integer.parseInt("" + ec_ant.charAt(count*2));
      if(ec_novo.charAt(count*2) == '-') this.ec_novo[count] = -1;
      else this.ec_novo[count] = Integer.parseInt("" + ec_novo.charAt(count*2));
    }
  }    
}
