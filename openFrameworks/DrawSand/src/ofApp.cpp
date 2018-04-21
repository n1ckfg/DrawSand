#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup() {
	ofSetFrameRate(fps);
	ofBackground(bgColor);

	particlesInit();
	startTime = ofGetElapsedTimeMillis();
	cout << "1 = draw | 2 = wind | 3 = push" << endl;
	cout << "R = reset | S = spin | space = record frame" << endl;

	grainImg.load("grain.png");
	radiusLimitMax /= downRes;
	//bloomSetup();
	//setupShaders();
}

//--------------------------------------------------------------
void ofApp::update() {

}

//--------------------------------------------------------------
void ofApp::draw() {
	//tex.beginDraw();
	ofBackground(bgColor);
	//ofEnableBlendMode(OF_BLENDMODE_MULTIPLY);
	grainImg.draw(0, 0, ofGetWidth() / downRes, ofGetHeight() / downRes);
	//ofSetColor(ofRandom(235, 255)); //tint(ofRandom(235, 255));
	grainImg.draw(0, 0, ofGetWidth() / downRes, ofGetHeight() / downRes);
	//ofSetColor(255); //noTint();
	//ofEnableBlendMode(OF_BLENDMODE_DISABLED);

	for (int x = 0; x < particleCountX; x++) {
		for (int y = 0; y < particleCountY; y++) {
			int loc = x + y * particleCountX;
			particles[loc].run();
		}
	}

	increaseForces();
	//tex.endDraw();

	//bloomDraw();
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key) {
	if (key == ' ') renderFrame();

	if (key == 'r' || key == 'R') particlesInit();

	if (key == 'b' || key == 'B') boundarySwitch = !boundarySwitch;

	if (key == 's' || key == 'S') spinSwitch = !spinSwitch;

	if (key == '1') {  //initial defaults
		rebuild = false;
		radiusLimitMin = 1; // default = 150
		radiusLimit = radiusLimitMin;
		radiusLimitMax = 10 / downRes;
		frictionMin = 1.99;                // default = 0.97 ... none = 1; decel < 1; accel > 1
		friction = frictionMin;
		frictionMax = 0.999;
	}

	if (key == '2') {  // alternate
		rebuild = false;
		radiusLimitMin = 20 / downRes;
		radiusLimitMax = 500 / downRes;
		frictionMin = 0.999;
		frictionMax = 1.2;
		spinAmountMin = 0.5;
		spinAmountMax = 5.0;
	}
	if (key == '3') {  // rebuild
		rebuild = true;
		radiusLimitMin = 1; // default = 150
		radiusLimit = radiusLimitMin;
		radiusLimitMax = 10 / downRes;
		frictionMin = 1.99;                // default = 0.97 ... none = 1; decel < 1; accel > 1
		friction = frictionMin;
		frictionMax = 0.999;
	}
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key) {

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ) {

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button) {

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button) {
	clicked = true;
}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button) {
	clicked = false;
}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y) {

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y) {

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h) {

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg) {

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo) { 

}

void ofApp::particlesInit() {
	particles.clear();
	for (int i = 0; i < particleCountX * particleCountY; i++) {
		Particle p = Particle(ofRandom(0, 100), ofRandom(0, 100));// ofGetWidth() / downRes), ofRandom(0, ofGetHeight() / downRes));
		particles.push_back(p);
	}
}

void ofApp::renderFrame() {
	ofSaveScreen("render/" + fileName + zeroPadding(frameCounter) + "." + fileType);
	frameCounter++;
}

string ofApp::zeroPadding(int _val) {
	string format = "%05d";
	char buffer[100];
	sprintf(buffer, format.c_str(), _val);
	return (string) buffer;
}

void ofApp::increaseForces() {
	if (clicked) {
		saveFrameArm = true;
		if (radiusLimit <= radiusLimitMax) {
			radiusLimit += 1;
		}
		if (friction <= frictionMax) {
			friction += 0.01;
		}
		if (spinAmount <= spinAmountMax) {
			spinAmount += 0.01;
		}
	}
	else {
		counterRelease++;
		if (counterRelease > counterReleaseMax) {
			counterRelease = 0;
			radiusLimit = radiusLimitMin;
			friction = frictionMin;
			spinAmount = spinAmountMin;
		}
		if (saveFrameArm) saveFrameArm = false;
	}
	//if(millis()>startTime+5000) println("fps: " + frameRate + "   radius: " + radiusLimit + "   friction: " + friction + "  spin: " + spinAmount);
}