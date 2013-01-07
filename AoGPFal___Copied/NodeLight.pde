class NodeLight extends NodeBase {
  int             mType; 
  EaseVecDelta    mPosition, mDirection; 
  EaseVecDelta    mColor, mSpecularColor; 
  EaseFloat       mSpotAngle, mSpotConcentration; 
  
  NodeLight(Globals iGlobals) {
    //Intialize base class(NodeBase) 
    super( iGlobals ); 
    //Initialize light defaults
    mPosition            = new EaseVecDelta( new PVector( 0.0, 0.0, 0.0 ) ); 
    
