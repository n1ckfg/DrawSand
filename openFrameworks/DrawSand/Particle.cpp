#include "Particle.h"


Particle::Particle(float _x, float _y) {
	x = _x;
	y = _y;
	ox = x;
	oy = y;
	s = int(random(5 / downRes, 20 / downRes));
	dustSpread /= downRes;
}

void Particle::update() {
	if (!rebuild) {
		if (mousePressed) {
			rx = mouseX / downRes;  // cursor
			ry = mouseY / downRes;
			radius = dist(x, y, rx, ry);  // distance from particle to cursor
			if (radius <= radiusLimit) {  // trigger distance
				mainColor = outerColor2;
				highlightColor = innerColor2;
				xySize = 4;
				float angle = atan2(y - ry, x - rx);  // angle between particle and cursor
														//calculate velocity
				if (spinSwitch) {
					vx -= (radiusLimit - radius) * 0.01 * cos(angle + (spinAmount + 0.0005 * (radiusLimit - radius)));
					vy -= (radiusLimit - radius) * 0.01 * sin(angle + (spinAmount + 0.0005 * (radiusLimit - radius)));
				}
				else {
					vx -= (radiusLimit - radius) * 0.01 * cos(angle + (0.0005 * (radiusLimit - radius)));
					vy -= (radiusLimit - radius) * 0.01 * sin(angle + (0.0005 * (radiusLimit - radius)));
				}
			}
		}
		if (abs(vx) < 0.7 && abs(vy) < 0.7) {
			xySize = 3;
		}
		if (abs(vx) < 0.3 && abs(vy) < 0.3) {
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
			if (x > (width / downRes) - boundary) {
				vx *= -1;
				x = (width / downRes) - (boundary + 1);
			}
			if (x < boundary) {
				vx *= -1;
				x = (boundary + 1);
			}
			if (y >(height / downRes) - boundary) {
				vy *= -1;
				y = (height / downRes) - (boundary + 1);
			}
			if (y < boundary) {
				vy *= -1;
				y = (boundary + 1);
			}
		}
	}
	else {
		rebuilder();
	}
}

void Particle::draw() {
	stroke(8);
	strokeWeight((float)1 / downRes);
	fill(0);//,50);
	ellipse(x, y, s, s);
}

void Particle::run() {
	update();
	draw();
}

void Particle::rebuilder() {
	if (mousePressed && x != ox && y != oy && dist(ox, oy, mouseX / downRes, mouseY / downRes) <= 50) {
		vx = 0;
		vy = 0;
		x = tween(x, ox, 10) + random(dustSpread) - random(dustSpread);
		y = tween(y, oy, 10) + random(dustSpread) - random(dustSpread);
	}
}

float Particle::tween(float v1, float v2, float e) {
	v1 += (v2 - v1) / e;
	return v1;
}
