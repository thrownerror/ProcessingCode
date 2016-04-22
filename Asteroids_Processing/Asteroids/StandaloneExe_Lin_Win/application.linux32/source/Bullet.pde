//Name: Robert Bailey
//Date: 27 Sept 2015
//Known errors: None
//Purpose: To create a bullet for the simulation of Asteroids

class Bullet
{
  //bullet's don't accelerate because I wanted the constant rate.  
  PVector position, velocity, direction;
  //Makes eli, the ellipse - bullet's shape
  PShape eli;
  float moveRate;
  boolean active; //most important variable here.  Deterimes if bullet can break asteroids, and if it is shwon

  Bullet(PVector dir, PVector pos)
  {
    //Gets the position and direction, instantiates velocity
    position = pos.copy();
    direction = dir.copy();
    velocity = new PVector(0, 0);
    active = false; //makes inactive
    eli = createShape(ELLIPSE, 0, 0, 10, 10);
  }

  void update()
  {
    //if active, advance in a linear fashion
    if (active)
    {    
      velocity = velocity.add(direction);
      velocity.limit(7);
      position = position.add(velocity);
          //Bullet wrapping

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
    }
  } 
  void display()
  {
    if (active)
    {
      shape(eli, position.x, position.y); //draws shape.
    }
  }

  void debug()
  {
    print("bull"); //it said something else earlier
  }
  //toggles activation, resets velocity to avoid WAnted style  curving bullets
  void activation()
  {
    active = !active;
    velocity.x = 0;
    velocity.y = 0;
  }
}