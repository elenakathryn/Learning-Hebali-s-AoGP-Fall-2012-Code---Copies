class SceneController extends NodeGeom {
  NodeCam           mCamera; 
  NodeLight[]       mLights; 
  boolean           mDebugMode; 

  SceneController(PApplet iApplet) {
    //Initializes base class (NodeGeom) 
    super( new Globals( iApplet ) ); 
    //GLGraphics requires lower-level access to some of the Papplet's properties, 
    // namely the OpenGL renderer. To provie this to each node, we'll create a globals
    // class that gets passed to each node when it is initialized. 
    mGlobals.setSceneController( this ); 
    //Initialize camera
    mCamera = new NodeCam( mGlobals ); 
    //Initialize light array (openGL only allows 8 lights) 
    mLights = new NodeLight[8]; 
    for (int i = 0; i < 8; i++) {
      mLights[i] = new NodeLight( mGlobals );
    }
    // do not draw debug by default 
    mDebugMode = false;
  }

  void draw() {
    // Enter Scene 
    mGlobals.mRenderer.beginGL(); 
    background(0); 
    pushMatrix(); 
    // everything drawn between beginCamera() and endCamera()
    // will be rendered through mCamera's perspective. 
    beginCamera(); 

    //render camera
    mCamera.draw(); 

    //Flip the y =axis(processing sets the +Y direction as the opposite of OpenGL's default, we'll flip it back here. 

    scale(1, -1, 1); 

    //render lights
    for(int i = 0; i < 8; i ++){
      mLights[i].draw(); 
    }
    
    //Call superclass draw() method. NodeGeom's draw() implementation will apply transformation matrix: 
    super.draw(); 
    
    //exit scene 
    endCamera(); 
    popMatrix(); 
    mGlobals.mRenderer.endGL(); 
  }
  
  void toggleDebugMode() {
    mDebugMode = !mDebugMode; 
  }
  
  boolean getDebugMode() { 
    return mDebugMode; 
  }
  
  void goToCameraState(String iStateName, float iDuration) {
    mCamera.gotoState( iStateName, iDuration ); 
  }
  
  void goToLightState(String iStateName, float iDuration) {
    // transitions all lights to given state( if state name is found in map
    for(int i = 0; i < 8; i++){
      mLights[i].goToState( iStateName, iDuration ); 
    }
  }
  
  NodeLight getLight(int iLightIndex){
    iLightIndex = max( 0, iLightIndex ); 
    iLightINdex = min( 7, iLightIndex ); 
    return mLights[iLightIndex];
  }
}

