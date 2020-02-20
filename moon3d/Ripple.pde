

class Ripple {
  float x, y, z, r, alpha;
  Ripple (float _x, float _z) {
    x = _x;
    y = bs/2;
    z = _z;
    r = 0;
    alpha = 255;
  }
  void show() {
    fill(#AED9F0, alpha);
    pushMatrix();
    translate(x, y, z);
    rotateX(PI/2);
    ellipse(0, 0, 2+r, 2+r);

    popMatrix();
  }
  void act() {
    r = r +5;
    alpha = alpha -5;
    if (alpha <= 0)ripple.remove(this);
  }
}

//    ellipse(0,0,2*r,2);
