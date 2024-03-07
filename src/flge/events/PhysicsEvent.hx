package flge.events;

import openfl.events.Event;
import openfl.events.EventType;

import box2d.dynamics.B2World;

/**
 * Events that contain data used by the PhysicsManager
 *
 * @see `PhysicsManager`
 */
class PhysicsEvent extends Event {
 
  /**
   * Defines the value of the `type` property of a `physicsupdate` event object.
   * This event has the following properties:
   *
   * | Property | Value |
   * | --- | ---|
   * | `bubbles` | `false` |
   * | `cancelable` | `false` |
   * | `currentTarget` | The object that is actively processing the Event object with an event listener. |
   * | `target` | The object with a listener registered for the `physicsupdate` event. |
   * | `world` | The box2d world instance that is being updated. |
   */ 
  public static inline var UPDATE:EventType<PhysicsEvent> = "physicsupdate";

  /**
   * The box2d world instance that the `PhysicsManager` is using 
   */
  public var world:Null<cpp.Pointer<B2World>>;


  /**
   * Creates and event object that contains information about physics events.
   * Event objects are passed as parameters to event listeners
   *
   * @param type The type of event. Event listeners can access information
   *                        through the inherited `type` property. There is
   *                        only one type of physics event: `PhysicsEvent.UPDATE`
   *
   * @param world The box2d world pointer used by `PhysicsManager`. Event listeners
   *                        can access this information through the `world` property.
   *
   * @param bubbles Determines whether the Event object participates in
   *                        the bubbling phase of the event flow. Event listeners
   *                        can access this information through the inherited `bubbles` property
   *
   * @param cancelable Determines whether the Event object can be canceled.
   *					              Event listeners can access this information through
   *					              the inherited `cancelable` property.
   */
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
