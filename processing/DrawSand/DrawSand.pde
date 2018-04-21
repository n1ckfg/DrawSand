//  based on Rotate by Jared "BlueThen" www.bluethen.com
// basics
int numParticles = 400;
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
int fps = 60;
int counterRelease = 0;
int counterReleaseMax = fps/3;
boolean saveFrameArm = false;
int frameCounter=1;
String fileName = "frame";
String fileType = "png";
boolean rebuild = false;
int startTime;
PImage grainImg;

void setup() {
  size(960, 540, P2D);
  frameRate(fps);
  background(bgColor);
  
  particlesInit();
  startTime=millis();
  println("1 = draw | 2 = wind | 3 = push");
  println("R = reset | S = spin | space = record frame");
  
  grainImg = loadImage("grain.png");
  radiusLimitMax /= downRes;
  bloomSetup();
  setupShaders();
}

void draw() {
  tex.beginDraw();
  tex.background(bgColor);
  tex.blendMode(MULTIPLY);
  tex.image(grainImg, 0, 0, width/downRes, height/downRes);
  tex.tint(random(235, 255));
  tex.image(grainImg, 0, 0, width/downRes, height/downRes);
  tex.noTint();
  tex.blendMode(NORMAL);

  for (int i = 0; i < particles.length; i++) { 
    particles[i].run();
  }  
  
  increaseForces();
  tex.endDraw();
  
  bloomDraw();
  
  surface.setTitle(""+frameRate);
}

void particlesInit() {
  for (int i = 0; i < particles.length; i++) { 
      particles[i] = new Particle(random(width/downRes), random(height/downRes));
  }
}

void renderFrame() {
  saveFrame("render/"+ fileName + zeroPadding(frameCounter, 1000) + "." + fileType);
  frameCounter++;
}

String zeroPadding(int _val, int _maxVal){
  String q = ""+_maxVal;
  return nf(_val,q.length());
}
