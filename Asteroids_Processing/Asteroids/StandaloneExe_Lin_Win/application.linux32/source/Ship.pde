//Name: Robert Bailey
//Date: 27 Sept 2015
//Known errors: To create a player ship class for a reconstruction of the Atari game Asteroids.

class Ship //moves with vector based movement
{
  //Vector, speed, direction, and placement declaration
  PVector position, velocity, acceleration, direction;
  float speed, maxSpeed, accelRate;
  float deg;
  PShape craft;
  boolean speeding;
  //supporting bullets
  Bullet bill;
  //life count
  int lives;
  //collision detection manager
  PShape boundingCircle;
  float boundingCordX;
  float boundingCordY;
  int score;
  //Only constructor
  Ship()
  {
    //Sets vectors and managers
    score = 0;
    position = new PVector(width/2, height/2);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    direction = new PVector(0, 0);
    bill = new Bullet(direction, position);
    direction = PVector.fromAngle(radians(-90));  
    //sets accelearation and max speed
    accelRate = .015;
    maxSpeed = 6.5;
    //draws the soacecraft
    craft = createShape();
    craft.beginShape();
    craft.vertex(0, -15);
    craft.vertex(15, 10);
    craft.vertex(15, 20);
    craft.vertex(12, 10);
    craft.vertex(-12, 10);
    craft.vertex(-15, 20);
    craft.vertex(-15, 10);
    craft.vertex(0, -15);
    craft.endShape();
    lives = 3;
    //creates the bounding circle
    boundingCordX = position.x;
    boundingCordY = position.y + 17.5;
    boundingCircle = createShape(ELLIPSE, 0, 0, 35, 35);
  }
//Advances and displays the spacecraft
  void update()
  {
    direction.normalize();
    if (speeding)
    {
      //Accelerates if up arrow is held
      acceleration = PVector.mult(direction, accelRate); 
      velocity = velocity.add(acceleration);
    } else
    {
      //otherwise, decellerates ever so slightly for the drifting motion from the original game.  Still a noticable chanagem but has th edrift
      velocity.mult(.992);
    }
    //limits the speed
    velocity.limit(6.0);
    position = position.add(velocity);
    //Wrapping
    if (position.x > width)
    {
      position.x = 0;
    }
    if (position.x < 0)
    {
      position.x = width;
    }

    if (position.y > height)
    {
      position.y = 0;
    }
    if (position.y < 0)
    {
      position.y = height;
    }
    shape(craft, position.x, position.y);
    //shape(boundingCircle, position.x, position.y); //draw fopr debug
  }

//Fires the bullet.  Sets its position to the tip of the ship and fires
  void fire(Bullet b)
  {
    b.position = this.position.copy();
    this.direction.normalize();
    b.direction = this.direction.copy();
    b.direction.normalize();
    b.activation();
  }

//Speed up toggle
  void speedUp(boolean control)
  {
    speeding = control;
  }
//Rotation management
  void rotation(int dir)
  {
    if (dir == 1)
    {
      direction.rotate(-.05);
      craft.rotate(-.05);
    }
    if (dir == 2)
    {
      direction.rotate(.05);
      craft.rotate(.05);
    }
  }
//Damage - lose a life and get placed in a random location on the board to avoid spawn deaths
  void takeDamage()
  {

    if (lives != 0)
    {
      lives--;
    }
    position.x = random(0, width);
    position.y = random(0, height);
  }
}