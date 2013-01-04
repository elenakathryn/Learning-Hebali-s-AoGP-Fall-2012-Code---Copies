class Globals {
  PApplet             mApplet; 
  GLGraphics          mRenderer; 
  GL                  mGl; 
  SceneController     mScene;
  ShaderManager       mShaderManager; 


  Globals(PApplet iApplet) {
    //get Applet referecnce
    mApplet = iApplet; 
    //get GLGraphics renderer reference
    mRenderer = (GLGraphics)g; 
    // get opengl handle reference
    mGl = mRenderer.gl; 
    //initialize shader manager
    mShaderManager = new ShaderManager( mApplet );
  }

  void setSceneController(SceneController iScene) {
    mScene = iScene;
  }
}

