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

public class Asteroids extends PApplet {

//Name: Robert Bailey
//Date: 27 Sept 2015
//Known errors: None
//Purpose: To simulate the Atari game 2600 game asteroids.  I created a version with asteroids which persue the player
//and asteroids which move with random direction more akin to the original title

//core components
Ship s;
Bullet [] bills;
Rock[] rocks;

//control declaration
int L_TURN;
int R_TURN;
boolean[] controlPad;

//All debug variables for quick testing with set mechanics
//testing rocks, left in becasuee they made me laugh
//Rock dwayne;
//Rock daRock;
//Rock johnson;
//keeps count off bullets
int bullCount;
//boolean test;

//helps placement of the asteroids
int toggle;

//game state changers
boolean inGame;
boolean levelChange;
int level;
float velocityMod;
boolean gameOver;
//sets game mode - the more classic one or the modern pursuing mode
boolean mode;

//setuput loop
public void setup()
{
  //sets the starting controls
  inGame = false;
  levelChange = false;
  gameOver = false;
  level = 1;
  
  s = new Ship();
  //println(s.lives); //debug
  //Sets up easier reading in the keyboard response
  L_TURN = 1;
  R_TURN = 2;
  bullCount = 0;
  //sets starting asteroid velocity
  velocityMod = .5f;
  controlPad = new boolean[4];//poor man's enum
  mode = false;//poor man's toggle
  controlPad[0] = false; //LEFT
  controlPad[1] = false; //RIGHT
  controlPad[2] = false; //UP
  controlPad[3] = false; //SPACE
  //manages all the bullets.  They are all named Bill.
  bills = new Bullet[4];
  //manages all the rocks.  They are all named rock.
  rocks = new Rock[10];
  //place to toss the bullets initially to avoid unwanted collisions
  PVector fillerDir = new PVector(0, -1);
  PVector fillerPos = new PVector(-500, -500);
  //creates the four (like in the original) asterodis
  for (int i = 0; i < bills.length; i++)
  {
    bills[i] = new Bullet(fillerDir, fillerPos);
  }
  //sets the toggle which determines quadrant of asteroids
  toggle = 1;
  //creates teh rocks
  for (int j = 0; j < rocks.length; j++)
  {

    rocks[j]  = new Rock(random(50, 80), s, toggle, velocityMod, mode);    
    toggle++;
    if (toggle > 4)
    {
      toggle = 0;
    }
  }
  //dwayne = new Rock(50);
  //daRock = new Rock(45);
  //johnson = new Rock(60);
}
//the game
public void draw()
{
  background(0); ///wipe when you're done

  //gamae over state.  It comes first because reasons.
  if (gameOver)
  {  
    background(0);
    textSize(50);
    //displays results.  They're kind of centered
    text("Game Over", width/4, height/2);
    text("Score: " + s.score, width/4, height/3);
    text("Final level:" + level, width/4, height/4);
  }
  //Level change state
  if (levelChange)
  {
    //preserves the score and lives/  Creates a new ship to avoid direction/graphic disconnects
    int shipScore = s.score;
    int shipLives = s.lives;
    s = new Ship();
    s.lives = shipLives;
    s.score = shipScore;

    //deactivates all the bullets
    for (int i = 0; i < bills.length; i++)
    {
      bills[i].active = false;
    }
    //makes rocks a biggera rea
    rocks = new Rock[10*level];
    //increase the rock speed.  I now realize I could have done velocityMode+=.1;
    //velocityMod = ((velocityMod * 10) + 1) / 10;
    //Fixed it
    velocityMod += .1f;
    //Makes all of the rocks
    for (int j = 0; j < rocks.length; j++)
    {

      rocks[j]  = new Rock(random(50, 80), s, toggle, velocityMod, mode);    
      toggle++;
      if (toggle > 4)
      {
        toggle = 0;
      }
    }
    //toggles to game mode
    levelChange = false;
    inGame = true;
  }
  //Surprisingly, the core of the game
  if (inGame)
  {
    if (controlPad[2])
    {
      s.speedUp(true);  //move forward
    } else
    {
      s.speedUp(false);  //decellearte
    }
    if (controlPad[0])
    {
      s.rotation(1); //left
    }
    if (controlPad[1])
    {
      s.rotation(2); //right
    }
    if (controlPad[3])  //fire
    {
      //Picks the bullet from the four availabe, meaning the player can only swap between those 4.
      //the 4 can be fired relatively rapidly, but the burst fire is sapced out to avoid machine gun spaceships
      s.fire(bills[bullCount]);
      controlPad[3] = false;
      bullCount++;
      if (bullCount >= bills.length)
      {
        bullCount = 0;
      }
    }
    s.update();

    //moves all the bullets
    for (int i = 0; i < bills.length; i++)
    {
      bills[i].update();
      bills[i].display();
    }
    //used to tell when to advance level
    int deathCounter = 0;
    //advances all the rocks
    for (int j = 0; j < rocks.length; j++)
    {
      rocks[j].update();
      for (int k = 0; k < bills.length; k++)
      {
        // int deathCounter = 0;
        //if the rock hasn't split, look for collisions
        if (rocks[j].child1 == null)
        {
          rocks[j].shipCollide(s);
          rocks[j].bulletCollide(bills[k]);
          //if it has, look for child collisions
        } else
        {
          rocks[j].child1.shipCollide(s);
          rocks[j].child2.shipCollide(s);
          rocks[j].child1.bulletCollide(bills[k]);
          rocks[j].child2.bulletCollide(bills[k]);
        }
      }
      //if rock and children are gone, increase death counter
      if (rocks[j].gone)
      {
        deathCounter++;
      }
      //if all the rocks are gone, advance level, add 1000 to score
      if (deathCounter == rocks.length)
      {
        levelChange = true;
        inGame = false;
        level++;
        s.score += 1000;
      }
    }
    //HUD
    textSize(30);
    text("Level: " + level, 50, 50);
    text("Score: " + s.score, width - 400, 50);
    text("Lives: " + s.lives, 50, height - 50);
    //If the player dies, game over
    if (s.lives==0)
    {
      gameOver = true;
      inGame = false;
      levelChange = false;
    }
  } 
  //Opening menu.  Introduces game, controls, and mode selection
  if (!inGame && !levelChange  && gameOver == false)
  {
    textSize(50);
    text("Welcome to Asteroids!", width/14, height*.25f);
    textSize(35);
    text("Spacebar shoots", width/4, height*.5f);
    text("Left arrow turns left", width/5, height*.6f);
    text("Right arrow turns right", width/5.5f, height*.7f);
    textSize(35);
    text("Press Left for targeting asteroids.", width/25, height * .85f); //asteroids move twoards player
    text("Press Right for classic asteroids.", width/18, height *.9f); //asteroids move randomly

    //If blocks to determine mode used when asteroids are created
    if (controlPad[0])
    {
      inGame = true;
      mode = false;
    }
    if (controlPad[1])
    {
      inGame = true;
      mode = true;

      for (int j = 0; j < rocks.length; j++)
      {
        rocks[j]  = new Rock(random(50, 80), s, toggle, velocityMod, mode);    
        toggle++;
        if (toggle > 4)
        {
          toggle = 0;
        }
      }
    }
    //reestablishes livees to ensure no accidental game over during level creation
    s.lives = 3;
  }
}
//Key methods.  On press, toggles on
public void keyPressed() {
  if (key == CODED)
  {
    if (keyCode == LEFT)
    {
      controlPad[0] = true;
    }
    if (keyCode == RIGHT)
    {
      controlPad[1] = true;
    }
    if (keyCode == UP)
    {
      controlPad[2] = true;
    }
  }
  if (key == ' ')
  {
    controlPad[3] = true;
  }
}
//On release, toggle off
public void keyReleased()
{
  if (key == CODED)
  {
    if (keyCode == LEFT)
    {
      controlPad[0] = false;
    }
    if (keyCode == RIGHT)
    {
      controlPad[1] = false;
    }
    if (keyCode == UP)
    {
      controlPad[2] = false;
    }
  }
  if (key == ' ')
  {
    controlPad[3] = false;
  }
}
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

