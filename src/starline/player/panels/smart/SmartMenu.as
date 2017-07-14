package starline.player.panels.smart {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.ColorTransform;
	
	import starline.ui.button.TextMenuButton;
	import fm.last.davidwhite.Tag;

	
	/**
	 * ...
	 * @author Andrey Guzhva
	 */
	
	 public class SmartMenu extends Sprite {
		 
		private var _parent:*;
		private var _root:*;
		// Menu
		private var last_item:int = 10;
		private var items:Array = new Array();
		private var cur_page:uint = 0;
		private var last_page:uint = 0;
		// Interface
		private var bg_mc:Sprite = new Sprite();
		// Last
		private var lfmTag:Tag = new Tag();
		
		public function SmartMenu(_root:*, _parent:*):void {
			this._parent = _parent;
			this._root = _root;

			bg_mc.graphics.beginFill(0x000000);
			bg_mc.graphics.drawRoundRect(0, 0, 660, 30, 5);
			bg_mc.graphics.endFill();
			bg_mc.alpha = 0.5;
			addChild(bg_mc);
			
			addItem("Плохое", 10, 5, 'top');
			addItem("Усталое", 100, 5, 'ru');
			addItem("Нейтральное", 210, 5, 'ua');
			addItem("Хорошее", 310, 5, 'by');
			addItem("Веселое", 430, 5, 'other');
		}
		
		public function addItem(label:String, x:uint, y:uint, panel:* = null ):void {
			var id:uint = items.length;
			var item:TextMenuButton = new TextMenuButton(label, 13, x, y);
			item.id = id;
			item.panel = panel;
			item.addEventListener( MouseEvent.CLICK, onButClicked, false,0,true);
			addChild(item);
			items.push( item );	
		}		
		private function onButClicked( e:MouseEvent ):void{
			changePage( e.currentTarget.id);
		}
		public function changePage( page:uint):void {
			
			//_parent._parent.app_settings_arr['smart_page'] = page;
			
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
			getTrackByTeg(items[cur_page].panel);
		}
		///////////////////////////////////////////////////////////////////////////////
		/////------------------------------------------------------------------Function
		///////////////////////////////////////////////////////////////////////////////
		private function getTrackByTeg(tag:String):void {
			lfmTag.getTopTracks(tag);
			lfmTag.addEventListener(Tag.GET_TOP_TRACKS, getTopTracksHandler);
		}
		private function getTopTracksHandler(event:Event):void{
			trace(lfmTag.xml);
			var tracks:XMLList = lfmTag.xml.toptracks.track;
			
			for each(var track:XML in tracks){
				trace("Track rank: " + track.@rank);
				trace("Track name: " + track.name);
				trace("Track tagcount: " + track.tagcount);
				trace("Track mbid: " + track.mbid);
				trace("Track url: " + track.url);
				trace("Track streamable: " + track.streamable);
				trace("Artist name: " + track.artist.name);
				trace("Artist mbid: " + track.artist.mbid);
				trace("Artist url: " + track.artist.url);
				for each(var image:XML in track.image){
					trace("Image size: " + image.@size + " and URL: " + image);
				}
				trace("\n");
			}
		}
		///////////////////////////////////////////////////////////////////////////////
	}
}