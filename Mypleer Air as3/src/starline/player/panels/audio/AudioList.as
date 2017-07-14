package starline.player.panels.audio {
	

	import flash.display.*;
	import flash.events.*;

	import starline.ui.list.ListBox;
	
	/*
	* Guzhva Andrey
	* http://starline-studio.com
	* 07.01.2011
	* MusicBox player | radio
	*/
	
	public class AudioList extends Sprite {
		
		public var _root:*;
		public var _parent:*;
		// Interface
		public var menu_mc:AudioMenu;
		public var list_mc:ListBox;
		
		public var in_arr:Array;
		public var sort_lines_arr:Array;
		public var lines_arr:Array;
		public var search_key:String = '';
		// Positiun
		public var prev_click:int;
		public var cur_click:int;
		public var prev_dclick:int;
		public var cur_dclick:int;
		// Flag
		public var random_flag:Boolean = false;
		public var round_flag:Boolean = false;
		// Vars
		private var cur_drag:uint;
		private var start_drag:uint;
		private var n_del:uint;
		
		public function AudioList(_root:*, _parent:*) :void {
			this._root = _root;
			this._parent = _parent;
			
			menu_mc = new AudioMenu(_root, this);
			addChild(menu_mc);

			list_mc = new ListBox(0, 45, 630, 10);
			addChild(list_mc); 
		}
		public function onList(arr:Array):void {
			in_arr = new Array();
			lines_arr = new Array();
			sort_lines_arr = new Array();
			if (arr) {
				in_arr = arr;
				if (in_arr.length>0) {	// если есть удиозаписи
					for (var i:int = 0; i < in_arr.length; ++i) {
						var p:* = in_arr[i];
						var line:AudioLine = new AudioLine(this, i, p);
						line.del_btn.visible = (line.oid == _root.flashVars.viewer_id)?true:false;
						line.add_btn.visible = (line.oid != _root.flashVars.viewer_id)?true:false;
						lines_arr.push(line); // создаем массив с аудиозаписями
					}
				}
			}
			cur_dclick = -1
			cur_click = -1;
			audioListSortByKey();
		}
		private function refreshN():void {
			for (var i:uint = 0; i < lines_arr.length; i++) {
				lines_arr.n = i;
			}
			
		}
		//////////////////////////////////////////////////////////////////////////////////////////////////
		////----------------------------------------------------------------------------------- Фильтровка 
		//////////////////////////////////////////////////////////////////////////////////////////////////
		public function audioListSortByKey(search_key:String = '', resetScroll:Boolean = true):void { // фильтровка аудиозаписей по слову
			if (cur_dclick != -1) {
				sort_lines_arr[cur_dclick].unDclick();
				cur_dclick = -1;
			}
			if (cur_click != -1) {
				sort_lines_arr[cur_click].unClick();
				cur_click = -1;
			}
			this.search_key = search_key;
			sort_lines_arr = new Array();
			if (search_key == "") {
				sort_lines_arr = lines_arr;
			} else {
				for (var i:uint = 0; i < lines_arr.length; i++) {
					var search_name:String = lines_arr[i].artist+' '+lines_arr[i].title;
					search_name = search_name.toLowerCase();
					if (search_name.indexOf(search_key)!= -1) {
						sort_lines_arr.push(lines_arr[i]);
					}
				}
			}
			list_mc.clear();
			if (resetScroll)
				list_mc.resetScrollBar();
			
			list_mc.addItemsArray( sort_lines_arr ); 
		}
		////////////////////////////////////////////////////////////////////////////////////////
		////------------------------------------------------------------------------- ADD DELETE
		////////////////////////////////////////////////////////////////////////////////////////
		public function onAdd(aid:uint, oid:uint, n:uint):void {
			_root.loaderBar_spr.visible = true;
			_root.VK.api('audio.add', {aid:aid, oid:oid}, _root.vkApiRequest.fetchAudioAdd, _root.vkApiRequest.requestFail);
		}
		public function onDel(aid:uint, oid:uint, n:uint):void {
			n_del = n;
			_root.loaderBar_spr.visible = true;
			_root.VK.api('audio.delete', {aid:aid, oid:oid}, _root.vkApiRequest.fetchAudioDelete, _root.vkApiRequest.requestFail);
		}
		public function audioDelete():void {
			lines_arr.splice(n_del, 1);
			refreshN();
			audioListSortByKey(search_key, false);
		}
		////////////////////////////////////////////////////////////////////////////////////////
		////----------------------------------------------------------------------------- SELECT
		////////////////////////////////////////////////////////////////////////////////////////
		public function onClick(n:int):void {
			if (n != cur_click) { 
				prev_click = cur_click;
				cur_click = n;
				sort_lines_arr[cur_click].onClick();
				if (prev_click >= 0) { sort_lines_arr[prev_click].unClick(); }
			}
		}
		public function onDclick(n:int):void {
			if(n != cur_dclick){
				prev_dclick = cur_dclick;
				cur_dclick = n;
				if (prev_dclick >= 0) {sort_lines_arr[prev_dclick].unDclick();}
				sort_lines_arr[cur_dclick].onDclick()
			}
			_parent.audio_flag = true;
			_parent.setLastAudio(sort_lines_arr[cur_dclick].artist+' - '+sort_lines_arr[cur_dclick].title);
			_parent.onNewPlay(sort_lines_arr[cur_dclick].url);
		}
		public function onNext():void {
			if (cur_dclick < sort_lines_arr.length-1) { 
				if (random_flag) {
					onDclick(Math.random()*sort_lines_arr.length);
				} else {
					onDclick(cur_dclick+1);
				}
			} else {
				onDclick(0);
			}
		}
		public function onPrev():void {
			if (cur_dclick  > 0) {
				if (random_flag) {
					onDclick(Math.random()*sort_lines_arr.length);
				} else {
					onDclick(cur_dclick-1);
				}
			}
		}
		////////////////////////////////////////////////////////////////////////////////////////
		////--------------------------------------------------------------------- Перетаскивание
		////////////////////////////////////////////////////////////////////////////////////////
		public function startDragLine(target:Sprite):void {
			start_drag = target['idx']; //idx взятой пролосы
			addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
			target.y = mouseY-10;
			addChild(target);
			target.startDrag();
		}
		public function stopDragLine(target:Sprite):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove); 
			stopDrag();
			target.x = 0;
			target.y = (start_drag - list_mc.sb.scrollPosition) * 32;
			list_mc.addChild(target);
			var after:uint  = (start_drag - 1) < 0 ? 0 : sort_lines_arr[start_drag - 1].aid;
			var before:uint = (start_drag + 1) > sort_lines_arr.length - 1 ? 0 : sort_lines_arr[start_drag + 1].aid;
			if (_root.flashVars.viewer_id == sort_lines_arr[start_drag].oid  && search_key == '') { 
				_root.VK.api('audio.reorder',
				{ aid:sort_lines_arr[start_drag].aid, after: after, before: before},
				_root.vkApiRequest.fetchAudioReorder,
				_root.vkApiRequest.requestFail);
			}
			refreshN();
		}
		
		private function mouseMove(e:MouseEvent):void {
			cur_drag = list_mc.sb.scrollPosition + int(list_mc.mouseY / 32); //idx наведенной
			var cur_line:Sprite = sort_lines_arr[cur_drag];
			var start_line:Sprite = sort_lines_arr[start_drag];
			if ((start_drag - cur_drag > 0 && cur_drag >= 0) || (start_drag - cur_drag < 0 && cur_drag < sort_lines_arr.length)) {
				setLine(cur_drag, start_drag);
				sort_lines_arr.splice(cur_drag, 1, start_line);
				sort_lines_arr.splice(start_drag, 1, cur_line);
				list_mc.items.splice(cur_drag, 1, start_line);
				list_mc.items.splice(start_drag, 1, cur_line);
				start_drag = cur_drag;
			}
			// скролл листа при перетаскивании
			//if (scroll_mc.mouseY < 0) {
				//scroll_mc.scrollWhell(3);
			//}
			//if (scroll_mc.mouseY > 320) {
				//scroll_mc.scrollWhell(-3);
			//}
		} 
		// устанока новых параметров после перетаскивания
		private function setLine(_cur:uint, _new:uint):void {
			sort_lines_arr[_cur].y = (_new - list_mc.sb.scrollPosition)* 32;
			sort_lines_arr[_cur].idx = _new;
			sort_lines_arr[_cur].n_txt.text  = _new + 1;
			sort_lines_arr[_new].idx = _cur;
			sort_lines_arr[_new].n_txt.text  = _cur + 1;
			if (_cur == cur_click || _new == cur_click) {
				cur_click = _new;
			}
			if ( _new == cur_dclick) {
				cur_dclick = _cur;
			}else if (_cur == cur_dclick) {
				cur_dclick = _new;
			}
		}
		
	}

}