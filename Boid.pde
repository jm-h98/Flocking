class Boid {
  PVector position;
  PVector velocity;
  PVector acceleration;
  int col = 255;
  private ArrayList<PVector> tail = new ArrayList<PVector>();
  private int tailLength = 10, size = 5;
  
  Boid() {
    this.position = new PVector(random(width), random(height));
    this.velocity = PVector.random2D();
    this.velocity.setMag(random(2, maxSpeed));
    this.acceleration = new PVector();
    
    for(int i = 0; i < tailLength; i++){
      tail.add(new PVector(this.position.x, this.position.y));
    }
  }

  void edges() {
    if (this.position.x > width) {
      this.position.x = 0;
    } else if (this.position.x < 0) {
      this.position.x = width;
    }
    if (this.position.y > height) {
      this.position.y = 0;
    } else if (this.position.y < 0) {
      this.position.y = height;
    }
  }

  PVector align(Boid[] boids) {
    PVector steering = new PVector();
    int total = 0;
    for (Boid other: boids) {
      float d = dist(this.position.x, this.position.y, other.position.x, other.position.y);
      if (other != this && d < perceptionRadius) {
        steering.add(other.velocity);
        total++;
      }
    }
    if (total > 0) {
      steering.div(total);
      steering.setMag(maxSpeed);
      steering.sub(this.velocity);
      steering.limit(maxForce);
    }
    return steering;
  }

  PVector separation(Boid[] boids) {
    PVector steering = new PVector();
    int total = 0;
    for (Boid other: boids) {
      float d = dist(this.position.x, this.position.y, other.position.x, other.position.y);
      if (other != this && d < perceptionRadius) {
        PVector diff = PVector.sub(this.position, other.position);
        diff.div(d * d);
        steering.add(diff);
        total++;
      }
    }
    if (total > 0) {
      steering.div(total);
      steering.setMag(maxSpeed);
      steering.sub(this.velocity);
      steering.limit(maxForce);
    }
    return steering;
  }

  PVector cohesion(Boid[] boids) {
    PVector steering = new PVector();
    int total = 0;
    for (Boid other: boids) {
      float d = dist(this.position.x, this.position.y, other.position.x, other.position.y);
      if (other != this && d < perceptionRadius) {
        steering.add(other.position);
        total++;
      }
    }
    if (total > 0) {
      steering.div(total);
      steering.sub(this.position);
      steering.setMag(maxSpeed);
      steering.sub(this.velocity);
      steering.limit(maxForce);
    }
    return steering;
  }

  void flock(Boid[] boids) {
    PVector alignment = this.align(boids);
    PVector cohesion = this.cohesion(boids);
    PVector separation = this.separation(boids);

    alignment.mult(alignValue);
    cohesion.mult(cohesionValue);
    separation.mult(seperationValue);

    this.acceleration.add(alignment);
    this.acceleration.add(cohesion);
    this.acceleration.add(separation);
  }

  void update() {
    ArrayList<PVector> temp = tail;
    tail = new ArrayList<PVector>();
    tail.add(new PVector(this.position.x, this.position.y));
    for(int i = 0; i < tailLength; i++){
      tail.add(new PVector(temp.get(i).x, temp.get(i).y));
    }
    
    this.position.add(this.velocity);
    this.velocity.add(this.acceleration);
    this.velocity.limit(maxSpeed);
    this.acceleration.mult(0);
  }

  void show() {
    for(int i = tail.size() - 1; i > 0; i--){
      int s = size - ((size/tailLength) * i);
      strokeWeight(s);
      int hue = 255 - ((255/tailLength) * i);
      stroke(hue);
      point(tail.get(i).x, tail.get(i).y);
    }
    
    strokeWeight(size + 2);
    stroke(col);
    point(this.position.x, this.position.y);
  }
}
