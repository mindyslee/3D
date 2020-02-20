ArrayList<Bullet> bullets;
ArrayList<Rain> raindrops;
ArrayList<Ripple> ripple;

//keyboard interaction
boolean up, down, left, right, space;

//World manipulation
int bs = 100;

//camera variables
float lx = 2500, ly = height/2 - bs/2, lz = 2500;
PVector xzDirection = new PVector(0, -10); //which way we are facing
PVector xyDirection = new PVector(0, -10);  //for looking up and down
PVector strafeDir   = new PVector(10, 0);
float leftRightHeadAngle = 0;
float upDownHeadAngle    = 0;


//color pallette
color black = #000000;
color white = #FFFFFF;

PImage map;
PImage galaxy;

//textures
PImage qblock, dT, dS, dB;

boolean pressed;

void setup() {
  size(1200, 1000, P3D);

  //load textures
  qblock = loadImage("qblock.png");
  dT     = loadImage("dirt_top.jpg");
  dS     = loadImage("dirt_top.jpg");
  dB     = loadImage("dirt_top.jpg");
  galaxy = loadImage("galaxy2.jpg");

  textureMode(NORMAL);

  //load map
  map         = loadImage("map.png");

  bullets   = new ArrayList<Bullet>();
  raindrops = new ArrayList<Rain>();
  ripple    = new ArrayList<Ripple>();

  pressed = false;

  imageMode(CENTER);
}

void draw() {

  background(0);

  pushMatrix();
  translate(2484, -2.9, 2493);
  //image(galaxy, 0, 0);

  popMatrix();


  if (pressed) {
    bullets.add(new Bullet(lx, ly, lz, xzDirection.x, xyDirection.y, xzDirection.y));
  }

  float dx = lx+xzDirection.x;
  float dy = ly+ xyDirection.y;
  float dz = xzDirection.y+lz;
  camera(lx, ly, lz, dx, dy, dz, 0, 1, 0); 
  xzDirection.rotate(leftRightHeadAngle);
  xyDirection.rotate(upDownHeadAngle);
  float piOverHeight = PI/height;
  leftRightHeadAngle = -(pmouseX - mouseX) * 0.01;
  upDownHeadAngle    = -(pmouseY - mouseY) * piOverHeight;

  //headAngle = headAngle + 0.01;

  strafeDir = xzDirection.copy();
  strafeDir.rotate(PI/2);
  
    drawMap();
  drawFloor();  
  drawBullets();
  drawRain();
  drawRipple();
  raindrops.add(new Rain());

  if (up) {
    //if (map.get((lx + xzDirection.x)/bs, (lz + xzDirection.y)/bs) != black) {
    lx = lx + xzDirection.x;
    lz = lz + xzDirection.y;
    }
 // }
  if (down) {
    lx = lx - xzDirection.x;
    lz = lz - xzDirection.y;
  }
  if (left) {
    lx = lx - strafeDir.x;
    lz = lz - strafeDir.y;
  }
  if (right) {
    lx = lx + strafeDir.x;
    lz = lz + strafeDir.y;
  }

  //direction.rotate(-(pmouseX - mouseX) * 0.01);
}

void drawBullets() {
  int i = 0;
  while (i < bullets.size()) {
    Bullet b = bullets.get(i);
    b.act();
    b.show();
    i++;
  }
}

void drawRain() {
  int i = 0;
  while (i < raindrops.size()) {
    Rain r = raindrops.get(i);
    r.act();
    r.show();
    i++;
  }
}
void drawRipple() {
  int i = 0;
  while (i < ripple.size()) {
    Ripple e = ripple.get(i);
    e.act();
    e.show();
    i++;
  }
}


void drawFloor() {
  int x = 0;
  int y = 0 + bs/2;
  stroke(100);
  strokeWeight(1);
  while (x < map.width*bs) {
    line(x, y, 0, x, y, map.height*bs);
    x = x + bs;
  }

  int z = 0;
  while (z < map.height*bs) {
    line(0, y, z, map.width*bs, y, z);
    z = z + bs;
  }

  noStroke();
}



void drawMap() {
  int mapX = 0, mapY = 0;
  int worldX = 0, worldZ = 0;

  while ( mapY < map.height ) {
    //read in a pixel
    color pixel = map.get(mapX, mapY);

    worldX = mapX * bs;
    worldZ = mapY * bs;

    if (pixel == black) {
      texturedBox(dT, dS, dB, worldX, 0, worldZ, bs/2);
    }


    mapX++;
    if (mapX > map.width) {
      mapX = 0; //go back to the start of the row
      mapY++;   //go down to the next row
    }
  }
}

void texturedBox(PImage top, PImage side, PImage bottom, float x, float y, float z, float size) {
  pushMatrix();
  translate(x, y, z);
  scale(size);

  //rotateX(rotx);
  //rotateY(roty);

  beginShape(QUADS);
  noStroke();
  texture(side);

  // +Z Front Face
  vertex(-1, -1, 1, 0, 0);
  vertex( 1, -1, 1, 1, 0);
  vertex( 1, 1, 1, 1, 1);
  vertex(-1, 1, 1, 0, 1);

  // -Z Back Face
  vertex(-1, -1, -1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1, 1, -1, 1, 1);
  vertex(-1, 1, -1, 0, 1);

  // +X Side Face
  vertex(1, -1, 1, 0, 0);
  vertex(1, -1, -1, 1, 0);
  vertex(1, 1, -1, 1, 1);
  vertex(1, 1, 1, 0, 1);

  // -X Side Face
  vertex(-1, -1, 1, 0, 0);
  vertex(-1, -1, -1, 1, 0);
  vertex(-1, 1, -1, 1, 1);
  vertex(-1, 1, 1, 0, 1);

  endShape();

  beginShape();
  texture(bottom);

  // +Y Bottom Face
  vertex(-1, 1, -1, 0, 0);
  vertex( 1, 1, -1, 1, 0);
  vertex( 1, 1, 1, 1, 1);
  vertex(-1, 1, 1, 0, 1);

  endShape();

  beginShape();
  texture(top);

  // -Y Top Face
  vertex(-1, -1, -1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1, -1, 1, 1, 1);
  vertex(-1, -1, 1, 0, 1);

  endShape();

  popMatrix();
}

void keyPressed() {
  if (keyCode == UP)    up = true;
  if (keyCode == DOWN)  down = true;
  if (keyCode == LEFT)  left = true;
  if (keyCode == RIGHT) right = true;
  if (key == ' ') space = true;
}

void keyReleased() {
  if (keyCode == UP)    up = false;
  if (keyCode == DOWN)  down = false;
  if (keyCode == LEFT)  left = false;
  if (keyCode == RIGHT) right = false;
  if (key == ' ') space = false;
}

void mouseDragged() {


  //  rotx = rotx + (pmouseY - mouseY) * 0.01;
  //  roty = roty - (pmouseX - mouseX) * 0.01;
}
