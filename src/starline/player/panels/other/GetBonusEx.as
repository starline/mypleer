package starline.player.panels.other {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import starline.player.components.GetBonus;

	/**
	 * @author 	Guzhva Andrey (http://aguzhva.com)
	 * @date 	18.02.2013
	 */
	
	public class GetBonusEx extends GetBonus {
		
		private var _player:*;
		
		public function GetBonusEx(player:Sprite, data:*) {
			
			this._player = player;
			
			bonusCount.text = data.bonus_star;
			friendsCount.text = data.app_friends_count;
			
			addFriendsBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				_player.onAddFriend();
			});
        }
	}
}