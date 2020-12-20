/*:::::::::In This version:::::::::::::
-Update made to visualize based on the amplitude of each input pitch. This required converting most
 integer arrays to floating point arrays.
 
 As of right now, removeRedundant still needs to be updated to finish implementing this change.
 */

//Try using two temporally offset FFTs to obtain faster pitch display without losing accuracy.

//Import necessary libraries:
import processing.sound.*;
import processing.video.*;

//Declare global variables:
AudioIn in;
FFT fft;
Sound device;
String testFileName = "BocCircle.mp3";
boolean DEBUGDISPLAY = false;

//Set sample rate and buffer size (bands). The sample rate should be as low
//as possible to reduce latency, but the time resolution needs to be fine enough to
//recognize impulses.
int bands = 4096;//so far best luck with bands = 8192 or 4096, sampleRate = 44100, sigParam = 0.7
int sampleRate = 44100;
float sigParam = 0.2  ; //Number between 0 and 1 that indicates sensitivity to
//frequency at least sigParam*maxFreq
float ampSensitivity = 1; //A larger number means less sensitive
int note = 0;
SoundFile TestFile;

boolean soundFileModeON = true;
boolean saveFileON = true;
boolean visualizationHasBegun = false;
boolean soundDetected = false;

//Declare Image Variables:
Movie Cn, Cs, Dn, Ds, En, Fn, Fs, Gn, Gs, An, As, Bn;
Movie CnMov,CsMov,DnMov,DsMov,EnMov,FnMov,FsMov,GnMov,GsMov,AnMov,AsMov,BnMov;
int mode = BLEND;
int sizeX = 620;
int sizeY = 360;

void setup() {
  
  //Set Background and Load Image Files:
  //For fractals, set size to 1024x1024
  size(displayWidth,displayHeight, P2D);
  background(255,201,0);
  visualizationHasBegun = false;
  
  while(device == null){
  device = new Sound(this);
  }
  while(in == null){
  in = new AudioIn(this,0);
  }
  while(fft == null){
  fft = new FFT(this, bands);
  }
  
  
if(CnMov == null){println("Yep, null");}
  //Just seeing if this helps in V.2.1:
  while(CnMov == null){
  CnMov = new Movie(this, "CnMov.mov");
  println("Made it through CnMov Initialization");
  }
  while(CsMov == null){
  CsMov = new Movie(this, "CsMov.mov");
    println("Made it through CsMov Initialization");
  }
  while(DnMov == null){
  DnMov = new Movie(this, "DnMov.mov");
  println("Made it through DnMov Initialization");
  }
  while(DsMov == null){
  DsMov = new Movie(this, "DsMov.mov");
  println("Made it through DsMov Initialization");
  }
  while(EnMov == null){
  EnMov = new Movie(this, "EnMov.mov");
    println("Made it through EnMov Initialization");
  }
  while(FnMov == null){
  FnMov = new Movie(this, "FnMov.mov");
    println("Made it through FnMov Initialization");
  }
  while(FsMov == null){
  FsMov = new Movie(this, "FsMov.mov");
    println("Made it through FsMov Initialization");
  }
  while(GnMov == null){
  GnMov = new Movie(this, "GnMov.mov");
    println("Made it through GnMov Initialization");
  }
  while(GsMov == null){
  GsMov = new Movie(this, "GsMov.mov");
    println("Made it through GsMov Initialization");
  }
  while(AnMov == null){
  AnMov = new Movie(this, "AnMov.mov");
    println("Made it through AnMov Initialization");
  }
  while(AsMov == null){
  AsMov = new Movie(this, "AsMov.mov");
    println("Made it through AsMov Initialization");
  }
  while(BnMov == null){
  BnMov = new Movie(this, "BnMov.mov");
    println("Made it through BnMov Initialization");
  }
  
  
  CnMov.loop();
  CsMov.loop();
  DnMov.loop();
  DsMov.loop();
  EnMov.loop();
  FnMov.loop();
  FsMov.loop();
  GnMov.loop();
  GsMov.loop();
  AnMov.loop();
  AsMov.loop();
  BnMov.loop();

  
   if(soundFileModeON){//CONDITIONAL FOR TURNING ON SOUNDFILE MODE
 TestFile = new SoundFile(this, testFileName);
 //PLAY INPUT FILE IF IN SOUNDFILE MODE:
  TestFile.play();
  //Designate the sound file as the source for thee FFT
  fft.input(TestFile);
 }else{//ELSE STATEMENT FOR MICROPHONE MODE
  //Designate the microphone as audio input for FFT 
  if(in != null && fft != null){
  in.start();
  in.amp(100);  
  fft.input(in);
   }
  }
  
  blendMode(mode);
  //Construct instances of necessary audio classes:

  
  //Designate audio input stream as input to FFT:
  
  //Designate Blending Mode for Images:
  blendMode(mode);
  
}
/*void movieEvent(Movie m) {
  if(m != null && CnMov != null && CsMov != null && DnMov != null&& DsMov != null && EnMov != null && FnMov != null
  && FsMov != null && GnMov != null && GsMov != null && AnMov != null && AsMov != null && BnMov != null && frameCount > 1){
  if(DEBUGDISPLAY == true){
    println("Movie Event");
  }
  m.read();
  }
}*/

