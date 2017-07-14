package starline.ui.simple {
	
	import flash.display.Sprite;

	// http://starline-studio.com
	// Guzhva Andrey
	// 22.12.2010
	
	public class DrawRect extends Sprite {
		private var bgColor:uint;
		private var w:uint;
		private var h:uint;
		private var a:Number;

		public function DrawRect(bgColor:uint = 0x000000, w:uint = 0, h:uint = 0, a:Number = 1) {
			this.bgColor 	= bgColor;
			this.w    		= w;
			this.h    		= h;
			this.a			= a;
			draw();
		}

		private function draw():void {
			graphics.beginFill(bgColor, a);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
		}
	}
}