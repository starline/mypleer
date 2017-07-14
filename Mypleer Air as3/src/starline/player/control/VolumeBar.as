package starline.player.control {
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	
	import starline.ui.button.DrawRect;

	/*
	* Guzhva Andrey
	* http://starline-studio.com
	* 09.01.2011
	* MusicBox player | radio
	*/
	
	public class VolumeBar extends Sprite {
		
		private var _parent:*;
		private var _root:*;

		// interface
		public var faderBar_mc:Sprite = new Sprite();
		public var progressBar_mc:Sprite = new Sprite();
		public var bg_mc:Sprite = new Sprite();
		public var hitBar_mc:Sprite = new Sprite();
		// Vars
		private var _width:int;
		private var _height:int;
		private var drag_flag:Boolean;
		private var volume:Number;
		private var sndMixerTransform:SoundTransform = new SoundTransform(1, 0);
		
		public function VolumeBar(_root:*, _parent:*, _width:int, _height:int) {
			this._width = _width;
			this._height = _height;
			this._parent = _parent;
			this._root = _root;
			createInterface();
			// Listener
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			hitBar_mc.addEventListener(MouseEvent.MOUSE_DOWN, downHitBar);
			addEventListener(Event.ENTER_FRAME, upDate);      
			addEventListener( MouseEvent.ROLL_OVER, onOver );
			addEventListener( MouseEvent.ROLL_OUT, onOut );
		}
		private function upDate(e:Event):void {
			progressBar_mc.width = faderBar_mc.x;
			if (drag_flag) {
				volume = faderBar_mc.x / _width;
				sndMixerTransform.volume = volume;
				SoundMixer.soundTransform = sndMixerTransform;
			}
		}
		public function setVolume(volume:Number):void {
			faderBar_mc.x  = _width * volume;
			volume = faderBar_mc.x / _width;
			sndMixerTransform.volume = volume;
			SoundMixer.soundTransform = sndMixerTransform;
		}
		private function mouseWheel(event:MouseEvent):void {
			var delta:int = event.delta;
			
			if (delta > 0)
				faderBar_mc.x  = (faderBar_mc.x + delta > _width)? _width : faderBar_mc.x + delta;
			if (delta < 0)
				faderBar_mc.x  = (faderBar_mc.x + delta < 0)? 0 : faderBar_mc.x + delta;
			
			volume = faderBar_mc.x / _width;
			sndMixerTransform.volume = volume;
			SoundMixer.soundTransform = sndMixerTransform;
		}
		// --------------------------------------------------------------------------- hitBar_mc drag
		private function downHitBar(e:MouseEvent):void {
			startDragFaderBar();
			_root.addEventListener(MouseEvent.MOUSE_UP, upVolumeHitBar);
		}
		private function upVolumeHitBar(e:MouseEvent):void {
			_root.removeEventListener(MouseEvent.MOUSE_UP, upVolumeHitBar);
			stopDragFaderBar();
		}
		private function startDragFaderBar():void {
			drag_flag = true;
			faderBar_mc.x = this.mouseX;
			var rectangle:Rectangle = new Rectangle(0, 0, _width, 0);
			faderBar_mc.startDrag(false, rectangle);
		}
		private function stopDragFaderBar():void {
			drag_flag = false;
			faderBar_mc.stopDrag();
		}
		
		// --------------------------------------------------------------------------------- Interface
		private function createInterface():void {
			bg_mc.addChild(new DrawRect(0xFFFFFF, _width, _height, 0.05));
			addChild(bg_mc);
			
			progressBar_mc.addChild(new DrawRect(0x016EB6, _width, _height)); 
			progressBar_mc.addChild(new DrawRect(0xFFFFFF, _width, _height/2, 0.2));
			addChild(progressBar_mc);
			
			var bar:DrawRect = new DrawRect(0xFFFFFF, 5, _height);
			bar.x = -bar.width/2;
			faderBar_mc.addChild(bar);
			addChild(faderBar_mc);
			
			hitBar_mc.addChild(new DrawRect(0xFFFFFF, _width, _height, 0));
			hitBar_mc.buttonMode = true;
			addChild(hitBar_mc);
		}
		//////////////////////////////////////////////////////////////////////////////////////////////////
		/////-------------------------------------------------------------------------- MouseWheel.capture
		//////////////////////////////////////////////////////////////////////////////////////////////////
		private function onOver( e:MouseEvent ):void{
			if ( e.target == this){
			}
		}
		private function onOut( e:MouseEvent ):void{
			if ( e.target == this && !mouseInside() ){
			}
		}
		private function mouseInside():Boolean{
			return mouseX > 0  &&  mouseX < width  &&  mouseY > 0  &&  mouseY < height;
		}
	}
}