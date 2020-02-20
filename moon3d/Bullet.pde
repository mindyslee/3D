class Bullet {

  float x, y, z, vx, vy, vz;

  Bullet(float _x, float _y, float _z, float _vx, float _vy, float _vz) {
    x = _x;
    y = _y;
    z = _z;
    vx = _vx;
    vz = _vz;
    vy = _vy;
  }

  void show() {

    pushMatrix();
    translate(x, y, z);
    fill(#F20C0C);
    sphere(10);
    popMatrix();
  }

  void act() {
    x = x + vx;
    z = z + vz;
    y = y +vy;

    if (y>bs/2) {
      bullets.remove(this);
    }
  }
}
