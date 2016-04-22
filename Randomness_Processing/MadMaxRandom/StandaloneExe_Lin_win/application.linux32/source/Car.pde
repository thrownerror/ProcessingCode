//Name: Robert Bailey
//Purpose: To draw a vaguely car like object and then facilitate matrix changes to it.
//Known errors: None
//Date: 6 September 2015

//TRANSFORMATIONS IN-CLASS EXERCISE
//IGME 202

//-----------------------------------------------------------
// CAR CLASS
class Car {
  //has starting x/y cords, and all parts of the car
  int xCord;
  int yCord;

  float targetCord;
  //int targetY;
  PShape car;
  PShape carTopLeft;
  PShape carTopRight;
  PShape carTop;
  PShape carRear;
  PShape leftWheel;
  PShape rightWheel;
  PShape fullCar; //will be the final group for the car so I don't have to
  //transform each wheel + body

  //-----------------------------------------------------------
  // COMPLETE THIS CONSTRUCTOR
  Car(int x, int y) {
    // ASSIGN ALL PARAMETERS TO THE CAR CLASS GLOBAL VARIABLES HERE
    xCord = x;
    yCord = y;
    targetCord = 0;
    // CREATE CAR PSHAPE HERE
    // ATTEMPT TO CREATE A CAR-LOOKING-THING USING YOUR OWN VERTICES

    //front of car
    //let's slam a bunch of vertices down and hope.
    car = createShape();
    fullCar = createShape(GROUP);
    car.beginShape();
    car.vertex(0, 20);
    car.vertex(2, 10);
    car.vertex(2.25, 9);
    car.vertex(3, 7);
    car.vertex(4, 5);
    car.vertex(5, 3);
    car.vertex(6, 2);
    car.vertex(7, 1);
    car.vertex(8, .33);
    car.vertex(9, .1);
    car.vertex(10, 0);
    car.vertex(20, 0);

    car.vertex(21, .1);
    car.vertex(22, .33);
    car.vertex(23, 1);
    car.vertex(24, 2);
    car.vertex(25, 3);
    car.vertex(26, 5);
    car.vertex(27, 7);
    car.vertex(27.75, 9);
    car.vertex(28, 10);
    car.vertex(30, 20);
    ////hood curve
    car.vertex(0, 20);
    car.vertex(0, 50);
    car.vertex(30, 50);
    car.vertex(30, 20);
    car.endShape(CLOSE);


    ////main body
    //have as three shape groups on top
    carTopLeft = createShape();
    carTopLeft.beginShape();
    carTopLeft.vertex(7, 24);
    carTopLeft.vertex(0, 50);
    carTopLeft.vertex(0, 20);
    carTopLeft.vertex(7, 24);
    carTopLeft.endShape(CLOSE);

    carTopRight = createShape();
    carTopRight.beginShape();
    carTopRight.vertex(23, 24);
    carTopRight.vertex(30, 50);
    carTopRight.vertex(30, 20);
    carTopRight.vertex(23, 24);
    carTopRight.endShape(CLOSE);

    carTop = createShape();
    carTop.beginShape();
    carTop.vertex(23, 24);

    carTop.vertex(15, 21);

    carTop.vertex(7, 24);
    carTop.vertex(0, 50);
    carTop.vertex(30, 50);
    carTop.vertex(23, 24);
    carTop.endShape(CLOSE);
    //car.vertex(23,24);
    //car.vertex(30,50);
    //car.vertex(30,20);
    //car.vertex(23,24);
    //car.vertex(22,23.25);
    //car.vertex(21,22.6);
    //car.vertex(20,22.1);
    //car.vertex(19,21.8);
    //car.vertex(18,21.4);
    //car.vertex(17,21.2);
    //car.vertex(16,21.1);
    //car.vertex(15,21);

    //car.vertex(14,21.1);
    //car.vertex(13,21.2);
    //car.vertex(12,21.4);
    //car.vertex(11,21.8);
    //car.vertex(10,22.1);
    //car.vertex(9,22.6);
    //car.vertex(8,23.25);
    //car.vertex(7,24);
    //car.vertex(0,50);
    //car.vertex(0,20);
    //car.vertex(7,24);
    //car.vertex(0,50);
    ////top details

    ////rear
    //test vertex
    carRear = createShape();
    carRear.beginShape();
    carRear.vertex(0, 50);
    carRear.vertex(0, 70);
    carRear.vertex(1, 71.2);
    carRear.vertex(2, 72.33);
    carRear.vertex(3, 73);
    carRear.vertex(4, 73.25);
    carRear.vertex(5, 73.75);
    carRear.vertex(6, 74);
    carRear.vertex(7, 74.2);
    carRear.vertex(8, 74.4);
    carRear.vertex(9, 74.6);
    carRear.vertex(10, 74.8);
    //  carRear.vertex(11,74.85);
    // carRear.vertex(12,74.9);
    //carRear.vertex(14,74.95);   
    carRear.vertex(15, 75);
    //carRear.vertex(16,74.95);   
    //carRear.vertex(17,74.93);
    //carRear.vertex(18,74.9);
    carRear.vertex(19, 74.85);
    carRear.vertex(20, 74.8);
    carRear.vertex(21, 74.6);
    carRear.vertex(22, 74.4);
    carRear.vertex(23, 74.2);
    carRear.vertex(24, 74);
    carRear.vertex(25, 73.75);
    carRear.vertex(26, 73.25);
    carRear.vertex(27, 73);
    carRear.vertex(28, 72.33);
    carRear.vertex(29, 71.2);
    carRear.vertex(30, 70);
    carRear.vertex(30, 50);
    carRear.endShape(CLOSE);
    //FINISH THE PSHAPE WITH YOUR CUSTOM VERTICES

    //it worked

    // ADD WHEELS TO THE CAR (ELLIPSES)
    //leftWheel = createShape(ELLIPSE, xCoord +10, yCoord + 25, 8, 8);
    //  rightWheel = createShape(ELLIPSE, xCoord +45, yCoord + 25, 8, 8);

    //groups everything together
    fullCar.addChild(car);
    fullCar.addChild(carRear);
    fullCar.addChild(carTopLeft);
    fullCar.addChild(carTopRight);
    fullCar.addChild(carTop);
    //   fullCar.addChild(leftWheel);
    // fullCar.addChild(rightWheel);
  }

