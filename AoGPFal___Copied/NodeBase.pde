//class: odebase 
// a basic scenegraph object
/// purpose: it is easy enough to keep track of a few objects within a simple program architecture. 
// as we build increasingly complex 3D scenes however, it will become more difficult to manage ojebects
// and the relationships between them. Therefore, it is important to establish a data structure that can 
// encapsulate some of this complexity. One common design pattern, used in modeling encironment ssuch as
// AYA as well as games and visualizations is the scenegraph. In this heirachical pattern, 
// Each pboejct or "node"  can have up to one parent and an unlimited number of children. 
// Nodes that have no parent are called root nodes. ode can be set to inheret properties form thier parents 
//or perform poperations on thier children, allowing operations to be easily cascated
// down a scenegraph. For example, a spine object could be established as a root noed, with leg object
// as its chidlren. Each leg would have 5 toe children. When the user moves the spine object in 3D space, 
// the legs and toes wil move with it automatically. If the user instead moved one of the legs, only its 
// toes would move with it. This heirachical stucture allows us to greatly redcue the complexity
// of interacting with the scene. 

class NodeBase {
  // Scenegraph properties 
  String                 mName; 
  NodeBase               mParent;
  ArrayList<NodeBase>    mChildren; 
  // Rendering Properties 
  boolean                mVisibility; 
  Globals                mGlobals; 

  NodeBase(Globals iGlobals) {
    mGlobals        =   iGlobals; 
    // Initialize Default name 
    mName           =   "untitled"; 
    // Initialize default visibility 
    mVisibility     =    true; 
    // Set default parent to null (no parent) 
    mParent         =    null; 
    // Initialize child list 
    mChildren       =    new ArrayList();
  }

  void setName(String iName) {
    // set node's name from input string
    mName = iName;
  }

  String getName() {
    //return name
    return mName;
  }

  void addChild(NodeBase iChild) {
    //set child's parent to be this node
    iChild.setParent( this ); 
    //Add input node to list of children
    mChildren.add( iChild );
  }

  void removeChild(int iIndex) {
    // Make sure that the input index is within the arraylist bound
    if (iIndex >= 0 && iIndex < mChildren.size()) {
      //Remove the parent reference from child node at the given index
      mChildren.get(iIndex).setParent(null); 
      // remove the node at the given index from child list
      mChildren.remove( iIndex );
    }
  }

  NodeBase getChild(int iIndex) {
    //make sure that the input index is within the arraylist bound
    if (iIndex >= 0 && iIndex < mChildren.size()) {
      // eturn the child node at the given index 
      return mChildren.get( iIndex );
    }
    //itherwise return null 
    return null; 
  }

  int getChildCount() {
    //return the nubmer of children under the current node
    return mChildren.size();
  }

  void setParent(NodeBase iParent) {
    // Set the parent reference to a given node 
    mParent = iParent;
  }

  NodeBase getParent() {
    // get a reference to the node's parent
    return mParent;
  }

  boolean isRootNode() {
    // return whether the node is a root node
    // a root nde is one that does not have a parent
    return (mParent == null);
  }

  NodeBase getRootNode() {
    // if node is a root, return it 
    if ( isRootNode() ) {
      return this;
    }
    // otherwise, clime up the scenegraph until we reach a root
    return mParent.getRootNode();
  }

  boolean getVisibility() {
    // return the node's visilbity 
    return mVisibility;
  }

  boolean getParentVisibility() {
    // If node is a root, retun its visibility
    if( isRootNode() ) {
      return mVisibility;
    }
    // The mVisibility of both curernt node and its parent(and grandparent, etc) must be true for current to be visibile
    return(mParent.getVisibility() && mVisibility);
  }

  void setVisibility(boolean iVisibility) {
    //Set the node's visibility form input 
    mVisibility = iVisibility;
  }


  void toggleVisibility() {
    //toggle visibility boolean
    mVisibility = !mVisibility;
  }


  void print(int iIndent) {
    if ( getVisibility() ) {
      // Fromat indentation string
      String indent =  "   "; 
      int len = indent.length() * iIndent; 
      String indentStr = new String(new char[len]).replace( "\0", indent ); 
      // print node info string
      println( indentStr + mName ); 
      // Print chidlren
      int tChildCount = getChildCount(); 
      for (int i = 0; i < tChildCount; i++) {
        mChildren.get( i ).print( iIndent + 1 );
      }
    }
  }


  void draw() {
    //Stub method
  }

  void drawDebug() {
    // stub method
  }

  
}





