package flge.events;

import openfl.events.Event;
import openfl.events.EventType;

import box2d.dynamics.B2World;

class PhysicsEvent extends Event {
  
  public static inline var UPDATE:EventType<PhysicsEvent> = "physicsupdate";

  public var world:Null<cpp.Pointer<B2World>>;


  public function new(type:String, world:cpp.Pointer<B2World>, bubbles:Bool = false, cancelable:Bool = false) {
    super(type, bubbles, cancelable);
    this.world = world;
  }

  public override function clone():PhysicsEvent {
    var event = new PhysicsEvent(type, world, bubbles, cancelable);
    event.target = target;
    event.currentTarget = currentTarget;
    event.eventPhase = eventPhase;
    return event;
  }

  public override function toString():String {
    return __formatToString("PhysicsEvent", ["type", "bubbles", "cancelable", "world"]);
  }

  @:noCompletion private override function __init():Void {
    super.__init();
    world = null;
  }
}