  // DISPLAYTRANSLATED WILL DRAW A TRANSLATED CAR TO THE WINDOW
  // **THIS CODE IS ALREADY DONE FOR YOU**
  void displayTranslated(float x, float y, float angleDegrees) {
    /*
    pushMatrix();
    translate(x, y);
    popMatrix();
    xCord = (int)x;
    yCord = (int)y;
    pushMatrix();
    translate(x, y);
    rotate(radians(angleDegrees));
    popMatrix();
    shape(fullCar);
    */
    pushMatrix();
    translate(x, y);
    rotate(radians(angleDegrees));
    shape(fullCar);
    popMatrix();
    xCord = (int)x;
    yCord = (int)y;
  }

  // DISPLAYROTATED WILL DRAW A ROTATED CAR TO THE WINDOW
  // APPLY ROTATIONS HERE AND COMPLETE THE FUNCTION BELOW
  void displayRotated(float angleInDegrees) {
    pushMatrix();
    rotate(radians(angleInDegrees));
    shape(fullCar);
    popMatrix();
  }

  // DISPLAYSCALED WILL DRAW THIS CAR TO THE WINDOW
  // APPLY SCALING HERE AND COMPLETE THE FUNCTION BELOW
  void displayScaled(float scaleFactor) {
    pushMatrix();
    scale(scaleFactor);
    shape(fullCar);
    popMatrix();
  }

  //displayRotAboutPoint will draw a car rotated around the point
  void displayRotAboutPoint(int px, int py, float angleDegrees)
  { 
    pushMatrix();
    translate(px, py);
    rotate(radians(angleDegrees));
    shape(fullCar);
    popMatrix();
  }

  void randomWeightedMovement()
  {
    int cX;
    int cY;
    float rX = random(1);
    float rY = random(1);
    if (rX < 0.31) {
    }
    //right
    else if (rX < 0.61) {
    }
    //left
    else if (rX <0.91) {
    }
    //still
    else 
    {
      //stay still
    }


    if (rY < 0.31) {
    }
    //up
    else if (rY < 0.61) {
    }
    //right
    else if (rY <0.91) {
    }
    //left
    else 
    {
      //stay still
    }
  }
  //right


  void randMove()
  {
    int mx;
    int my;
    float rx = random(-1, 2);
    float ry = random(-1, 2);
    mx = floor(rx) * 10;
    my = floor(ry) * 10;
   // this.displayTranslated(mx + xCord, my + yCord);
  }


  void gaussianMoveStart()
  {
    targetCord = randomGaussian() * width;
    if (targetCord < 0)
    {
      targetCord = 0;
    } else if (targetCord > width)
    {
      targetCord = width;
    }
  }

  void move (float x, float y, float deg)
  {
    pushMatrix();
    translate(x, y);
    popMatrix();
    pushMatrix();
    translate(x, y);
    rotate(radians(deg));
    popMatrix();
    xCord = (int)x;
    yCord = (int)y;
    shape(fullCar);
  }

  void findTarget()
  {
    if (xCord < targetCord + 1 && xCord > targetCord - 1)
    {
      this.gaussianMoveStart();
    } else
    {
      if (xCord < targetCord)
      {
        //this.move(xCord + 1, yCord, 105);
        this.displayTranslated(xCord + 1, yCord,+15);
        //this.displayRotated(105);
      } else
      {
       // this.move(xCord - 1, yCord, 105);

          this.displayTranslated(xCord-1, yCord,-15);
        //this.displayRotated(105);
      }
    }
  }


  //circular movement forward
}