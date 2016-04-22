//Robert Bailey HvZB
//Purpose: Creates a zombie for the HvZ simulation.  It will win.  It cannot be stopped.  It may be Megatron.
//Look down, now up.  The zombies are now tiefighters
class Zombie extends Vehicle {
  //Zombies be hungry
  Human targetFood = null;
  PVector target = null;
  //PShape to draw this seeker object
  PShape body;
  PShape lWing;
  PShape rWing;
  PShape fullShip;
  //overall steering force for this Seeker accumulates the steering forces
  //  of which this will be applied to the vehicle's acceleration
  PVector steeringForce;
  //PVector target;
  PVector obstacleDodging;

  //---------------------------------------
  //Constructor
  //Seeker(x position, y position, radius, max speed, max force)
  //---------------------------------------
  Zombie(float x, float y, float r, float ms, float mf) 
  {
    //call the super class' constructor and pass in necessary arguments

    super(x, y, r, ms, mf);

    // target = new PVector(mouseX, mouseY);
    // println(this.position.x);

    //instantiate steeringForce vector to (0, 0)
    steeringForce = new PVector(0, 0);

    obstacleDodging = new PVector(0, 0);
    fill(144, 144, 144);
    fullShip = createShape(GROUP);
    lWing = createShape();
    lWing.beginShape();
    lWing.vertex(-6, 12.5);
    lWing.vertex(-9, 9.5);
    lWing.vertex(-10, 7.5);
    lWing.vertex(-10, 4.5);
    lWing.vertex(-10, 2.5);
    lWing.vertex(-11, 1.5);
    lWing.vertex(-11, -1.5);
    lWing.vertex(-10, -2.5);
    lWing.vertex(-10, 2.5);
    lWing.vertex(-10, -4.5);
    lWing.vertex(-10, -7.5);
    lWing.vertex(-9, -9.5);
    lWing.vertex(-6, -12.5);
    lWing.vertex(-6.75, -10.5);
    lWing.vertex(-7.25, -10.25);
    lWing.vertex(-7.5, -6.5);
    lWing.vertex(-7.5, -1.5);
    lWing.vertex(-5, -1.5);
    lWing.vertex(-5, 1.5);
    lWing.vertex(-7.5, 1.5);
    lWing.vertex(-7.5, 6.5);
    lWing.vertex(-7.25, 8.75);
    lWing.vertex(-5.75, 10.5);
    lWing.vertex(-6, 12.5);
    lWing.endShape(CLOSE);

    rWing = createShape();
    rWing.beginShape();
    rWing.vertex(6, 12.5);
    rWing.vertex(9, 9.5);
    rWing.vertex(10, 7.5);
    rWing.vertex(10, 4.5);
    rWing.vertex(10, 2.5);
    rWing.vertex(11, 1.5);
    rWing.vertex(11, -1.5);
    rWing.vertex(10, -2.5);
    rWing.vertex(10, 2.5);
    rWing.vertex(10, -4.5);
    rWing.vertex(10, -7.5);
    rWing.vertex(9, -9.5);
    rWing.vertex(6, -12.5);
    rWing.vertex(6.75, -10.5);
    rWing.vertex(7.25, -10.25);
    rWing.vertex(7.5, -6.5);
    rWing.vertex(7.5, -1.5);
    rWing.vertex(5, -1.5);
    rWing.vertex(5, 1.5);
    rWing.vertex(7.5, 1.5);
    rWing.vertex(7.5, 6.5);
    rWing.vertex(7.25, 8.75);
    rWing.vertex(5.75, 10.5);
    rWing.vertex(6, 12.5);
    rWing.endShape(CLOSE);


    body = createShape();
    body.beginShape();
    body.vertex(0, 7.5);
    body.vertex(-1, 7.17);
    body.vertex(-2, 6.5);
    body.vertex(-3, 5.5);
    body.vertex(-4, 4.4);
    body.vertex(-4.5, 3.5);
    body.vertex(-5, 2.5);
    body.vertex(-5.5, 1.5);
    body.vertex(-5.8, .5);

    body.vertex(-6, 0);

    body.vertex(-5.8, -.5);
    body.vertex(-5.5, -1.5);
    body.vertex(-5, -2.5);
    body.vertex(-4.5, -3.5);
    body.vertex(-4, -4.6);
    body.vertex(-3, -5.5);
    body.vertex(-2, -6.5);
    body.vertex(-1, -7.16);

    body.vertex(0, -7.5);

    body.vertex(1, -7.16);
    body.vertex(2, -6.5);
    body.vertex(3, -5.5);
    body.vertex(4, -4.6);
    body.vertex(4.5, -3.5);
    body.vertex(5, -2.5);
    body.vertex(5.5, -1.5);
    body.vertex(5.8, -.5);

    body.vertex(6, 0);

    body.vertex(5.8, .5);
    body.vertex(5.5, 1.5);
    body.vertex(5, 2.5);
    body.vertex(4.5, 3.5);
    body.vertex(4, 4.4);
    body.vertex(3, 5.5);
    body.vertex(2, 6.5);
    body.vertex(1, 7.17);

    body.vertex(0, 7.5);
    body.endShape(CLOSE);

    fullShip.addChild(lWing);
    fullShip.addChild(rWing);
    fullShip.addChild(body);
    
    safeDistance = r+r;  //since it's slower, it can cut more corners
  }




