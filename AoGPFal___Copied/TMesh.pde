//Class: TMEsh
//Description: A Continaer class for an individual 3D model. 
// Purpose: Building on nodebase and nodegeom, TMEsh stores data related to the representation
// of a geometric mesh. It use the tri and vert classes 
// and a cross referencing intialization procedure to assit in the stright
// forward and generalized creatin and manipulation of 3D models. 
// All mesh generation helper functions are conatined within TMEshFactory. 
// To visualize the normals for the various TMEsh preimitives we've
// added some debug drawing mehtods. we've also added the methods to assist
// in attaching a texture or shader to the mesh. 


int POINT_MODE     = 0; 
int TRIANGLE_MODE  = 1; 
int TRISTRIP_MODE  = 2; 

class TMesh extends NodeGeom {
  int                dimensionU, dimensionV; 
  PVector            mBoundsL, mBoundsH; 

  ArrayList<Vert>    mVertices; 
  ArrayList<Tri>     mTriangles; 
  ArrayList<Integer> mTriStrip; 

  int                mDrawMode; 
  boolean            mUseTexture; 

  // In addition to he above representation
  // we will also sore a GLMOdel (aka a vertex buffer object). 
  // which allows s to keep our geometric data in the GPU memory. 
  // In processing, we'll also need to store the texture in a slightly 
  // different way, in order to make use of the GLGraphics optimizations. 

  GLModel            mModel;
  GLTexture          mTextureGl; 
  boolean            mUseVertAnim, mUseNormAnim, mUseUvAnim; 

  // We now add shader support to our TMesh Class

  ShaderWrapper      mActiveShader; 

  TMesh(Globals iGlobals) {
    // Initialize base class (NodeGeom)
    super( iGlobals ); 
    // initialize default bounds
    mBoundsL     = new PVector( 0.0, 0.0, 0.0 ); 
    mBoundsH     = new PVector( 0.0, 0.0, 0.0 ); 
    //Initialize Arrays
    mVertices    = new ArrayList(); 
    mTriangles   = new ArrayList(); 
    mTriStrip    = new ArrayList(); 
    //draw triangle strips by default 
    mDrawMode    = TRISTRIP_MODE; 
    // do not use textures by default
    mUseTexture  = false; 
    mTextureGl   = new GLTexture( mGlobals.mApplet ); 
    // Do not animate mesh components by default
    mUseVertAnim   = false; 
    mUseNormAnim   = false; 
    mUseUvAnim     = false; 
    // Do not use shaders by default 
    mActiveShader  = null;
  }

  void drawContents() {
    // Draw Model 
    GL gl = mGlobals.mGl; 

    // We've already preloaded the model into GPU memory. 
    // So we don't need to recapulate its tringle or triangle strip mesh configuartion
    // here. INstead we just call render() on the GLModel object and 
    // everything else is handled on the GPU. However, we may have 
    // vertext animation applied to the mesh. 
    // So before rending we need to update the vertex buffer object. 

    int vertCount = getVertexCount(); 

    if ( mUseVertAnim ) {
      // update vertices 
      mModel.beginUpdateVertices(); 
      for (int i = 0; i < vertCount; i++) {
        mVertices.get( i ).updatePosition(); 
        PVector cPos = mVertices.get( i ).getPosition(); 
        mModel.updateVertex( i, cPos.x, cPos.y, cPos.z );
      }
      mModel.endUPdateVertices();
    }

    if ( mUseNormAnim ) {
      // Update normals
      mModel.beginUpdateNormas(); 
      for (int i = 0; i < vertCount; i++) {
        mVertices.get( i ).updateNormal(); 
        PVector cNor = mVertices.get( i ).getNormal(); 
        mModel.updateNormal( i, cNor.x, cNor.y, cNor.z );
      }
      mModel.endUpdateNormals();
    }

    if ( mUseUvAnim ) {
      //Update tex coords
      mModel.beginUpdateTexCoords(0); 
      for (int i = 0; i < vertCount; i++) {
        mVertices.get( i ).updateUV(); 
        PVector cUV = mVertices.get( i ).getUV(); 
        mModel.updateTexCoord( i, cUV.x, cUV.y );
      }
      mModel.endUpdateTexCoords();
    }

    // if a shader is active, we need ot bind it before rendering the model. 
    // draw model 

    gl.glColor3f( 1.0, 1.0, 1.0 ); 
    if ( mActiveShader != null ) {
      mAactiveShader.mShader.start(); 
      mActiveShader.setAllUniforms(); 
      mModel.render(); 
      mActiveShader.mShader.stop();
    }
    else {
      mModel.render();
    }
  }