  public void update()
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
  public void display()
  {
    if (active)
    {
      shape(eli, position.x, position.y); //draws shape.
    }
  }

  public void debug()
  {
    print("bull"); //it said something else earlier
  }
  //toggles activation, resets velocity to avoid WAnted style  curving bullets
  public void activation()
  {
    active = !active;
    velocity.x = 0;
    velocity.y = 0;
  }
}
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
    float p1 = random(-.1f, -.8f) * rad;
    float p2 = random(-.1f, -.7f)* rad;
    float p3 = random(.1f, .7f)* rad;
    float p4 = random(.1f, .8f)* rad;
    float p5 = random(.1f, .8f)* rad;
    float p6 = random(.1f, .7f)* rad;
    float p7 = random(-.1f, -.7f)* rad;
    float p8=  random(-.1f, -.8f)* rad;
    //creates teh asteroid.  Points 0,-1 0,1, 1,0 and -1,0 are all set.  The inbetween points are random on small ranges set in the point declaration above.
    //The asteroid is scalled by its radius so the same random method can be used each time
    obj= createShape();
    obj.beginShape();
    obj.vertex(0, -1 * rad);
    obj.vertex(-.5f* rad, p1);
    obj.vertex(-.75f* rad, p2);
    obj.vertex(-1* rad, 0);
    obj.vertex(-.75f* rad, p3);
    obj.vertex(.5f* rad, p4);
    obj.vertex(0, 1* rad);
    obj.vertex(.5f* rad, p5);
    obj.vertex(.75f* rad, p6);
    obj.vertex(1* rad, 0); 
    obj.vertex(.75f* rad, p7);
    obj.vertex(.5f* rad, p8);
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
    velocityMod = vM * 1.5f;
    float p1 = random(-.1f, -.8f) * rad;
    float p2 = random(-.1f, -.7f)* rad;
    float p3 = random(.1f, .7f)* rad;
    float p4 = random(.1f, .6f)* rad;
    float p5 = random(.1f, .8f)* rad;
    float p6 = random(.1f, .7f)* rad;
    float p7 = random(-.1f, -.7f)* rad;
    float p8=  random(-.1f, -.8f)* rad;
    obj= createShape();
    obj.beginShape();
    obj.vertex(0, -1 * rad);
    obj.vertex(-.5f* rad, p1);
    obj.vertex(-.75f* rad, p2);
    obj.vertex(-1* rad, 0);
    obj.vertex(-.75f* rad, p3);
    obj.vertex(.5f* rad, p4);
    obj.vertex(0, 1* rad);
    obj.vertex(.5f* rad, p5);
    obj.vertex(.75f* rad, p6);
    obj.vertex(1* rad, 0); 
    obj.vertex(.75f* rad, p7);
    obj.vertex(.5f* rad, p8);
    obj.vertex(0, -1* rad);   
    obj.endShape();
    //avoids no object reference errors.
    child1 = null;
    child2 = null;
  }