void draw() {
  //Troubleshooting experiment:
  
  
    if (CnMov.available() == true) {
    CnMov.read(); } 
    if (CsMov.available() == true) {
    CnMov.read(); } 
    if (DnMov.available() == true) {
    DnMov.read(); } 
    if (DsMov.available() == true) {
    DsMov.read(); } 
    if (EnMov.available() == true) {
    EnMov.read(); } 
    if (FnMov.available() == true) {
    FnMov.read(); } 
    if (FsMov.available() == true) {
    FsMov.read(); } 
    if (GnMov.available() == true) {
    GnMov.read(); } 
    if (GsMov.available() == true) {
    GsMov.read(); } 
    if (AnMov.available() == true) {
    AnMov.read(); } 
    if (AsMov.available() == true) {
    AsMov.read(); } 
    if (BnMov.available() == true) {
    BnMov.read(); } 
    
    
    //Initialize significant frequency counter at start of loop:
    if(DEBUGDISPLAY == true){
      println("beginning of draw loop");
    }
  int freqIndex = 0, numNotes = 0;
  float[] sigArray = new float[0];
  float bigfreq = 0, currentAmp = 0, ampThreshold = 0;
  float[] Spectrum = new float[bands];
//Image set hotkeys removed due to technical issue with running that many videos for the video version
  
    Cn = CnMov; Cs = CsMov; Dn = DnMov; Ds = DsMov; En = EnMov; Fn = FnMov; Fs = FsMov;
    Gn = GnMov; Gs = GsMov; An = AnMov; As = AsMov; Bn = BnMov;
  //End of image hotkey designation  
  
  
  //Obtain frequency spectrum using FFT and a measure of volume by summing
  //the frequency spectrum:  
  if(DEBUGDISPLAY == true){
    println("line 202 (before FFT analyze)");
  }
  if(fft != null){
  fft.analyze();
  Spectrum = fft.spectrum;
  }
  if(DEBUGDISPLAY == true){
    println("line 209 (after FFT analyze)");
  }
  
  //Find the greatest constituent frequency and its index. Note that this is redundant with sigArray.
  if(Spectrum != null){
  bigfreq = max(Spectrum);
  freqIndex = getIndex(Spectrum, bigfreq);
  
  //Obtain a measure of amplitude by summing the frequency spectrum:
  currentAmp = arraySum(Spectrum);
  if(DEBUGDISPLAY == true){
  println("line 220");
  }
  //If the current amplitude is above the threshold, find the indices frequencies at least .9 times the greatest frequency and store them in an array.
  //if not, the function returns the array [-1]:
 sigArray = removeRedundant(indToNum(findSigFreqs(Spectrum, bigfreq, ampThreshold)));
 if(DEBUGDISPLAY == true){
 println("line226");
 }
 numNotes = sigArray.length;
  }
 
    
  //DEBUG DISPLAY::::::::::::::::::;::::::::::::::
  /*println("Amplitude of Max Frequency:  " + bigfreq);  
  println("Index of Max Frequency: " + freqIndex);  
  println("Amplitude of Input:  " + currentAmp);
  println("Number of Notes Found:  " + numNotes);
  */
  //END OF DEBUG DISPLAY......................

  //Gimme dat Synesthesia!!:
  

  Visualize(currentAmp, ampThreshold,sigArray,currentAmp, Cn, Cs, Dn, Ds, En, Fn, Fs, Gn, Gs, An, As, Bn);
  visualizationHasBegun = true;
  
  
  //Display the name of each note detected:
  /*for(int u = 0 ; u < numNotes - 1 ; u++){
    
    showMeDatNote(pitchRecognize(sigArray[u]),620/(numNotes+2),160);
  }*/
          
//For each note found, display an image. If multiple notes were found, display
//that many images blended together

//For saving video, use this:

if(saveFileON == true){
 if(soundDetected == false){ 
  if(currentAmp > 0){
    soundDetected = true;
   }
 }
 if(soundDetected){
   saveFrame("frames./####");
 }
} //END OF VIDEO CAPTURE BLOCK

} //END OF DRAW FUNCTION

