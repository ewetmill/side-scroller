final int screenWidth = 512;
final int screenHeight = 432;

float DOWN_FORCE = 2;
float ACCELERATION = 1.3;
float DAMPENING = 0.75;

void initialize() {
  addScreen("level", new MarioLevel(width, height));
  frameRate(30);
}

class MarioLevel extends Level {
  MarioLevel(float levelWidth, float levelHeight) {
    super(levelWidth, levelHeight);
    addLevelLayer("layer", new MarioLayer(this));
  }
}

class MarioLayer extends LevelLayer {
  MarioLayer(Level owner) {
    super(owner);
    setBackgroundColor(color(0, 100, 190));
    addBoundary(new Boundary(0,height-48,width,height-48));
    showBoundaries = true;
    Mario mario = new Mario(width/2, height/2);
    addPlayer(mario);
  }
}

class Mario extends Player {
  Mario(float x, float y) {
    super("Mario");
    setupStates();
    setPosition(x,y);
    handleKey('W');
    handleKey('A');
    handleKey('D');
    setForces(0,DOWN_FORCE);
    setAcceleration(0,ACCELERATION);
    setImpulseCoefficients(DAMPENING,DAMPENING);
  }
  void setupStates() {
    addState(new State("idle", "graphics/mario/small/Standing-mario.gif"));
    addState(new State("running", "graphics/mario/small/Running-mario.gif",1,4));
    addState(new State("jumping", "graphics/mario/small/Jumping-mario.gif"));
    addState(new State("dead", "graphics/mario/small/Dead-mario.gif",1,2));
    setCurrentState("idle");    
  }
  void handleInput() {
    // handle running
    if(isKeyDown('A') || isKeyDown('D')) {
      if (isKeyDown('A')) {
        setHorizontalFlip(true);
        addImpulse(-2, 0);
      }
      if (isKeyDown('D')) {
        setHorizontalFlip(false);
        addImpulse(2, 0);
      }
      setCurrentState("running");
    }

    // handle jumping
    if(isKeyDown('W') && active.name!="jumping" && boundaries.size()>0) {
      addImpulse(0,-35);
      setCurrentState("jumping");
    }
    
    if(!isKeyDown('A') && !isKeyDown('D') && !isKeyDown('W')) {
      setCurrentState("idle");
    }
  }
}
