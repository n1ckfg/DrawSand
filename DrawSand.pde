//  based on Rotate by Jared "BlueThen" www.bluethen.com
// basics
int numParticles = 100;
color bgColor=color(255,127,0);
int particleCountX = int(numParticles/2);  // default 40
int particleCountY = int(numParticles/2);
Particle[] particles = new Particle[particleCountX * particleCountY];

// additional
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
int frameRateNum = 60;
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
  size(960, 540, P2D);
  //colorMode(RGB, 1);  // 1-bit
  //stroke(1);
  //smooth();
  frameRate(frameRateNum);
  background(bgColor);
  particlesInit();
  startTime=millis();
  println("1 = draw | 2 = wind | 3 = push");
  println("R = reset | S = spin | space = record frame");
  bloomSetup();
}

void draw() {
  tex.beginDraw();
  tex.background(bgColor);
  //noStroke();
  //fill(bgColor,bgAlpha);
  //rect(0,0,width,height);
  if (boundarySwitch==true) {
    tex.strokeWeight(1);
    tex.stroke(0);//,50);
    tex.noFill();
    //quad(boundary,boundary,width-boundary,boundary,width-boundary,height-boundary,boundary,height-boundary);
  }  // border
  if (mousePressed) {  // circle halo
    //tex.noStroke();
    //tex.fill(0,150,250);//,(random(20)+10));
    //tex.ellipse(mouseX/downRes,mouseY/downRes,radiusLimit/8,radiusLimit/8);
  }
  for (int x = 0; x < particleCountX; x++) { 
    for (int y = 0; y < particleCountY; y++) { 
      int loc = x + y * particleCountX;
      particles[loc].update();
    }
  }  
  increaseForces();
  tex.endDraw();
  
  bloomDraw();
}

void particlesInit() {
  for (int i = 0; i < particles.length; i++) { 
      particles[i] = new Particle(random(width/downRes), random(height/downRes));
  }
}

void renderFrame() {
  addNoise();
  saveFrame("data/"+ fileName + frameCounter + "." + fileType);
  frameCounter++;
}

void addNoise() {
  for (int x = 0; x < particleCountX; x++) { 
    for (int y = 0; y < particleCountY; y++) { 
      int loc = x + y * particleCountX;
      float dice = random(1);
      if (dice<0.1) {
        for (int i=0; i<spread; i++) {
          float qx = particles[loc].x + random(spread) - random(spread);
          float qy = particles[loc].y + random(spread) - random(spread);
          if (dice<0.05) {
            tex.fill(255,50);
          }  else{
            tex.fill(0,50);
          }
           tex.strokeWeight(1);
           tex.ellipse(qx,qy,1,1);
        }
      }
    }
  }
}
