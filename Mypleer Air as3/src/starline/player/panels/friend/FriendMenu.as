package starline.player.panels.friend {
        
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
		
	/**
	 * ...
	 * @author Andrey Guzhva
	 */
        
	 public class FriendMenu extends Sprite {
			 
		private var _parent:*;
		private var _root:*;
		
		private var search_key:String;
		
		//Interface
		private var search_txt:TextField = new TextField();
		
		public function FriendMenu(_root:*, _parent:*):void {
			this._parent = _parent;
			this._root = _root;
			this.search_key = '';
			
			var n_tf:TextFormat = new TextFormat();
			n_tf.font = "Arial";
			n_tf.size = 12;
			n_tf.bold = false;
			n_tf.color = 0x000000;
			search_txt.border = true;
			search_txt.background = true;
			search_txt.type = TextFieldType.INPUT;
			search_txt.defaultTextFormat = n_tf;
			search_txt.width = 255;	search_txt.height = 20;
			addChild(search_txt);
			
			addEventListener(Event.ENTER_FRAME, searchUpDate);
		}
		// Поиск
		private function searchUpDate(e:Event = null):void {
			if (search_txt.text.toLowerCase() != search_key) {
				search_key = search_txt.text.toLowerCase();
				_parent.onListSortByKey(search_key);
			}
		}
	}
}