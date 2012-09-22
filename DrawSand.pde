//  based on Rotate by Jared "BlueThen" www.bluethen.com
color bgColor=color(255);
int bgAlpha = 80;
//basics
int particleCountX = 200;  // default 40
int particleCountY = 200;  // default 30
int xStart = 0;  // default 18
int yStart = 0;  // default 16
int xPos = xStart;
int yPos = yStart;
int posIntervalX = 2;  // default 16
int posIntervalY = 2;  // default 12
Particle[][] particles = new Particle[particleCountX][particleCountY];
//additional
int radiusLimitMin = 1; // default = 150
int radiusLimit = radiusLimitMin;
int radiusLimitMax = 10;
float frictionMin = 1.99;                // default = 0.97 ... none = 1; decel < 1; accel > 1
float friction = frictionMin;
float frictionMax = 0.999;
int boundary = 0;                    // default = 10;
boolean boundarySwitch = true;        // default = true
float spinAmountMin = 0.2;               // default = 0.7
float spinAmount = spinAmountMin;
float spinAmountMax = 1.0;
boolean spinSwitch = true;            // default = true
int frameRateNum = 24;
int counterRelease = 0;
int counterReleaseMax = frameRateNum/3;
boolean saveFrameArm = false;
int frameCounter=1;

void setup() {
  size(640,360,OPENGL);
  //colorMode(RGB, 1);  // 1-bit
  //stroke(1);
  smooth();
  frameRate(frameRateNum);
  background(bgColor);
  for (int x = 0; x < particleCountX; x++) { 
    for (int y = 0; y < particleCountY; y++) { 
      particles[x][y] = new Particle();
      xPos = int(random(width));
      yPos = int(random(height));
    }
  }
}

void draw() {
  noStroke();
  fill(bgColor,bgAlpha);
  rect(0,0,width,height);
  if(boundarySwitch==true){
    strokeWeight(1);
    stroke(255,50);
    noFill();
    quad(boundary,boundary,width-boundary,boundary,width-boundary,height-boundary,boundary,height-boundary);
  }  // border
  if(mousePressed){  // circle halo
      noStroke();
    fill(0,150,250,(random(20)+10));
    ellipse(mouseX,mouseY,radiusLimit/8,radiusLimit/8);
  }
  for (int x = 0; x < particleCountX; x++) { 
    for (int y = 0; y < particleCountY; y++) { 
      Particle particle = (Particle) particles[x][y];
      particle.update();
    }
  }  
  increaseForces();
  println(frameRate);
}

void keyPressed() {
  if(key==' '){
    xPos = xStart;
    yPos = yStart;
    for (int x = 0; x < particleCountX; x++) { 
      for (int y = 0; y < particleCountY; y++) { 
        particles[x][y] = new Particle();
        xPos += posIntervalX;
      }
      xPos = xStart;
      yPos += posIntervalY;
    }
  }
  if(key=='b'||key=='B'){
    if(boundarySwitch==true){
      boundarySwitch=false;
    }
    else if (boundarySwitch==false){
      boundarySwitch=true;
    }
  }
  if(key=='s'||key=='S'){
    if(spinSwitch==true){
      spinSwitch=false;
    }
    else if (spinSwitch==false){
      spinSwitch=true;
    }
  }
  if(key=='1'){  // moderate defaults
    radiusLimitMin = 20; 
    radiusLimitMax = 200;
    frictionMin = 0.9;                
    frictionMax = 0.999;
    spinAmountMin = 0.2;               
    spinAmountMax = 2.0;
  }
  if(key=='2'){  // more motion
    radiusLimitMin = 20; 
    radiusLimitMax = 500;
    frictionMin = 0.999;                
    frictionMax = 1.2;
    spinAmountMin = 0.5;               
    spinAmountMax = 5.0;
  }
}

void increaseForces() {
  if(mousePressed==true){
    saveFrameArm=true;
    if(radiusLimit <= radiusLimitMax){
      radiusLimit+=1;
    }
    if(friction <= frictionMax){
      friction+=0.01;
    }
    if(spinAmount <= spinAmountMax){
      spinAmount+=0.01;
    }
  } 
  else if(mousePressed==false){
    counterRelease++;
    if(counterRelease>counterReleaseMax){
      counterRelease=0;
      radiusLimit = radiusLimitMin;
      friction = frictionMin;
      spinAmount = spinAmountMin;
    }
    if(saveFrameArm){
      saveFrame("data/frame"+frameCounter+".tga");
      saveFrameArm=false;
      frameCounter++;
    }
  }
  println("radius: " + radiusLimit + "     friction: " + friction + "     spin: " + spinAmount);
}





