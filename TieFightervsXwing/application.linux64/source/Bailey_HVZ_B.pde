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
void setup() 
{
  size(1000, 1000);
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
  h1 = new Human(800, 800, 70, 3, .110);
  h2 = new Human(width/16, height/5, 70, 3, .110);
  Human h3 = new Human(width - width / 10, height - height/4, 70, 3, .110);
  hs.add(h1);
  hs.add(h2);
  hs.add(h3);
  //Makes some obstacles
  obs = new ArrayList<Obstacle>();
  o1 = new  Obstacle(8, 100, 100);
  obs.add(o1);
  o2 = new Obstacle(7.3, 275, 275);
  obs.add(o2);
  o3 = new Obstacle(6.0, 700, 700);
  obs.add(o3);
  o4 = new Obstacle(4.5, 500, 200);
  obs.add(o4);
  o5 = new Obstacle(5.0, 750, 250);
  obs.add(o5);
  Obstacle o6 = new Obstacle(4.0, 200, 650);
  obs.add(o6);
  Obstacle o7 = new Obstacle(7.0, 500, 500);
  obs.add(o7);
  Obstacle o8 = new Obstacle(8.5, 400, 750);
  obs.add(o8);
  Obstacle o9 = new Obstacle(4, 800, 550);
  obs.add(o9);
  //Makes some zambies for the zamboni
  z1 = new Zombie(width/4, height/2, 65, 1, 0.075);
  //z2 = new Zombie(width/4, height/7, 65, 1, 0.075);
  //z3 = new Zombie(width - width/6, height - height/6, 65, 1, 0.075);
  zamboni.add(z1);
  //zamboni.add(z2);
  //zamboni.add(z3);
}

void draw() {
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
void keyPressed() {
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
void mousePressed()
{
  stroke(0,0,0);  //prevetns blue/red/green tie fighters or xwings
  if (mouseButton == LEFT)
  {
    if (controlPad[6] && zamboni.size() > 0) //when in removal mode, removes the oldest zombie
    {
      zamboni.remove(0);
    } else
    {
      Zombie zToAdd = new Zombie(mouseX, mouseY, 65, 1, 0.075); //adds a new zombie/tie fighter at mouse position
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
      Human hToAdd = new Human(mouseX, mouseY, 80, 3, .110); //spawns a new xwing at mouse position
      hs.add(hToAdd);
    }
  }
}