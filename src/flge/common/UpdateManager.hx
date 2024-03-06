package flge.common;

import flge.events.UpdateEvent;
import openfl.events.EventDispatcher;

class UpdateManager extends EventDispatcher {
  
  public static var inst : UpdateManager;

  private var timer : haxe.Timer;

  public function new() {
    super();
    inst = this;
    timer = new haxe.Timer(1000.0/60.0);
    timer.run = update;
  }

  private function update() {
    Timer.update();
    dispatchEvent(new UpdateEvent(UpdateEvent.UPDATE, flge.Timer.dt));
  }
}
