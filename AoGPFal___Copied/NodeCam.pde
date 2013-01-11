class NodeCam extends NodeBase {
  
  EaseVecDelta     mEye, mTarget, mUp; 
  EaseFloat        mFov, mNear, mFar;
  boolean          useOrtho; 
  
  NodeCam(Globals iGlobals){
    //initialize base class ( nodeBase)
    super(iGlobals); 
    // initialize camera vector defaults
    mEye       = new EaseVecDelta( new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ) ); 
    mTarget    = new EaseVecDelta( new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ) ); 
    mUp        = new EaseVecDelta( new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ) ); 
    // initialize default field of view, near plane and far plane
    mFov       = new EaseFloat( PI/3.0 ); 
    mNear      = new EaseFloat( 0.1 ); 
    mFar       = new EaseFloat( 100000.0 ); 
    // Use perspective projection by default 
    useOrtho   = false; 
  }
  
  
  void draw(){
    //Update
    mEye.update(); 
    mTarget.update(); 
    mUp.update(); 
    mFov.update(); 
    mNear.update(); 
    mFar.update(); 
  
  
    //set camera properties
    if ( useOrtho ){
      ortho( -width/2.0, width/2.0, -height/2.0, height/2.0, getNear(), getFar() ); 
    }
    else {
      perspective( getFov(), (float) width/height, getNear(), getFar() ); 
    }
    PVector tEye     = getEye(); 
    PVector tTarget  = getTarget(); 
    PVector tUp      = getWorldUp(); 
    camera( tEye.x, tEye.y, tEye.z, tTarget.x, tTarget.y, tTarget.z, tUp.x, tUp.y, tUp.z ); 
  }
  
  // we can add individual state parameters uing the velow methods, these are wrappers for common formats: 
  void addState(String iStateName, PVector iEye, PVector iLook, PVector iUp) {
    addStateEye( iStateName, iEye ); 
    addStateLookAt( iStateName, iLook ); 
    addStateUpAxis( iStateName, iUp ); 
  }
  
  void gotoState(String iStateName, float iDuration) {
    mEye.goToState( iStateName, iDuration );   
    mTarget.goToState( iStateName, iDuration ); 
    mUp.goToState( iStateName, iDuration ); 
    mFov.goToState( iStateName, iDuration ); 
    mNear.goToState( iStateName, iDuration ); 
    mFar.goToState( iStateName, iDuration ); 
  }
  
  void addStateEye(String iStateName, PVector iValue)                   { mEye.addState( iStateName, iValue ); }
  void addStateEyeVelocity(String iStateName, PVector iValue)           { mEye.addStateVelocity( iStateName, iValue); }
  void addStateEyeAcceleration(String iStateName, PVector iValue)       { mEye.addStateAcceleration( iStateName, iValue); }
  void addStateLookAt(String iStateName, PVector iValue)                { mTarget.addState( iStateName, iValue ); }
  void addStateLookAtVelocity(String iStateName, PVector iValue)        { mTarget.addStateVelocity( iStateName, iValue ); }
  void addStateLookAtAcceleration(String iStateName, PVector iValue)    { mTarget.addStateAcceleration( iStateName, iValue ); }
  void addStateUpAxis(String iStateName, PVector iValue)                { mUp.addState( iStateName, iValue ); }
  void addStateUpAxisVelocity(String iStateName, PVector iValue)        { mUp.addStateVelocity( iStateName, iValue ); }
  void addStateUpAxisAcceleration(String iStateName, PVector iValue)    { mUp.addStateAcceleration( iStateName, iValue ); }
  
  void addStateParameters(String iStateName, float iFov, float iNear, float iFar) {
    mFov.addState( iStateName, iFov ); 
    mNear.addState( iStateName, iNear ); 
    mFar.addState( iStateName, iFar ); 
  }
  
  boolean        getOrtho()                              { return useOrtho; }
  void           setOrtho(boolean iOrtho)                { useOrtho = iOrtho; }
  void           setOrtho()                              { useOrtho = true; }
  void           setPersp()                              { useOrtho = false; }
  
  EaseVecDelta   getEyeRef()                             { return mEye; }
  EaseVecDelta   getTargetRef()                          { return mTarget; }
  EaseVecDelta   getWorldUpRef()                         { return mUp; }
  
  PVector        getEye()                                { return mEye.get(); }
  PVector        getTarget()                             { return mTarget.get(); }
  PVector        getWorldUp()                            { return mUp.get(); }
  
  PVector        getEyeVelocity()                        { return mEye.getVelocity(); }
  PVector        getTargetVelocity()                     { return mTarget.getVelocity(); }
  PVector        getWorldUpVelocity()                    { return mUp.getVelocity(); }
  
  PVector        getEyeAcceleration()                    { return mEye.getAcceleration(); }
  PVector        getTargetAcceleration()                 { return mTarget.getAcceleration(); }
  PVector        getWorldUpAcceleration()                { return mUp.getAcceleration(); }
  
  void           setEye(PVector iValue)                  { mEye.set( iValue ); }
  void           setTarget(PVector iValue)               { mTarget.set( iValue ); }
  void           setWorldUp(PVector iValue)              { mUp.set( iValue ); }
  
  void           setEyeVeolicty(PVector iValue)          { mEye.setVelocity( iValue ); }
  void           setTargetVelocity(PVector iValue)       { mTarget.setVelocity( iValue ); }
  void           setWorldUpVelocity(PVector iValue)      { mUp.setVelocity( iValue ); }
  
  void           setEyeAcceleration(PVector iValue)      { mEye.setAcceleration( iValue ); }
  void           setTargetAcceleration(PVector iValue)   { mTarget.setAcceleration( iValue ); }
  void           setWorldUpAcceleration(PVector iValue)  { mUp.setAcceleration( iValue ); }
  
  EaseFloat      getFofRef()                             { return mFov; }
  EaseFloat      getNearRef()                            { return mNear; }
  EaseFloat      getFarRef()                             { return mFar; }
  
  float          getFov()                                { return mFov.get(); }
  float          getNear()                               { return mNear.get(); }
  float          getFar()                                { return mFar.get(); }
  
  void           setFov(float iValue)                    { mFov.set( iValue ); }
  void           setNear(float iValue)                   { mNear.set( iValue ); }
  void           setFar(float iValue)                    { mFar.set( iValue ); }
  
}


    
    
    
    
    
    
    
    
    
    
    
    
