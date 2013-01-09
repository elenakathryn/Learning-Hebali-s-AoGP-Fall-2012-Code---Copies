class NodeLight extends NodeBase {
  int             mType; 
  EaseVecDelta    mPosition, mDirection; 
  EaseVecDelta    mColor, mSpecularColor; 
  EaseFloat       mSpotAngle, mSpotConcentration; 
  
  NodeLight(Globals iGlobals) {
    //Intialize base class(NodeBase) 
    super( iGlobals ); 
    //Initialize light defaults
    mPosition            = new EaseVecDelta( new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ) );  
    mDirection           = new EaseVecDelta( new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ) ); 
    mColor               = new EaseVecDelta( new PVector( 255, 255, 255 ), new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ) ); 
    mSpecularColor       = new EaseVecDelta( new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ) ); 
    mSpotAngle           = new EaseFloat( radians( 45.0 ) ); 
    mSpotConcentration   = new EaseFloat( 100.0); 
    disable(); 
  }
  
  void disable() {
    mType = -1;
  }
  
  int getType() {
    return mType; 
  }
  
  void setType(int iType) {
    mType = iType;
  }
  
  void draw() {
    if (myType < 0 ) { return; }
    
    // Update 
    mPosition.update(); 
    mDirection.update(); 
    mColor.update(); 
    mSpecularColor.update(); 
    mSpotAngle.update(); 
    mSpotConcetration.update(); 
    
    //Render light
    if( mType == 0 ) {
      PVector tColor     = getColor(); 
      PVector tPosition  = getPosition(); 
      ambientLight( tColor.x, tColor.y, tColor.z, tPosition.z, tPosition.y, tPosition.z ); 
    }
    else if ( mType == 1 ) {
      PVector tColor     = getColor(); 
      PVector tDirection = getDirection(); 
      directionalLight( tColor.x, tColor.y, tColor.z, tDirection.x, tDirection.y, tDirection.z ); 
    }
    else if ( mType == 2 ) {
      PVector tColor     = getColor(); 
      PVector tPosition  = getPosition(); 
      pointLight( tColor.x, tColor.y, tColor.z, tPosition.x, tPosition.y, tPosition.z ); 
    }
    else if ( mType == 3) {
      PVector tColor     = getColor(); 
      PVector tPosition  = getPosition(); 
      PVector tDirection = getDirection(); 
      spotLogith( tColor.x, tColor.y, tColor.z, 
                  tPosition.x, tPosition.y, tPosition.z, 
                  tDireciton.x, tDirection.y, tDirection.z. 
                  getSpotAngle(), getSpotConcentration() );
    }
    
    //handle specularity
    PVector tSpecularColor = getSpecularColor(); 
    lightSpecular( tSpecularColor.x, tSpecularColor.y, tSpecularColor.z ); 
  }
  
  EaseVecDelta getPositionRef()                                  { return mPosition; }
  EaseVecDelta getDirectionRef()                                 { return mDireciton; }
  
  EaseVecDelta getColorRef()                                     { return mColor; }
  EaseVecDelta getSpecularColorRef()                             { return mSpecularColor; }
  
  EaseFloat    getSpotAngleRef()                                 { return mSpotAngle; }
  EaseFloat    getSpotConcentrationRef()                         { return mSpotConcentration; }
  
    
