import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Bailey_HVZ_B extends PApplet {

//Robert Bailey HvZB
//Date:10_25_2015
//Purpose: To wipe out those puny rebel scum.  Using a baseline HvZ scheme

//Obstacle declaration
Obstacle o1;
Obstacle o2;
Obstacle o3;
Obstacle o4;
Obstacle o5;
//Data structure declaration
ArrayList<Obstacle> obs;
ArrayList<Human> hs;
ArrayList<Zombie>zamboni;
boolean[] controlPad;

//Here for early debugging purpose to directly refer to certain instances
Zombie z1;
Zombie z2;
Zombie z3;
Human h1;
Human h2;
public void setup() 
{
  
  //creates the spots for each key to be read
  controlPad = new boolean[8];
  controlPad[0] = false; //1
  controlPad[1] = false; //2
  controlPad[2] = false; //3
  controlPad[3] = false; //4
  controlPad[4] = false; //5
  controlPad[5] = false; //6

  controlPad[6] = false; //r, toggles kill mode

  hs = new ArrayList<Human>();
  zamboni = new ArrayList<Zombie>();
  //Makes some humans
  h1 = new Human(800, 800, 70, 3, .110f);
  h2 = new Human(width/16, height/5, 70, 3, .110f);
  Human h3 = new Human(width - width / 10, height - height/4, 70, 3, .110f);
  hs.add(h1);
  hs.add(h2);
  hs.add(h3);
  //Makes some obstacles
  obs = new ArrayList<Obstacle>();
  o1 = new  Obstacle(8, 100, 100);
  obs.add(o1);
  o2 = new Obstacle(7.3f, 275, 275);
  obs.add(o2);
  o3 = new Obstacle(6.0f, 700, 700);
  obs.add(o3);
  o4 = new Obstacle(4.5f, 500, 200);
  obs.add(o4);
  o5 = new Obstacle(5.0f, 750, 250);
  obs.add(o5);
  Obstacle o6 = new Obstacle(4.0f, 200, 650);
  obs.add(o6);
  Obstacle o7 = new Obstacle(7.0f, 500, 500);
  obs.add(o7);
  Obstacle o8 = new Obstacle(8.5f, 400, 750);
  obs.add(o8);
  Obstacle o9 = new Obstacle(4, 800, 550);
  obs.add(o9);
  //Makes some zambies for the zamboni
  z1 = new Zombie(width/4, height/2, 65, 1, 0.075f);
  //z2 = new Zombie(width/4, height/7, 65, 1, 0.075);
  //z3 = new Zombie(width - width/6, height - height/6, 65, 1, 0.075);
  zamboni.add(z1);
  //zamboni.add(z2);
  //zamboni.add(z3);
}

public void draw() {
  // println(controlKey);  //debug
  background(125);  //It represents the hopeless void of humanity, and totally isn't here as a default
  //Borders - the Bookstore.  Closing tomorrow.
  stroke(0); //ensures lines stay a constant color
  line(70, 70, 70, height-70);
  line(70, 70, width-70, 70);
  line(width-70, 70, width-70, height-70);
  line(width-70, height-70, 70, height-70);

  // Draw an ellipse at the mouse location
  // ellipse(mouseX, mouseY, 20, 20);  //For when you have to have a mobile obstacle.  

  //For loops.  For days.
  for (int i = 0; i < hs.size(); i++)  //humans
  {
    //moves all humasn
    if (hs.size() != 0)
    {
      hs.get(i).update();
      hs.get(i).display();
    }
  }
  if (zamboni.size() != 0)
  {
    for (int j = 0; j <zamboni.size(); j++) //zombies
    {

      //Zombies move second to avoid nullRefernece/outofBounds errors generated from killing humans mid cycle
      //moves all zombies and checks for collisions
      zamboni.get(j).display();
      zamboni.get(j).collisionCheck(hs, zamboni);
      zamboni.get(j).update();
    }
  }
  //Obstacle behavior.  Done after everything else to avoid errors from killing humans mid cycle.
  for (int k = 0; k < obs.size(); k++)
  {
    obs.get(k).display();
    for (int j = 0; j < zamboni.size(); j++)
    {
      zamboni.get(j).avoidance(obs.get(k));
    }
    if (hs.size()!=0)
    {
      for (int i = 0; i < hs.size(); i++)
      {
        hs.get(i).avoidance(obs.get(k));
      }
    }
  }
}

//ASSUMING CONTROL
public void keyPressed() {
  //Turns on/off each key on a button press
  if (keyCode == '1')
  {
    controlPad[0] = !controlPad[0];
  }
  if (keyCode == '2')
  {
    controlPad[1] = !controlPad[1];
  }
  if (keyCode == '3')
  {
    controlPad[2] = !controlPad[2];
  }
  if (keyCode == '4')
  {
    controlPad[3] = !controlPad[3];
  }
  if (keyCode == '5')
  {
    controlPad[4] = !controlPad[4];
  }  
  if (keyCode == '6')
  {
    //6 has had enough of your shenagans
    //controlPad[5] = !controlPad[5];
    controlPad[0] = false;
    controlPad[1] = false;
    controlPad[2] = false;
    controlPad[3] = false;
    controlPad[4] = false;
    controlPad[6] = false;
  }
  if (keyCode == 'r' || keyCode == 'R') //when combined with mouse buttons, allows removal of zombies/humans
  {
    controlPad[6] = !controlPad[6];
  }
  //}
}
//Mouse control.  Spawn/remove zombies and humans
public void mousePressed()
{
  stroke(0,0,0);  //prevetns blue/red/green tie fighters or xwings
  if (mouseButton == LEFT)
  {
    if (controlPad[6] && zamboni.size() > 0) //when in removal mode, removes the oldest zombie
    {
      zamboni.remove(0);
    } else
    {
      Zombie zToAdd = new Zombie(mouseX, mouseY, 65, 1, 0.075f); //adds a new zombie/tie fighter at mouse position
      zamboni.add(zToAdd);
    }
  }
  if (mouseButton == RIGHT)
  {    
    if (controlPad[6]  && hs.size() > 0)  //when in removal mode, removes oldest xWing
    {
      hs.remove(0);
    } else
    {
      Human hToAdd = new Human(mouseX, mouseY, 80, 3, .110f); //spawns a new xwing at mouse position
      hs.add(hToAdd);
    }
  }
}
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
    body.vertex(0, 12.5f);
    body.vertex(-1.5f, 11);
    body.vertex(-1, 8.5f);
    body.vertex(-1, 5.5f);
    body.vertex(-1.5f, 3.5f);
    body.vertex(-1.5f, -.5f);
    body.vertex(-1.5f, -4.5f);
    body.vertex(-1.5f, -7.5f);
    body.vertex(-1.5f, -9.25f);
    body.vertex(-1.5f, -9.5f);
    body.vertex(-.5f, -12.5f);

    body.vertex(.5f, -12.5f);
    body.vertex(1.5f, -9.5f);
    body.vertex(1.5f, -9.25f);
    body.vertex(1.5f, -7.5f);
    body.vertex(1.5f, -4.5f);
    body.vertex(1.5f, -.5f);
    body.vertex(1.5f, 3.5f);
    body.vertex(1, 5.5f);
    body.vertex(1, 8.5f);
    body.vertex(1.5f, 11);
    body.vertex(0, 12.5f);
    body.endShape(CLOSE);
    fill(255, 0, 0);
    lWing = createShape();
    lWing.beginShape();
    lWing.vertex(-1.5f, -2);
    lWing.vertex(-9.5f, -5.3f);
    lWing.vertex(-9.5f, -7.5f);    
    lWing.vertex(-9.5f, 4.5f);
    lWing.vertex(-12.5f, 4.5f);
    lWing.vertex(-12.5f, -7.5f);
    lWing.vertex(-1.5f, -9.25f);
    lWing.endShape(CLOSE);

    rWing = createShape();
    rWing.beginShape();
    rWing.vertex(1.5f, -2);
    rWing.vertex(9.5f, -5.3f);
    rWing.vertex(9.5f, -7.5f);    
    rWing.vertex(9.5f, 4.5f);
    rWing.vertex(12.5f, 4.5f);
    rWing.vertex(12.5f,-7.5f);
    rWing.vertex(1.5f, -9.25f);
    rWing.endShape(CLOSE);
    lThrust = createShape();
    lThrust.beginShape();
    lThrust.vertex(-4.5f, -5.5f);
    lThrust.vertex(-2.5f, -5.5f);
    lThrust.vertex(-2.5f, -10);
    lThrust.vertex(-3, -11);
    lThrust.vertex(-4, -11);
    lThrust.vertex(-4.5f, -10);
    lThrust.vertex(-4.5f, -5.5f);
    lThrust.endShape(CLOSE);

    rThrust = createShape();
    rThrust.beginShape();
    rThrust.vertex(4.5f, -5.5f);
    rThrust.vertex(2.5f, -5.5f);
    rThrust.vertex(2.5f, -10);
    rThrust.vertex(3, -11);
    rThrust.vertex(4, -11);
    rThrust.vertex(4.5f,  -10);
    rThrust.vertex(4.5f, -5.5f);
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
  public void calcSteeringForces() 
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
      newSteeringForce.mult(1.2f);
    }
