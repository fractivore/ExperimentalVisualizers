import processing.sound.*;
import processing.video.*;

class Visualizer{
  
  protected boolean DEBUGDISPLAY = false;
  protected PImage Cn,Cs,Dn,Ds,En,Fn,Fs,Gn,Gs,An,As,Bn;
  protected int[]  widths = new int[12];
  protected int[]  heights = new int[12];
  protected PImage frameStorage,frameClear;
  protected int bands = 4096;
  protected float ampSensitivity = 1;
  protected float sigParam = 0.2;
  protected int sampleRate = 44100;
  protected FFT fft;
  protected AudioIn in;
  protected Sound device;
  protected int mode = BLEND;
  protected float scaling = 2;
  protected int colorThreshhold = 50;
  protected int refreshRate = 3000;
  
  protected PImage test, kaleidoStorage;
  protected boolean debugDisplayON = true;
  protected PShape mySlice, mySlice2;
  protected float offset = 0;
  protected SoundFile soundFile;
  
  protected int freqIndex = 0, numNotes = 0;
  protected float[] sigArray = new float[0];
  protected float bigfreq = 0, currentAmp = 0, ampThreshold = 0;
  protected float[] Spectrum = new float[bands];
  
  protected Capture camIn;
  protected int numPixels;
  protected int[] backgroundPixels;
  protected int[] feedbackArray;
  protected int[] relativePitchArray;
  protected int pitchArrayConstant = 50;
  
  protected int lastPeakTime = 0;
  protected int thisPeakTime = 1;
  protected int millisTimeDifference = 1;
  protected float beatDetectionThreshhold = 1;

  
  Visualizer(PImage Cn, PImage Cs, PImage Dn, PImage Ds, PImage En, PImage Fn, PImage Fs, PImage Gn, PImage Gs, PImage An, PImage As, PImage Bn, PApplet parent){
    
    this.Cn = Cn;
    this.Cs = Cs;
    this.Dn = Dn;
    this.Ds = Ds;
    this.En = En;
    this.Fn = Fn;
    this.Fs = Fs;
    this.Gn = Gn;
    this.Gs = Gs;
    this.An = An;
    this.As = As;
    this.Bn = Bn;
     while(device == null){
      device = new Sound(parent);
     }
     while(in == null){
      in = new AudioIn(parent,0);
     }
     while(fft == null){
       this.fft = new FFT(parent,bands); 
     }
    
     if(in != null && fft != null){
      this.in.start();
      this.in.amp(100);  
      this.fft.input(in);
     }
     
     blendMode(mode);
    
  }
  
    Visualizer(PImage Cn, PImage Cs, PImage Dn, PImage Ds, PImage En, PImage Fn, PImage Fs, PImage Gn, PImage Gs, PImage An, PImage As, PImage Bn,String soundFileName, PApplet parent){
    this.Cn = Cn;
    this.Cs = Cs;
    this.Dn = Dn;
    this.Ds = Ds;
    this.En = En;
    this.Fn = Fn;
    this.Fs = Fs;
    this.Gn = Gn;
    this.Gs = Gs;
    this.An = An;
    this.As = As;
    this.Bn = Bn;
     while(device == null){
      device = new Sound(parent);
     }
     while(in == null){
      in = new AudioIn(parent,0);
     }
     while(fft == null){
       this.fft = new FFT(parent,bands); 
     }
    
     this.soundFile = new SoundFile(parent, soundFileName);
     //PLAY INPUT FILE IF IN SOUNDFILE MODE:
     this.soundFile.play();
    //Designate the sound file as the source for thee FFT
    fft.input(soundFile);
    
    blendMode(mode);
    
  }
  
    Visualizer(PImage Cn, PApplet parent){
    
    this.Cn = Cn;

     while(device == null){
      device = new Sound(parent);
     }
     while(in == null){
      in = new AudioIn(parent,0);
     }
     while(fft == null){
       this.fft = new FFT(parent,bands); 
     }
    
     if(in != null && fft != null){
      this.in.start();
      this.in.amp(100);  
      this.fft.input(in);
     }
     
     blendMode(mode);
    
  }//end single PImage constructor
  
