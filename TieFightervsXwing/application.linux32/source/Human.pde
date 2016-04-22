//Robert Bailey HvZB

//Human class
//Creates a Human object extended from the Vehicle class
//The human is now a XWing
//Implements: 
//  calcSteeringForces() and display()
//Doomed to die in the wake of the overwhelming strength of the empire.
class Human extends Vehicle //TRANSFORMERS ROLL OUT
{
  //seeking target
  //set to null for now
  PVector target = null;
  PVector closestMag;
  //PShape to draw this seeker object
  //These PShapes are not human shaped.  
  PShape fullShip;
  PShape lWing;
  PShape rWing;
  PShape lThrust;
  PShape rThrust;
  PShape body;
  
  Zombie closestZom;

  PVector steeringForce;
  //PVector target;  //department of redunancy department
  PVector obstacleDodging;


  //---------------------------------------
  //Constructor
  //Human(x position, y position, radius, max speed, max force)
  //---------------------------------------
  Human(float x, float y, float r, float ms, float mf) 
  {
    //calls the super class' constructor and pass in necessary arguments

    super(x, y, r, ms, mf);

    target = new PVector(mouseX, mouseY);

    //instantiate steeringForce vector to (0, 0)
    steeringForce = new PVector(0, 0);
    obstacleDodging = new PVector(0, 0);
    //PShape initialization
    fill(255,0,0);
    fullShip = createShape(GROUP);

    body = createShape();
    //  body.setFill(color(255, 0, 0));
    /*
    //the old traingle
     body.beginShape();
     body.vertex(0, -12.5);
     body.vertex(-12.5, 12.5);
     body.vertex(12.5, 12.5);
     body.vertex(0, -12.5);
     */
     //the new tech
    body.beginShape();
    body.vertex(0, 12.5);
    body.vertex(-1.5, 11);
    body.vertex(-1, 8.5);
    body.vertex(-1, 5.5);
    body.vertex(-1.5, 3.5);
    body.vertex(-1.5, -.5);
    body.vertex(-1.5, -4.5);
    body.vertex(-1.5, -7.5);
    body.vertex(-1.5, -9.25);
    body.vertex(-1.5, -9.5);
    body.vertex(-.5, -12.5);

    body.vertex(.5, -12.5);
    body.vertex(1.5, -9.5);
    body.vertex(1.5, -9.25);
    body.vertex(1.5, -7.5);
    body.vertex(1.5, -4.5);
    body.vertex(1.5, -.5);
    body.vertex(1.5, 3.5);
    body.vertex(1, 5.5);
    body.vertex(1, 8.5);
    body.vertex(1.5, 11);
    body.vertex(0, 12.5);
    body.endShape(CLOSE);
    fill(255, 0, 0);
    lWing = createShape();
    lWing.beginShape();
    lWing.vertex(-1.5, -2);
    lWing.vertex(-9.5, -5.3);
    lWing.vertex(-9.5, -7.5);    
    lWing.vertex(-9.5, 4.5);
    lWing.vertex(-12.5, 4.5);
    lWing.vertex(-12.5, -7.5);
    lWing.vertex(-1.5, -9.25);
    lWing.endShape(CLOSE);

    rWing = createShape();
    rWing.beginShape();
    rWing.vertex(1.5, -2);
    rWing.vertex(9.5, -5.3);
    rWing.vertex(9.5, -7.5);    
    rWing.vertex(9.5, 4.5);
    rWing.vertex(12.5, 4.5);
    rWing.vertex(12.5,-7.5);
    rWing.vertex(1.5, -9.25);
    rWing.endShape(CLOSE);
    lThrust = createShape();
    lThrust.beginShape();
    lThrust.vertex(-4.5, -5.5);
    lThrust.vertex(-2.5, -5.5);
    lThrust.vertex(-2.5, -10);
    lThrust.vertex(-3, -11);
    lThrust.vertex(-4, -11);
    lThrust.vertex(-4.5, -10);
    lThrust.vertex(-4.5, -5.5);
    lThrust.endShape(CLOSE);

    rThrust = createShape();
    rThrust.beginShape();
    rThrust.vertex(4.5, -5.5);
    rThrust.vertex(2.5, -5.5);
    rThrust.vertex(2.5, -10);
    rThrust.vertex(3, -11);
    rThrust.vertex(4, -11);
    rThrust.vertex(4.5,  -10);
    rThrust.vertex(4.5, -5.5);
    rThrust.endShape(CLOSE);

    fullShip.addChild(body);
    fullShip.addChild(lWing);
    fullShip.addChild(rWing);
    fullShip.addChild(lThrust);
    fullShip.addChild(rThrust);


    ///Debug for location checking
    //closestMag = new PVector(1, 0);
    //closestMag.setMag(100000000);
    // println(position);
    //draw the seeker "pointing" toward 0 degrees
    safeDistance = r+r+r;
  }



