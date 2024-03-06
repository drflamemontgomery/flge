package flge.display;

import openfl.display.Sprite;
import openfl.events.Event;

import flge.common.UpdateManager;

class Application extends Sprite {
  
  public function new() {
    super();

    addEventListener(Event.ADDED_TO_STAGE, added);
  }

  private function onExit(e) {
  }

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