      Visualizer(Capture camIn, PImage Cn, PImage Cs, PImage Dn, PImage Ds, PImage En, PImage Fn, PImage Fs, PImage Gn, PImage Gs, PImage An, PImage As, PImage Bn, PApplet parent){
        
    this.Cn = Cn;
    this.widths[0] = this.Cn.width;
    this.heights[0] = this.Cn.height;
    this.Cs = Cs;
    this.widths[1] = this.Cs.width;
    this.heights[1] = this.Cs.height;    
    this.Dn = Dn;
    this.widths[2] = this.Dn.width;
    this.heights[2] = this.Dn.height;      
    this.Ds = Ds;
    this.widths[3] = this.Ds.width;
    this.heights[3] = this.Ds.height;  
    this.En = En;
    this.widths[4] = this.En.width;
    this.heights[4] = this.En.height;  
    this.Fn = Fn;
    this.widths[5] = this.Fn.width;
    this.heights[5] = this.Fn.height;  
    this.Fs = Fs;
    this.widths[6] = this.Fs.width;
    this.heights[6] = this.Fs.height;  
    this.Gn = Gn;
    this.widths[7] = this.Gn.width;
    this.heights[7] = this.Gn.height;  
    this.Gs = Gs;
    this.widths[8] = this.Gs.width;
    this.heights[8] = this.Gs.height;  
    this.An = An;
    this.widths[9] = this.An.width;
    this.heights[9] = this.An.height;  
    this.As = As;
    this.widths[10] = this.As.width;
    this.heights[10] = this.As.height;  
    this.Bn = Bn;
    this.widths[11] = this.Bn.width;
    this.heights[11] = this.Bn.height;  
    
    this.camIn = camIn;
    this.numPixels = camIn.width*camIn.height;
    this.backgroundPixels = new int[numPixels];
    
    parent.loadPixels();
    this.camIn.loadPixels();
    arrayCopy(this.camIn.pixels,this.backgroundPixels);
    

     while(device == null){
      this.device = new Sound(parent);
     }
     while(in == null){
      this.in = new AudioIn(parent,0);
     }
     while(fft == null){
       this.fft = new FFT(parent,bands); 
     }
    
     if(in != null && fft != null){
      this.in.start();
      this.in.amp(100);  
      this.fft.input(in);
     }
     
     frameStorage = createImage(max(widths),max(heights),ARGB);
     frameClear = createImage(max(widths),max(heights),ARGB);
     for(int i = 0 ; i < frameStorage.pixels.length ; i++){
      frameStorage.pixels[i] = color(0,0,0,0);
      frameClear.pixels[i] = color(0,0,0,0);
     }
     
     blendMode(mode);
    
  }//end capture constructor
  
      Visualizer(Capture camIn, PImage Cn, PApplet parent){
    
    this.Cn = Cn;

     while(device == null){
      device = new Sound(parent);
     }
     while(in == null){
      in = new AudioIn(parent,0);
     }
     while(fft == null){
       this.fft = new FFT(parent,bands); 
     }
    
     if(in != null && fft != null){
      this.in.start();
      this.in.amp(100);  
      this.fft.input(in);
     }
     
    this.camIn = camIn;
    this.numPixels = camIn.width*camIn.height;
    this.backgroundPixels = new int[numPixels];
    this.feedbackArray = new int[numPixels];
    
    parent.loadPixels();
    this.camIn.loadPixels();
    arrayCopy(this.camIn.pixels,this.backgroundPixels);
    arrayCopy(this.backgroundPixels,this.feedbackArray);
     
     blendMode(mode);
    
  }//end single PImage constructor with capture
  
