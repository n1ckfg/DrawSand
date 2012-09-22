class Particle {
  color outerColor1 = color(200,100,0,100);
  color outerColor2 = color(200,120,20,250);
  color innerColor1 = color(200,120,20,250);
  color innerColor2 = color(255,255,200,250);
  color mainColor = outerColor1;
  color highlightColor = innerColor1;
  //---
  float x;
  float y;
  float vx;
  float vy;
  float xySize = 3;

  Particle() {
    x = xPos;
    y = yPos;
  }

  void update() {
    if (mousePressed) {
      int rx = mouseX;  // cursor
      int ry = mouseY;
      float radius = dist(x,y,rx,ry);  // distance from particle to cursor
      if (radius <= radiusLimit) {  // trigger distance
        mainColor = outerColor2;
        highlightColor = innerColor2;
        xySize = 4;
        float angle = atan2(y-ry,x-rx);  // angle between particle and cursor
        //calculate velocity
        if(spinSwitch){
          vx -= (radiusLimit - radius) * 0.01 * cos(angle + (spinAmount + 0.0005 * (radiusLimit - radius)));
          vy -= (radiusLimit - radius) * 0.01 * sin(angle + (spinAmount + 0.0005 * (radiusLimit - radius)));
        } 
        else {
          vx -= (radiusLimit - radius) * 0.01 * cos(angle + (0.0005 * (radiusLimit - radius)));
          vy -= (radiusLimit - radius) * 0.01 * sin(angle + (0.0005 * (radiusLimit - radius)));
        }
      } 
    }
    if (abs(vx)<0.7&&abs(vy)<0.7) {
      xySize = 3;
    }
    if (abs(vx)<0.3&&abs(vy)<0.3) {
      mainColor = outerColor1;
      highlightColor = innerColor1;
    }
    //apply velocity
    x += vx;
    y += vy;
    //apply friction
    vx *= friction;
    vy *= friction;
    //boundaries
    if(boundarySwitch){  
      if (x > width-boundary) {
        vx *= -1;
        x = width-(boundary+1);
      }
      if (x < boundary) {
        vx *= -1;
        x = (boundary+1);
      }
      if (y > height-boundary) {
        vy *= -1;
        y = height-(boundary+1);
      }
      if (y < boundary) {
        vy *= -1;
        y = (boundary+1);
      }
    }
    //draw particles
    drawParticle();

  }
  //appearance of particle
  void drawParticle() {
stroke(0,50);
strokeWeight(10);
point(x,y);
/*
noStroke();
fill(255,20);
ellipseMode(CENTER);
ellipse(x,y,10,10);
*/
  }
}








