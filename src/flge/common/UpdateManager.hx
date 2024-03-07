package flge.common;

import flge.events.UpdateEvent;
import openfl.events.EventDispatcher;

/**
 * An Event Manager class for common update events
 *
 */
class UpdateManager extends EventDispatcher {
 
  /**
   * The current UpdateManager instance
   *
   * Subscribe to the Update Event using
   * `UpdateManager.inst.addEventListener(UpdateEvent.UPDATE, callback)`
   */ 
  public static var inst : UpdateManager;

  private var timer : haxe.Timer;

  /**
   * Create a new UpdateManager instance
   */
  public function new() {
    super();
    inst = this;
    timer = new haxe.Timer(16);
    timer.run = update;
  }

  private function update() {
    Timer.update();
    dispatchEvent(new UpdateEvent(UpdateEvent.UPDATE, flge.Timer.dt));
  }
}