        Visualizer(Capture camIn, PImage Cn, PApplet parent,SoundFile soundFileName){
    
    this.Cn = Cn;

     while(device == null){
      device = new Sound(parent);
     }

     while(fft == null){
       this.fft = new FFT(parent,bands); 
     }
    


     

    //Designate the sound file as the source for thee FFT
    
    
    soundFileName.play();
    fft.input(soundFileName);
     
    this.camIn = camIn;
    this.numPixels = camIn.width*camIn.height;
    this.backgroundPixels = new int[numPixels];
    this.feedbackArray = new int[numPixels];
    
    parent.loadPixels();
    this.camIn.loadPixels();
    arrayCopy(this.camIn.pixels,this.backgroundPixels);
     
     blendMode(mode);
    
  }//end single PImage constructor with capture, sound file mode
  
//:::::::::::::::::::::::::DEFINE FUNCTIONS:::::::::::::::::::::::::::::::::::::::::::::

//Define getIndex function (used to obtain the index of a known value in an array):
int getIndex(float[] someArray, float ValueToBeFound) {

  
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
void vidOverlay(int index){
  
  this.getSpectrum();
        
  float[] notesIn = new float[0];
  float[] ampsIn = subset(this.sigArray, this.sigArray.length/2);
  float totalSigAmp = this.arraySum(ampsIn);
 
 if(this.sigArray.length > 1){
   notesIn = subset(this.sigArray,0,this.sigArray.length/2);
  if(this.currentAmp > this.ampThreshold){
    background(0);
    if(notesIn.length == 1){ //Changed from check if noteNums.length == 1
      this.multiImageDisplay(notesIn[0],1, this.currentAmp);
    }else{
      int L = 0;
      while(L <= notesIn.length - 1){
        this.multiImageBitShift(notesIn[L],totalSigAmp/ampsIn[L],this.currentAmp, index);

        L++;
        

     }//End of "for" loop for incrementing the index counter, nested within the "else" case.
    }//End of "else" case, wherein the note number array is incremented through to
    //display images
  }//Ends check if the input value is greater than designated threshold
 }//Ends check if noteNum array is large enough for the halving operation

}//Main Function bracket

//Define Pitch Recognition funtion (just converts index into pitch):
float pitchRecognize(float ind){

  
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
void multiImageDisplay(float notein, float numImages, float ampIn){
        

  
  float ampBrightnessScale = (ampIn/(ampIn + ampSensitivity));
  if(notein == 11){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(this.Cn,0,0,width,height);
  }else if(notein == 0){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(this.Cs,0,0,width,height);
  }else if(notein == 1){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(this.Dn,0,0,width,height);
  }else if(notein == 2){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(this.Ds,0,0,width,height);
  }else if(notein == 3){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(this.En,0,0,width,height);
  }else if(notein == 4){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(this.Fn,0,0,width,height);
  }else if(notein == 5){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(this.Fs,0,0,width,height);
  }else if(notein == 6){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(this.Gn,0,0,width,height);
  }else if(notein == 7){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(this.Gs,0,0,width,height);
  }else if(notein == 8){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(this.An,0,0,width,height);
  }else if(notein == 9){
    colorMode(HSB);
    tint(128,0,255*ampBrightnessScale,255/numImages);
    image(this.As,0,0,width,height);
  }else if(notein == 10){
    colorMode(HSB);
    tint(128,0, 255*ampBrightnessScale,255/numImages);
    image(this.Bn,0,0,width,height);
    
    
  }
}//Multi-image display

void autoKaleidoscope(PImage img, int originX, int originY){
  
  this.getSpectrum();
  
  float radius = this.currentAmp*1000;
  float slices = round(this.numNotes);
  
  float angle = PI/slices;
  //offset+=PI/180;

  mySlice = createShape();
  mySlice.beginShape(TRIANGLE);
    mySlice.texture(img);
    mySlice.noStroke();
    mySlice.vertex(0, 0, originX, originY);
    mySlice.vertex(cos(angle)*radius, sin(angle)*radius, originX+cos(angle+offset)*radius+img.width/2, originY+sin(angle+offset)*radius+img.height/2);
    mySlice.vertex(cos(-angle)*radius, sin(-angle)*radius, originX+cos(-angle+offset)*radius+img.width/2, originY + sin(-angle+offset)*radius+img.height/2);
  mySlice.endShape();
  
    mySlice2 = createShape();
  mySlice2.beginShape(TRIANGLE);
    mySlice2.texture(img);
    mySlice2.noStroke();
    mySlice2.vertex(0, 0, originX, originY);
    mySlice2.vertex(cos(angle)*radius, sin(angle)*radius, originX+cos(-angle+offset)*radius+img.width/2, originY+ sin(-angle+offset)*radius+img.height/2);
    mySlice2.vertex(cos(-angle)*radius, sin(-angle)*radius, originX+cos(angle+offset)*radius+img.width/2, originY+sin(angle+offset)*radius+img.height/2);
  mySlice2.endShape();

  translate(originX, originY);
  for (int i = 0; i < slices; i++) {
    rotate(angle*2);
    if(i%2==0){
    shape(mySlice);
    }else{
     shape(mySlice2);
    }
  
   }
 
 //imageIn.updatePixels();
 

   
}//autokaleidoscope function

void getSpectrum(){
  
  if(this.fft != null){
    this.fft.analyze();
    this.Spectrum = this.fft.spectrum;
  }
 
  
  //Find the greatest constituent frequency and its index. Note that this is redundant with sigArray.
  if(this.Spectrum != null){
  this.bigfreq = max(Spectrum);
  this.freqIndex = getIndex(Spectrum, bigfreq);
  
  //Obtain a measure of amplitude by summing the frequency spectrum:
  currentAmp = arraySum(Spectrum);

  //If the current amplitude is above the threshold, find the indices frequencies at least .9 times the greatest frequency and store them in an array.
  //if not, the function returns the array [-1]:
 this.sigArray = removeRedundant(indToNum(findSigFreqs(Spectrum, bigfreq, ampThreshold)));

 this.numNotes = this.sigArray.length;
  }
  
}//end getSpectrum

void feedbackKaleidoscope(int originX,int originY,int level,PApplet parent){
  
  if(this.kaleidoStorage == null){
   kaleidoStorage = createImage(width,height, RGB); 
     parent.loadPixels();
     arrayCopy(parent.pixels, kaleidoStorage.pixels);
  }
  
  loadPixels();
  this.kaleidoStorage.loadPixels();
  arrayCopy(parent.pixels, kaleidoStorage.pixels);
  kaleidoStorage.updatePixels();
  this.autoKaleidoscope(kaleidoStorage,originX,originY);

  
  if(level > 1){
   feedbackKaleidoscope(originX+level*30, originY+level*50, level-1,parent); 
  }
  
  
}//end feedbackKaleidoscope

void glitchyBackgroundSubtraction(PApplet parent){
  
  this.getSpectrum();
  
    if (this.camIn.available()) {
    this.camIn.read(); // Read a new video frame
    this.camIn.loadPixels(); // Make the pixels of video available
    // Difference between the current frame and the stored background
    int presenceSum = 0;
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
    presenceSum = 0;
      // Fetch the current color in that location, and also the color
      // of the background in that spot
      color currColor = this.camIn.pixels[i];
      color bkgdColor = this.backgroundPixels[i];
      // Extract the red, green, and blue components of the current pixel's color
      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract the red, green, and blue components of the background pixel's color
      int bkgdR = (bkgdColor >> 16) & 0xFF;
      int bkgdG = (bkgdColor >> 8) & 0xFF;
      int bkgdB = bkgdColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - bkgdR);
      int diffG = abs(currG - bkgdG);
      int diffB = abs(currB - bkgdB);
      // Add these differences to the running tally
      presenceSum += diffR + diffG + diffB;
      // Render the difference image to the screen
      if(presenceSum > 500-log(currentAmp+1)*500 &&presenceSum>0 && i>0){
      parent.pixels[i] = parent.pixels[i-1];
      }else{
        parent.pixels[i] = this.camIn.pixels[i];
      }
      // The following line does the same thing much faster, but is more technical
      //pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
    }
    parent.updatePixels(); // Notify that the pixels[] array has changed
    //println(presenceSum); // Print out the total amount of movement
  }
  if(keyPressed){
    camIn.loadPixels();
    arrayCopy(camIn.pixels, backgroundPixels);
  }//end keyPressed conditional
}//end glitchyBackgroundSubtraction

void foregroundImageReplace(PApplet parent){
  
  this.getSpectrum();
  
    if (this.camIn.available()) {
    this.camIn.read(); // Read a new video frame
    this.camIn.loadPixels(); // Make the pixels of video available
    // Difference between the current frame and the stored background
    this.Cn.loadPixels();
    int presenceSum = 0;
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
    presenceSum = 0;
    float floatI = i;
      // Fetch the current color in that location, and also the color
      // of the background in that spot
      color currColor = this.camIn.pixels[i];
      color bkgdColor = this.backgroundPixels[i];
      // Extract the red, green, and blue components of the current pixel's color
      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract the red, green, and blue components of the background pixel's color
      int bkgdR = (bkgdColor >> 16) & 0xFF;
      int bkgdG = (bkgdColor >> 8) & 0xFF;
      int bkgdB = bkgdColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - bkgdR);
      int diffG = abs(currG - bkgdG);
      int diffB = abs(currB - bkgdB);
      // Add these differences to the running tally
      presenceSum += diffR + diffG + diffB;
      // Render the difference image to the screen
      if(presenceSum > 150  && i>0 && floor(floatI/parent.width)*Cn.width+i%parent.width < Cn.pixels.length){
      parent.pixels[i] = Cn.pixels[floor(floatI/parent.width)*Cn.width+i%parent.width];
      }else{
        parent.pixels[i] = this.camIn.pixels[i];
      }
      // The following line does the same thing much faster, but is more technical
      //pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
    }
    parent.updatePixels(); // Notify that the pixels[] array has changed
    //println(presenceSum); // Print out the total amount of movement
  }
  if(keyPressed){
    camIn.loadPixels();
    arrayCopy(camIn.pixels, backgroundPixels);
  }//end keyPressed conditional
}//end foregroundImageReplacement

