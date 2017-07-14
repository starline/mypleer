package starline.player.control {
	
	import flash.display.*;
	
	import starline.ui.simple.DrawRect;
	import starline.player.components.ControlPlayer;


	// http://starline-studio.com
	// Guzhva Andrey
	// 22.12.2010
	
	public class RightButton extends SimpleButton {
		
		private var upColor:uint   = 0xFFCC00;
		private var skin:ControlPlayer = new ControlPlayer();

		public function RightButton() {
			downState      = skin.right_down;
			overState      = skin.right_down;
			upState        = skin.right_up;
			hitTestState   = new DrawRect(upColor, 42, 42);
			useHandCursor  = true;
		}
	}
}