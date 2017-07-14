package starline.player.panels.smart {
        
	import flash.display.*;
	import flash.events.*;
	
	import starline.ui.scroll.ScrollBox;
	
	/*
	* Guzhva Andrey
	* http://starline-studio.com
	* 07.01.2011
	* MusicBox player | radio
	*/
	
	public class SmartList extends Sprite {
			
		public var _root:*;
		public var _parent:*;
		// Interface
		public var scroll_mc:ScrollBox;
		public var menu_mc:SmartMenu;
		public var box_mc:Sprite;
		
		public var radio_arr:Array = new Array();
		// Position
		public var prev_click:int;
		public var cur_click:int;
		public var prev_dclick:int;
		public var cur_dclick:int;
		
		public function SmartList(_root:*, _parent:*) :void {
			this._root = _root;
			this._parent = _parent;
			scroll_mc = new ScrollBox(_root, 640, 320);
			scroll_mc.y = 45;
			addChild(scroll_mc);
			menu_mc = new SmartMenu(_root, this);
			addChild(menu_mc);
		}            
	}

}