void foregroundTrails(PApplet parent){
  
  this.getSpectrum();
  
    if (this.camIn.available()) {
    this.camIn.read(); // Read a new video frame
    this.camIn.loadPixels(); // Make the pixels of video available
    // Difference between the current frame and the stored background
    this.Cn.loadPixels();
    int presenceSum = 0;
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
    presenceSum = 0;
      // Fetch the current color in that location, and also the color
      // of the background in that spot
      color currColor = this.camIn.pixels[i];
      color bkgdColor = this.backgroundPixels[i];
      // Extract the red, green, and blue components of the current pixel's color
      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract the red, green, and blue components of the background pixel's color
      int bkgdR = (bkgdColor >> 16) & 0xFF;
      int bkgdG = (bkgdColor >> 8) & 0xFF;
      int bkgdB = bkgdColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - bkgdR);
      int diffG = abs(currG - bkgdG);
      int diffB = abs(currB - bkgdB);
      // Add these differences to the running tally
      presenceSum += diffR + diffG + diffB;
      // Render the difference image to the screen
      if((diffR > colorThreshhold || diffG > colorThreshhold || diffB > colorThreshhold)  && i>0){
      parent.pixels[i] = parent.pixels[i] + Cn.pixels[i*round(currentAmp)%this.camIn.pixels.length];
      }else{
        parent.pixels[i] = this.camIn.pixels[i];
      }
      // The following line does the same thing much faster, but is more technical
      //pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
    }
    parent.updatePixels(); // Notify that the pixels[] array has changed
    //println(presenceSum); // Print out the total amount of movement
  }
  if(keyPressed){
    camIn.loadPixels();
    arrayCopy(camIn.pixels, backgroundPixels);
  }//end keyPressed conditional
}//end foregroundTrails