//:::::::::::::::::::::::::DEFINE FUNCTIONS:::::::::::::::::::::::::::::::::::::::::::::

//Define getIndex function (used to obtain the index of a known value in an array):
int getIndex(float[] someArray, float ValueToBeFound) {
   if(DEBUGDISPLAY == true){
  println("getIndex (beginning)");
  }
  
  int IndexToBeFound = -1;
  if(someArray != null){
  for(int n = 0 ; n < bands ; n++){
    if(someArray[n] == ValueToBeFound){
      IndexToBeFound = n;
      break;
     }
    }
   }
   
   return IndexToBeFound;
 }

//Define arraySum function (used to sum the elements of an array): 
float arraySum(float[] inArray){
   if(DEBUGDISPLAY == true){
  println("arraySum (beginning)");
  }
 
  float sum = 0;
  if(inArray != null){
  for(int k = 0 ; k < inArray.length - 1 ; k++){
    sum += inArray[k];
    }
  }  
  return sum;
}

//Define the visualizer function. The final version of this function will output
//a blend of a subset of 12 different images based on input pitches.
void Visualize(float testvalue, float threshold,float[] noteNums, float amplitudeIn, Movie Cnimg, Movie Csimg, Movie Dnimg, Movie Dsimg, Movie Enimg, Movie Fnimg,
      Movie Fsimg, Movie Gnimg, Movie Gsimg, Movie Animg, Movie Asimg, Movie Bnimg){
         if(DEBUGDISPLAY == true){
  println("Visualize (beginning)");
  }
        
  float[] notesIn = new float[0];
  float[] ampsIn = subset(noteNums, noteNums.length/2);
  float totalSigAmp = arraySum(ampsIn);
 
 if(noteNums.length > 1){
   notesIn = subset(noteNums,0,noteNums.length/2);
  if(testvalue > threshold){
    background(0);
    if(notesIn.length == 1){ //Changed from check if noteNums.length == 1
      multiImageDisplay(notesIn[0],1, amplitudeIn, Cnimg, Csimg, Dnimg, Dsimg, Enimg, Fnimg,
      Fsimg, Gnimg, Gsimg, Animg, Asimg, Bnimg);
    }else{
      int L = 0;
      while(L <= notesIn.length - 1){
        if(DEBUGDISPLAY == true){
          println("start of notesIn while loop (line 319)");
        }
        multiImageDisplay(notesIn[L],totalSigAmp/ampsIn[L],amplitudeIn, Cnimg, Csimg, Dnimg, Dsimg, Enimg, Fnimg,
      Fsimg, Gnimg, Gsimg, Animg, Asimg, Bnimg);
      if(DEBUGDISPLAY == true){
      println("Before L increments (line 323");
      }
        L++;
        
         if(DEBUGDISPLAY == true){
  println("Visualize (loop end)");
  }
     }//End of "for" loop for incrementing the index counter, nested within the "else" case.
    }//End of "else" case, wherein the note number array is incremented through to
    //display images
  }//Ends check if the input value is greater than designated threshold
 }//Ends check if noteNum array is large enough for the halving operation
 if(DEBUGDISPLAY == true){
   println("Visualize (actual end)");
 }
}//Main Function bracket

