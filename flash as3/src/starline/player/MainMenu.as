package starline.player {
	
	import flash.display.*;
	import flash.events.*;
	import starline.utils.external.External;
	
	import starline.ui.button.SpriteMenuButton;
	
	/**
	 * @author Andrey Guzhva
	 * @date 15.10.2012
	 */
	
	public class MainMenu extends Sprite {
		
		public var _parent:* = null;
		public var _root:* = null;
		
		private var last_item:int = 10;
		private var items:Array = new Array();
		private var cur_page:uint = 0;
		private var last_page:uint = 0;
		
		public function MainMenu(_root:*, _parent:*):void {
			
			this._parent = _parent;
			this._root = _root;
			
			addItem("аудиозаписи", 255, 0, 0, _parent.audioList_mc);
			addItem("радиостанции", 255, 257, 0, _parent.radioList_mc);
			addItem("оформление", 165, 514, 0, _parent.skinList_mc);
			addItem("кабинет", 120, 681, 0, _parent.cabinetList_mc);
			
		}
		
		
		public function addItem(label:String, width:uint, x:uint, y:uint, panel:Sprite = null ):void {
			var id:uint = items.length;
			
			var item:SpriteMenuButton = new SpriteMenuButton(label, width);
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
		
		
		public function changePage( page:uint, save_flag:Boolean = true):void {
			
			// Save cur page
			if (page == 0 || page == 1 && save_flag) {
				_root.MP.api("save_cur_page", { cur_page:page }, function():void{}, _root.mpApiRequest.requestFail);
			}
			
			// Включение странцы раздела
			if (page == 0 && _parent.app_settings_arr['myaudio_comlete'] == 0) {
				_parent.audioList_mc.menu_mc.changePage(_parent.app_settings_arr['audio_page']);
			}
			if (page == 1) { _parent.radioList_mc.menu_mc.changePage(_parent.app_settings_arr['radio_page']); }
			if (page == 2) { _parent.skinList_mc.menu_mc.changePage(_parent.app_settings_arr['skin_page']); }
			if (page == 3) { _parent.cabinetList_mc.menu_mc.changePage(_parent.app_settings_arr['cabinet_page']); }
			
			
			_parent.app_settings_arr['main_page'] = page;
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
			items[last_page].panel.visible = false;
			items[cur_page].panel.visible = true;
		}
		
		
		
		///////////////////////////////////////////////////////////////////////
		////------------------------------------------------------------- Other
		///////////////////////////////////////////////////////////////////////
		public function disebleVK():void {
			items[0].alpha = 0.3;	items[0].removeEventListener(MouseEvent.CLICK, onButClicked);	items[0].addEventListener( MouseEvent.CLICK, onVK );
			items[2].alpha = 0.3;	items[2].removeEventListener(MouseEvent.CLICK, onButClicked);	items[2].addEventListener( MouseEvent.CLICK, onVK );
			items[3].alpha = 0.3;	items[3].removeEventListener(MouseEvent.CLICK, onButClicked);	items[3].addEventListener( MouseEvent.CLICK, onVK );
			items[4].alpha = 0.3;	items[4].removeEventListener(MouseEvent.CLICK, onButClicked);	items[4].addEventListener( MouseEvent.CLICK, onVK );
			items[5].alpha = 0.3;	items[5].removeEventListener(MouseEvent.CLICK, onButClicked);	items[5].addEventListener( MouseEvent.CLICK, onVK );
		}
		
		/**
		 * onVK
		 */
		private function onVK(e:MouseEvent):void {
			External.call('vkAuth');
		}
	}
}