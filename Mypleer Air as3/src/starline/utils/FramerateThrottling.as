package starline.utils{
	
   import flash.desktop.NativeApplication;
   import flash.display.Sprite;
   import flash.events.Event;
 
   /*For AIR aplication
	* Guzhva Andrey
	*/
   
	public class FramerateThrottling extends Sprite {
		
		public function Application ():void {
			__init ();
		}
     
		private function __init ():void {
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, __activate__);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, __deactivate__);
		}
     
		private function __activate__($event:Event):void {
			stage.frameRate = 24;
		}
		private function __deactivate__ ($event:Event):void {
			stage.frameRate = 1;
		}
   }
}