//Define Pitch Recognition funtion (just converts index into pitch):
float pitchRecognize(float ind){
   if(DEBUGDISPLAY == true){
  println("pitchRecognize (beginning)");
  }
  
  float freqRes = sampleRate/bands;
  for(int p = 0 ; p < 10 ; p++) {
    if ((16.35*pow(2,p))-pow(2,p-1)*.98 < ind*freqRes && ind*freqRes  < (16.35*pow(2,p))+pow(2,p-1)*.98){
      return 0; //Note = C
      
   }else if (17.32*pow(2,p)-pow(2,p-1)*1.03 < ind*freqRes && ind*freqRes < (17.32*pow(2,p))+ pow(2,p-1)*1.03){
      return 1; //Note = C#
     
   }else if (18.35*pow(2,p)-pow(2,p-1)*1.10 < ind*freqRes && ind*freqRes < 18.35*pow(2,p)+pow(2,p-1)*1.10){
      return 2; //Note = D
      
   }else if (19.45*pow(2,p)- pow(2,p-1)*1.15 < ind*freqRes && ind*freqRes < (19.45*pow(2,p))+pow(2,p-1)*1.15){
      return 3; //Note = D#
      
   }else if (20.60*pow(2,p)- pow(2,p-1)*1.23 < ind*freqRes && ind*freqRes < (20.60*pow(2,p))+pow(2,p-1)*1.23){
      return 4; //Note = E
      
    }else if (21.83*pow(2,p)- pow(2,p-1)*1.29 < ind*freqRes && ind*freqRes < (21.83*pow(2,p))+pow(2,p-1)*1.29){
      return 5; //Note = F
     
    }else if (23.12*pow(2,p)- pow(2,p-1)*1.38 < ind*freqRes && ind*freqRes < (23.12*pow(2,p))+pow(2,p-1)*1.38){
      return 6; //Note = F#
     
    }else if (24.50*pow(2,p)- pow(2,p-1)*1.46 < ind*freqRes && ind*freqRes < (24.50*pow(2,p))+pow(2,p-1)*1.46){
      return 7; //Note = G
      
    }else if (25.96*pow(2,p)- pow(2,p-1)*1.54 < ind*freqRes && ind*freqRes < (25.96*pow(2,p))+pow(2,p-1)*1.54){
      return 8; //Note = G#
      
    }else if (27.50*pow(2,p)- pow(2,p-1)*1.64 < ind*freqRes && ind*freqRes < (27.50*pow(2,p))+pow(2,p-1)*1.64){
      return 9; //Note = A
      
    }else if (29.14*pow(2,p)- pow(2,p-1)*1.73 < ind*freqRes && ind*freqRes < (29.14*pow(2,p))+pow(2,p-1)*1.73){
      return 10; //Note = A#
      
    }else if (30.87*pow(2,p)- pow(2,p-1)*1.83 < ind*freqRes && ind*freqRes < (30.87*pow(2,p))+pow(2,p-1)*1.83){
      return 11; //Note = B
      
       }
     }
     
    return -1; //Note is not within one of the specified ranges.
}

//Define the function that finds the number of significant frequencies and their indices:
//As of V1.3 findSigFreqs appears to be working properly.
//Inputs are taken from the FFT spectrum, which indexes in integer multiples of sampleRate/bands (units of Hz)
float[] findSigFreqs(float[] spctrm, float amplitude, float threshold){
  if(DEBUGDISPLAY == true){
    println("findSigFreqs (beginning)");
   }
  
  float[] sigFreqsArray = new float[0];
  float[] ampArray = new float[0];
  float maxVal = max(spctrm);
  
  if(amplitude > threshold){
    for(int b = 0 ; b < bands ; b++){
      if(spctrm[b] >= maxVal*sigParam){
        sigFreqsArray = append(sigFreqsArray, b);
        ampArray = append(ampArray,spctrm[b]);
        
      }//End of "if" statement
    }//End of incrementinc "for" loop
  } else {
    sigFreqsArray = append(sigFreqsArray,-1);
  }//End of "else" case
  
  sigFreqsArray = concat(sigFreqsArray,ampArray);
  
  
  return sigFreqsArray;
  //This value is passed to indToNum
}

//Define the function that eliminates redundant note indices:
  /* 
    Valid inputs to this function are even-length arrays
    where the first half gives the note numbers and the second half
    gives their respective amplitudes.
  */
