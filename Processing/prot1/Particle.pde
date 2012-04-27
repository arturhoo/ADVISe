class Particle {
	PVector loc, vel, acc;
	float pRadius;

	Particle(PVector loc) {
		this.acc = new PVector(0,0,0);
		this.vel = new PVector(random(-1,1), random(-1,1), 0);
		this.loc = loc.get();
		this.pRadius = 10;
	}

  void run(PVector loc) {
    update(loc);
    render();
  }

  void update(PVector loc) {
    this.loc = loc.get();
  }

  void madnessRun(){
    madnessUpdate();
    render();
  }

	void madnessUpdate(){
		// Define nova aceleração
		acc.set(random(-0.16, 0.16), random(-0.16, 0.16), 0);

		// Se esta muito rapida
		if (abs(vel.x) > 5 || abs(vel.y) > 5) vel.mult(0.5);	
    
    // Define nova velocidade e localização
    vel.add(acc);
    loc.add(vel);
    // Retire quando tentar escapar
    if (loc.x > width || loc.x < 0) vel.x *= -1;
    if (loc.y > height || loc.y < 0) vel.y *= -1;
	}

  void render() {
    ellipseMode(CENTER);
    stroke(10, 10, 10);
    fill(12, 106, 17, 95);
    ellipse(loc.x, loc.y, pRadius, pRadius);
  }
}