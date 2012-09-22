//  based on Rotate by Jared "BlueThen" www.bluethen.com

int sW = 960;
int sH = 540;
int numParticles = 400;

color bgColor=color(255);
int bgAlpha = 80;
//basics
int particleCountX = int(numParticles/2);  // default 40
int particleCountY = int(numParticles/2);
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
String fileName = "frame";
String fileType = "png";
int spread = 10;
boolean rebuild = false;
int startTime;

void setup() {
  size(sW,sH,OPENGL);
  //colorMode(RGB, 1);  // 1-bit
  //stroke(1);
  smooth();
  frameRate(frameRateNum);
  background(bgColor);
  particlesInit();
  startTime=millis();
  println("1 = draw | 2 = wind | 3 = push");
  println("R = reset | S = spin | space = record frame");
}

void draw() {
  noStroke();
  fill(bgColor,bgAlpha);
  rect(0,0,width,height);
  if(boundarySwitch==true){
    strokeWeight(1);
    stroke(0,50);
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
}

void particlesInit(){
    for (int x = 0; x < particleCountX; x++) { 
    for (int y = 0; y < particleCountY; y++) { 
      particles[x][y] = new Particle();
      xPos = int(random(width));
      yPos = int(random(height));
    }
  }
}

void renderFrame(){
  addNoise();
  saveFrame("data/"+ fileName + frameCounter + "." + fileType);
  frameCounter++;
}

void addNoise(){
    for (int x = 0; x < particleCountX; x++) { 
    for (int y = 0; y < particleCountY; y++) { 
      float dice = random(1);
      if(dice<0.1){
      for(int i=0;i<spread;i++){
        float qx = particles[x][y].x + random(spread) - random(spread);
        float qy = particles[x][y].y + random(spread) - random(spread);
        if(dice<0.05){
        stroke(255,50);
        }else{
        stroke(0,50);
        }
        strokeWeight(1);
        point(qx,qy);
      }
      }
    }
  }}