float[] removeRedundant(float[] pitchesAmpsIn){
   if(DEBUGDISPLAY == true){
  println("removeRedundant (beginning)");
  }
  float[] pitchesIn = new float[0];
  float[] ampsIn = new float[0];

  
  if(pitchesAmpsIn != null){
      pitchesIn = subset(pitchesAmpsIn, 0, pitchesAmpsIn.length/2);
      ampsIn = subset(pitchesAmpsIn, pitchesAmpsIn.length/2);
  }
  float[] pitchesOut = new float[0];
  float[] ampsOut = new float[0];
  float[] pitchesAmpsOut = new float[0];
  
  if(pitchesIn.length > 0 && ampsIn.length > 0){
    
    if(ampsOut.length == 0){
      ampsOut = append(ampsOut, ampsIn[0]);

    }

    
    if(pitchesOut.length == 0){
      pitchesOut = append(pitchesOut, pitchesIn[0]);
    }
    
    
 if(ampsOut.length > 0 &&  pitchesOut.length > 0){  
  for(int k = 1 ; k< pitchesIn.length; k++){
    
    for(int p = 0 ; p <= pitchesOut.length ; p++){
      if(p < pitchesOut.length){
         
        if(pitchesIn[k] == pitchesOut[p]){
           
          ampsOut[p] = ampsOut[p] + ampsIn[k];
           
          break;
         }
      }
      if(p == pitchesOut.length){
        pitchesOut = append(pitchesOut,pitchesIn[k]); //Stop forgetting to assign the appended array to the array variable, dude!
        
        
        ampsOut = append(ampsOut, ampsIn[k]);
         
        break;
    }//End of second "if" statement within second "for" loop
  }//End of second "for" loop
}//End of first "for" loop
 }else{
    pitchesOut = append(pitchesOut, -1);
    ampsOut = append(ampsOut, -1);
  }
 }else{
   pitchesOut = append(pitchesOut, -1);
   ampsOut = append(ampsOut, -1);
 }
  
  pitchesAmpsOut = concat(pitchesOut,ampsOut);
  
  
  return pitchesAmpsOut;
} /* END OF removeRedundant 
      Output is passed to Visualize*/

//Function that converts sigFrequency index array into note number array:
  /*
  This function accepts inputs from findSigFreqs. Properly formatted inputs are arrays 
  containing an even number of elements, where the first half contains the indices of
  the detected significant frequencies and the second half contains their amplitude.
  */
float[] indToNum(float[] indAmpArray){
  if(DEBUGDISPLAY == true){
  println("indToNum (beginning)");
  }
  float[] amplitudeArray = new float[0];
  float[] numArray = new float[0];
  float[] indArray = new float[0];
  if(indAmpArray != null){
    indArray = subset(indAmpArray,0,indAmpArray.length/2);
    amplitudeArray = subset(indAmpArray,indAmpArray.length/2);
  }
  

  
  for(int h = 0 ; h < indArray.length ; h++){
    numArray = append(numArray, pitchRecognize(indArray[h]));
  }
  
  numArray = concat(numArray,amplitudeArray);
  

  
  return numArray;
  //This should be an even-length array where the first half is integer note numbers coded 0-12
  //and the second half is the amplitude of each.
  //Output is passed to removeRedundant
}

//Function that overlays numImages images:
void multiImageDisplay(float notein, float numImages, float ampIn, Movie Cnimg, Movie Csimg, Movie Dnimg, Movie Dsimg, Movie Enimg, Movie Fnimg,
      Movie Fsimg, Movie Gnimg, Movie Gsimg,Movie Animg, Movie Asimg, Movie Bnimg){
        
        if(DEBUGDISPLAY == true){
    println("multiImageDisplay (beginning)");
   }
  
  float ampBrightnessScale = (ampIn/(ampIn + ampSensitivity));
  if(notein == 11){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(Cnimg,0,0,displayWidth,displayHeight);
  }else if(notein == 0){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(Csimg,0,0,displayWidth,displayHeight);
  }else if(notein == 1){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(Dnimg,0,0,displayWidth,displayHeight);
  }else if(notein == 2){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(Dsimg,0,0,displayWidth,displayHeight);
  }else if(notein == 3){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(Enimg,0,0,displayWidth,displayHeight);
  }else if(notein == 4){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(Fnimg,0,0,displayWidth,displayHeight);
  }else if(notein == 5){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(Fsimg,0,0,displayWidth,displayHeight);
  }else if(notein == 6){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(Gnimg,0,0,displayWidth,displayHeight);
  }else if(notein == 7){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(Gsimg,0,0,displayWidth,displayHeight);
  }else if(notein == 8){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(Animg,0,0,displayWidth,displayHeight);
  }else if(notein == 9){
    colorMode(HSB);
    tint(128,0,255*ampBrightnessScale,255/numImages);
    image(Asimg,0,0,displayWidth,displayHeight);
  }else if(notein == 10){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(Bnimg,0,0,displayWidth,displayHeight);
    
    if(DEBUGDISPLAY == true){
    println("multiImageDisplay (end)");
   }
  }
}
