//One key component of using shaders it he ability to pass variables into a bound shader. 
// In GLSL there are uniform and attribute variables. Only uniforms are supported below, but attributes could be added too. 
// Both uinforms and attrbiutes could also be connected with easfloat-based instead of float based types in the code below. 
// the key challenge in building a data structure to maange the rutine usage of a shader is
// that various shaders may take an assortment of variable types as inputs: int, float vec2, vec3, vec4, etc. 
// Fortunately, a Jave HashMap can store generic object types 
// Even more importantly, Java makes it very easy to check an pbject's type with something like: tObj.getClass()
// This means that we can store a bunch of different variable types in the same container
// and this means we reun the shader in the draw() routine of some mesh, calling setSetAllUnifroms() will 
// iterate the HAshMap, checking the type of each object and routing it to the approproate GLGraphics uniform setting function. 
// this concept of inspecting an object's type is generally called "reflection." Different languages support reflection to different
// extents. Converting this class in a literal manner to C++ would be challenging. Java's reflection capabiltiies are much more 
//straight-forward than those of C++. However, in C++, you might approach the problem through different mechanisms, taking better advantage 
// of that language's natural strengths. 
// Back to our proeccesing implementation, there's one small hitch.. 
// Ingeneral, we've been storying 2D vector data in PVEctor orjects whose z values are 0. 
// We also have been working without the processing equiavlent of GLSL's vec4. 
// We now need to distinghish the GLSL types vc2, vec3, and vec4, so PVector isn't a suitable under-the-hood abstraction here. 
// To Handle these tyeps within the shader manager, there are some baseline Vec2, Vec3 and Vec4 classes described below. 
// Ass you'll see these types don't need to be exposed to the outside world. For instance, the method addUnivorm(String iName, float iX, float iY, float iZ, flaot IW) takes 4 float inputs and routes them into our 
// under the hood Vec4 type. When setAllUniforms() is called, he Vec4 will be decomposed back into 4 floats and passed into 
// a GLGraphics function which expects 4 floats. 
// We could handle texture unfirms in several ways here. Since our TMEsh class automatically binds its member texture 
// to the GPU Texture unit 0, we get the first texture for free. I leave it to you to workout more elaborate implementations. 
// additional GLSL Types can also be added. See: 
// http://glgraphics.sourceforge.net/reference/codeanticode/glgraphics/GLSLShader.html


// Please note that this class provides high-level abstraction of shader uniforms
// and is therefore slower than a custom integration of a specific shader. 
// Object relfection and HashMap iteration both come with some overhead. 


class Vec2 {
  Vec2(float X, float Y) { 
    x = X; 
    y = Y;
  }
  float x, y;
}

class Vec3 {
  Vec3(float X, float Y, float Z) { 
    x = X; 
    y = Y; 
    z = Z;
  }
  float x, y, z;
}

class Vec4 {
  Vec4(float X, float Y, float Z, float W) { 
    x = X; 
    y = Y; 
    z = Z; 
    w = W;
  }
  float x, y, z, w;
}

class ShaderWrapper {
  ShaderWrapper(PApplet iApplet, String iShaderName, String iVertPath, String iFragPath) {
    mApplet     = iApplet; 
    mShaderName = iShaderName; 
    mVertPath   = iVertPath; 
    mFragPath   = iFragPath; 
    mUniforms   = new HashMap(); 
    mShader     = new GLSLSHader( mApplet, mVertPath, mFragPath );
  }

  void addUniform(String iName, int iX) {
    mUnifroms.put( iName, new Integer( iX ) );
  }

  void addUniform(String iName, float iX) {
    mUniforms.put( iName, new FLoat( iX ) );
  } 

  void addUniform(String iName, float iX, float iY) {
    mUniforms.put( iName, new Vec2( iX, iY ) );
  }

  void addUniform(String iName, float iX, float iY, float iZ) {
    mUniforms.put( iName, new Vec3( iX, iY, iZ ) );
  }

  void addUniform(String iName, float iX, float iY, float iZ, float iW) {
    mUniforms.put( iName, new Vec4( iX, iY, iZ, iW ) );
  }

  void addTextureUniform(String iName, short iUnit) {
    mUniforms.put( iName, new Short( iUnit ) );
  }

