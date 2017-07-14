package starline.utils{
	
   import flash.desktop.NativeApplication;
   import flash.display.Sprite;
   import flash.events.Event;
 
   /*
	* For AIR aplication
	* Guzhva Andrey
	*/
   
	public class FramerateAir extends Sprite {
		
		public function FramerateAir () {
			init ();
		}
     
		private function init ():void {
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate );
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate );
		}
     
		private function onActivate ($event:Event):void {
			stage.frameRate = 24;
		}
		private function onDeactivate  ($event:Event):void {
			stage.frameRate = 1;
		}
   }
}