package starline.ui.button {
	
	import flash.display.*;	
	
	import starline.ui.simple.DrawRect;


	// http://starline-studio.com
	// Guzhva Andrey
	// 22.12.2010
	
	public class CustomSimpleButton extends SimpleButton {
		
		private var upColor:uint   = 0x009900;
		private var overColor:uint = 0x03B803;
		private var downColor:uint = 0x03B803;
		private var w:uint;
		private var h:uint;

		public function CustomSimpleButton(w:uint = 30, h:uint = 30) {
			this.w = w;
			this.h = h;
			downState      = new DrawRect(downColor, w, h);
			overState      = new DrawRect(overColor, w, h);
			upState        = new DrawRect(upColor, w, h);
			hitTestState   = new DrawRect(upColor, w, h);
			useHandCursor  = true;
		}
	}
}