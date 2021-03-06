class SparkLine {
  int[] valores = { 153871, 163235, 168297, 
                    181571, 194317, 207132, 
                    222289, 241242, 260175, 
                    269293, 276256, 356194, 
                    392667, 428650};
  float[] valoresNormalizados;
  int x, y, w, h;

  SparkLine(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    // Proporcionaliza para se alinhar com os quadrados
    this.x = this.x + w/valores.length/2;
    this.w = this.w - w/valores.length;

    this.valoresNormalizados = new float[valores.length];
    int menorValor = this.valores[0];
    int maiorValorPreNormalizado = this.valores[numEstudos-1]-menorValor;
    for(int i=0; i<this.valores.length; i++) {
      this.valoresNormalizados[i] = (float) (this.valores[i]-menorValor)/maiorValorPreNormalizado;
    }
  }

  void imprimeValoresNormalizados() {
    for(int i=0; i<this.valores.length; i++) {
      print(this.valoresNormalizados[i] + ", ");
    }
    print("\n");
  }

  void drawSparkLine () {
    int[] pontos = new int[valores.length];
    pontos[0] = 0;
    int espacamento = w/(pontos.length-1);
    for(int i=1; i<pontos.length; i++) {
      pontos[i] = pontos[i-1] + espacamento;
    }
    // pontos[pontos.length] = w;
    strokeWeight(2);
    for(int i=0; i<pontos.length-1; i++) {
      stroke(cSparkLine);
      line(x+pontos[i], y+h-(h*valoresNormalizados[i])-3, x+pontos[i], y+h-(h*valoresNormalizados[i])+3);
      line(x+pontos[i+1], y+h-(h*valoresNormalizados[i+1])-3, x+pontos[i+1], y+h-(h*valoresNormalizados[i+1])+3);
      line(x+pontos[i], y+h-(h*valoresNormalizados[i]), x+pontos[i+1], y+h-(h*valoresNormalizados[i+1]));
    }
    strokeWeight(1);
  }
}
