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
  abstract void calcSteeringForces();
  abstract void display();

  //--------------------------------
  //Class methods
  //--------------------------------

  //Method: update()
  //Purpose: Calculates the overall steering force within calcSteeringForces()
  //         Applies movement "formula" to move the position of this vehicle
  //         Zeroes-out acceleration 
  void update()
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
  void applyForce(PVector force) 
  {
    acceleration.add(PVector.div(force, mass));
  }


  //--------------------------------
  //Steering Methods
  //--------------------------------

  //Method: seek(target's position vector)
  //Purpose: Calculates the steering force toward a target's position
  PVector seek(PVector target) 
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
  PVector flee(PVector target)
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
  PVector wander()
  {
   
    PVector circleCen = this.velocity.copy();
    circleCen.normalize();
    circleCen.mult(radius * 1.5);
    PVector displacement = new PVector(0, 1);
    displacement.mult(radius*1.5);
   // displacement.mult(radius*2);
    displacement.rotate(radians(wanderAngle));
    wanderAngle = wanderAngle + ((random(0, 1) * 20) - (20 * .5));
    return circleCen.add(displacement);
  }

  //Avoids obstacles
  PVector avoidObstacle(Obstacle ob)
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