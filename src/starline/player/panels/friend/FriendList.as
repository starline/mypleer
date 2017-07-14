package starline.player.panels.friend {
	
	import flash.display.*;
	import flash.events.*;
	
	import starline.player.components.DelBtn;
	import starline.ui.list.ListBox;
	
	/**
	 * @author Guzhva Andrey
	 * @site http://aguzhva.com
	 * @date 16.10.2012
	 * @project MusicBox player | radio
	 */
	
	public class FriendList extends Sprite {
		
		private var _root:*;
		private var _parent:*;
		
		// Interface
		public var list_mc:ListBox;
		public var searchPanel_mc:FriendMenu;
		private var bg_mc:Sprite = new Sprite();
		private var close_btn:DelBtn = new DelBtn();
		
		public var in_arr:Array = new Array();
		public var sort_lines_arr:Array = new Array();
		public var lines_arr:Array = new Array();
		public var search_key:String = '';
		
		// Positiun
		public var prev_click:int;
		public var cur_click:int;
		public var prev_dclick:int;
		public var cur_dclick:int;
		
		public function FriendList(_root:*, _parent:*) :void {
			this._root = _root;
			this._parent = _parent;
			
			bg_mc.graphics.beginFill(0xDCCA7D);
			bg_mc.graphics.drawRoundRect(0, 0, 300, 550, 8);
			bg_mc.graphics.endFill();
			bg_mc.alpha = 0.98;
			addChild(bg_mc);
						
			list_mc = new ListBox(8, 40, 255, 15);
			addChild(list_mc);
			
			searchPanel_mc = new FriendMenu(_root, this);
			searchPanel_mc.x = 8;	searchPanel_mc.y = 10;
			addChild(searchPanel_mc);
			
			close_btn.x = 273;	close_btn.y = 10;
			addChild(close_btn);
			close_btn.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void { _parent.friendList_mc.visible = false; } );
		}
		
		public function onList(arr:Array):void {
			this.in_arr = arr;
			cur_click = -1;
			cur_dclick = -1;
			lines_arr = new Array();
			if (in_arr.length>0) {	// если есть друзья
				for (var i:int = 0; i < in_arr.length; ++i) {
					var p:* = in_arr[i];
					var line:FriendLine = new FriendLine(this, i, p);
					lines_arr.push(line); // создаем массив с друзьями
				}
				onListSortByKey();
			}
		}
		
		public function onListSortByKey(search_key:String = ''):void { // фильтровка аудиозаписей по слову
			this.search_key = search_key;
			sort_lines_arr = new Array();
			if (search_key == "") {
				sort_lines_arr = lines_arr;
			} else {
				for (var i:uint = 0; i < lines_arr.length; i++) {
					var search_name:String = lines_arr[i].first_name+' '+lines_arr[i].last_name;
					search_name = search_name.toLowerCase();
					if (search_name.indexOf(search_key)!= -1) {
						sort_lines_arr.push(lines_arr[i]);
					}
				}
			}
			onListUpdate();
		}
		
		private function onListUpdate():void {
			list_mc.clear();
			list_mc.resetScrollBar();
			list_mc.addItemsArray( sort_lines_arr );
		}
		
		
		// ----------------------------------------------------------------------------- select
		public function onClick(n:int):void {
			if (n != cur_click) { 
				prev_click = cur_click;
				cur_click = n;
				lines_arr[cur_click].onClick();
				if (prev_click >= 0) { lines_arr[prev_click].unClick(); }
			}
		}
		
		
		public function onDclick(n:int):void {
			if(n != cur_dclick){
				prev_dclick = cur_dclick;
				cur_dclick = n;
				if (prev_dclick >= 0) {lines_arr[prev_dclick].unDclick();}
				lines_arr[cur_dclick].onDclick()
			}
			
			_parent.audioList_mc.fid = lines_arr[cur_dclick].uid;
			_parent.audioList_mc.menu_mc.changePage(1, false, true);
			_parent.audioList_mc.menu_mc.getFriendAudio(lines_arr[cur_dclick].uid);
			_parent.menu_mc.changePage(0);
		}	
	}
}