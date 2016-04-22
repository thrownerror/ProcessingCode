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
void setup()
{
  //sets the starting controls
  inGame = false;
  levelChange = false;
  gameOver = false;
  level = 1;
  size(600, 800);
  s = new Ship();
  //println(s.lives); //debug
  //Sets up easier reading in the keyboard response
  L_TURN = 1;
  R_TURN = 2;
  bullCount = 0;
  //sets starting asteroid velocity
  velocityMod = .5;
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
void draw()
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
    velocityMod += .1;
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
    text("Welcome to Asteroids!", width/14, height*.25);
    textSize(35);
    text("Spacebar shoots", width/4, height*.5);
    text("Left arrow turns left", width/5, height*.6);
    text("Right arrow turns right", width/5.5, height*.7);
    textSize(35);
    text("Press Left for targeting asteroids.", width/25, height * .85); //asteroids move twoards player
    text("Press Right for classic asteroids.", width/18, height *.9); //asteroids move randomly

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
void keyPressed() {
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
void keyReleased()
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