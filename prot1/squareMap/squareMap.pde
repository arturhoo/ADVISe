int width = 200;
int height = 200;

void setup() {
  size(width, height);
  frameRate(60);
  smooth();
  
  float[][] mat = new float[5][];
  float[][] mat2 = new float[5][];
    
  float[] a = {2.449489743,0,0,0,4.795831523};
  float[] b = {1.732050808,0,0,3.464101615,9.949874371};
  float[] c = {0,0,0,0,1.414213562};
  float[] d = {0,0,0,8.426149773,0};
  float[] e = {297.6205638,2.449489743,4,12.28820573,15.58845727};
  mat[0] = a;
  mat[1] = b;
  mat[2] = c;
  mat[3] = d;
  mat[4] = e;
  
  for(int i=0; i<5; i++) {
    for(int j=0; j<5; j++) {
      mat[i][j] = log(mat[i][j]);
    }
  }
  
  float[] y = new float[5];
  for (int count1 = 0; count1<5; count1++) {
    y[count1] = 0;
    for(int count2 = 0; count2<5; count2++) {
      if(y[count1] < mat[count2][count1]) y[count1] = mat[count2][count1];
    }
    print (y[count1] + " ");
  }
  print("\n");
  float[] x = new float[5];
  for (int count1 = 0; count1<5; count1++) {
    x[count1] = 0;
    for(int count2 = 0; count2<5; count2++) {
      if(x[count1] < mat[count1][count2]) x[count1] = mat[count1][count2];
    }
    print (x[count1] + " ");
  }
  
  float comp = 0;
  for (int i=0; i<y.length; i++) comp += y[i];
  float altura = 0;
  for (int i=0; i<x.length; i++) altura += x[i];
  float xpx = width/comp;
  float ypx = height/altura;

  fill(153);
  stroke(0);
  float xcount = 0;
  for(int i=0; i<5; i++) {
    float ycount = 0;
    for(int j=0; j<5; j++) {
      // Alinhar canto superior esquerdo
      //rect(ycount, xcount, mat[i][j]*xpx, mat[i][j]*ypx);
      // Alinhar canto superior direito
      rect(ycount+((ycount+y[j]*xpx)-(ycount+mat[i][j]*xpx)), xcount, mat[i][j]*xpx, mat[i][j]*ypx);
      ycount += y[j]*xpx;
    }
    xcount += x[i]*ypx;   
  }
  fill(106,78,19);
  stroke(106,78,19);
  line(0, height, width, 0);
}

void draw() {


}
