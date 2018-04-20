#pragma once

#include "ofMain.h"
#include "Particle.h"

class ofApp : public ofBaseApp {

	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void mouseEntered(int x, int y);
		void mouseExited(int x, int y);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);

		void particlesInit();
		void renderFrame();
		string zeroPadding(int _val);
		void increaseForces();

		// basics
		bool clicked = false;
		int numParticles = 400;
		ofColor bgColor = ofColor(255, 127, 0);
		int particleCountX = int(numParticles / 2);  // default 40
		int particleCountY = int(numParticles / 2);
		vector<Particle> particles;

		// additional
		int radiusLimitMin = 1; // default = 150
		int radiusLimit = radiusLimitMin;
		int radiusLimitMax = 10;
		float frictionMin = 1.99;                // default = 0.97 ... none = 1; decel < 1; accel > 1
		float friction = frictionMin;
		float frictionMax = 0.999;
		int boundary = 0;                    // default = 10;
		bool boundarySwitch = true;        // default = true
		float spinAmountMin = 0.2;               // default = 0.7
		float spinAmount = spinAmountMin;
		float spinAmountMax = 1.0;
		bool spinSwitch = true;            // default = true
		int fps = 60;
		int counterRelease = 0;
		int counterReleaseMax = fps / 3;
		bool saveFrameArm = false;
		int frameCounter = 1;
		string fileName = "frame";
		string fileType = "png";
		bool rebuild = false;
		int startTime;
		ofImage grainImg;
		int downRes = 4;
		
};
