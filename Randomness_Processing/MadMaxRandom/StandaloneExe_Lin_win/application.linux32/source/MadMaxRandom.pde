Car c1;
//float banana;
float noiseScale;
float outputVal;
void setup()
{
  size(700, 500);
  //background(255);
  //banana = 0;
  noiseDetail(6);
  noiseScale = 0.01;
  c1 = new Car(250, 250);
}

void draw()
{
 background(255);
  //banana = map(mouseX, 0, width, 1, 15);
  //c1.displayTranslated(0,0);
  //c1.displayScaled(banana);
 //for (int y = 0; y < height; y++)
 //{
 //  for (int x = 0; x < width; x++)
 //  {
 //    outputVal = noise(x*noiseScale, y * noiseScale);
 //    stroke(color(140, outputVal*120, 42));
 //     point(x, y);
 //  }
 // }
  
  c1.findTarget();
}