package flge.display;

import openfl.display.Sprite;
import openfl.events.Event;

import box2d.common.math.B2Vec2;
import box2d.dynamics.B2World;
import box2d.dynamics.B2Body;

import flge.phys.PhysicsManager;
import flge.events.PhysicsEvent;

class  PhysicsSprite extends Sprite {

  var body : cpp.ConstPointer<B2Body>;

  public function new(body:cpp.ConstPointer<B2Body>) {
    super();
    this.body = body;
    addEventListener(Event.ADDED_TO_STAGE, added);
  }

  private function added(e) {
    removeEventListener(Event.ADDED_TO_STAGE, added);
    PhysicsManager.inst.addEventListener(PhysicsEvent.UPDATE, physicsUpdate);
  }

  private function physicsUpdate(e:PhysicsEvent) {
    var position = body.value.getPosition();
    var local = parent.globalToLocal(new openfl.geom.Point(position.x, position.y));
    x = local.x;
    y = local.y;
    rotation = body.value.getAngle() / Math.PI * 180.0;
  }
}
