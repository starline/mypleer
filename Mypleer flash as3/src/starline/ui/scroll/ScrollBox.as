package starline.ui.scroll {

	import flash.display.*;
	import flash.events.*;
	import Math;
	import flash.geom.Rectangle; 
	
	import starline.ui.simple.DrawRect;
	import starline.ui.button.CustomSimpleButton;
	import starline.utils.MouseWheel;

	
	/*
	* Guzhva Andrey
	* http://starline-studio.com
	* 06.01.2011
	* MusicBox player | radio
	*/

	public class ScrollBox extends Sprite {
		
		public var wrapper:*;
		
		public var select_position:Sprite = new Sprite();
		public var scroll_bg:Sprite = new Sprite();
		public var scroll_bar:Sprite = new Sprite();
		public var scroll_content:Sprite = new Sprite();

		public var wheelStep:int;
		public var scrollStep:int;
		private var scrollBoxHeight:uint;
		private var scrollBoxWidth:uint;
		private var contentHeight:uint;;
		private var scrollHeight:Number;
		private var scrollBarHeight:Number;
		
		public function ScrollBox(wrapper:*, _width:int, _height:int):void {
			// Start setting
			this.wrapper = wrapper;
			this.scrollBoxHeight = _height;
			this.scrollBoxWidth = _width;
			
			// Listeners
			addEventListener(MouseEvent.MOUSE_WHEEL, wheel);
			addEventListener(Event.ENTER_FRAME, scrollupdate);
			addEventListener( MouseEvent.ROLL_OVER, onOver );
			addEventListener( MouseEvent.ROLL_OUT, onOut );
			scroll_bar.addEventListener(MouseEvent.MOUSE_DOWN, MouseDown);
			// Отображаем интерфейс
			createInterface();
		}
		
		public function contentupdate(target:* , scrollStep:int = 1):void {
			if (scroll_content.numChildren > 0) {scroll_content.removeChildAt(0);}
			scroll_content.addChild(target);
			
			this.contentHeight = scroll_content.height;
			this.wheelStep = (scrollStep != 1)?scrollStep:32;
			this.scrollStep = scrollStep;
			scrollBarHeight = scrollBoxHeight < contentHeight ? scrollBoxHeight / contentHeight * scrollBoxHeight : scrollBoxHeight;
			scroll_bar.height = scrollBarHeight;
			scroll_bar.y = 0;
			this.scrollHeight = scrollBoxHeight - scrollBarHeight;
			scroll_bar.visible = scrollBoxHeight < contentHeight ? (true) : (false);
			scroll_bg.visible = scrollBoxHeight < contentHeight ? (true) : (false);
			select_position.visible = scrollBoxHeight < contentHeight ? (true) : (false);
		}
		
		private function scrollupdate(e:Event):void {
				var newY:Number = scroll_bar.y  / scrollBarHeight * scrollBoxHeight;
				newY = Math.round(newY / scrollStep) * scrollStep;
				scroll_content.y = -newY;
		}
		private function wheel(event:MouseEvent):void {
			scrollWhell(event.delta);
		}
		public function scrollWhell(delta:Number):void {
			var step:int = (delta < 0) ? wheelStep : -wheelStep;
			var new_y:int = Math.round(scroll_bar.y + step * scrollBoxHeight / contentHeight);
			if (step > 0)
				scroll_bar.y = (new_y > scrollHeight)? scrollHeight : new_y;
			if (step < 0)
				scroll_bar.y = (new_y < 0)? 0 : new_y;
		}
		private function MouseDown(e:MouseEvent):void {
			startDrag_function();
			wrapper.addEventListener(MouseEvent.MOUSE_UP, MouseUp);
		}
		private function MouseUp(e:MouseEvent):void {
			wrapper.removeEventListener(MouseEvent.MOUSE_UP, MouseUp);
			stopDrag_function();
		}
		private function startDrag_function():void {
			var rectangle:Rectangle = new Rectangle(scrollBoxWidth, 0, 0, scrollHeight + 0.1);
			scroll_bar.startDrag(false, rectangle);
		}
		private function stopDrag_function():void {
			scroll_bar.stopDrag();
		}
		//////////////////////////////////////////////////////////////////////////////////////////
		////--------------------------------------------------------------------------- MouseWhell
		//////////////////////////////////////////////////////////////////////////////////////////
		private function onOver( e:MouseEvent ):void{
			if ( e.target == this){
				MouseWheel.capture();
			}
		}
		private function onOut( e:MouseEvent ):void{
			if ( e.target == this && !mouseInside() ){
				MouseWheel.release();
			}
		}
		private function mouseInside():Boolean{
			return mouseX > 0  &&  mouseX < width  &&  mouseY > 0  &&  mouseY < height;
		}
		// -------------------------------------------------------------------- Select position
		public function playPosition(position:int):void {
			select_position.visible = true;
			select_position.y = position * scrollBoxHeight / contentHeight;
		}
		//////////////////////////////////////////////////////////////////////////////////
		//// ------------------------------------------------------------------- Интерфейс
		//////////////////////////////////////////////////////////////////////////////////
		private function createInterface():void {
			addChild(scroll_content);
			// scroll_bg
			scroll_bg.addChild(new DrawRect(0xFFFFFF, 20, 20));
			scroll_bg.alpha = 0.3;
			scroll_bg.x = scrollBoxWidth;
			scroll_bg.height = scrollBoxHeight;
			addChild(scroll_bg);
			// select_position
			select_position.addChild(new DrawRect(0x0099FF, 20, 5));
			select_position.x = scrollBoxWidth;
			addChild(select_position);
			// scroll_bar
			var bsb:Shape = new Shape();
			bsb.graphics.beginFill(0xFFFFFF);
			bsb.graphics.drawRect(10, 0, 10, 20);
			bsb.alpha = 0.3;
			var sbtn:CustomSimpleButton = new CustomSimpleButton(20, 20);
			scroll_bar.addChild(sbtn);
			scroll_bar.addChild(bsb);
			scroll_bar.x = scrollBoxWidth;
			this.scrollHeight = scrollBoxWidth - scroll_bar.height;
			addChild(scroll_bar);
			// Set Mask
			var square:DrawRect = new DrawRect(0x000000, scrollBoxWidth, scrollBoxHeight);
			addChild(square);
			scroll_content.mask = square;
			// hit zone
			var hit_zone:Sprite = new Sprite();
			hit_zone.graphics.beginFill(0x000000);
			hit_zone.graphics.drawRect(0, 0, this.width, this.height);
			hit_zone.alpha = 0;
			addChildAt(hit_zone, 0);
		}
	}
}