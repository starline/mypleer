package starline.player.panels.audio {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.ColorTransform;
	
	import starline.player.components.SearchBg;
	import starline.ui.button.TextMenuButton;
	
	/**
	 * @author Andrey Guzhva
	 * @date 15.10.2012
	 */
	
	 public class AudioMenu extends Sprite {
			 
		private var _parent:*;
		private var _root:*;
		
		// Other Vars
		private var search_key:String;
		private var search_bg:SearchBg;
		
		// Menu
		private var last_item:int = 10;
		public var items:Array = new Array();
		private var cur_page:uint = 0;
		private var last_page:uint = 0;
		
		public function AudioMenu(_root:*, _parent:*):void {
			this._parent = _parent;
			this._root = _root;
			this.search_key = '';
			search_bg = new SearchBg();
			addChild(search_bg);
			
			addItem("Мои", 10, 5, 'my');
			addItem("Друзья", 100, 5, 'friend');
			addItem("Группы", 200, 5, 'group');
			addItem("Поиск", 505, 5, 'search');
			
			search_bg.in_txt.addEventListener(Event.CHANGE, searchUpDate);
			search_bg.in_txt.addEventListener(KeyboardEvent.KEY_DOWN, SearchKeyEnter);
			
			search_bg.rendom_btn.addEventListener(MouseEvent.MOUSE_UP, onRendom);
			search_bg.rendom_btn.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void { _parent._parent.helpWindow_mc.onAction(true, ' Случайный '); } );
			search_bg.rendom_btn.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void { _parent._parent.helpWindow_mc.onAction(false); } );
			search_bg.round_btn.addEventListener(MouseEvent.MOUSE_UP, onRound);
			search_bg.round_btn.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void { _parent._parent.helpWindow_mc.onAction(true, ' Повтор '); } );
			search_bg.round_btn.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void { _parent._parent.helpWindow_mc.onAction(false); } );
		}
		
		
		// Menu
		public function addItem(label:String, x:uint, y:uint, panel:* = null ):void {
			var id:uint = items.length;
		
			var item:TextMenuButton = new TextMenuButton(label, 13, x, y);
			item.id = id;
			item.panel = panel;
			item.addEventListener( MouseEvent.CLICK, onButClicked );
			addChild(item);
			items.push( item );	
		}
		
		
		private function onButClicked(e:MouseEvent):void{
			changePage( e.currentTarget.id);
		}
		
		
		public function changePage(page:uint, without_some_btn:Boolean = true, without_switch:Boolean = false ):void {
			
			if ((page != 1 && page != 2) || !without_some_btn) {
				
				_root.player_mc.app_settings_arr['audio_page'] = page;
				
				last_page = cur_page;
				cur_page = page;
				
				if ( cur_page >= items.length )
					cur_page = items.length - 1;
				if ( cur_page < 0 )
					cur_page = 0;
				
				items[last_page].setSel( false );
				items[cur_page].setSel( true );
			}
			
			if (!without_switch) {
				switchPanels(page);
			}
			
		}
		
		
		
		/**
		 * switchPanels
		 * Включаем выбранную панель
		 */
		public function switchPanels( cur_page:uint ):void {
			
			// My audios
			if (items[cur_page].panel == 'my') {
				_root.loaderBar_spr.visible = true;
				_root.VK.api('audio.get', null, _root.vkApiRequest.fetchUserAudio, _root.vkApiRequest.requestFail);
			}
			
			// Search audios
			if (items[cur_page].panel == 'search'){
				searchFunction();
			}
			
			// Group audios
			if (items[cur_page].panel == 'group'){
				if (_root.player_mc.app_settings_arr['group_comlete'] == 0) { 
					_root.loaderBar_spr.visible = true;
					
					// Выбираем группы пользователя
					// Первый ответ отдает максимум 500 групп
					_root.VK.api(
						'groups.get',
						{ extended: 1}, 
						function (data:Object):void {
							
							// Кол-во групп 
							var groupCount:Number = data[0];
							data.shift();
							
							_root.loaderBar_spr.visible = false;
							_root.player_mc.app_settings_arr['group_comlete'] = 1;
							_root.player_mc.groupList_mc.onList(data as Array);
						},
						_root.vkApiRequest.requestFail
					);
				}
				_root.player_mc.friendList_mc.visible = false;
				_root.player_mc.groupList_mc.visible = true;
			}
			
			// Friends audios
			if (items[cur_page].panel == 'friend'){
				if (_root.player_mc.app_settings_arr['friend_comlete'] == 0) { 
					_root.loaderBar_spr.visible = true;
					_root.VK.api('getFriends', null, _root.vkApiRequest.fetchUserFriends, _root.vkApiRequest.requestFail);
				}
				_root.player_mc.groupList_mc.visible = false;
				_root.player_mc.friendList_mc.visible = true;
			}
			
		}
		
		
		
		/**
		 * getGroupAudio
		 */
		public function getGroupAudio(gid:uint):void {
			_root.loaderBar_spr.visible = true;
			_root.VK.api(
				'audio.get',
				{gid: gid},
				function(data:Object):void {
					_root.loaderBar_spr.visible = false;
					_root.player_mc.app_settings_arr['myaudio_comlete'] = 1;
					_root.player_mc.audioList_mc.onList(data as Array);
				},
				_root.vkApiRequest.requestFail
			);
		}
		
		
		/**
		 * getFriendAudio
		 */
		public function getFriendAudio(fid:uint):void {
			_root.loaderBar_spr.visible = true;
			_root.VK.api(
				'audio.get',
				{uid: fid },
				function(data:Object):void {
					_root.loaderBar_spr.visible = false;
					_root.player_mc.app_settings_arr['myaudio_comlete'] = 1;
					_root.player_mc.audioList_mc.onList(data as Array);
				},
				_root.vkApiRequest.requestFail
			);
		}
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////
		////------------------------------------------------------------------------ Rendom & Round
		///////////////////////////////////////////////////////////////////////////////////////////
		private function onRendom(e:MouseEvent = null):void {
			_parent.random_flag = (_parent.random_flag)?false:true;
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = (_parent.random_flag)?0x0099FF:0x666666;
			search_bg.rendom_btn.bg.transform.colorTransform = colorTransform;
		}
		
		
		private function onRound(e:MouseEvent = null):void {
			_parent.round_flag = (_parent.round_flag)?false:true;
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = (_parent.round_flag)?0x0099FF:0x666666;
			search_bg.round_btn.bg.transform.colorTransform = colorTransform;
		}
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////
		////--------------------------------------------------------------------------------- Поиск
		///////////////////////////////////////////////////////////////////////////////////////////
		public function searchByArtst(artist:String):void {
			search_key = artist;
			search_bg.in_txt.text = artist;
			changePage(3);
		}
		
		
		private function SearchKeyEnter(e:KeyboardEvent):void { 
			if (e.keyCode == 13) { // Enter
				changePage(3);
			}
		}
		
		
		private function searchFunction(e:MouseEvent = null):void {
			_parent.search_key = '';
			_root.loaderBar_spr.visible = true;
			
			_root.VK.api('audio.search', { count:200, q:search_key }, _root.vkApiRequest.fetchAudioSearch, _root.vkApiRequest.requestFail);
		}
		
		
		private function searchUpDate(e:Event = null):void {
			if (search_bg.in_txt.text.toLowerCase() != search_key) {
				search_key = search_bg.in_txt.text.toLowerCase();
				_parent.audioListSortByKey(search_key);
			}
		}
	}
}