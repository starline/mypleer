package starline.ui.simple {
	
	import flash.display.Sprite;

	// http://starline-studio.com
	// Guzhva Andrey
	// 22.12.2010
	
	public class DrawRoundRect extends Sprite {
		private var color:uint;
		private var w:uint;
		private var h:uint;
		private var r:uint;
		private var a:Number;

		public function DrawRoundRect(color:uint, w:uint, h:uint, r:uint, a:Number = 1) {
			this.color 	= color;
			this.w    		= w;
			this.h    		= h;
			this.r    		= r;
			this.a			= a;
			draw();
		}

		private function draw():void {
			graphics.beginFill(color, a);
			graphics.drawRoundRect(0, 0, w, h, r);
			graphics.endFill();
		}
	}
}