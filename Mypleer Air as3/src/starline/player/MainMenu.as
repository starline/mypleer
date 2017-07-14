package starline.player {
	
	import flash.display.*;
	import flash.events.*;
	
	import starline.ui.button.SpriteMenuButton;
	
	/**
	 * ...
	 * @author Andrey Guzhva
	 */
	
	public class MainMenu extends Sprite {
		
		public var _parent:* = null;
		
		private var last_item:int = 10;
		private var items:Array = new Array();
		private var cur_page:uint = 0;
		private var last_page:uint = 0;
		
		public function MainMenu(_parent:*):void {
			this._parent = _parent;
			
			addItem("АУДИОЗАПИСИ", 156, 0, 0, _parent.audioList_mc);
			addItem("РАДИОСТАНЦИИ", 155, 158, 0, _parent.radioList_mc);
			addItem("ДРУЗЬЯ", 120, 315, 0, _parent.friendList_mc);
			addItem("ГРУППЫ", 120, 437, 0, _parent.groupList_mc);
			addItem("ОФОРМЛЕНИЕ", 120, 559, 0, _parent.skinList_mc);
			addItem("КАБИНЕТ", 120, 681, 0, _parent.cabinetList_mc);
			
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
		public function changePage( page:uint):void {
			if (page == 2) {
				items[3].panel.visible = false;
				items[page].panel.visible = true;
			}else if (page == 3) {
				items[2].panel.visible = false;
				items[page].panel.visible = true;
			}else{
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
		}
		    
		public function switchPanels():void {
			items[2].panel.visible = false;
			items[3].panel.visible = false;
			items[last_page].panel.visible = false;
			items[cur_page].panel.visible = true;
			// Google Analitics
			_parent._root.googleTracker.trackPageview(items[cur_page]._label);
		}
	}

}