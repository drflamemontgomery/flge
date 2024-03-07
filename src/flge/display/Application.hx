package flge.display;

import openfl.display.Sprite;
import openfl.events.Event;

import flge.common.UpdateManager;

/**
 * Base class for creating an FLGE application.
 *
 * This class contains code to setup the update events
 */
class Application extends Sprite {
  
  public function new() {
    super();

    addEventListener(Event.ADDED_TO_STAGE, added);
  }

  private function onExit(e) {
  }
  
  /**
   * The initialization function that runs after the class is setup
   * and added to the stage.
   * Make sure to add the `super.init()` call otherwise the update events
   * will not be setup.
   */
  @:dox(show)
  private function init() {
    stage.application.onExit.add(onExit);

    new UpdateManager();
  }

  private function added(e) {
    removeEventListener(Event.ADDED_TO_STAGE, added);

#if ios
    haxe.Timer.delay(init, 100);
#else
    init();
#end
  }

}
