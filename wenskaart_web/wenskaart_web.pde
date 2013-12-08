/***
 
 wenskaart.ode
 
 A creation from Multec, the professional bachelor in multimedia and
 communication technology at the Erasmus University College in Brussels.
 
 Authors:
 - Inti De Ceukelaire
 - Wouter Van den Broeck
 
 TODO:
 - export large image
 - submit to Google, twitter, etc.
 
 ***/

import processing.pdf.*;

// *****************************************************************************
// Global variables:
// -----------------------------------------------------------------------------

// layoutOptions = ["links", "rechts", "centraal", "banner 1", "banner 2"];
String layout = "banner 1";

// fontOptions = ["sans-serif", "serif", "monospace", "fantasy", "cursive"];
String fontName = "serif";
int fontSize = 28;
PFont font;

color bgColor = color(190, 0, 0);
color fgColor = color(255);
color txtColor = color(255);

String txt = "Beste wensen voor het nieuwe jaar";

// Vlokkenparameters:
int seed = 0;
int nFlakes = 50;           // standaard aantal sneeuwvlokjes
int nMinTrunks = 5;         // Minimum aantal stammen
int nMaxTrunks = 8;         // Maximum aantal stammen
int nMinBranch = 3;         // Minimum aantal takjes
int nMaxBranch = 8;         // Maximum aantal takjes
int nTotBranch = 12;        // 
float minScale = 0.2;       // Minimumschaal t.o.v. trunkHeight      
float maxScale = 1.5;       // Minimumschaal t.o.v. trunkHeight
float trunkHeight = 40;
float branchHeight = 7;

// -----------------------------------------------------------------------------
// Variablelen

PGraphics fg;
PGraphics tg;
PShape multec;
boolean showMultec = true;
boolean redrawFlakes = true;
boolean redrawText = true;
int marginW = 35;
int marginH = 30;

// *****************************************************************************
// PApplet methods:
// -----------------------------------------------------------------------------

void setup() {
  size(700, 360);
  background(255);
  randomSeed(seed);
  fg = createGraphics(width, height, RGB);
  tg = createGraphics(width, height, RGB);

  font = createFont(fontName, fontSize);
  multec = loadShape("images/Multec_logo_RGB.svg");
}

void draw() {
  randomSeed(seed);

  // redraw the flakes when needed:
  if (redrawFlakes) {
    drawFlakes();
    redrawFlakes = false;
  }

  // redraw the text when needed:
  if (redrawText) {
    drawText();
    redrawText = false;
  }

  background(bgColor);
  image(fg, 0, 0);
  image(tg, 0, 0);
  if (showMultec) { 
    drawMultec();
  }

  noLoop();
}

// *********************************************************************************************
// Flakes:
// ---------------------------------------------------------------------------------------------

void drawFlakes() {
  float rx;
  float ry;
  fg.beginDraw();
  fg.background(fgColor, 0);
  for (int n = 0; n < nFlakes; n++) {
    if (layout == "links") {
      rx = 1 - random(random(.8));
      ry = random(1);
    }
    else if (layout == "rechts") {
      rx = random(random(.8));
      ry = random(1);
    }
    else if (layout == "centraal") {
      rx = random(1);
      ry = 1 - random(random(.8));
    }
    else {
      rx = random(1);
      ry = random(1);
    }
    drawOutlinedFlake(n, rx, ry);
  }
  fg.endDraw();
}

void drawOutlinedFlake(int n, float fx, float fy) {
  float[] data = makeSnowFlake();
  float sca = pow(random(sqrt(minScale), sqrt(maxScale)), 2);

  fg.pushMatrix();
  fg.translate(fx * width, fy * height);
  fg.rotate(random(0, TWO_PI));
  fg.scale(sca);

  // teken basis:
  fg.strokeWeight(2);
  drawFlake(data, bgColor);

  // teken vlok:
  fg.strokeWeight(1);
  drawFlake(data, fgColor);

  fg.popMatrix();
}

void drawFlake(float[] data, color c) {
  int nTrunks = data[0];
  int nBranch = data[1];
  fg.fill(c);
  fg.stroke(c);
  fg.pushMatrix();
  for (int i = 0; i <= nTrunks; i++) {
    fg.line(0, 0, 0, trunkHeight);
    for (int j = 2; j < nMaxBranch + 2; j++) {
      fg.line(0, data[j], -branchHeight, data[j] - branchHeight);
      fg.line(0, data[j], branchHeight, data[j] - branchHeight);
      fg.ellipse(0, trunkHeight, 2, 2);
    }
    fg.rotate(TWO_PI / data[0]);
  }
  fg.popMatrix();
}

float[] makeSnowFlake() {
  int nBranch = random(nMinBranch, nMaxBranch);
  float[] data = new float[nBranch + 2];
  data[0] = floor(random(nMinTrunks, nMaxTrunks));
  data[1] = nBranch;
  for (int j = 2; j < nTotBranch + 2; j++) {
    data[j] = ceil(random(0, trunkHeight));
  }
  return data;
}

