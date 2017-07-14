package starline.player {
	
	/*
	* Guzhva Andrey
	* http://starline-studio.com
	* 06.01.2011
	* MusicBox player | radio
	*/
	
	public class VkApiRequest {
		
		public var _root:*;

		public function VkApiRequest(_root:*):void {
			this._root = _root;	
		}
		public function fetchAudioAdd(data: Object): void {
			_root.loaderBar_spr.visible = false;
			//data[0];
		}
		public function fetchAudioDelete(data: Object): void {
			_root.loaderBar_spr.visible = false;
			if (data == 1) 
				_root.player_mc.audioList_mc.audioDelete();
			else	
				_root.player_mc.audioList_mc.searchPanel_mc.changePage(0);
		}
		public function fetchUserBalance(data: Object): void {
			_root.loaderBar_spr.visible = false;
			_root.checkBalanse(data);
		}
		public function fetchFriendsProfiles(data: Object): void {
			_root.loaderBar_spr.visible = false;
			_root.player_mc.friendList_mc.onList(data as Array);
		}
		
		public function fetchFriendAudio(data: Object): void {
			_root.loaderBar_spr.visible = false;
			_root.player_mc.audioList_mc.onList(data as Array);
		}
		
		public function fetchGroupAudio(data: Object): void {
			_root.loaderBar_spr.visible = false;
			_root.player_mc.audioList_mc.onList(data as Array);
		}
		
		public function fetchUserProfile(data: Object): void {
			_root.user_profile = data[0];
		}
		
		public function fetchUserFriends(data: Object): void {
			_root.user_friends = data as Array;
		}
		
		public function fetchUserGroupsFull(data: Object): void {
			_root.player_mc.groupList_mc.onList(data as Array);
		}
		
		public function fetchUserAudio(data: Object): void {
			_root.loaderBar_spr.visible = false;
			_root.user_audios = data as Array;
			_root.player_mc.audioList_mc.onList(data as Array);
		}
		
		public function fetchCityById(data: Object): void {
			_root.user_profile.city_name = data[0].name;
		}
		
		public function fetchCountryById(data: Object): void {
			_root.user_profile.country_name = data[0].name;
		}
		
		public function fetchAudioReorder(data: Object): void {
		}
		
		public function fetchAudioSearch(data: Object): void {
			_root.loaderBar_spr.visible = false;
			var arr:Array = data as Array;
			arr.splice(0, 1);
			_root.player_mc.audioList_mc.onList(arr);
		}
		
		public function requestFail(data: Object): void {
			for (var key: String in data[0]) {
				trace(key + "=" + data[0][key] + "\n");
			}
			//trace("Error: "+data.error_msg+"\n");
		}
	}

}