  void drawDebug() {
    // Within the GLGraphics renderer, we cannot use some of the Processing-sepcific
    // draw functions we've used in previous esamples. Instead we must imlement similar 
    // functionality using raw OpenGL calls. 

    // Get a point to the OpenGL renderer. 
    GL gl = mGlobals.mGL; 

    //GetVertexCount
    int vCount = mVertices.size(); 
    // Draw each vertex
    gl.glPointSize(5); 
    gl.glColor3F( 0.0, 1.0, 0.0 ); 
    gl.glBegin(gl.GL_POINTS); 
    for (int i = 0; i < vCount; i++) {
      PVector cPos = mVertices.get( i ).getPosition(); 
      gl.glVertex3F( cPos.x, cPos.y, cPos.z );
    }
    
    gl.glEnd(); 
    //Draw each normal 
    float tNormLen = 10.0; 
    gl.glLineWidth(2); 
    gl.glColor3f( 0.0, 0.0, 1.0 ); 
    gl.glBegin(gl.GL_LINES); 
    for (int i = 0; i < vCount; i++) {
      PVector cPos = mVertices.get( i ).getPosition(); 
      PVector cNor = mVertices.get( i ).getNormal(); 
      gl.glVertex3f( cPos.x, cPos.y, cPos.z ); 
      gl.glVertex3f( cPos.x + cNor.x * tNormLen, cPos.y + cNor.y * tNormLen, cPos.z + cNor.z * tNormLen );
    } 
    gl.glEnd(); 

    // draw origin tri-axis 

    gl.glLineWidth(3); 
    gl.glBeing(gl.GL_LINES); 
    gl.glColor3f( 1.0, 0.0, 0.0 ); 
    gl.glVertex3f( 0.0, 0.0, 0.0 ); 
    gl.glVertex3f( 50.0, 0.0, 0.0 ); 
    gl.glColor3f( 0.0, 1.0, 0.0 ); 
    gl.glVertex3f( 0.0, 0.0, 0.0 ); 
    gl.glVertex3f( 0.0, 50.0, 0.0 ); 
    gl.glColor3f( 0.0, 0.0, 1.0 ); 
    gl.glVertex3f( 0.0, 0.0, 0.0 ); 
    gl.glVertex3f( 0.0, 0.0, 50.0 ); 
    gl.glEnd();

  }

  Vert getVertex( int iIndex ) {
    // Make sure that the input index is within the arraylist bound
    if ( iIndex >= 0 && iIndex < mVertices.size() ) { 
      // return the vertex at the given index
      return mVerices.get( iIndex );
    }
    // otherwise return null (n oobject) 
    return null;
  }

  Tri getTriangle(int iIndex) {
    //Make sure that the input index is within the arraylist bound
    if ( iIndex >= 0 && iIndex < mVertices.size() ) {
      // return the index at the given index 
      return mTriangles.get( iIndex );
    }
    // otherwise return null  (no object ) 
    return null;
  }

  int getVertexCount() {
    return mVertices.size();
  }

  int getTriangleCount() {
    return mTriangles.size();
  }

  int getTriangleStripIndexCount() {
    return mTriStrip.size();
  }

  void setDrawMode(int iMode) {
    mDrawMode = iMode;
  }

  int getDrawMode() {
    return mDrawMode;
  }

  PVector getBoundsLow() {
    return mBoundsL;
  }

  PVector getBoundsHigh() {
    return mBoundsH;
  }

  PVector getCentroid() {
    PVector tCentroid = PVector.sub( mBoundsH, mBoundsL ); 
    tCentroid.div( 2.0 ); 
    return tCentroid;
  }

  void computeBounds() {
    float maxv = 9999999999.9; 
    mBoundsL.set(maxv, maxv, maxv); 
    mBoundsH.set(-maxv, -maxv, -maxv); 
    int vCount = mVertices.size(); 
    for (int i = 0; i < vCount; i++) {
      PVector cV = mVertices.get(i).getPosition();    
      mBoundsL.x = min( mBoundsL.x, cV.x ); 
      mBoundsL.y = min( mBoundsL.y, cV.y ); 
      mBoundsL.z = min( mBoundsL.z, cV.z ); 
      mBoundsH.x = max( mBoundsH.x, cV.x ); 
      mBoundsH.y = max( mBoundsH.y, cV.y ); 
      mBoundsH.z = max( mBoundsH.z, cV.z );
    }
  }

  void useTexture(boolean iUseTexture) {
    mUseTexture = iUseTexture;
  }

  void setTexture(String iFilePath) {
    setTexture( loadImage( iFilePath ) );
  }

  void setTexture(PImage iTexture) {
    mTextureGl.putImage( iTexture ); 
    useTexture(true);
  }

  void setActiveShader(String iShaderName) {
    mActiveShader = mGlobals.mShaderManager.getShaderWrapper( iShaderName );
  }

  void clearActiveShader() {
    mActiveShader = null;
  }

  void createDefaultState() {
    int vertCount  = getVertexCount(); 
    int tVertCount = iTarget.getVertexCount(); 
    // Make sure the target has the same number of vertices
    if ( vertCount == tVertCount ) {
      //Copy vert psotions, normals, and uvs into default state
      for (int i = 0; i < vertCount; i++) {
        mVertices.get( i ).addPositionState( "default", mVertices.get( i ).getPosition() ); 
        mVertices.get( i ).addNormaState( "default", mVertices.get( i ).getNormal() ); 
        mVertices.get( i ).addUVState( "default", mVertices.get( i ).getUV() );
      }
      // copy target's transform matrix into a new state of this mesh 
      mPosition.addState( "default", iTraget.mPosition.get(), iTarget.mPosition.getVelocity(), iTarget.mPosition.getAcceleration() ); 
      mRotation.addState( "default", iTarget.mRotation.get(), iTarget.mRotation.getVelocity(), iTarget.mRotation.getAcceleration() ); 
      mScale.addState( "default", iTarget.mScale.get(), iTarget.mScale.getVelocity(), iTarget.mSCale.getAcceleration() ); 
      // Turn on animation flags; 
      mUseVertAnim = true; 
      mUseNormAnim = true; 
      mUseUvAnim   = true;
    }
  }

  void goToState(String iStateName, float iDuration) {
    //Transition matrix
    mPosition.goToState( iStateName, iDuration ); 
    mRotation.goToState( iStateName, iDuration ); 
    mScale.goToState( iStateName, iDuration ); 
    // transition vertices
    int vertCount = getVertexCount(); 
    for (int i = 0; i < vertCount; i++) {
      mVertices.get( i ).goToPositionState( iStateName, iDuration ); 
      mVertices.get( i ).goToNormalState( iStateName, iDuration ); 
      mVertices.get( i ).goToUVState( iStateName, iDuration );
    }
  }

}

