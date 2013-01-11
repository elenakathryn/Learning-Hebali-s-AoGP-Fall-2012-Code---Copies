class EaseVec { 
  PVector     controlState; 
  EaseFloat   x, y, z; 

  EaseVec() {
    //Initialize ease vars
    x = new EaseFloat( 0.0 ); 
    y = new EaseFloat( 0.0 );
    z = new EaseFloat( 0.0 ); 
    //INitialize control variable 
    controlState = new PVector ( 0.0, 0.0, 0.0 );
  }

  EaseVec(PVector ControlState) {
    // Initialize ease vars
    x = new EaseFloat( ControlState.x );
    y = new EaseFloat( ControlState.y );
    z = new EaseFloat( ControlState.z );
    // Set control variable
    controlState = ControlState.get();
  }

  void setEaseType(String iTypeName) {  
    x.setEaseType( iTypeName ); 
    y.setEaseType( iTypeName ); 
    z.setEaseType( iTypeName );
  }

  void addState(String iStateName, PVector iState) { 
    //add component states
    x.addState( iStateName, iState.x); 
    y.addState( iStateName, iState.y); 
    z.addState( iStateName, iState.z);
  }

  void goToState(String iStateName, float iDuration) {
    //Goto Component States
    x.goToState( iStateName, iDuration ); 
    y.goToState( iStateName, iDuration ); 
    z.goToState( iStateName, iDuration ); 
    //Update Control state from components
    controlState.set( x.get(), y.get(), z.get() );
  }

  void update() {
    //Update components
    x.update(); 
    y.update(); 
    z.update(); 
    // update control state from components 
    controlState.set( x.get(), y.get(), z.get() );
  }

  void set(float X, float Y, float Z) {
    set( new PVector( X, Y, Z) );
  }

  void set(PVector iState) { 
    x.set(iState.x); 
    y.set(iState.y); 
    z.set(iState.z); 
    controlState.set(iState.get());
  }

  PVector get() {
    return controlState.get();
  }

  void resetTransition() {
    // reset Components
    x.resetTransition(); 
    y.resetTransition(); 
    z.resetTransition();
  }

  void startTransition() {
    //start components
    x.startTransition(); 
    y.startTransition(); 
    z.startTransition();
  }
}



