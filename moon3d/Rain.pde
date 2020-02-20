class Rain {

  float x, y, z, vy, vx, vz;
  float s;

  Rain() {

    s = random(0, 100);
    y = -1500;
    z = random(0, 5000);
    x = random(0, 5000);
    s = 15;

    vy = 5;
  }

  void show() {
    pushMatrix();
    translate (x, y, z);
    fill (255);
    sphere (s);
    popMatrix();
  }

  void act() {
    x = x + vx;
    y = y + vy;
    z = z + vz; 

    if (y>bs/2) {
      ripple.add(new Ripple(x, z));
      raindrops.remove(this);
    }
  }
}