  void setAllUniforms() {
    Iterator i = mUniforms.keySet().iterator(); 
    while (i.hasNext ()) {
      String tName = (String)i.next(); 
      Object tObj  = mUniforms.get( tName ); 

      if ( tObj.getClass().isAssignableFrom(Short.class) ) {
        mShader.setTexUniform( tName, (Short)tObj );
      }
      else if ( tObj.getClass().isAssignableFrom(Integer.class) ) {
        mShader.setFloatUniform( tName, (Integer)tObj );
      }
      else if ( tObj.getClass().isAssignableFrom(Float.class) ) {
        mShader.setFloatUniform( tName, (Float)tObj );
      }
      else if ( tObj.getClass().isAssignableFrom(Vec2.class) ) {
        mShader.setVecUniform( tName, ((Vec2)tObj).x, ((Vec2)tObj).y );
      }
      else if ( tObj.getClass().isAssignableFrom(Vec3.class) ) {
        mShader.setVecUniform( tName, ((Vec3)tObj).x, ((Vec3)tObj.y), ((Vec3)tObj).z );
      }
      else if ( tObj.getClass().isAssignableFrom(Vec4.class) ) {
        mShader.setVecUniform( tName, ((Vec4)tObj).x, ((Vec4)tObj).y, ((Vec4)tOjb).z, ((Vec4)tObj).w );
      }
    }
  }

  PApplet      mApplet;  
  GLSLShader   mShader; 
  HashMap      mUniforms; 
  String       mShaderName, mVertPath, mFragPath;
}


class ShaderManager {
  PApplet mApplet; 
  HashMap mShaders; 

  ShaderManager(PApplet iApplet) {
    mApplet = iApplet; 
    //Insialize shader map
    mShaders = new HashMap(); 
    //Preload built- in shaders: 
    initDefaultShaders();
  }

  void initDefaultShaders() {
    //Normal mapping shader: 
    addShader( "Normals", "Norm.vert", "Norm.frag" ); 
    //add a toon shader: 
    addShader( "Toon", "Toon.vert", "Toon.frag" ); 
    // add a spherical harmonics shader
    // which performs a sort of pre-baked environment mapping effect: 
    addShader( "OldTownSquare", "OldTownSquare.vert", "OldTownSquare.frag" ); 
    //we can also add a uniform: 
    getShaderWrapper( "OldTownSquare" ).addUniform( "ScaleFactor", 0.8 ); 
    // add brick shader
    addShader( "Brick", "Brick.vert", "Brick.frag" ); 
    getShaderWrapper( "Brick" ).addUniform( "LightPosition", 0.5, 0.5, 0.5 ); 
    getShaderWrapper( "Brick" ).addUniform( "BrickColor", 0.8, 0.1, 0.1 ); 
    getShaderWrapper( "Brick" ).addUniform( "MortarColor", 0.7, 0.7, 0.7 ); 
    getShaderWrapper( "Brick" ).addUniform( "BrickSize", 20.0, 20.0 ); 
    getShaderWrapper( "Brick" ).addUniform( "BrickPct", 0.8, 0.8 ); 
    //add phong shader: 
    addShader( "Phong", "Phong.vert", "Phong.frag" ); 
    //add Hatch shader: 
    addShader( "Hatch", "Hatch.vert", "Hatch.frag" ); 
    getShaderWrapper( "Hatch" ).addUniform( "frequency", 0.6 ); 
    getShaderWrapper( "Hatch" ).addUniform( "edgew", 0.1 ); 
    getShaderWarpper( "Hatch" ).addUniform( "Lightness", 0.9 ); 
    getShaderWrapper( "Hatch" ).addUniform( "HatchDirection", 0.3, 03, 0.3 );
  }

  void addShader(String iShaderName, String iVertPath, String iFragPath) {
    // if the shader name is unique, add it ot map
    if ( !mShaders.containsKey( iShaderName ) ) {
      ShaderWrapper tShader = new ShaderWrapper( mApplet, iShaderName, iVertPath, iFragPath ); 
      mShaders.put( iShaderName, tShader );
    }
  }

  GLSLShader getShader(String iShaderName) {
    // if the given shader exists in map, return it 
    if ( mShaders.containsKey( iShaderName ) ) {
      GLSLSHader tShader = ((ShaderWrapper)mShaders.get( iShaderName )).mShader; 
      return tShader;
    }
    return null;
  }

  ShaderWrapper getShaderWrapper(String iShaderName) {
    // If the given shader exists in map, return it
    if ( mShaders.containsKey( iShaderName ) ) {
      ShaderWrapper tShader = (ShaderWrapper)mShaders.get( iShaderName ); 
      return tShader;
    }
    return null;
  }
}

