import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter;
import processing.opengl.PGraphics2D;

DwPixelFlow context;
DwFilter filter;
PGraphics2D tex, tex2;
PMatrix mat_scene;
int downRes = 4;

// This goes immediately after size().
void bloomSetup() {  
  mat_scene = getMatrix();
  tex = (PGraphics2D) createGraphics(width/downRes, height/downRes, P2D);
  tex2 = (PGraphics2D) createGraphics(width, height, P2D);
  context = new DwPixelFlow(this);
  filter = new DwFilter(context);
  //filter.bloom.setBlurLayers(10);
  filter.bloom.param.mult = 3.5; // 0.0-10.0
  filter.bloom.param.radius = 0.5; // 0.0-1.0
}

// For a simple scene, just put this at the end of the draw loop.
void bloomDraw() {
  tex2.beginDraw();
  tex2.image(tex, 0, 0, width, height);
  drawShaders();
  tex2.endDraw();
  filter.bloom.apply(tex2);
  image(tex2, 0, 0);
}

// Or, for a more complex scene, this goes at the beginning of the draw loop...
void bloomMatrixStart() {
  pushMatrix();
}

// ...and this goes at the end.
void bloomMatrixEnd() {
  setMatrix(mat_scene);
  bloomDraw();
  popMatrix();
}
