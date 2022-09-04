import peasy.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioInput in;
BeatDetect beat;

PeasyCam cam;

void setup() {
  fullScreen(P3D);
  noCursor();
  minim = new Minim(this);
  cam = new PeasyCam(this, 500);
  in = minim.getLineIn(Minim.STEREO, 1024);
  beat = new BeatDetect();
  beat.setSensitivity(400);
}

void draw() {
  beat.detect(in.mix);

  blendMode(NORMAL);
  background(0);

  cam.setDistance(750);

  hint(DISABLE_DEPTH_TEST);

  int total = 100;
  PVector[][] pp =  new PVector[total][total];
  for (int i = 0; i< total; i++) {
    float lat = map(i, 0, total-1, -HALF_PI, HALF_PI);
    for (int j = 0; j<total; j++) {
      float lon = map(j, 0, total-1, -PI, PI);

      int imnd = i + j*total;
      float r = 200 + in.mix.get(imnd%1024)*200;

      float x = r*sin(lat) * cos(lon);
      float y= r *cos(lat) *sin(lon);
      float z= r*cos(lon);
      pp[i][j] = new PVector(x, y, z);
    }
  }
  blendMode(ADD);
  for (int i =0; i<total-1; i++) {
    beginShape(TRIANGLE_STRIP);
    stroke(5,50,255, in.mix.get(i)*500);
    noFill();
    fill(in.mix.get(i)*500);
    for (int j = 0; j < total; j++) {
      vertex(pp[i][j].x, pp[i][j].y, pp[i][j].z);
      vertex(pp[i+1][j].x, pp[i+1][j].y, pp[i+1][j].z);
    }
    endShape();
  }
}
