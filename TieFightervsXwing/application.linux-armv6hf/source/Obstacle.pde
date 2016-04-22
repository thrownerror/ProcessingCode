//Robert Bailey HvZB
//Creates an obstacle.  They don't do much besides exist.
//The obstacels now look like asterioids.  Largely unchanged from HvZA, just with more PShapes
class Obstacle {
  float radius;
  PVector position;
  PShape body;
  Obstacle(float rad, float pX, float pY)
  {

    position = new PVector(pX, pY);
    radius = rad;
    fill(139, 69, 19);

    body = createShape();
    body.beginShape();
    body.vertex(0, 4.75);
    body.vertex(-1.8,4);
      body.vertex(-3.2,3);
      body.vertex(-4.1,2.8);
      body.vertex(-5.4,1.5);
      body.vertex(-4,.5);
      body.vertex(-4.1,-.5);
      body.vertex(-3.9,-1.9);
      body.vertex(-4,-3);
      body.vertex(-4.5,-4);
      body.vertex(-3,-4.2);
      body.vertex(-1.5,-4.3);
      body.vertex(0,-5);
      body.vertex(1,-4.75);
      body.vertex(2,-4);
      body.vertex(2.9,-2.8);
      body.vertex(4.1,-3.1);
      body.vertex(4.2,-1.25);
      body.vertex(4.8,-.8);
      body.vertex(5,0);
      body.vertex(4.6,1.2);
      body.vertex(4.1,1.95);
      body.vertex(3.8,3);
      body.vertex(2.35,4.5);
      body.vertex(1.2,4.1);
      body.vertex(0,4.75);
      body.endShape();
  }
  void display()
  {
    pushMatrix();
    translate(position.x,position.y);
    scale(radius);
    shape(body);
    popMatrix();
    //ellipse(position.x, position.y, radius, radius);
  }

  void ToString()
  {
    //To string for debug
    println(radius + " " + position.x + " " + position.y);
  }
}