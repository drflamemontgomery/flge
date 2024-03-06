package flge.debug;

import flge.phys.PhysicsManager;
import flge.events.PhysicsEvent;

import openfl.display.Sprite;
import openfl.display.Graphics;

import box2d.common.B2Draw;
import box2d.common.math.B2Transform;
import box2d.common.math.B2Vec2;
import box2d.dynamics.B2World;
import box2d.dynamics.B2Fixture;

class DebugDraw extends Sprite {

  private var __internal : DebugDrawInternal;
  public var flags(get, set) : Int;

  inline function get_flags() {
    return __internal.flags;
  }

  inline function set_flags(v) {
    return __internal.flags = v;
  }

  public function new() {
    super();
    __internal = new DebugDrawInternal(graphics);
    PhysicsManager.inst.addEventListener(PhysicsEvent.UPDATE, drawEvent);
  }
  
  private function drawEvent(e:PhysicsEvent) {
    graphics.clear();
    if(e.world == null) return;
    __internal.debugDraw(e.world); 
  }
}

private class DebugDrawInternal extends B2Draw {

  private var ppm(get, never):Int;
  inline function get_ppm() { return PhysicsManager.PPM; }
  
  private var graphics : Graphics;

  public function new(graphics:Graphics) {
    super();
    this.graphics = graphics;
  }

  override function drawCircle(center:B2Vec2, radius:Float, color:Int) {
    graphics.lineStyle(1.0, color, 1.0);
    graphics.drawCircle(center.x*ppm, center.y*ppm, radius*ppm);
  }

  override function drawSolidCircle(center:B2Vec2, radius:Float, axis:B2Vec2, color:Int) {
    graphics.beginFill(Std.int(color/2), 0.5);
    drawCircle(center, radius, color);
    graphics.endFill();

    graphics.lineStyle(1.0, color, 1.0);
    graphics.moveTo(center.x*ppm, center.y*ppm);
    center.x *= ppm;
    center.y *= ppm;
    untyped __cpp__("b2Vec2 p = {0} + {1} * {2}", center, radius*ppm, axis);
    graphics.lineTo(untyped __cpp__("p.x"), untyped __cpp__("p.y"));
  }

  override function drawPolygon(vertices:cpp.Pointer<B2Vec2>, vertexCount:Int, color:Int) {
    graphics.lineStyle(1.0, color, 1.0);
    graphics.moveTo(vertices.at(0).x*ppm, vertices.at(0).y*ppm);
    for(i in 0...vertexCount) {
      var index = (i+1)%vertexCount;
      graphics.lineTo(vertices.at(index).x*ppm, vertices.at(index).y*ppm);
    }
  }

  override function drawSolidPolygon(vertices:cpp.Pointer<B2Vec2>, vertexCount:Int, color:Int) {
    graphics.beginFill(Std.int(color/2), 0.5);
    drawPolygon(vertices, vertexCount, color);
    graphics.endFill();
  }

  override function drawSegment(p1:B2Vec2, p2:B2Vec2, color:Int) {
    graphics.lineStyle(1.0, color, 1.0);
    graphics.moveTo(p1.x*ppm, p1.y*ppm);
    graphics.lineTo(p2.x, p2.y*ppm);
  }

  override function drawPoint(p:B2Vec2, size:Float, color:Int) {
    graphics.lineStyle(1.0, color, 1.0);
    graphics.beginFill(color, 1.0);
    graphics.drawCircle(p.x*ppm, p.y*ppm, size*0.5);
    graphics.endFill();
  }

}
