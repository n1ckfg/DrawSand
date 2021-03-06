void keyPressed() {
  if (key==' ') renderFrame();

  if (key=='r' || key=='R') particlesInit();
  
  if (key=='b'||key=='B') boundarySwitch = !boundarySwitch;

  if (key=='s'||key=='S') spinSwitch = !spinSwitch; 

  if (key=='1') {  //initial defaults
    rebuild = false;
    radiusLimitMin = 1; // default = 150
    radiusLimit = radiusLimitMin;
    radiusLimitMax = 10/downRes;
    frictionMin = 1.99;                // default = 0.97 ... none = 1; decel < 1; accel > 1
    friction = frictionMin;
    frictionMax = 0.999;
  }
  
  if (key=='2') {  // alternate
    rebuild = false;
    radiusLimitMin = 20/downRes; 
    radiusLimitMax = 500/downRes;
    frictionMin = 0.999;                
    frictionMax = 1.2;
    spinAmountMin = 0.5;               
    spinAmountMax = 5.0;
  }
  if (key=='3') {  // rebuild
    rebuild = true;
    radiusLimitMin = 1; // default = 150
    radiusLimit = radiusLimitMin;
    radiusLimitMax = 10/downRes;
    frictionMin = 1.99;                // default = 0.97 ... none = 1; decel < 1; accel > 1
    friction = frictionMin;
    frictionMax = 0.999;
  }
}

void increaseForces() {
  if (mousePressed) {
    saveFrameArm=true;
    if (radiusLimit <= radiusLimitMax) {
      radiusLimit+=1;
    }
    if (friction <= frictionMax) {
      friction+=0.01;
    }
    if (spinAmount <= spinAmountMax) {
      spinAmount+=0.01;
    }
  } else {
    counterRelease++;
    if (counterRelease > counterReleaseMax) {
      counterRelease=0;
      radiusLimit = radiusLimitMin;
      friction = frictionMin;
      spinAmount = spinAmountMin;
    }
    if (saveFrameArm) saveFrameArm=false;
  }
  //if(millis()>startTime+5000) println("fps: " + frameRate + "   radius: " + radiusLimit + "   friction: " + friction + "  spin: " + spinAmount);
}
