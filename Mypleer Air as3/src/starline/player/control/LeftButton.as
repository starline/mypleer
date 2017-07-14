package starline.player.control {
	
	import flash.display.*;
	
	import starline.ui.button.DrawRect;
	import starline.player.components.ControlPlayer;


	// http://starline-studio.com
	// Guzhva Andrey
	// 22.12.2010
	
	public class LeftButton extends SimpleButton {
		
		private var upColor:uint   = 0xFFCC00;
		private var skin:ControlPlayer = new ControlPlayer();

		public function LeftButton() {
			downState      = skin.left_down;
			overState      = skin.left_down;
			upState        = skin.left_up;
			hitTestState   = new DrawRect(upColor, 42, 42);
			useHandCursor  = true;
		}
	}
}