void foregroundClear(PApplet parent){
  
  this.getSpectrum();
  
    if (this.camIn.available()) {
    this.camIn.read(); // Read a new video frame
    this.camIn.loadPixels(); // Make the pixels of video available
    // Difference between the current frame and the stored background
    this.Cn.loadPixels();
    int presenceSum = 0;
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
    presenceSum = 0;
      // Fetch the current color in that location, and also the color
      // of the background in that spot
      color currColor = this.camIn.pixels[i];
      color bkgdColor = this.backgroundPixels[i];
      // Extract the red, green, and blue components of the current pixel's color
      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract the red, green, and blue components of the background pixel's color
      int bkgdR = (bkgdColor >> 16) & 0xFF;
      int bkgdG = (bkgdColor >> 8) & 0xFF;
      int bkgdB = bkgdColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - bkgdR);
      int diffG = abs(currG - bkgdG);
      int diffB = abs(currB - bkgdB);
      // Add these differences to the running tally
      presenceSum += diffR + diffG + diffB;
      // Render the difference image to the screen
      if(presenceSum < 150  && i>0){
        parent.pixels[i] = this.camIn.pixels[i];
      }
      // The following line does the same thing much faster, but is more technical
      //pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
    }
    parent.updatePixels(); // Notify that the pixels[] array has changed
    //println(presenceSum); // Print out the total amount of movement
  }
  if(keyPressed){
    camIn.loadPixels();
    arrayCopy(camIn.pixels, backgroundPixels);
  }//end keyPressed conditional
}//end foregroundClear

color multiImageBitShift(float notein, float numImages, float ampIn, int i){
        
int a;
int h;
int s;
int b;
color out = 0;
  
  float ampBrightnessScale = (ampIn/(ampIn + ampSensitivity));
  if(notein == 11){
    colorMode(HSB);

     a = (Cn.pixels[i] >> 24) & 0xFF; 
     h = (Cn.pixels[i] >> 16) & 0xFF;
     s = (Cn.pixels[i] >> 8) & 0xFF;
     b = Cn.pixels[i] & 0xFF;
     a = floor(255/numImages);
     b = floor(b*ampBrightnessScale);
     a = a << 24;
     h = h << 16;
    out = a | h | s | b;
    
  }else if(notein == 0){
    colorMode(HSB);

     a = (Cs.pixels[i] >> 24) & 0xFF; 
     h = (Cs.pixels[i] >> 16) & 0xFF;
     s = (Cs.pixels[i] >> 8) & 0xFF;
     b = Cs.pixels[i] & 0xFF;
     a = floor(255/numImages);
     b = floor(b*ampBrightnessScale);
     a = a << 24;
     h = h << 16;
     s = s << 8;
     out = a | h | s | b;
    
  }else if(notein == 1){
    colorMode(HSB);

     a = (Dn.pixels[i] >> 24) & 0xFF; 
     h = (Dn.pixels[i] >> 16) & 0xFF;
     s = (Dn.pixels[i] >> 8) & 0xFF;
     b = Dn.pixels[i] & 0xFF;
     a = floor(255/numImages);
     b = floor(b*ampBrightnessScale);
     a = a << 24;
     h = h << 16;
     s = s << 8;
     out = a | h | s | b;
    
  }else if(notein == 2){
    colorMode(HSB);

     a = (Ds.pixels[i] >> 24) & 0xFF; 
     h = (Ds.pixels[i] >> 16) & 0xFF;
     s = (Ds.pixels[i] >> 8) & 0xFF;
     b = Ds.pixels[i] & 0xFF;
     a = floor(255/numImages);
     b = floor(b*ampBrightnessScale);
     a = a << 24;
     h = h << 16;
     s = s << 8;
     out = a | h | s | b;
    
  }else if(notein == 3){
    colorMode(HSB);

     a = (En.pixels[i] >> 24) & 0xFF; 
     h = (En.pixels[i] >> 16) & 0xFF;
     s = (En.pixels[i] >> 8) & 0xFF;
     b = En.pixels[i] & 0xFF;
     a = floor(255/numImages);
     b = floor(b*ampBrightnessScale);
     a = a << 24;
     h = h << 16;
     s = s << 8;
     out = a | h | s | b;
    
  }else if(notein == 4){
    colorMode(HSB);

     a = (Fn.pixels[i] >> 24) & 0xFF; 
     h = (Fn.pixels[i] >> 16) & 0xFF;
     s = (Fn.pixels[i] >> 8) & 0xFF;
     b = Fn.pixels[i] & 0xFF;
     a = floor(255/numImages);
     b = floor(b*ampBrightnessScale);
     a = a << 24;
     h = h << 16;
     s = s << 8;
     out = a | h | s | b;
    
  }else if(notein == 5){
    colorMode(HSB);

     a = (Fs.pixels[i] >> 24) & 0xFF; 
     h = (Fs.pixels[i] >> 16) & 0xFF;
     s = (Fs.pixels[i] >> 8) & 0xFF;
     b = Fs.pixels[i] & 0xFF;
     a = floor(255/numImages);
     b = floor(b*ampBrightnessScale);
     a = a << 24;
     h = h << 16;
     s = s << 8;
     out = a | h | s | b;
    
  }else if(notein == 6){
    colorMode(HSB);
  
     a = (Gn.pixels[i] >> 24) & 0xFF; 
     h = (Gn.pixels[i] >> 16) & 0xFF;
     s = (Gn.pixels[i] >> 8) & 0xFF;
     b = Gn.pixels[i] & 0xFF;
     a = floor(255/numImages);
     b = floor(b*ampBrightnessScale);
     a = a << 24;
     h = h << 16;
     s = s << 8;
     out = a | h | s | b;
    
  }else if(notein == 7){
    colorMode(HSB);

     a = (Gs.pixels[i] >> 24) & 0xFF; 
     h = (Gs.pixels[i] >> 16) & 0xFF;
     s = (Gs.pixels[i] >> 8) & 0xFF;
     b = Gs.pixels[i] & 0xFF;
     a = floor(255/numImages);
     b = floor(b*ampBrightnessScale);
     a = a << 24;
     h = h << 16;
     s = s << 8;
     out = a | h | s | b;
    
  }else if(notein == 8){
    colorMode(HSB);

     a = (An.pixels[i] >> 24) & 0xFF; 
     h = (An.pixels[i] >> 16) & 0xFF;
     s = (An.pixels[i] >> 8) & 0xFF;
     b = An.pixels[i] & 0xFF;
     a = floor(255/numImages);
     b = floor(b*ampBrightnessScale);
     a = a << 24;
     h = h << 16;
     s = s << 8;
     out = a | h | s | b;
    
  }else if(notein == 9){
    colorMode(HSB);

     a = (As.pixels[i] >> 24) & 0xFF; 
     h = (As.pixels[i] >> 16) & 0xFF;
     s = (As.pixels[i] >> 8) & 0xFF;
     b = As.pixels[i] & 0xFF;
     a = floor(255/numImages);
     b = floor(b*ampBrightnessScale);
     a = a << 24;
     h = h << 16;
     s = s << 8;
     out =  a | h | s | b;
    
  }else if(notein == 10){
    colorMode(HSB);

     a = (Bn.pixels[i] >> 24) & 0xFF; 
     h = (Bn.pixels[i] >> 16) & 0xFF;
     s = (Bn.pixels[i] >> 8) & 0xFF;
     b = Bn.pixels[i] & 0xFF;
     a = floor(255/numImages);
     b = floor(b*ampBrightnessScale);
     a = a << 24;
     h = h << 16;
     s = s << 8;
     out = a | h | s | b;
    
    
 
  }
  return out;
}//Multi-image bitShift

