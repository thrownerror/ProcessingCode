//Name: Robert Bailey
//Date: 27 Sept 2015
//Known errors: For classic mode, the asteroids tend to start bunched up.  After a few seconds they spread out normally
//Purpose: To simulate the asteroids for the Atari game Asteroids.  Come in two modes

class Rock
{
  //the radius isn't actually the radius, but I'd fallen in too deep.
  float radius;  //technically, width
  PVector position, direction, velocity;
  float startPosX;
  float startPosY;
  float startDirX;
  float startDirY;
  float startVelX;
  float startVelY;
  float velocityMod;
  float rad;


  //life variables
  boolean hasSplit; //big one has broken
  boolean destroyed; //instance of rock is gone
  boolean gone; //rock and children are all destroyed


  PShape obj; //rock to be drawn
  Rock child1;  //children to be created when needed
  Rock child2;
  Ship target; //ship to move towards
  boolean mode; //mode toggling
  Rock(float r, Ship s, int toggle, float vMod, boolean mde)
  { //the rock lives
    hasSplit = false;
    destroyed = false;
    gone = false;
    mode = mde;
    //sets the rock in various quadrants based off of the toggle from the main class.
    //Also sets a direction to move towards a roughly random direction in classic  mode
    radius = r;
    if (toggle == 1) {
      startPosX = random(0, 210);
      startPosY = random(0, 200)*-1 ;
      startDirX = random(0, 1);
      startDirY = random(-1, 0);
    }
    if (toggle == 2) {
      startPosX = random(0, 210);
      startPosY = random(0, 200); 
      startDirX = random(0, 1);
      startDirY = random(0, 1);
    }
    if (toggle == 3)
    {
      startPosX = random(0, 210) * -1;
      startPosY = random(0, 200) ;
      startDirX = random(-1, 0);
      startDirY = random(0, 1);
    }
    if (toggle == 4)
    {
      startPosX = random(0, 210) * -1;
      startPosY = random(0, 200) * -1;
      startDirX = random(-1, 0);
      startDirY = random(-1, 0);
    }

    //sets the target
    target = s;
    position = new PVector(startPosX, startPosY);
    //If in targeting mode: direction is towards the player ship
    if (mode == false)
    {
      direction = new PVector(s.position.x, s.position.y);    
      direction.normalize();
    }
    //If in classic mode, direction is random and placement is as well
    if (mode == true)
    {
      position = new PVector(random (0, width), random(0, 300));
      direction = new PVector(startDirX, startDirY );
    }
    //sets speed modifer for upper limit
    velocityMod = vMod;
    startVelX = random(0, 5);
    startVelY = random(0, 5);
    velocity = new PVector(startVelX, startVelY);

    //finally sets the real readius
    rad = radius/2;

//Creates a bunch of points to avoid random results being too similar between asteroids
    float p1 = random(-.1, -.8) * rad;
    float p2 = random(-.1, -.7)* rad;
    float p3 = random(.1, .7)* rad;
    float p4 = random(.1, .8)* rad;
    float p5 = random(.1, .8)* rad;
    float p6 = random(.1, .7)* rad;
    float p7 = random(-.1, -.7)* rad;
    float p8=  random(-.1, -.8)* rad;
    //creates teh asteroid.  Points 0,-1 0,1, 1,0 and -1,0 are all set.  The inbetween points are random on small ranges set in the point declaration above.
    //The asteroid is scalled by its radius so the same random method can be used each time
    obj= createShape();
    obj.beginShape();
    obj.vertex(0, -1 * rad);
    obj.vertex(-.5* rad, p1);
    obj.vertex(-.75* rad, p2);
    obj.vertex(-1* rad, 0);
    obj.vertex(-.75* rad, p3);
    obj.vertex(.5* rad, p4);
    obj.vertex(0, 1* rad);
    obj.vertex(.5* rad, p5);
    obj.vertex(.75* rad, p6);
    obj.vertex(1* rad, 0); 
    obj.vertex(.75* rad, p7);
    obj.vertex(.5* rad, p8);
    obj.vertex(0, -1* rad);   
    obj.endShape();
  }
//Child craeteor.  Get's passed most of its parent's information to avoid children spawning all over the screen
  Rock(float r, float pX, float pY, float dX, float dY, float vX, float vY, float vM, Ship s, boolean mde)  //child creator
  {
    //Normal delcaration, except has split is true
    radius = r;
    rad = radius/2;
    hasSplit = true;
    destroyed = false;
    position = new PVector(pX, pY);
    mode = mde;
    //If target mode, moves twoards enemy ship
    if (mode == false)
    {
      direction = new PVector(s.position.x, s.position.y);
    }
    //Otherwise, go in a random direction
    if (mode == true)
    {
      startDirX = random(0, 1);
      startDirY = random(0, 1);
      direction = new PVector(startDirX, startDirY);
    }
    direction.normalize();
    velocity = new PVector(vX, vY);
    //Same shape forming as above
    velocityMod = vM * 1.5;
    float p1 = random(-.1, -.8) * rad;
    float p2 = random(-.1, -.7)* rad;
    float p3 = random(.1, .7)* rad;
    float p4 = random(.1, .6)* rad;
    float p5 = random(.1, .8)* rad;
    float p6 = random(.1, .7)* rad;
    float p7 = random(-.1, -.7)* rad;
    float p8=  random(-.1, -.8)* rad;
    obj= createShape();
    obj.beginShape();
    obj.vertex(0, -1 * rad);
    obj.vertex(-.5* rad, p1);
    obj.vertex(-.75* rad, p2);
    obj.vertex(-1* rad, 0);
    obj.vertex(-.75* rad, p3);
    obj.vertex(.5* rad, p4);
    obj.vertex(0, 1* rad);
    obj.vertex(.5* rad, p5);
    obj.vertex(.75* rad, p6);
    obj.vertex(1* rad, 0); 
    obj.vertex(.75* rad, p7);
    obj.vertex(.5* rad, p8);
    obj.vertex(0, -1* rad);   
    obj.endShape();
    //avoids no object reference errors.
    child1 = null;
    child2 = null;
  }
//Moves the asteroids.  Collision checks are done in main class
  void update()
  {
    //If not destroyed, move:
    if (!destroyed)
    { 
      //towards ship
      if (mode == false)
      {
        direction = PVector.sub(s.position, this.position);
        direction.normalize();
        //or along set path
      } else
      {
        direction.normalize();
      }
      //increases velocity and position
      velocity = velocity.add(direction);
      velocity.limit(velocityMod);
      position = position.add(velocity);
//Wrapping of asteroids
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
//draws shape
      shape(obj, position.x, position.y);
      //If the parent is destroyed, instead advances children
    } else
    {
      if (child1 != null) //null pointer check
      {
        child1.update();
        child2.update();
        if (child1.destroyed && child2.destroyed)
        {
          gone = true;  //asteroid is completly wiped off board
        }
      }
    }
  }
//Checks for bullet collisions using bounding circles
  boolean bulletCollide(Bullet b)
  {
    if ( sqrt((pow((this.position.x - b.position.x), 2) + pow((this.position.y - b.position.y), 2)) ) <= (this.radius/2 + 5))
    {
      if (b.active)
      {
        // obj.setFill(color(0, 0, 0));
        //Bullet deactivates and the asteroid breaks apart/get destroyed if there is a collision
        b.activation();
        if (!destroyed)
        {
          breakApart();
        }
        s.score += 100;
        //increase score
        return true;
      } else
      {
        return false; //no collision, bullet not active
      }
    } else 
    {
      obj.setFill(color(255, 255, 255)); //no collision carry on
      return false;
    }
  }

//Ship-asteroid collision resolution and detection
  void shipCollide(Ship s)
  {
//Bounding circles
    if ( sqrt((pow((this.position.x - (s.position.x)), 2) + pow((this.position.y - (s.position.y)), 2)) ) <= (this.radius/2 + 17.5))
    {
      //Ship loses a life
      s.takeDamage();
      //moves position to avoid the asteroid dealing multiple lives of damage to the player
      this.position.x = random(0, 200);
      this.position.y = random(0, 200);
    }
  }

//If asteroid is hit by a bullet
  void breakApart()
  {
    if (!hasSplit)
    {
      //Splits into two children who carry on near the parent's destruction site
      hasSplit = true;
      child1 = new Rock(radius/2, position.x+radius/4, position.y + radius/6, direction.x + random(-10, 10), direction.y + random(-10, 10), velocity.x/2, velocity.y/2, velocityMod, target, mode);
      child2 = new Rock(radius/2, position.x-radius/4, position.y - radius/6, direction.x - random(-10, 10), direction.y - random(-10, 10), velocity.x/2, velocity.y/2, velocityMod, target, mode);
    }
    //Otherwise, just destroyed and thrown off the board
    destroyed = true;
    position.x = -1000;
    position.y = -1000;
    direction.x = 0;
    direction.y = -1;
  }
}