//Weighting of behavior
    newSteeringForce.mult(1.8f);  //tiny steps

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
  public boolean toClose()
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
  public void avoidance(Obstacle o)
  {
    obstacleDodging = obstacleDodging.add(avoidObstacle(o));
  }

  //Finds the closest zombie from the zamboni
  public Zombie closestZombie()
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
  public void display() 
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
  public void evadeTarget(Zombie z)
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
    body.vertex(0, 4.75f);
    body.vertex(-1.8f,4);
      body.vertex(-3.2f,3);
      body.vertex(-4.1f,2.8f);
      body.vertex(-5.4f,1.5f);
      body.vertex(-4,.5f);
      body.vertex(-4.1f,-.5f);
      body.vertex(-3.9f,-1.9f);
      body.vertex(-4,-3);
      body.vertex(-4.5f,-4);
      body.vertex(-3,-4.2f);
      body.vertex(-1.5f,-4.3f);
      body.vertex(0,-5);
      body.vertex(1,-4.75f);
      body.vertex(2,-4);
      body.vertex(2.9f,-2.8f);
      body.vertex(4.1f,-3.1f);
      body.vertex(4.2f,-1.25f);
      body.vertex(4.8f,-.8f);
      body.vertex(5,0);
      body.vertex(4.6f,1.2f);
      body.vertex(4.1f,1.95f);
      body.vertex(3.8f,3);
      body.vertex(2.35f,4.5f);
      body.vertex(1.2f,4.1f);
      body.vertex(0,4.75f);
      body.endShape();
  }
  public void display()
  {
    pushMatrix();
    translate(position.x,position.y);
    scale(radius);
    shape(body);
    popMatrix();
    //ellipse(position.x, position.y, radius, radius);
  }

  public void ToString()
  {
    //To string for debug
    println(radius + " " + position.x + " " + position.y);
  }
}
//Robert Bailey HvZB