  //Method: calcSteeringForces()
  //Purpose: Based upon the specific steering behaviors this Seeker uses
  //         Calculates all of the resulting steering forces
  //         Applies each steering force to the acceleration
  //         Resets the steering force
  void calcSteeringForces() 
  {
    // println(velocity);
    target.x = mouseX;
    target.y = mouseY;
    PVector newSteeringForce; //= flee(closestZombie());
    evadeTarget(closestZombie());
    if (toClose())
    {
      newSteeringForce = flee(target);
    } else
    {
      PVector panic = wander();
      PVector adjust = position.copy().add(panic);
   //   println(adjust);
      newSteeringForce = seek(adjust);
      // newSteeringForce = flee(new PVector(mouseX, mouseY));
      //  println("bananna");
    }

    if (position.x <80 || position.x > width-80 || position.y < 80 || position.y > height - 80)
    {
      target.x = width/2;
      target.y = height/2;
      newSteeringForce = seek(target);
      newSteeringForce.mult(1.2);
    }
//Weighting of behavior
    newSteeringForce.mult(1.8);  //tiny steps

    obstacleDodging.mult(1); //IT'S A ROCK! RUN FOR YOUR LIFE
    obstacleDodging.mult(safeDistance); //RUN FASTER
    //    }
    steeringForce.add(obstacleDodging);
    //add the above seeking force to this overall steering force

    steeringForce.add(newSteeringForce);


    //limit this seeker's steering force to a maximum force
    steeringForce.limit(maxForce);
    //    println(steeringForce);
    //debug lines
    //   println(maxForce);
    //  println(steeringForce);
    //apply this steering force to the vehicle's acceleration
    applyForce(steeringForce);
    //acceleration.add(steeringForce);


    //reset the steering force to 0
    steeringForce = new PVector(0, 0);
    obstacleDodging = new PVector(0, 0);
  }
  
  //Gets range of closest zombie.  Used for drwaing evade lines and toggling between wander and evasion
  boolean toClose()
  {
    if (closestZom == null)
    {
      return false;
    }
    PVector distance = closestZom.position.copy().sub(this.position);
    if (distance.mag() < 300)
    {
      return true;
    }

    return false;
  }
  
  //Calls vehicle's avoid obstacle method
  void avoidance(Obstacle o)
  {
    obstacleDodging = obstacleDodging.add(avoidObstacle(o));
  }

  //Finds the closest zombie from the zamboni
  Zombie closestZombie()
  {

    Zombie closest = null;
    Zombie prior = null;
    for (int i = 0; i < zamboni.size(); i++)
    {
      if (prior == null)
      {
        //The first zombie becomes the closest
        closest = zamboni.get(i);
        prior = zamboni.get(i);
        //println(prior);
      } else
      {
        //Compares distances from human to zombie, keeping and returning the closest's position
        PVector newPos = zamboni.get(i).position.copy();
        PVector toTarget = newPos.sub(this.position.copy());
        PVector compMag = closest.position.copy().sub(this.position.copy());
        if (toTarget.mag() < compMag.mag())
        {
          closest = zamboni.get(i);
        }
      }
    }
    closestZom = closest;
    //  println(closest.position);
    if (closest != null)
    {
      return closest;
    } else
    {
      Zombie zero = null;
      return zero;
    }
  }
  
  //Method: display()
  //Purpose: Finds the angle this seeker should be heading toward
  //         Draws this seeker as a triangle pointing toward 0 degreed
  //         All Vehicles must implement display
  void display() 
  {

    // println(position);
    //calculate the direction of the current velocity - this is done for you
    float angle = velocity.heading() + PI/2*3;   
    //right.mult(20);
    //draw this vehicle's body PShape using proper translation and rotation
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    scale(3);
    shape(fullShip);//, position.x, position.y);
    popMatrix();
    //Forward and Left vectors - extended for visibility
    if (controlPad[0])
    {
      //debug lines
      stroke(0,0,255);
      line(position.x, position.y, position.x + (right.x *50), position.y + (right.y*50 ));
      line(position.x, position.y, position.x + forward.x*50, position.y + forward.y*50);
    }
    //debug lines
  }
  
  //An upgraded flee.  Instead of avoiding the pursuer's current spot, it runs from where the pursuer should be in a set amount of time.
  //Here, it guesses where the purseur will be after around 60 frames, since the size of the vehicles made everything else behave like flee until then.
  //It works well except on sharp turns, but by then the vehicles usually dead anyway.
  void evadeTarget(Zombie z)
  {
    if (z != null)  //null references are obnixous
    {
      PVector zomPos = z.position.copy();
      PVector zomVel = z.velocity.copy();
      zomPos = zomPos.add(zomVel.mult(60));
      //debug lines.  Also draws a circle for a more obvious visual reference.  It will show as green
      if (controlPad[1]  && toClose())
      {
       // println("here");
        fill(0, 255, 0);
        stroke(0,255,0);
        line(zomPos.x, zomPos.y, this.position.x, this.position.y);
        ellipse(zomPos.x, zomPos.y, 20, 20);
      }
      target = zomPos.copy();
   //   println(target);
    }
  }
}