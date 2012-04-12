class ParticleSystem {

  ArrayList particles;
  PVector origin;
  int horizontalEscape = 0, verticalEscape = 0;
  int horizontalSpacing = 12, verticalSpacing = 12;


  ParticleSystem(int num, PVector v) {
    particles = new ArrayList();
    origin = v.get();
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(origin));
    }
  }

  void run(PVector loc) {
    horizontalEscape = 0;
    verticalEscape = 0;

    for (int i=0; i<particles.size(); i++) {
      Particle p = (Particle) particles.get(i);
      PVector actualLoc = new PVector(loc.x, loc.y, 0);
      
      actualLoc.add((horizontalEscape++)*horizontalSpacing, verticalEscape*verticalSpacing, 0);
      p.run(actualLoc);
      if(horizontalEscape > 40) {
        horizontalEscape = 0;
        verticalEscape++;
      }
    }
  }

  void addParticle() {
    particles.add(new Particle(origin));
  }
  
  void addParticle(float x, float y) {
    particles.add(new Particle(new PVector(x,y)));
  }

}