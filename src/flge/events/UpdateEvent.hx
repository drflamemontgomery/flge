package flge.events;

import openfl.events.Event;
import openfl.events.EventType;

class UpdateEvent extends Event {

  public static inline var UPDATE:EventType<UpdateEvent> = "update";

  public var dt:Float;
  
  public function new(type:String, bubbles:Bool = true, cancelable:Bool = false, dt:Float = 0.) {
    super(type, bubbles, cancelable);
    this.dt = dt;
  } 

  public override function clone():UpdateEvent {
    var event = new UpdateEvent(type, bubbles, cancelable, dt);
    event.target = target;
    event.currentTarget = currentTarget;
    event.eventPhase = eventPhase;
    return event;
  }

  public override function toString():String {
    return __formatToString("UpdateEvent", ["type", "bubbles", "cancelable", "dt"]);
  }

  @:noCompletion private override function __init():Void {
    super.__init();
    dt = flge.Timer.dt;
  }
}
