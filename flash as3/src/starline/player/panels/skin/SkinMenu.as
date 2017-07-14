package starline.player.panels.skin {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.ColorTransform;
	
	import starline.ui.button.TextMenuButton;

	
	/**
	 * ...
	 * @author Andrey Guzhva
	 */
	
	 public class SkinMenu extends Sprite {
		 
		private var _parent:*;
		private var _root:*;
		// Menu
		private var last_item:int = 10;
		private var items:Array = new Array();
		private var cur_page:uint = 0;
		private var last_page:uint = 0;
		// Interface
		private var bg_mc:Sprite = new Sprite();
		
		public function SkinMenu(_root:*, _parent:*):void {
			this._parent = _parent;
			this._root = _root;

			bg_mc.graphics.beginFill(0x000000);
			bg_mc.graphics.drawRoundRect(0, 0, 660, 30, 5);
			bg_mc.graphics.endFill();
			bg_mc.alpha = 0.5;
			addChild(bg_mc);
			
			addItem("Обои", 10, 5, 'wall');
			addItem("Арт", 110, 5, 'art');
			addItem("Анимированные", 200, 5, 'anime');
		}
		
		
		public function addItem(label:String, x:uint, y:uint, panel:* = null ):void {
			var id:uint = items.length;
		
			var item:TextMenuButton = new TextMenuButton(label, 13, x, y);
			item.id = id;
			item.panel = panel;
			item.addEventListener( MouseEvent.CLICK, onButClicked );
			addChild(item);
			items.push( item );	
		}
		
		
		private function onButClicked( e:MouseEvent ):void{
			changePage( e.currentTarget.id);
		}
		
		
		public function changePage( page:uint):void {
			
			_parent._parent.app_settings_arr['skin_page'] = page;
			
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
			_root.MP.api(
				"get_bg",
				{teg: String(items[cur_page].panel) },
				function (data:Object):void {
					_root.loaderBar_spr.visible = false;
					_root.player_mc.skinList_mc.onList(data as Array);
				},
				_root.mpApiRequest.requestFail
			);
			_root.loaderBar_spr.visible = true;
		}
	}
}