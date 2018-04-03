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
  float ox;
  float oy;
  float vx;
  float vy;
  float xySize = 3;
  int s;
  int rx = mouseX/downRes;  // cursor
  int ry = mouseY/downRes;
  float radius = dist(x,y,rx,ry);
      
  Particle(float _x, float _y) {
    x = _x;
    y = _y;
    ox = x;
    oy = y;
    s = int(random(5,20));
  }

  void update() {
    if (!rebuild) {
      if (mousePressed) {
        rx = mouseX/downRes;  // cursor
        ry = mouseY/downRes;
        radius = dist(x,y,rx,ry);  // distance from particle to cursor
        if (radius <= radiusLimit) {  // trigger distance
          mainColor = outerColor2;
          highlightColor = innerColor2;
          xySize = 4;
          float angle = atan2(y-ry,x-rx);  // angle between particle and cursor
          //calculate velocity
          if (spinSwitch) {
            vx -= (radiusLimit - radius) * 0.01 * cos(angle + (spinAmount + 0.0005 * (radiusLimit - radius)));
            vy -= (radiusLimit - radius) * 0.01 * sin(angle + (spinAmount + 0.0005 * (radiusLimit - radius)));
          } else {
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
      if (boundarySwitch) {  
        if (x > (width/downRes)-boundary) {
          vx *= -1;
          x = (width/downRes)-(boundary+1);
        }
        if (x < boundary) {
          vx *= -1;
          x = (boundary+1);
        }
        if (y > (height/downRes)-boundary) {
          vy *= -1;
          y = (height/downRes)-(boundary+1);
        }
        if (y < boundary) {
          vy *= -1;
          y = (boundary+1);
        }
      }
    } else {
      rebuilder();
    }
    //draw particles
    drawParticle();

  }
  //appearance of particle
  void drawParticle() {
    tex.fill(0);//,50);
    //tex.strokeWeight(s);
    tex.ellipse(x,y,s,s);
  }

  void rebuilder(){
    if (mousePressed && x!=ox && y !=oy && dist(ox,oy,mouseX/downRes,mouseY/downRes)<=50) {
      vx = 0;
      vy = 0;
      x = tween(x,ox,10) + random(spread) - random(spread);
      y = tween(y,oy,10) + random(spread) - random(spread);
    }
  }
  
  float tween(float v1, float v2, float e) {
    v1 += (v2-v1)/e;
    return v1;
  }

}
