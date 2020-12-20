class AfterimageFunction extends Visualizer{
  
  protected int toggleTracker = 0;
  
  AfterimageFunction(Capture camIn, PImage Cn, PApplet parent){
    super(camIn, Cn, parent);
  }
  
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
        int shiftedIndex = this.functionToggle(i,metaTracker,parent);
        if(shiftedIndex >= 0){
        parent.pixels[shiftedIndex] = feedbackArray[i] + Cn.pixels[i*round(currentAmp)%this.Cn.pixels.length];
        this.feedbackArray[i] = parent.pixels[shiftedIndex];
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

int functionToggle(int i,int metaTracker, PApplet parent){
  
  if(keyPressed){
   this.toggleTracker++; 
  }
  
  if(this.toggleTracker%2 == 1){
    return pitchWiseHrzntlShift(i,metaTracker, parent);
  }else{
    return pitchWiseDiagonalShift(i,metaTracker, parent); 
  }
  
}

int pitchWiseHrzntlShift(int i,int metaTracker, PApplet parent){
         if(floor((i/parent.width)/relativePitchArray[metaTracker%relativePitchArray.length])%2 == 0 && metaTracker%2==0 && i%parent.width+round(sigArray[metaTracker%sigArray.length]*scaling) < parent.width){ 
      return (i+round(sigArray[metaTracker%sigArray.length]*scaling));

        }else if(floor((i/parent.width)/relativePitchArray[metaTracker%relativePitchArray.length])%2 == 0 && metaTracker%2==1 && (i%parent.width-round(sigArray[metaTracker%sigArray.length]*scaling)) > 0){
        return(i-round(sigArray[metaTracker%sigArray.length]*scaling));
        }
        else return -1;
}

int pitchWiseDiagonalShift(int i,int metaTracker, PApplet parent){
         if(floor((i/parent.width)/relativePitchArray[metaTracker%relativePitchArray.length])%2 == 0 && metaTracker%2==0 && i%parent.width+round(sigArray[metaTracker%sigArray.length]*scaling) < parent.width){ 
      return (i+round(sigArray[metaTracker%sigArray.length]*scaling)+round(sigArray[metaTracker%sigArray.length]*scaling)*parent.width);

        }else if(floor((i/parent.width)/relativePitchArray[metaTracker%relativePitchArray.length])%2 == 0 && metaTracker%2==1 && (i%parent.width-round(sigArray[metaTracker%sigArray.length]*scaling)) > 0){
        return(i-round(sigArray[metaTracker%sigArray.length]*scaling)+round(sigArray[metaTracker%sigArray.length]*scaling)*parent.width);
        }
        else return -1;
}

  
}//end AfterimageFunction class
