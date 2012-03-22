int getIntFromEcPosition(String ec, int pos) {
  int prev_pos = 0;
  int ccursor = 0;
  int counter = 0;
  String ec_mod = ec + ".";
  while(true) {
    if(ec_mod.charAt(ccursor) == '.') {
      if(counter == pos) {
        String ssubstring = "" + ec_mod.substring(prev_pos, ccursor);
        if(ssubstring.equals("-")) return -1;
        else return Integer.parseInt(ssubstring);
      }
      prev_pos = ccursor+1;
      counter++;      
    }
    ccursor++;
  }
}
      
    
    
  
