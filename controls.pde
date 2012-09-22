void keyPressed() {
  if(key==' '){
    renderFrame();
  }
  if(key=='r'||key=='R'){
    particlesInit();
  }
  /*
  if(key=='b'||key=='B'){
    if(boundarySwitch==true){
      boundarySwitch=false;
    }
    else if (boundarySwitch==false){
      boundarySwitch=true;
    }
  }
  */
  if(key=='s'||key=='S'){
    if(spinSwitch==true){
      spinSwitch=false;
    }
    else if (spinSwitch==false){
      spinSwitch=true;
    }
  }
  if(key=='1'){  //initial defaults
    rebuild = false;
    radiusLimitMin = 1; // default = 150
    radiusLimit = radiusLimitMin;
    radiusLimitMax = 10;
    frictionMin = 1.99;                // default = 0.97 ... none = 1; decel < 1; accel > 1
    friction = frictionMin;
    frictionMax = 0.999;
  }
  if(key=='2'){  // alternate
    rebuild = false;
    radiusLimitMin = 20; 
    radiusLimitMax = 500;
    frictionMin = 0.999;                
    frictionMax = 1.2;
    spinAmountMin = 0.5;               
    spinAmountMax = 5.0;
  }
  if(key=='3'){  // rebuild
    rebuild = true;
    radiusLimitMin = 1; // default = 150
    radiusLimit = radiusLimitMin;
    radiusLimitMax = 10;
    frictionMin = 1.99;                // default = 0.97 ... none = 1; decel < 1; accel > 1
    friction = frictionMin;
    frictionMax = 0.999;
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
      saveFrameArm=false;
    }
  }
  if(millis()>startTime+5000) println("fps: " + frameRate + "   radius: " + radiusLimit + "   friction: " + friction + "  spin: " + spinAmount);
}