// *********************************************************************************************
// Text:
// ---------------------------------------------------------------------------------------------

void drawText() {
  //println(">> drawText() - layout: " + layout + ", fontSize: " + fontSize);

  tg.background(bgColor, 0);
  tg.beginDraw();
  tg.noStroke();
  tg.textFont(font);

  int tx;
  int ty;

  if (layout == "links") {
    tx = marginW;
    tg.textAlign(LEFT);
  }
  else if (layout == "rechts") {
    tx = width - marginW;
    tg.textAlign(RIGHT);
  }
  else {
    tx = width / 2;
    tg.textAlign(CENTER);
  }

  if (layout == "links" || layout == "rechts" || layout == "centraal") {
    ty = fontSize + 25;
  }
  else {
    ty = height - fontSize * 1.2;
  }

  if (layout == "links" || layout == "rechts" || layout == "centraal") {
    tg.fill(bgColor);
    tg.text(txt, tx - 2, ty - 2);
    tg.text(txt, tx + 0, ty - 2);
    tg.text(txt, tx + 2, ty - 2);
    tg.text(txt, tx - 2, ty);
    tg.text(txt, tx + 2, ty);
    tg.text(txt, tx - 2, ty + 2);
    tg.text(txt, tx + 0, ty + 2);
    tg.text(txt, tx + 2, ty + 2);
    tg.fill(txtColor);
    tg.text(txt, tx, ty);
  }
  else if (layout == "banner 1") {
    drawBanner(tx, ty, txtColor, bgColor);
  }
  else if (layout == "banner 2") {
    drawBanner(tx, ty, fgColor, txtColor);
  }

  tg.endDraw();
}

void drawBanner(int tx, int ty, color c1, color c2) {
  textSize(fontSize);
  float ascent = textAscent();
  float descent = textDescent();

  switch (fontName) {
  case "sans-serif":
  case "serif":
  case "monospace":
    ascent += fontSize / 4.5;
    descent += fontSize / 5;
    break;
  case "fantasy":
    ascent += fontSize / 2.5;
    descent += fontSize / 2;
    break;
  case "cursive":
    ascent += fontSize / 3.7;
    descent += fontSize / 3.3;
    break;
  default:
    println("ERROR: Onverwachte font '" + fontName + "'.");
  }

  tg.fill(c1);
  tg.rect(0, round(ty - ascent), width, round(ascent + descent));
  tg.fill(c2);
  tg.text(txt, tx, ty);
}

// *********************************************************************************************
// Multec logo:
// ---------------------------------------------------------------------------------------------

void drawMultec() {
  float mw = 100;
  float mh = multec.height * mw / multec.width;
  multec.disableStyle();
  pushMatrix();
  if (layout == "links") {
    translate(marginW, height - 25 - mh);
  }
  else if (layout == "rechts" || layout == "centraal") {
    translate(width - marginW - mw, height - 25 - mh);
  }
  else {
    translate(width - marginW - mw, marginH);
  }
  noFill();
  stroke(bgColor, 204);
  strokeWeight(6);
  shape(multec, 0, 0, mw, mh);
  fill(fgColor);
  noStroke();
  shape(multec, 0, 0, mw, mh);
  popMatrix();
}

// *********************************************************************************************
// Webpage control methods:
// ---------------------------------------------------------------------------------------------

void setLayout(String v) {
  //println(">> setLayout(" + v + ") - layout: " + layout);
  layout = v;
  redrawFlakes = true;
  redrawText = true;
  redraw();
}

void setFont(String name) {
  fontName = name;
  font = createFont(fontName, fontSize);
  redrawText = true;
  redraw();
}

void setFontSize(int size) {
  //println(">> setFontSize(" + size + ") - fontName: " + fontName);
  fontSize = size;
  font = createFont(fontName, fontSize);
  redrawText = true;
  redraw();
}

void setText(String newText) {
  txt = newText;
  redrawText = true;
  redraw();
}

void setNFlakes(int n) {
  nFlakes = constrain(n, 1, 200);
  redrawFlakes = true;
  redraw();
}

void setNTrunks(int min, int max) {
  nMinTrunks = min;
  nMaxTrunks = max;
  redrawFlakes = true;
  redraw();
}

void setNBranches(int min, int max) {
  nMinBranch = min;
  nMaxBranch = max;
  redrawFlakes = true;
  redraw();
}

void setFgColor(int r, int g, int b) {
  fgColor = color(r, g, b);
  redrawFlakes = true;
  redraw();
}

void setBgColor(int r, int g, int b) {
  bgColor = color(r, g, b);
  redrawFlakes = true;
  redrawText = true;
  redraw();
}

void setTxtColor(int r, int g, int b) {
  txtColor = color(r, g, b);
  redrawText = true;
  redraw();
}

void resetSeed() {
  seed = floor(random(0, 500));
  redrawFlakes = true;
  redraw();
}

void showMultecLogo() {
  showMultec = true;
  redraw();
}

void hideMultecLogo() {
  showMultec = false;
  redraw();
}

void exportImage() {
  save("img.png");
}

