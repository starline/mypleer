package starline.player.control {
	
	import flash.display.*;
	
	import starline.ui.simple.DrawRect;
	import starline.player.components.ControlPlayer;


	// http://starline-studio.com
	// Guzhva Andrey
	// 22.12.2010
	
	public class PouseButton extends SimpleButton {
		
		private var upColor:uint   = 0xFFCC00;
		private var skin:ControlPlayer = new ControlPlayer();

		public function PouseButton() {
			downState      = skin.pouse_down;
			overState      = skin.pouse_down;
			upState        = skin.pouse_up;
			hitTestState   = new DrawRect(upColor, 75, 75);
			useHandCursor  = true;
		}
	}
}