void foregroundSynesthesia(PApplet parent){
  
  arrayCopy(frameClear.pixels,frameStorage.pixels);//clear the storage image to a fully transparent layer
  
  
    if (this.camIn.available()) {
    this.camIn.read(); // Read a new video frame
    this.camIn.loadPixels(); // Make the pixels of video available
    // Difference between the current frame and the stored background
    this.Cn.loadPixels();
    int presenceSum = 0;
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
    presenceSum = 0;
      // Fetch the current color in that location, and also the color
      // of the background in that spot
      color currColor = this.camIn.pixels[i];
      color bkgdColor = this.backgroundPixels[i];
      // Extract the red, green, and blue components of the current pixel's color
      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract the red, green, and blue components of the background pixel's color
      int bkgdR = (bkgdColor >> 16) & 0xFF;
      int bkgdG = (bkgdColor >> 8) & 0xFF;
      int bkgdB = bkgdColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - bkgdR);
      int diffG = abs(currG - bkgdG);
      int diffB = abs(currB - bkgdB);
      // Add these differences to the running tally
      presenceSum += diffR + diffG + diffB;
      // Render the difference image to the screen
      if(presenceSum > 150  && i>0){
        this.getSpectrum();
        vidOverlay(i);
        dP("i: " + i);
        dP("frameStorage.pixels[i]: " + frameStorage.pixels[i]);
      parent.pixels[i] = frameStorage.pixels[i];
      }else{
        parent.pixels[i] = this.camIn.pixels[i];
      }
      // The following line does the same thing much faster, but is more technical
      //pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
    }
    parent.updatePixels(); // Notify that the pixels[] array has changed
    //println(presenceSum); // Print out the total amount of movement
  }
  if(keyPressed){
    camIn.loadPixels();
    arrayCopy(camIn.pixels, backgroundPixels);
  }//end keyPressed conditional
}//end foregroundSynesthesia