//Vehicle class
//Specific autonomous agents will inherit from this class 
//Abstract since there is no need for an actual Vehicle object
//Implements the stuff that each auto agent needs: movement, steering force calculations, and display
//Now, with the XWing/Tie Fighter theme, the title makes mure sense

abstract class Vehicle 
{

  //--------------------------------
  //Class fields
  //--------------------------------
  //vectors for moving a vehicle
  PVector acceleration, position, velocity;

  //no longer need direction vector - will utilize forward and right
  //these orientation vectors provide a local point of view for the vehicle
  PVector forward, right;

  //floats to describe vehicle movement and size
  float maxSpeed, maxForce;
  float radius, mass;
  // PShape wanderCircle;
  //floats for obstacleAvoidance
  float safeDistance;
  float wanderAngle;


  //--------------------------------
  //Constructor
  //Vehicle(x position, y position, radius, max speed, max force)
  //--------------------------------
  Vehicle(float x, float y, float r, float ms, float mf) 
  {
    //Assign parameters to class fields

    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    forward = velocity.copy();
    right = new PVector(-forward.y, forward.x);
    acceleration = new PVector(0, 0);

    maxSpeed = ms;
    maxForce = mf;

    radius = r;
    mass = 1;
    wanderAngle = 0;
    //safeDistance = r+r*3;
  }

  //--------------------------------
  //Abstract methods
  //--------------------------------
  //every sub-class Vehicle must use these functions
  public abstract void calcSteeringForces();
  public abstract void display();

  //--------------------------------
  //Class methods
  //--------------------------------

  //Method: update()
  //Purpose: Calculates the overall steering force within calcSteeringForces()
  //         Applies movement "formula" to move the position of this vehicle
  //         Zeroes-out acceleration 
  public void update()
  {
    //calculate steering forces by calling calcSteeringForces()
    calcSteeringForces();
    //add acceleration to velocity, limit the velocity, and add velocity to position
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    //displays velocity
    if (controlPad[4])
    {
      line(position.x, position.y, position.x + velocity.x, position.y + velocity.y);
    }
    position.add(velocity);
    //calculate forward and right vectors
    forward = velocity.copy();
    forward.normalize();
    right = new PVector(-forward.y, forward.x);
    //reset acceleration
    //displays Accleeration
    if (controlPad[5])
    {
      line(position.x, position.y, position.x + acceleration.x, position.y + acceleration.y);
    }
    //resets acceleration
    acceleration.x = 0; 
    acceleration.y = 0;
  }


