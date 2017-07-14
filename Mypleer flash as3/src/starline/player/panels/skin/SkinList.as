package starline.player.panels.skin {
    
	import flash.display.*;
	import flash.events.*;
	
	import starline.ui.simple.DrawRect;
	import starline.ui.scroll.ScrollBox;
	
	/**
	 * @author	Guzhva Andrey (aguzhva.com)
	 * @date	18.02.2013
	 * @private	Mypleer
	 */
	
	public class SkinList extends Sprite {
		
		public var _root:*;
		public var _parent:*;
		
		// Interface
		public var scroll_mc:ScrollBox;
		public var menu_mc:SkinMenu;
		private var box_mc:Sprite;
		
		public var skin_arr:Array = new Array();
		
		public function SkinList(root:Sprite, parent:Sprite) :void {
			this._root = root;
			this._parent = parent;
			scroll_mc = new ScrollBox(_root, 640, 320);
			scroll_mc.y = 45;
			addChild(scroll_mc);
			menu_mc = new SkinMenu(_root, this);
			addChild(menu_mc);
		}
		
		
		/**
		 * setApplyBgByBid
		 */
		public function setApplyBgByBid(bid:uint):void {
			for(var i:uint = 0; i < skin_arr.length; i++) {
				var search_id:uint = skin_arr[i].bid;
				if(search_id == bid) {
					skin_arr[i].apply_btn.visible = true;
					skin_arr[i].order = 1;
					skin_arr[i].buy_btn.visible = false;
				}
			}
		}
		
		
		/**
		 * onList
		 */
		public function onList(arr:Array):void {
			for (var n:int = 0; n < skin_arr.length; ++n) {
				skin_arr[n].loader.unloadAndStop();
			}
			skin_arr = new Array();
			for (var i:int = 0; i < arr.length; ++i) {
				var p:* = arr[i];
				var line:SkinLine = new SkinLine(_root, _parent, i, p);
				skin_arr.push(line);
			}
			onListUpdate();
		}
		
		
		/**
		 * onListUpdate
		 */
		private function onListUpdate():void {
			box_mc = new Sprite();
			
			var count:int = Math.ceil(skin_arr.length / 6);
			var x_v:int = 0;
			var y_v:int = 0;
			for (var i:int = 0; i < skin_arr.length; ++i) {
				skin_arr[i].x = 104 * x_v;
				skin_arr[i].y = 107 * y_v;
				skin_arr[i].n = i;
				box_mc.addChild(skin_arr[i]);
				y_v = (x_v == 5)? ++y_v: y_v;
				x_v = (x_v == 5)? 0: ++x_v;
			}
			if (skin_arr.length > 0) {
				scroll_mc.contentupdate( box_mc );
			}
		}
	}
}