#pragma once

#include "ofMain.h"

class Particle {

	public:
		Particle(float _x, float _y);
		void update();
		void draw();
		void run();
		void rebuilder();
		float tween(float v1, float v2, float e);

		ofColor outerColor1 = ofColor(200, 100, 0, 100);
		ofColor outerColor2 = ofColor(200, 120, 20, 250);
		ofColor innerColor1 = ofColor(200, 120, 20, 250);
		ofColor innerColor2 = ofColor(255, 255, 200, 250);
		ofColor mainColor = outerColor1;
		ofColor highlightColor = innerColor1;
		//---
		float x;
		float y;
		float ox;
		float oy;
		float vx;
		float vy;
		float xySize = 3;
		int s;
		int downRes = 1;
		int rx = ofGetAppPtr() -> mouseX / downRes;
		int ry = ofGetAppPtr() -> mouseY / downRes;
		float radius = ofVec2f(x, y).distance(ofVec2f(rx, ry));
		int dustSpread = 10;

};