void bitShiftSynesthesia(PApplet parent){
  dP("bitShiftSynesthesia called");
  this.getSpectrum();
  
  for(int i = 0 ; i < parent.pixels.length ; i++){
   for(int j = 0 ; j < this.numNotes ; j++){
    parent.pixels[i] += multiImageBitShift(this.sigArray[j],this.numNotes,this.currentAmp,i);
     dP("parent.pixels[i]: "+parent.pixels[i]);
   }
    
  }
  
}//end bitShiftSynesthesia

void trailsVisualize(PApplet parent){
  
  this.getSpectrum();
  
    if (this.camIn.available()) {
    this.camIn.read(); // Read a new video frame
    this.camIn.loadPixels(); // Make the pixels of video available
    // Difference between the current frame and the stored background
    this.Cn.loadPixels();
   // int presenceSum = 0;
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
  //  presenceSum = 0;
      // Fetch the current color in that location, and also the color
      // of the background in that spot
      color currColor = this.camIn.pixels[i];
      color bkgdColor = this.backgroundPixels[i];
      // Extract the red, green, and blue components of the current pixel's color
      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract the red, green, and blue components of the background pixel's color
      int bkgdR = (bkgdColor >> 16) & 0xFF;
      int bkgdG = (bkgdColor >> 8) & 0xFF;
      int bkgdB = bkgdColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - bkgdR);
      int diffG = abs(currG - bkgdG);
      int diffB = abs(currB - bkgdB);
      // Add these differences to the running tally
    //  presenceSum += diffR + diffG + diffB;
      // Render the difference image to the screen
      if((diffR > colorThreshhold || diffG > colorThreshhold || diffB > colorThreshhold)  && i>0){
        if(floor((i/parent.width)/10)%2 == 0 && i%parent.width+round(currentAmp*scaling) < parent.width){ 
      parent.pixels[i+round(currentAmp*scaling)] = feedbackArray[i] + Cn.pixels[i*round(currentAmp)%this.Cn.pixels.length];
      this.feedbackArray[i] = parent.pixels[i+round(currentAmp*scaling)];
        }else if(i%parent.width-round(currentAmp*scaling) > 0){
          parent.pixels[i-round(currentAmp*scaling)] = feedbackArray[i] + Cn.pixels[i*round(currentAmp)%this.Cn.pixels.length];  
          this.feedbackArray[i] = parent.pixels[i-round(currentAmp*scaling)];
        }
      }else{
        parent.pixels[i] = this.camIn.pixels[i];
      }
      // The following line does the same thing much faster, but is more technical
      //pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
    }
    parent.updatePixels(); // Notify that the pixels[] array has changed
    //println(presenceSum); // Print out the total amount of movement
  }
  if(this.refreshRate == 0){
   this.refreshRate = 1; 
  }
  if(keyPressed||millis()%refreshRate==0){
    camIn.loadPixels();
    arrayCopy(camIn.pixels, backgroundPixels);
    arrayCopy(this.backgroundPixels,this.feedbackArray);
  }//end keyPressed conditional
}//end trailsVisualize

void colorWheel(PApplet parent){
  
  this.getSpectrum();
  
    if (this.camIn.available()) {
    this.camIn.read(); // Read a new video frame
    this.camIn.loadPixels(); // Make the pixels of video available
    // Difference between the current frame and the stored background
    this.Cn.loadPixels();
    int presenceSum = 0;
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
    presenceSum = 0;
      // Fetch the current color in that location, and also the color
      // of the background in that spot
      color currColor = this.camIn.pixels[i];
      color bkgdColor = this.backgroundPixels[i];
      // Extract the red, green, and blue components of the current pixel's color
      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract the red, green, and blue components of the background pixel's color
      int bkgdR = (bkgdColor >> 16) & 0xFF;
      int bkgdG = (bkgdColor >> 8) & 0xFF;
      int bkgdB = bkgdColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - bkgdR);
      int diffG = abs(currG - bkgdG);
      int diffB = abs(currB - bkgdB);
      // Add these differences to the running tally
      presenceSum += diffR + diffG + diffB;
      // Render the difference image to the screen
      if((diffR > colorThreshhold || diffG > colorThreshhold || diffB > colorThreshhold)  && i>0){
      parent.pixels[i] = parent.pixels[i] + round(currentAmp*scaling);
      }else{
        parent.pixels[i] = this.camIn.pixels[i];
      }
      // The following line does the same thing much faster, but is more technical
      //pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
    }
    parent.updatePixels(); // Notify that the pixels[] array has changed
    //println(presenceSum); // Print out the total amount of movement
  }
  if(this.refreshRate==0){
    this.refreshRate = 1;
  }
  if(keyPressed||millis()%this.refreshRate==0){
    camIn.loadPixels();
    arrayCopy(camIn.pixels, backgroundPixels);
  }//end keyPressed conditional
}//end colorWheel

