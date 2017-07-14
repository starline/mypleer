package starline.player.panels.cabinet {
	
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
	
	 public class CabinetMenu extends Sprite {
		 
		private var _parent:*;
		private var _root:*;
		// Menu
		private var last_item:int = 10;
		private var items:Array = new Array();
		private var cur_page:uint = 0;
		private var last_page:uint = 0;
		// Interface
		private var bg_mc:Sprite = new Sprite();
		
		public function CabinetMenu(_root:*, _parent:*):void {
			this._parent = _parent;
			this._root = _root;

			bg_mc.graphics.beginFill(0x000000);
			bg_mc.graphics.drawRoundRect(0, 0, 660, 30, 5);
			bg_mc.graphics.endFill();
			bg_mc.alpha = 0.5;
			addChild(bg_mc);
			
			addItem("Звезды", 10, 5, _parent.starPanel_mc);
			//addItem("Без рекламы", 100, 5, _parent.adsPanel_mc);
		}
		
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
			items[last_page].panel.visible = false;
			items[cur_page].panel.visible = true;
		}

	}

}