  //Method: applyForce(force vector)
  //Purpose: Divides the incoming force by the mass of this vehicle
  //         Adds the force to the acceleration vector
  public void applyForce(PVector force) 
  {
    acceleration.add(PVector.div(force, mass));
  }


  //--------------------------------
  //Steering Methods
  //--------------------------------

  //Method: seek(target's position vector)
  //Purpose: Calculates the steering force toward a target's position
  public PVector seek(PVector target) 
  { 
    PVector targManip = target.copy();
    PVector goalV  = targManip.copy().sub(position);
    goalV.setMag(maxSpeed);
    PVector result = goalV.copy().sub(velocity);
    if (controlPad[1])
    {
      line(position.x, position.y, position.x+result.x, position.y + result.y);
    }
    // PVector result = new PVector(0,0);

    return result;
  }
  //The opposite of seek - runs away from a given position
  public PVector flee(PVector target)
  {

    PVector manipTarget = target.copy();
    PVector goalV  = manipTarget.copy().sub(position);
    goalV.setMag(maxSpeed);
    goalV.mult(-1);
    PVector result = goalV.copy().sub(velocity);
    if (controlPad[1])
    {
      line(position.x, position.y, target.x, target.y);
    }

    //  PVector result = new PVector(0,0);
    return result;
  }
  //Generates a circle in front of the actor, and a point on the rim gets picked.  The vehicle navigates to that point, and then changes what angle they're looking at for next time
  public PVector wander()
  {
   
    PVector circleCen = this.velocity.copy();
    circleCen.normalize();
    circleCen.mult(radius * 1.5f);
    PVector displacement = new PVector(0, 1);
    displacement.mult(radius*1.5f);
   // displacement.mult(radius*2);
    displacement.rotate(radians(wanderAngle));
    wanderAngle = wanderAngle + ((random(0, 1) * 20) - (20 * .5f));
    return circleCen.add(displacement);
  }

