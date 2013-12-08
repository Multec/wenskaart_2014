import processing.pdf.*;

color bgColor = color(220);
color fgColor = color(255);

// Vlokkenparameters:
int nMaxSnowFlakes = 90;    //Maximum aantal sneeuwvlokjes
int nMinTrunks = 5;         //Minimum aantal stammen
int nMaxTrunks = 9;         //Maximum aantal stammen
int nMinBranch = 6;         //Minimum aantal takjes
int nMaxBranch = 14;         //Maximum aantal takjes
float minScale = 0.2;       //Minimumschaal t.o.v. branchheight      
float maxScale = 1.3;       //Minimumschaal t.o.v. branchheight    

// Variablelen
float branchHeight = 40;

void setup() {
  size(400, 400);
  background(bgColor);
}

void draw() {
  background(bgColor);
  
  /* Teken sneeuwvlokjes */
  for (int n = 0; n < nMaxSnowFlakes; n++) {
    drawFlakes(n, random(1));
  }

  noLoop();
  
  save("achtergrond.png");
}

void drawFlakes(int n, float rx) {
  float ry = random(1);
  float sca = pow(random(sqrt(minScale), sqrt(maxScale)), 2); // the scale
  float rot = random(0, (2 * PI)); // the rotation
  float[] data = makeSnowFlake();
  
  pushMatrix();
  translate(rx * width, ry * height);
  
  drawOutlinedFlake(data, rot, sca);
  translate(width, 0);
  drawOutlinedFlake(data, rot, sca);
  translate(0, height);
  drawOutlinedFlake(data, rot, sca);
  translate(-width, 0);
  drawOutlinedFlake(data, rot, sca);

  popMatrix();
}

void drawOutlinedFlake(float[] data, float rot, float sca) {
  pushMatrix();
  rotate(rot);
  scale(sca);
  
  // teken rode vlok:
  stroke(bgColor);
  strokeWeight(2);
  drawFlake(data);

  // teken witte vlok:
  stroke(fgColor);
  strokeWeight(1);
  drawFlake(data);
  
  popMatrix();
}

void drawFlake(float[] data) {
  pushMatrix();
  for (int i = 0; i <= data[0]; i++) {
    line(0, 0, 0, branchHeight);
    for (int j = 1; j < (data.length - 1); j++) {
      line(0, data[j], -10, data[j] - 10);
      line(0, data[j], 10, data[j] - 10);
      ellipse(0, branchHeight, 2, 2);
    }
    rotate((2 * PI) / data[0]);
  }
  popMatrix();
}

float[] makeSnowFlake() {
  int nBranch = floor(random(nMinBranch, nMaxBranch));
  float[] data = new float[nBranch + 1];
  data[0] = floor(random(nMinTrunks, nMaxTrunks));
  for (int j = 1; j <= nBranch; j++) {
    data[j] = ceil(random(0, branchHeight));
  }
  return data;
}

