#include "Particle.h"
#include "ofApp.h"
// https://gist.github.com/jmsaavedra/7964315

Particle::Particle(float _x, float _y) {
	x = _x;
	y = _y;
	ox = x;
	oy = y;
	downRes = ((ofApp*) ofGetAppPtr()) -> downRes;
	s = int(ofRandom(5 / downRes, 20 / downRes));
	dustSpread /= downRes;
}

void Particle::update() {
	int radiusLimit = ((ofApp*) ofGetAppPtr()) -> radiusLimit;
	bool spinSwitch = ((ofApp*) ofGetAppPtr()) -> spinSwitch;
	float spinAmount = ((ofApp*) ofGetAppPtr()) -> spinAmount;
	float friction = ((ofApp*) ofGetAppPtr()) -> friction;
	int boundary = ((ofApp*) ofGetAppPtr()) -> boundary;
	bool boundarySwitch = ((ofApp*) ofGetAppPtr()) -> boundarySwitch;

	if (!((ofApp*) ofGetAppPtr()) -> rebuild) {
		if (((ofApp*) ofGetAppPtr()) -> clicked) {
			rx = ofGetAppPtr()->mouseX / downRes;  // cursor
			ry = ofGetAppPtr()->mouseY / downRes;
			radius = ofVec2f(x, y).distance(ofVec2f(rx, ry));  // distance from particle to cursor
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
			if (x > (ofGetWidth() / downRes) - boundary) {
				vx *= -1;
				x = (ofGetWidth() / downRes) - (boundary + 1);
			}
			if (x < boundary) {
				vx *= -1;
				x = (boundary + 1);
			}
			if (y >(ofGetHeight() / downRes) - boundary) {
				vy *= -1;
				y = (ofGetHeight() / downRes) - (boundary + 1);
			}
			if (y < boundary) {
				vy *= -1;
				y = (boundary + 1);
			}
		}
	} else {
		rebuilder();
	}
}

void Particle::draw() {
	ofSetColor(0);
	ofFill();//,50);
	ofEllipse(x, y, s, s);

	ofSetColor(8);
	glLineWidth((float)1 / downRes);
	ofNoFill();
	ofEllipse(x, y, s, s);
}

void Particle::run() {
	update();
	draw();
}

void Particle::rebuilder() {
	float dist = ofVec2f(ox, oy).distance(ofVec2f(ofGetAppPtr()->mouseX / downRes, ofGetAppPtr()->mouseY / downRes));
	if (((ofApp*) ofGetAppPtr()) -> clicked && x != ox && y != oy && dist <= 50) {
		vx = 0;
		vy = 0;
		x = tween(x, ox, 10) + ofRandom(dustSpread) - ofRandom(dustSpread);
		y = tween(y, oy, 10) + ofRandom(dustSpread) - ofRandom(dustSpread);
	}
}

float Particle::tween(float v1, float v2, float e) {
	v1 += (v2 - v1) / e;
	return v1;
}