  //Method: calcSteeringForces()
  //Purpose: Based upon the specific steering behaviors this Seeker uses
  //         Calculates all of the resulting steering forces
  //         Applies each steering force to the acceleration
  //         Resets the steering force
  void calcSteeringForces() 
  {

    PVector newSteeringForce = new PVector(0, 0);
    pickTarget(hs);
    if (targetFood != null)
    {
      target = targetFood.position.copy();
    }
    if (target != null)
    {
      pursueTarget(targetFood);
      //out of bounds correction - seek center
      newSteeringForce = seek(target);
      //   PVector jim = new PVector(mouseX, mouseY);
      // newSteeringForce = seek(jim);
      if (hs.size() == 0)
      {
        PVector noFood = wander();
        newSteeringForce = seek(noFood);
      }

      if (position.x <70 || position.x > width-70 || position.y < 70 || position.y > height - 70)
      {
        target.x = width/2;
        target.y = height/2;
        newSteeringForce = seek(target);
        // newSteeringForce.mult(10);
      }
    }
    if (hs.size() == 0)
    {
      PVector justWander = wander();
      newSteeringForce = seek(justWander);

      if (position.x <70 || position.x > width-70 || position.y < 70 || position.y > height - 70)
      {
        target = new PVector(0, 0);
        target.x = width/2;
        target.y = height/2;
        newSteeringForce = seek(target);
        // newSteeringForce.mult(10);
      }
    }


    //get the steering force returned from calling seek
    //PVector obstacleDodging;
    // PVector newSteeringForce = seek(target);
    //Movement weighting
    newSteeringForce.mult(2);
    obstacleDodging.mult(1.5);
    obstacleDodging.mult(safeDistance);
    steeringForce.add(obstacleDodging);
    //add the above seeking force to this overall steering force
    steeringForce.add(newSteeringForce);

    //limit this seeker's steering force to a maximum force
    steeringForce.limit(maxForce);
    //println(maxForce);
    //println(steeringForce.mag()); 
    //debug
    //apply this steering force to the vehicle's acceleration
    applyForce(steeringForce);
    //        println("[ " + this.acceleration.x + " , " + this.acceleration.y + " ]");  //debug
    //resets forces
    steeringForce = new PVector(0, 0);
    obstacleDodging = new PVector(0, 0);
  }
  //Calls avoidObstacles
  void avoidance(Obstacle o)
  {
    obstacleDodging = obstacleDodging.add(avoidObstacle(o));
  }

  //Method: display()
  //Purpose: Finds the angle this seeker should be heading toward
  //         Draws this seeker as a triangle pointing toward 0 degreed
  //         All Vehicles must implement display

  void display() 
  {

    //calculate the direction of the current velocity - this is done for you
    float angle = velocity.heading() + PI/2;   
    //right.mult(20);
    //draw this vehicle's body PShape using proper translation and rotation
    pushMatrix();
    translate(position.x, position.y);

    scale(3);
    rotate(angle);

    //rotate(radians(10));
    //body.rotate(radians(angle));
    shape(fullShip);//, position.x, position.y);
    popMatrix();
    if (controlPad[0])
    {
      //debug lines
      stroke(0, 0, 255);
      line(position.x, position.y, position.x + (right.x *50), position.y + (right.y*50 ));
      line(position.x, position.y, position.x + forward.x*50, position.y + forward.y*50);
    }
    //debug lines
  }

  //Checks for any collisions with humans using the bounding circles.  Has the zamboni (zeds here) purely for adding the human in easily
  void collisionCheck(ArrayList<Human>h, ArrayList<Zombie> zeds)
  {
    if (h != null) 
    {
      for (int i = 0; i < h.size(); i++)
      {
        Human victim = h.get(i);
        // float vicRadius = 12.5;
        PVector comparePos;
        //chekcs positions
        comparePos = h.get(i).position.copy();
        comparePos.sub(this.position);
        if (comparePos.mag() <= (this.radius))
        {
          //removes reference to human and adds in a zombie to replace it at the same location
          h.remove(i);
          stroke(0);
          Zombie z = new Zombie(victim.position.x, victim.position.y, victim.radius, 1, .075);
          println(z.position);
          println(this.position);
          zeds.add(z);
        }
      }
    }
  }
  //Finds the closest human
  void pickTarget(ArrayList<Human> h)
  {
    float closestDistance = 1000000;  //default distance to have something to compare too=
    float newDistance;
    Human possibleTarget = null;
    if (h != null || h.size() <= 0)
    {
      for (int i = 0; i < h.size(); i++)
      {     
        //gets a copy of the position
        PVector placeholder = h.get(i).position.copy();
        placeholder.sub(this.position); //subtracts this zombie's position
        if (placeholder.magSq() < closestDistance)
        {
          //sets closest distance to nearest human as determined throught the vector subtraction
          closestDistance = placeholder.magSq();
          possibleTarget = h.get(i);
        }
      }
      //otherwise, no target
    } else
    {
      closestDistance = 0;
    }
    //sets the target and distance
    targetFood = possibleTarget;
    newDistance = closestDistance;
  }
  void pursueTarget(Human h)
  {

    if (h != null)
    {
      PVector targetPos = h.position.copy();
      PVector targetVel = h.velocity.copy();

      targetPos = targetPos.add(targetVel.mult(60));
      if (controlPad[1])
      {
        fill(255, 0, 0);
        stroke(255, 0, 0);
        line(targetPos.x, targetPos.y, this.position.x, this.position.y);
        ellipse(targetPos.x, targetPos.y, 20, 20);
      }
      target = targetPos.copy();
    }
    //if(h == null)
    //{
    // target = wander();
    //}
  }
}