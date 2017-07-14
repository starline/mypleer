package starline.utils{
	
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.events.Event;
 
   /*
	* For AIR aplication
	* Guzhva Andrey
	*/
   
	public final class  Framerate{
		
		private var originalFrameRate:uint; 
		private var standbyFrameRate:uint; 
		public var _stage:Stage; 
     
		public  function Framerate(stage:Stage, standBy:uint):void {
			this._stage = stage;
			this.originalFrameRate = _stage.frameRate;
			this.standbyFrameRate = standBy;
			_stage.addEventListener(Event.ACTIVATE, onActivate);
			_stage.addEventListener(Event.DEACTIVATE, onDeactivate);
		}
     
		private function onActivate(event:Event):void {
			_stage.frameRate = originalFrameRate;
		}
		private function onDeactivate (event:Event):void {
			_stage.frameRate = standbyFrameRate;
		}
   }
}