void trailsPitchVisualize(PApplet parent){
  
  this.getSpectrum();
  
  int[] newRelativePitchArray = new int[sigArray.length];
    for(int i = 0 ; i <sigArray.length ; i++){
     newRelativePitchArray[i] = 1 + round(sigArray[i]*pitchArrayConstant); 
    }
    
    if(DEBUGDISPLAY){printArray(sigArray);}
    
    this.setRelativePitchArray(newRelativePitchArray);
    int tracker = 0;
    int metaTracker = 0;
  
    if (this.camIn.available()) {
    this.camIn.read(); // Read a new video frame
    this.camIn.loadPixels(); // Make the pixels of video available
    // Difference between the current frame and the stored background
    this.Cn.loadPixels();
   // int presenceSum = 0;
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
  //  presenceSum = 0;
      // Fetch the current color in that location, and also the color
      // of the background in that spot
      color currColor = this.camIn.pixels[i];
      color bkgdColor = this.backgroundPixels[i];
      // Extract the red, green, and blue components of the current pixel's color
      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract the red, green, and blue components of the background pixel's color
      int bkgdR = (bkgdColor >> 16) & 0xFF;
      int bkgdG = (bkgdColor >> 8) & 0xFF;
      int bkgdB = bkgdColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - bkgdR);
      int diffG = abs(currG - bkgdG);
      int diffB = abs(currB - bkgdB);
      // Add these differences to the running tally
    //  presenceSum += diffR + diffG + diffB;
      // Render the difference image to the screen
      tracker++;
      if(tracker%sigArray[metaTracker%sigArray.length] == 0){
       tracker = 0;
       metaTracker++;
      }
      
      try{
      if((diffR > colorThreshhold || diffG > colorThreshhold || diffB > colorThreshhold)  && i>0){
        if(floor((i/parent.width)/relativePitchArray[metaTracker%relativePitchArray.length])%2 == 0 && metaTracker%2==0 && i%parent.width+round(sigArray[metaTracker%sigArray.length]*scaling) < parent.width){ 
      parent.pixels[i+round(sigArray[metaTracker%sigArray.length]*scaling)] = feedbackArray[i] + Cn.pixels[i*round(currentAmp)%this.Cn.pixels.length];
      this.feedbackArray[i] = parent.pixels[i+round(sigArray[metaTracker%sigArray.length]*scaling)];
        }else if(floor((i/parent.width)/relativePitchArray[metaTracker%relativePitchArray.length])%2 == 0 && metaTracker%2==1 && (i%parent.width-round(sigArray[metaTracker%sigArray.length]*scaling)) > 0){
          parent.pixels[i-round(sigArray[metaTracker%sigArray.length]*scaling)] = feedbackArray[i] + Cn.pixels[i*round(currentAmp)%this.Cn.pixels.length];  
          this.feedbackArray[i] = parent.pixels[i-round(sigArray[metaTracker%sigArray.length]*scaling)];
        }
      }else{
        parent.pixels[i] = this.camIn.pixels[i];
      }
      }catch(ArrayIndexOutOfBoundsException e){
      }//end catch
      

      // The following line does the same thing much faster, but is more technical
      //pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
    }
    parent.updatePixels(); // Notify that the pixels[] array has changed
    //println(presenceSum); // Print out the total amount of movement
  }
  if(this.refreshRate == 0){
   this.refreshRate = 1; 
  }
  if(keyPressed||millis()%refreshRate==0){
    camIn.loadPixels();
    arrayCopy(camIn.pixels, backgroundPixels);
    arrayCopy(this.backgroundPixels,this.feedbackArray);
  }//end keyPressed conditional
}//end trailsPitchVisualize

void beatTrailWipe(){
 this.beatDelayDetect();
 this.setRefreshRate(millisTimeDifference); 
}

void beatDelayDetect(){
  
  if(this.currentAmp > this.beatDetectionThreshhold){
    this.thisPeakTime = millis() % 65536;
    this.millisTimeDifference = (this.thisPeakTime - this.lastPeakTime) % 65536;
    this.lastPeakTime = this.thisPeakTime;
  }
  
}

void setRelativePitchArray(int[] newRelativePitchArray){
  
  this.relativePitchArray = newRelativePitchArray;
  
}

void setPitchArrayConstant(int pitchArrayConstantIn){
 this.pitchArrayConstant = pitchArrayConstantIn; 
}

void debugDisplayON(){
 this.DEBUGDISPLAY = true; 
}

void setAmpSensitivity(float sensitivityIn){
 this.ampSensitivity = sensitivityIn; 
}

void setMode(int mode){
 this.mode = mode;
 blendMode(mode);
}

void setScaling(float newScaling){
 this.scaling = newScaling; 
}

void setColorThreshhold(int newColorThreshhold){
 this.colorThreshhold = newColorThreshhold; 
}

void setRefreshRate(int refreshRate){
 this.refreshRate = refreshRate; 
}

void setBeatDetectionThreshhold(float beatDetectionThreshhold){
 this.beatDetectionThreshhold = beatDetectionThreshhold; 
}

void dP(String thingToPrint){
 if(DEBUGDISPLAY){
  println(thingToPrint); 
 }
}


  
}//end class
