package flge.display;

import openfl.display.Sprite;
import openfl.events.Event;

import box2d.common.math.B2Vec2;
import box2d.dynamics.B2World;
import box2d.dynamics.B2Body;

import flge.phys.PhysicsManager;
import flge.events.PhysicsEvent;

/**
 * A class that extends the `Sprite` class to render at the location of the box2d body
 */
class  PhysicsSprite extends Sprite {

  @:dox(show)
  private var body : cpp.ConstPointer<B2Body>;

  /**
   * Create a `Sprite` instance with a box2d body instance
   *
   * @param body A cpp pointer to a box2d body
   */
  public function new(body:cpp.ConstPointer<B2Body>) {
    super();
    this.body = body;
    addEventListener(Event.ADDED_TO_STAGE, added);
  }

  private function added(e) {
    removeEventListener(Event.ADDED_TO_STAGE, added);
    PhysicsManager.inst.addEventListener(PhysicsEvent.UPDATE, physicsUpdate);
  }

  /**
   * The update callback subscribed from `PhysicsManager`.
   * This should run at 60fps or at the applications framerate.
   */
  @:dox(show)
  private function physicsUpdate(e:PhysicsEvent) {
    var position = body.value.getPosition();
    var local = parent.globalToLocal(new openfl.geom.Point(position.x, position.y));
    x = local.x;
    y = local.y;
    rotation = body.value.getAngle() / Math.PI * 180.0;
  }
}
