package starline.player {
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.*;
	import flash.utils.Timer;
	import vk.gui.Box;
	
	/**
	* @author Guzhva Andrey
	* @site aguzhva.com
	* @date 06.01.2011
	* @project MusicBox player | radio
	*/
	
	public class VkApiRequest {
		
		public var _root:*;
		
		// Friend
		public var friendProfile_arr:Array = new Array();
		public var friendUid_arr:Array = new Array();
		public var count_fr:int;
		public var i_fr:int;
		public var friends_string:String;

		
		public function VkApiRequest(_root:*):void {
			this._root = _root;	
		}
		
		
		
		/////////////////////////////////////////////////////////////////
		////------------------------------------------------------- Audio
		/////////////////////////////////////////////////////////////////
		public function fetchUserAudio(data: Object): void {
			_root.loaderBar_spr.visible = false;
			_root.player_mc.app_settings_arr['myaudio_comlete'] = 1;
			_root.player_mc.audioList_mc.onList(data as Array);
		}
		
		
		public function fetchAudioReorder(data: Object): void {
		}
		
		
		public function fetchAudioAdd(data: Object): void {
			_root.loaderBar_spr.visible = false;
			_root.player_mc.audioList_mc.audioAdd();
		}
		
		
		public function fetchAudioDelete(data: Object): void {
			_root.loaderBar_spr.visible = false;
			if (data == 1){ 
				_root.player_mc.audioList_mc.audioDelete();
			}else{	
				_root.player_mc.audioList_mc.searchPanel_mc.changePage(0);
			}
		}
		
		
		
		///////////////////////////////////////////////////////////////////
		////------------------------------------------------------- Friends
		///////////////////////////////////////////////////////////////////
		public function fetchUserFriends(data: Object): void {
			friendUid_arr = data as Array;
			count_fr = Math.ceil(friendUid_arr.length / 1000);
			i_fr = 0;
			fetchFriendsProfiles();
		}
		
		
		public function fetchFriendsProfiles(data: Object = null): void {
			if (data) {
				var add_arr:Array = data as Array;
				for (var i:int = 0; i < add_arr.length; ++i) {
					friendProfile_arr.push(add_arr[i]);
				}
			}
			
			if (i_fr < count_fr) {
				friends_string = [friendUid_arr.slice(i_fr*1000, (i_fr+1) * 1000)].toString();
				_root.VK.api('getProfiles', {uids:friends_string, fields:"uid,first_name,last_name,sex"}, fetchFriendsProfiles, requestFail);
				i_fr++;
			}else {
				_root.loaderBar_spr.visible = false;
				_root.player_mc.app_settings_arr['friend_comlete'] = 1;
				_root.player_mc.friendList_mc.onList(friendProfile_arr);	
			}
		}
		
		
		
		///////////////////////////////////////////////////////////////////
		////-------------------------------------------------------- Search
		///////////////////////////////////////////////////////////////////
		public function fetchAudioSearch(data: Object): void {
			_root.loaderBar_spr.visible = false;
			var search_arr:Array = data as Array;
			var search_count:* = search_arr[0];
			search_arr.splice(0, 1);
			search_arr.sortOn('title');
			for (var i:int = 0; i < search_arr.length; i++)
				for (var j:int = i + 1; j < search_arr.length;)
					if (search_arr[i].title.toLowerCase() == search_arr[j].title.toLowerCase() && search_arr[i].duration == search_arr[j].duration) search_arr.splice(j, 1);
					else break;
					
			search_arr.sortOn('artist');		
			_root.player_mc.audioList_mc.onList(search_arr);
		}
		
		
		
		////////////////////////////////////////////////////////////////////
		////---------------------------------------------------------- Error
		////////////////////////////////////////////////////////////////////
		public function requestFail(data: String): void {
			_root.loaderBar_spr.visible = false;
			
			_root.MP.api(
				'save_error',
				{ error: _root.APP_TYPE + "." + _root.APP_VERSION + "." + data },
				function():void { },
				_root.mpApiRequest.requestFail
			);
			
			if (data == "9" || data == "6") {
				var popUp1_mc:Box = new Box(
					"Что-то пошло не так... Такое бывает.",
					"Сайт Vkontakte.ru cчитает, что вы слишком активны," + 
					" поэтому ограничил ваши действия." + 
					" Это ещё может быть связано с низким рейтингом вашей страницы." +
					" Повысьте рейтинг, заполнив больше информации о себе, или пройдите валидацию через смс." + 
					" Приятного прослушивания.",
					200,
					600,
					["Закрыть"] 
				);
				popUp1_mc.setVisible(true);
				_root.addChild(popUp1_mc);
			}else{
				var popUp2_mc:Box = new Box( 
					"Что-то пошло не так... Такое бывает.",
					"Не переживайте, это временный сбой сервера Vkontakte.ru." + 
					" Он мог возникнуть из-за плохого интернет соединения или перегрузке сервера." + 
					" Убедитесь, что ваш провайдер предоставляет качественные услуги." +
					" Данные об ошибке получены и я уже работаю над проблемой." + 
					" Ваше последнее действие скорее всего не сохранено, поэтому повторите попытку. " + 
					" Советую перезагрузить плеер, дабы установить стабильное соединение. " +
					" Приятного прослушивания.",
					200,
					600,
					["Перезагрузить плеер", "Закрыть"]
				);
				popUp2_mc.addEventListener( Event.SELECT, onBoxButtonClicked );
				popUp2_mc.setVisible(true);
				_root.addChild(popUp2_mc);
			}
		}
		
		
		private function onBoxButtonClicked( e:Event ):void{
            if ((e.target.buttonClickedIndex) == 0) {
                navigateToURL( new URLRequest('http://mypleer.com'), "_blank" );
            }
		}
	}
}