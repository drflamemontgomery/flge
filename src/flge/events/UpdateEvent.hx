package flge.events;

import openfl.events.Event;
import openfl.events.EventType;

/**
 * Events that contain data used by the UpdateManager
 *
 * @see `UpdateManager`
 */
class UpdateEvent extends Event {

  /**
   * Defines the value of the `type` property of a `update` event object.
   * This event has the following properties:
   *
   * | Property | Value |
   * | --- | ---|
   * | `bubbles` | `false` |
   * | `cancelable` | `false` |
   * | `currentTarget` | The object that is actively processing the Event object with an event listener. |
   * | `target` | The object with a listener registered for the `update` event. |
   * | `dt` | The time passed in seconds. |
   */ 
  public static inline var UPDATE:EventType<UpdateEvent> = "update";

  /**
   * The time passed in seconds since the last update event
   */
  public var dt:Float;
  
  /**
   * Creates and event object that contains information about update events.
   * Event objects are passed as parameters to event listeners
   *
   * @param type The type of event. Event listeners can access information
   *                        through the inherited `type` property. There is
   *                        only one type of physics event: `UpdateEvent.UPDATE`
   *
   * @param bubbles Determines whether the Event object participates in
   *                        the bubbling phase of the event flow. Event listeners
   *                        can access this information through the inherited `bubbles` property
   *
   * @param cancelable Determines whether the Event object can be canceled.
   *					              Event listeners can access this information through
   *					              the inherited `cancelable` property.
   *
   * @param dt The time passed in seconds by `flge.Timer`. Event listeners
   *                        can access this information through the `dt` property.
   *
   * @see `flge.Timer`
   */
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
