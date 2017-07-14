package starline.player.panels.radio {
        
	import flash.display.*;
	import flash.events.*;
	
	import starline.ui.scroll.ScrollBox;
	
	/*
	* Guzhva Andrey
	* http://starline-studio.com
	* 07.01.2011
	* MusicBox player | radio
	*/
	
	public class RadioList extends Sprite {
			
		private var _root:*;
		private var _parent:*;
		// Interface
		public var scroll_mc:ScrollBox;
		public var menu_mc:RadioMenu;
		
		public var radio_arr:Array = new Array();
		// Position
		public var prev_click:int;
		public var cur_click:int;
		public var prev_dclick:int;
		public var cur_dclick:int;
		
		public function RadioList(_root:*, _parent:*) :void {
			this._root = _root;
			this._parent = _parent;
			scroll_mc = new ScrollBox(_root, 640, 320);
			scroll_mc.y = 45;
			addChild(scroll_mc);
			menu_mc = new RadioMenu(_root, this);
			addChild(menu_mc);
		}
		public function onRadioList(arr:Array):void {
			cur_click = -1;
			cur_dclick = -1;
			radio_arr = new Array();
			for (var i:int = 0; i < arr.length; ++i) {
				var p:* = arr[i];
				var line:RadioLine = new RadioLine(_root,this,i,p);
				radio_arr.push(line);
			}
			onRadioListUpdate();
		}
		private function onRadioListUpdate():void {
			var box_mc:Sprite = new Sprite();
			
			var count:int = Math.ceil(radio_arr.length / 6);
			var x_v:int = 0;
			var y_v:int = 0;
			for (var i:int = 0; i < radio_arr.length; ++i) {
				radio_arr[i].x = 104 * x_v;
				radio_arr[i].y = 107 * y_v;
				radio_arr[i].n = i;
				box_mc.addChild(radio_arr[i]);
				y_v = (x_v == 5)? ++y_v: y_v;
				x_v = (x_v == 5)? 0: ++x_v;
			}
			if (radio_arr.length > 0) {
				scroll_mc.contentupdate( box_mc );
			}
		}
		public function add_stations(stid:uint):void {
			_root.send_server.add_stations(stid);
		}
		// ----------------------------------------------------------------------------- select
		public function onClick(n:int):void {
			if (n != cur_click) { 
				prev_click = cur_click;
				cur_click = n;
				radio_arr[cur_click].onClick();
				if (prev_click >= 0) { radio_arr[prev_click].unClick(); }
			}
		}
		public function onDclick(n:int):void {
			if(n != cur_dclick){
				prev_dclick = cur_dclick;
				cur_dclick = n;
				if (prev_dclick >= 0) {radio_arr[prev_dclick].unDclick();}
				radio_arr[cur_dclick].onDclick()
				scroll_mc.playPosition(n * 100 / 5); // позиция отметки на скролле
			}
			_parent.audio_flag = false;
			_parent.setLastAudio(radio_arr[cur_dclick].title);
			_parent.onNewPlay(radio_arr[cur_dclick].url);
		}               
	}

}