  //Avoids obstacles
  public PVector avoidObstacle(Obstacle ob)
  {
    // ob.ToString();
    PVector vecToCent = new PVector(0, 0);
    PVector desiredVelocity = new PVector(0, 0);
    PVector steer = new PVector(0, 0);

    vecToCent = PVector.sub(ob.position, this.position, vecToCent);//ob.position.sub(this.position);
    float vecToCentMagSquared = vecToCent.magSq();
    //too far away
    if (vecToCentMagSquared - (ob.radius*ob.radius) - (this.radius*this.radius) > safeDistance*safeDistance)
    {
      return steer;
    }
    //behind
    if (vecToCent.dot(forward) < 0)
    {
      return steer;
    }
    //course okay
    if (ob.radius + this.radius < abs(vecToCent.dot(right)))
    {
      return steer;
    }
    //i don't like change
    if (right.copy().dot(vecToCent) > 0)
    {
      desiredVelocity = right.copy().mult(maxSpeed * -1);
    } else
    {
      desiredVelocity = right.copy().mult(maxSpeed * 1);
    }
    desiredVelocity = PVector.mult(right, maxSpeed);
    steer = PVector.sub(desiredVelocity, velocity);
    //Displays
    if (controlPad[2])
    {
      line(position.x, position.y, position.x+steer.x, position.y+steer.y);  //vector of turning
      line(position.x, position.y, position.x+vecToCent.x, position.y + vecToCent.y); //vector to object
    }
    // steer.mult(vecToCent.mag());

    return steer;
  }
}
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
    lWing.vertex(-6, 12.5f);
    lWing.vertex(-9, 9.5f);
    lWing.vertex(-10, 7.5f);
    lWing.vertex(-10, 4.5f);
    lWing.vertex(-10, 2.5f);
    lWing.vertex(-11, 1.5f);
    lWing.vertex(-11, -1.5f);
    lWing.vertex(-10, -2.5f);
    lWing.vertex(-10, 2.5f);
    lWing.vertex(-10, -4.5f);
    lWing.vertex(-10, -7.5f);
    lWing.vertex(-9, -9.5f);
    lWing.vertex(-6, -12.5f);
    lWing.vertex(-6.75f, -10.5f);
    lWing.vertex(-7.25f, -10.25f);
    lWing.vertex(-7.5f, -6.5f);
    lWing.vertex(-7.5f, -1.5f);
    lWing.vertex(-5, -1.5f);
    lWing.vertex(-5, 1.5f);
    lWing.vertex(-7.5f, 1.5f);
    lWing.vertex(-7.5f, 6.5f);
    lWing.vertex(-7.25f, 8.75f);
    lWing.vertex(-5.75f, 10.5f);
    lWing.vertex(-6, 12.5f);
    lWing.endShape(CLOSE);

    rWing = createShape();
    rWing.beginShape();
    rWing.vertex(6, 12.5f);
    rWing.vertex(9, 9.5f);
    rWing.vertex(10, 7.5f);
    rWing.vertex(10, 4.5f);
    rWing.vertex(10, 2.5f);
    rWing.vertex(11, 1.5f);
    rWing.vertex(11, -1.5f);
    rWing.vertex(10, -2.5f);
    rWing.vertex(10, 2.5f);
    rWing.vertex(10, -4.5f);
    rWing.vertex(10, -7.5f);
    rWing.vertex(9, -9.5f);
    rWing.vertex(6, -12.5f);
    rWing.vertex(6.75f, -10.5f);
    rWing.vertex(7.25f, -10.25f);
    rWing.vertex(7.5f, -6.5f);
    rWing.vertex(7.5f, -1.5f);
    rWing.vertex(5, -1.5f);
    rWing.vertex(5, 1.5f);
    rWing.vertex(7.5f, 1.5f);
    rWing.vertex(7.5f, 6.5f);
    rWing.vertex(7.25f, 8.75f);
    rWing.vertex(5.75f, 10.5f);
    rWing.vertex(6, 12.5f);
    rWing.endShape(CLOSE);


    body = createShape();
    body.beginShape();
    body.vertex(0, 7.5f);
    body.vertex(-1, 7.17f);
    body.vertex(-2, 6.5f);
    body.vertex(-3, 5.5f);
    body.vertex(-4, 4.4f);
    body.vertex(-4.5f, 3.5f);
    body.vertex(-5, 2.5f);
    body.vertex(-5.5f, 1.5f);
    body.vertex(-5.8f, .5f);

    body.vertex(-6, 0);

    body.vertex(-5.8f, -.5f);
    body.vertex(-5.5f, -1.5f);
    body.vertex(-5, -2.5f);
    body.vertex(-4.5f, -3.5f);
    body.vertex(-4, -4.6f);
    body.vertex(-3, -5.5f);
    body.vertex(-2, -6.5f);
    body.vertex(-1, -7.16f);

    body.vertex(0, -7.5f);

    body.vertex(1, -7.16f);
    body.vertex(2, -6.5f);
    body.vertex(3, -5.5f);
    body.vertex(4, -4.6f);
    body.vertex(4.5f, -3.5f);
    body.vertex(5, -2.5f);
    body.vertex(5.5f, -1.5f);
    body.vertex(5.8f, -.5f);

    body.vertex(6, 0);

    body.vertex(5.8f, .5f);
    body.vertex(5.5f, 1.5f);
    body.vertex(5, 2.5f);
    body.vertex(4.5f, 3.5f);
    body.vertex(4, 4.4f);
    body.vertex(3, 5.5f);
    body.vertex(2, 6.5f);
    body.vertex(1, 7.17f);

    body.vertex(0, 7.5f);
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
  public void calcSteeringForces() 
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
    obstacleDodging.mult(1.5f);
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
  public void avoidance(Obstacle o)
  {
    obstacleDodging = obstacleDodging.add(avoidObstacle(o));
  }

  //Method: display()
  //Purpose: Finds the angle this seeker should be heading toward
  //         Draws this seeker as a triangle pointing toward 0 degreed
  //         All Vehicles must implement display

  public void display() 
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
  public void collisionCheck(ArrayList<Human>h, ArrayList<Zombie> zeds)
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
          Zombie z = new Zombie(victim.position.x, victim.position.y, victim.radius, 1, .075f);
          println(z.position);
          println(this.position);
          zeds.add(z);
        }
      }
    }
  }
  //Finds the closest human
  public void pickTarget(ArrayList<Human> h)
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
  public void pursueTarget(Human h)
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
  public void settings() {  size(1000, 1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Bailey_HVZ_B" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