//Moves the asteroids.  Collision checks are done in main class
  public void update()
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
  public boolean bulletCollide(Bullet b)
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
  public void shipCollide(Ship s)
  {
//Bounding circles
    if ( sqrt((pow((this.position.x - (s.position.x)), 2) + pow((this.position.y - (s.position.y)), 2)) ) <= (this.radius/2 + 17.5f))
    {
      //Ship loses a life
      s.takeDamage();
      //moves position to avoid the asteroid dealing multiple lives of damage to the player
      this.position.x = random(0, 200);
      this.position.y = random(0, 200);
    }
  }

//If asteroid is hit by a bullet
  public void breakApart()
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
    accelRate = .015f;
    maxSpeed = 6.5f;
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
    boundingCordY = position.y + 17.5f;
    boundingCircle = createShape(ELLIPSE, 0, 0, 35, 35);
  }
//Advances and displays the spacecraft
  public void update()
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
      velocity.mult(.992f);
    }
    //limits the speed
    velocity.limit(6.0f);
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
  public void fire(Bullet b)
  {
    b.position = this.position.copy();
    this.direction.normalize();
    b.direction = this.direction.copy();
    b.direction.normalize();
    b.activation();
  }

//Speed up toggle
  public void speedUp(boolean control)
  {
    speeding = control;
  }
//Rotation management
  public void rotation(int dir)
  {
    if (dir == 1)
    {
      direction.rotate(-.05f);
      craft.rotate(-.05f);
    }
    if (dir == 2)
    {
      direction.rotate(.05f);
      craft.rotate(.05f);
    }
  }
//Damage - lose a life and get placed in a random location on the board to avoid spawn deaths
  public void takeDamage()
  {

    if (lives != 0)
    {
      lives--;
    }
    position.x = random(0, width);
    position.y = random(0, height);
  }
}
  public void settings() {  size(600, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Asteroids" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
