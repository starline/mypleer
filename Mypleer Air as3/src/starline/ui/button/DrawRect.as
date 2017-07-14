package starline.ui.button {
	
	import flash.display.Shape;

	// http://starline-studio.com
	// Guzhva Andrey
	// 22.12.2010
	
	public class DrawRect extends Shape {
		private var bgColor:uint;
		private var w:uint;
		private var h:uint;
		private var a:Number;

		public function DrawRect(bgColor:uint, w:uint, h:uint, a:Number = 1) {
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