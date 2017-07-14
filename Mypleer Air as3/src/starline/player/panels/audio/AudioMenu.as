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
	 * ...
	 * @author Andrey Guzhva
	 */
	
	 public class AudioMenu extends Sprite {
			 
		private var _parent:*;
		private var _root:*;
		// Other Vars
		public var gid:uint;
		public var fid:uint;
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
			addItem("Друг", 100, 5, 'friend');
			addItem("Группа", 200, 5, 'group');
			addItem("Поиск", 505, 5, 'search');
			items[1].visible = false;
			items[2].visible = false;

			addEventListener(Event.ENTER_FRAME, searchUpDate);
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
		
			var item:TextMenuButton = new TextMenuButton(label, 14);
			item.id = id;
			item.x = x;
			item.y = y;
			item.panel = panel;
			item.addEventListener( MouseEvent.CLICK, onButClicked );
			addChild(item);
			items.push( item );	
		}
				
		private function onButClicked( e:MouseEvent ):void{
			changePage( e.currentTarget.id);
		}
		public function changePage( page:uint):void {
			last_page = cur_page;
			cur_page = page;
			
			if ( cur_page >= items.length )
				cur_page = items.length - 1;
			if ( cur_page < 0 )
				cur_page = 0;
				
			items[last_page].setSel( false );
			items[cur_page].setSel( true );
			
			switchPanels();
		}
		    
		public function switchPanels():void {
			if (items[cur_page].panel == 'my') {
				_root.loaderBar_spr.visible = true;
				_root.VK.api('audio.get', null, _root.vkApiRequest.fetchUserAudio, _root.vkApiRequest.requestFail);
			}
			if(items[cur_page].panel == 'search'){
				searchFunction();
			}
			if (items[cur_page].panel == 'group'){
				_root.player_mc.getGroupAudio(gid);
			}
			if (items[cur_page].panel == 'friend'){
				_root.player_mc.getFriendAudio(fid);
			}
		}
		///////////////////////////////////////////////////////////////////////////////////////////
		////-------------------------------------------------------------------------- Rendom Round
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
		
		// Поиск
		private function SearchKeyEnter(e:KeyboardEvent):void { 
			if (e.keyCode == 13) { // Enter
				changePage(3);
			}
		}
		private function searchFunction(e:MouseEvent = null):void {
			_parent.search_key = '';
			_root.loaderBar_spr.visible = true;
			_root.VK.api('audio.search',
			{ count:100, q:search_key },
			_root.vkApiRequest.fetchAudioSearch,
			_root.vkApiRequest.requestFail
			);
		}
		private function searchUpDate(e:Event = null):void {
			if (search_bg.in_txt.text.toLowerCase() != search_key) {
					search_key = search_bg.in_txt.text.toLowerCase();
					_parent.audioListSortByKey(search_key);
			}
		}
	}

}