package starline.player.control {
	
	import flash.display.*;
	
	import starline.ui.button.DrawRect;
	import starline.player.components.ControlPlayer;


	// http://starline-studio.com
	// Guzhva Andrey
	// 22.12.2010
	
	public class PlayButton extends SimpleButton {
		
		private var upColor:uint   = 0xFFCC00;
		private var skin:ControlPlayer = new ControlPlayer();

		public function PlayButton() {
			downState      = skin.play_down;
			overState      = skin.play_down;
			upState        = skin.play_up;
			hitTestState   = new DrawRect(upColor, 75, 75);
			useHandCursor  = true;
		}
	}
}