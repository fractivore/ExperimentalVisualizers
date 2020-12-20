Capture camIn;
AfterimageFunction glitchyVisTest;
PImage test;
int mode = BLEND;
SoundFile songIn;
int pitchArrayConstantSetting = 50;

void setup(){
  size(640,480);
  frameRate(30);
  camIn = new Capture(this,width,height);
  camIn.start();
    test = loadImage("DSC_0054SelfCompositeJeffTile.jpg");
    while(songIn == null){
     songIn = new SoundFile(this, "weepsy-04.wav");
    }
    
    while(glitchyVisTest==null){
        glitchyVisTest = new AfterimageFunction(camIn, test, this);
    }
    
  glitchyVisTest.setScaling(1000);
  glitchyVisTest.setAmpSensitivity(.00001);
  glitchyVisTest.setColorThreshhold(15);
  glitchyVisTest.setBeatDetectionThreshhold(.8);
  glitchyVisTest.setPitchArrayConstant(pitchArrayConstantSetting);
    
   //  songIn.play();
  

  


}

void draw(){
 
  if(keyPressed){
  pitchArrayConstantSetting++;
  glitchyVisTest.setPitchArrayConstant(pitchArrayConstantSetting);
  }
  glitchyVisTest.beatTrailWipe();
  glitchyVisTest.dP("glitchyVisTest.currentAmp: " + glitchyVisTest.currentAmp);
  glitchyVisTest.trailsPitchVisualize(this);
  glitchyVisTest.colorWheel(this);  
  saveFrame();
}
