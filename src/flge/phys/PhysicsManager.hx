package flge.phys;

import flge.events.PhysicsEvent;

import openfl.events.EventDispatcher;

import box2d.Include;
import box2d.dynamics.B2World;

class PhysicsManager extends EventDispatcher {
  public static var inst : PhysicsManager;
  public static var PPM  : Int = 64;

  public var world(default, null) : cpp.Pointer<B2World>;
  public var paused(default, null) : Bool;

  private var timer : haxe.Timer;
  private var updateEvent : PhysicsEvent;

  public function new(gravity : { x : Float, y : Float }) {
    super();
    inst = this;
    world = untyped __cpp__("new b2World(b2Vec2({0}, {1}))", gravity.x, gravity.y);
    updateEvent = new PhysicsEvent(PhysicsEvent.UPDATE, world);
    start(); 
  }

  private function updateWorld() {
    world.value.step(1.0/60.0, 10, 8);
    dispatchEvent(updateEvent);
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

}
