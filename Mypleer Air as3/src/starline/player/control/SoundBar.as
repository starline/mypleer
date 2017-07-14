package starline.player.control {
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import starline.ui.button.DrawRect;

	// http://starline-studio.com
	// Guzhva Andrey
	// 21.12.2010
	
	public class SoundBar extends Sprite {
		
		private var _parent:*;
		private var _root:*;

		// interface
		public var faderBar_mc:Sprite = new Sprite();
		public var progressBar_mc:Sprite = new Sprite();
		public var bg_mc:Sprite = new Sprite();
		public var loadBar_mc:Sprite = new Sprite();
		public var hitBar_mc:Sprite = new Sprite();
		// Vars
		private var _width:int;
		private var _height:int;
		// Flag
		private var drag_flag:Boolean = false;
		
		public function SoundBar(_root:*, _parent:*, _width:int, _height:int) {
			this._width = _width;
			this._height = _height;
			this._parent = _parent;
			this._root = _root;
			createInterface();
			loadBar_mc.scaleX = 0;
			faderBar_mc.x = 0;
			hitBar_mc.addEventListener(MouseEvent.MOUSE_DOWN, downHitBar);
			addEventListener(Event.ENTER_FRAME, upDate);
			
			addEventListener( MouseEvent.ROLL_OVER, onOver );
			addEventListener( MouseEvent.ROLL_OUT, onOut );
		}
		private function upDate(e:Event):void {
			if (!drag_flag && _parent.playerSound.play_flag) {
				faderBar_mc.x = loadBar_mc.width * _parent.playerSound.sndChannel.position / _parent.playerSound.snd.length;
			}
			progressBar_mc.width = faderBar_mc.x;
			hitBar_mc.width = loadBar_mc.width;
		}
		public function setPosition(scale:Number):void {
			loadBar_mc.scaleX = scale;
		}
		// --------------------------------------------------------------------------- hitBar_mc drag
		private function downHitBar(e:MouseEvent):void {
			drag_flag = true;
			startDragFaderBar();
			_root.addEventListener(MouseEvent.MOUSE_UP, upHitBar);
		}
		private function upHitBar(e:MouseEvent):void {
			_root.removeEventListener(MouseEvent.MOUSE_UP, upHitBar);
			stopDragFaderBar();
		}
		private function startDragFaderBar():void {
			faderBar_mc.x = this.mouseX;
			var rectangle:Rectangle = new Rectangle(0, 0, loadBar_mc.width, 0);
			faderBar_mc.startDrag(false, rectangle);
		}
		private function stopDragFaderBar():void {
			_parent.playerSound.onPosition(faderBar_mc.x / loadBar_mc.width);
			drag_flag = false;
			faderBar_mc.stopDrag();
		}
		public function onCross(direction:String):void {
			if (direction == 'l') 
				faderBar_mc.x = (faderBar_mc.x - 10 > 0) ? (faderBar_mc.x -10) : 0;
				_parent.playerSound.onPosition(faderBar_mc.x / loadBar_mc.width);	
			if (direction == 'r')
				faderBar_mc.x = (faderBar_mc.x + 10 > loadBar_mc.width) ? loadBar_mc.width : faderBar_mc.x + 10;
				_parent.playerSound.onPosition(faderBar_mc.x / loadBar_mc.width);	
		}
		// --------------------------------------------------------------------------------- Interface
		private function createInterface():void {
			bg_mc.addChild(new DrawRect(0xFFFFFF, _width, _height, 0.05));
			addChild(bg_mc);
			
			loadBar_mc.addChild(new DrawRect(0x0099FF, _width, _height, 0.2));
			addChild(loadBar_mc);
			
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