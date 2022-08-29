PVector centerPos;
PVector mousePos;
PVector direction;
float positionX, positionY = 0;
float offsetX, offsetY = 0;
float travelSpeed = 0.02;
float lineSpacing = 50;
float circleDiameter = 40;
float randomSpawnValue = 300;
float randomSpawnMin = 20;
float randomSpawnMax = 100;
float disappearOffset = 400;
float appearRangeMin = 50;
float appearRangeMax = 200;
float initialPointNumber = 15;
float maxPoints = 200;
float pointsNumber = 0;
float timer;
float actualTime;
PShape arrow;
PShape player;
ArrayList<Point> points = new ArrayList<Point>();

void setup()
{
  centerPos = new PVector(width/2, height/2);
  size(700,700);
  frameRate(30);
  rectMode(CENTER);
  noStroke();
  frameRate(60);
  initPShapes();
  spawnFirstPoints();
}

void initPShapes()
{
  arrow = createShape(TRIANGLE, -10, 0, 10, 0, 0, 10);
  arrow.setStroke(false);
  arrow.setFill(150);
  player = createShape(ELLIPSE, 0, 0, circleDiameter, circleDiameter);
  player.setStroke(false);
  player.setFill(color(255, 0, 0));
}

void spawnFirstPoints()
{
  for(int i=0; i < initialPointNumber; i++)
  {
    Point po = new Point();
    po.setPos(true);
  }
}

void draw()
{
  background(240);
  centerPos = new PVector(width/2, height/2);
  calculateWalkForce();
  displayGrid();
  spawnPoints();
  displayPoints();
  deletePoints();
  displayPlayer();
}

void calculateWalkForce()
{
  mousePos = new PVector(mouseX, mouseY);
  direction = new PVector(centerPos.x - mousePos.x, centerPos.y - mousePos.y);
  positionX += direction.x * travelSpeed;
  positionY += direction.y * travelSpeed;
}

void spawnPoints()
{
  timer = millis();  
  if (timer + randomSpawnValue >= actualTime)
  {
    randomSpawnValue = random(randomSpawnMin, randomSpawnMax);
    actualTime += randomSpawnValue;
    if(points.size() < maxPoints)
    {
      Point po = new Point();
      po.setPos(false);
    }
  }
}

void displayPoints()
{
  for (int i=0; i<points.size(); i++)
  {
    Point pointNow = points.get(i);
    //pointNow.randCol = color(random(255), random(255), random(255));
    pointNow.display();
  }
}

void deletePoints()
{
  for (int i=0; i<points.size(); i++)
  {
    Point pointNow = points.get(i);
    if(pointNow.posX < -width/2 - disappearOffset || pointNow.posX > width/2 + disappearOffset || pointNow.posY < -height/2 - disappearOffset || pointNow.posY > height/2 + disappearOffset)
    {
      points.remove(i);
    }
    if(dist(pointNow.posX, pointNow.posY, 0, 0) < circleDiameter / 2)
    {
      points.remove(i);
      circleDiameter++;
      initPShapes();
    }
  }
}

void displayGrid()
{
  fill(180);
  float lineCountHor = width / lineSpacing;
  float lineCountVer = height / lineSpacing;
  float offsetX = positionX % lineSpacing;
  float offsetY = positionY % lineSpacing;
  for (int i=0; i<lineCountHor+1; i++)
  {
    rect(i*lineSpacing + offsetX, height/2, 1, height);
  }
  for (int j=0; j<lineCountVer+1; j++)
  {
    rect(width/2, j*lineSpacing + offsetY, width, 1);
  }
}

void displayPlayer()
{
  float deltaX = mousePos.x - centerPos.x;
  float deltaY = mousePos.y - centerPos.y;
  float angle = atan2(deltaY, deltaX);
  float displaceX = cos(angle) * circleDiameter * 0.6;
  float displaceY = sin(angle) * circleDiameter * 0.6;
  pushMatrix();
  translate(centerPos.x, centerPos.y);
  translate(displaceX, displaceY);
  rotate(angle - PI/2);
  shape(arrow);
  popMatrix();
  pushMatrix();
  translate(centerPos.x, centerPos.y);
  shape(player);
  popMatrix();
}

class Point
{
  float posX, posY;
  float minX, maxX;
  float minY, maxY;
  float randX, randY;
  color randCol;

  void setPos(boolean init)
  {
    randCol = color(random(255), random(255), random(255));
    pushMatrix();
    translate(centerPos.x, centerPos.y);
    if(!init){
      int spawnPlace = int(random(4));
      switch(spawnPlace)
      {
        case 0:
          minX = -width/2 - appearRangeMax;
          maxX = -width/2 - appearRangeMin;
          minY = -height/2;
          maxY = height/2;
          break;
        case 1:
          minY = -height/2 - appearRangeMax;
          maxY = -height/2 - appearRangeMin;
          minX = -width/2;
          maxX = width/2;
          break;
        case 2:
          minX = width/2 + appearRangeMin;
          maxX = width/2 + appearRangeMax;
          minY = -height/2;
          maxY = height/2;
          break;
        case 3:
          minY = height/2 + appearRangeMin;
          maxY = height/2 + appearRangeMax;
          minX = -width/2;
          maxX = width/2;
          break;
      }
    }
    else
    {
      minX = -width/2;
      maxX = width/2;
      minY = -height/2;
      maxY = height/2;
    }
    posX = random(minX, maxX);
    posY = random(minY, maxY);
    points.add(this);
    popMatrix();
  }

  void display()
  {
    pushMatrix();
    translate(centerPos.x, centerPos.y);
    posX += direction.x * travelSpeed;
    posY += direction.y * travelSpeed;
    fill(randCol);
    ellipse(posX, posY, 20, 20);
    popMatrix();
  }
}
