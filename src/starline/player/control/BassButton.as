package starline.player.control {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import starline.player.panels.audio.AudioSoundFx;
	import starline.player.components.BassBtn;

	/**
	 * @author 	Andrey Guzhva (aguzhva.com)
	 * @date	17.02.2013
	 */
	
	public class BassButton extends BassBtn {
		
		private var _player:*;
		
		public function BassButton(player:Sprite) {
			this._player = player;
			
			// Интерфейс
			off_btn.visible = false;
			
			// События
			on_btn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { 
				e.target.visible = false;
				off_btn.visible = true;
				
				_player.snd.filters = [AudioSoundFx.lowpassUp128];
			});
			off_btn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { 
				e.target.visible = false;
				on_btn.visible = true;
				
				_player.snd.filters = [];
			});
			
		}
	}
}