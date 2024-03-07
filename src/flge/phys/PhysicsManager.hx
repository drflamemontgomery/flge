package flge.phys;

import flge.events.PhysicsEvent;

import openfl.events.EventDispatcher;

import box2d.Include;
import box2d.dynamics.B2World;

/**
 * PhysicsManager is the default physics library in this engine
 * using [box2d](https://box2d.org)
 *
 * Subscribe to the Physics Update Event using
 * `PhysicsManager.inst.addEventListener(PhysicsEvent.UPDATE, callback)`
 */
class PhysicsManager extends EventDispatcher {
  /**
   * The current instance of the PhysicsManager
   */
  public static var inst : PhysicsManager;

  /**
   * Pixels Per Meter
   * Box2d uses Meters instead of pixels so
   * set this as your desired pixel size
   */
  public static var PPM  : Int = 64;


  /**
   * The raw cpp pointer to the box2d world instance.
   *
   * Access the raw structure by using world.value
   */
  public var world(default, null) : cpp.Pointer<B2World>;

  /**
   * Whether the physics simulation is paused or not
   */
  public var paused(default, null) : Bool;

  private var timer : haxe.Timer;
  private var updateEvent : PhysicsEvent;

  /**
   * Creates a new world with the given gravity
   *
   * @param gravity in units of m/s
   */
  public function new(gravity : { x : Float, y : Float }) {
    super();
    inst = this;
    world = untyped __cpp__("new b2World(b2Vec2({0}, {1}))", gravity.x, gravity.y);
    updateEvent = new PhysicsEvent(PhysicsEvent.UPDATE, world);
    start(); 
  }

  public function start() {
    timer = new haxe.Timer(16);
    timer.run = updateWorld;
    paused = false;
  }

  public function stop() {
    timer.stop();
    paused = true;
  }

  private function updateWorld() {
    world.value.step(1.0/60.0, 10, 8);
    dispatchEvent(updateEvent);
  }
}
