Boid[] flock;

float alignValue = 0.75;
float cohesionValue = 1;
float seperationValue = 1.075;
int boidCount = 800;
int perceptionRadius = 50;
float maxForce = 1;
float maxSpeed = 5;
PFont font;
double timeScale = 0.5;

boolean recording = false;

void setup() {
  fullScreen(P2D);
  frameRate(144);
  font = createFont("Arial Bold",48);
  colorMode(RGB);
  flock = new Boid[boidCount];
  for (int i = 0; i < flock.length; i++) {
    flock[i] = new Boid();
  }
  maxForce = (float) (maxForce * timeScale);
  maxSpeed = (int) (maxSpeed * timeScale);
}

void draw() {
  background(0);
  
  for (Boid boid : flock) {
    boid.edges();
    boid.flock(flock);
    boid.update();
    boid.show();
  }
  
  if(recording)
    saveFrame("frames/######.png");
}
