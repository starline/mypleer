package starline.ui.list {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import starline.ui.simple.DrawRect;
	  
	import starline.utils.MouseWheel;

	/**
	* @author Alexey Kharkov
	* Andrey Guzhva
	* 28.01.2011
	*/
  
	public class ListBox extends Sprite {
	  
		public var items:Array = null;

		private var cur:* = null; // Currently active item
		private var hl:* = null; // Highlighted item
		private var w:int = 0; // width
		
		internal var sel:Sprite = null; // Highlighting rectangle
		public var sb:ScrollBar = null;
		
		internal var enMouse:Boolean = true;
		
		static internal const ITEM_H:uint = 32;
		static private const W:uint = 10; // padding ScrollBar List
		public var ITEMS_COUNT_TO_SCROLL:uint = 10;
    

		public function ListBox( x:int, y:int, w:int, count:uint ):void{
			this.x = x;
			this.y = y;
			this.w = w;
			this.ITEMS_COUNT_TO_SCROLL = count;

		  
			items = new Array();
			
			// Selection rects
			sel = new Sprite();
			var select:Sprite = new Sprite();
			//Utils.fillRect( sel, 0, 0, w, ITEM_H, 0x0099FF, 0.5);
			Utils.fillRect( select, 0, 0, w, ITEMS_COUNT_TO_SCROLL * ITEM_H, 0x0099FF, 0);
			//sel.mouseEnabled = false;
			addChild( select );
			sel.mask = maskRect();
		  
			// Scroll bar
			sb = new ScrollBar( w + W, 0, ITEM_H * ITEMS_COUNT_TO_SCROLL );
			sb.visible = false;
			sb.addEventListener( Event.SCROLL, onScroll );
			addChild( sb );

			// Keys control
			addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		  
			addEventListener( MouseEvent.ROLL_OVER, onOver );
			addEventListener( MouseEvent.ROLL_OUT, onOut );
			addEventListener( MouseEvent.MOUSE_WHEEL, onWheel );
		}
    
		public function clear():void{
		  cur = null;
		  items = new Array();
		  clearLayout();
		}
		public function resetScrollBar():void {
			sb.init( 0, ITEMS_COUNT_TO_SCROLL );
			sb.scrollPosition = 0;
			sb.visible = false;
		}
		public function addItemsArray( arr:Array ):void{
			for ( var i:uint = 0; i < arr.length; ++i ){
				addItemHelper( arr[i] );
			}
			upd();
		}
		
		public function addItem( s:String ):void{
		  addItemHelper( s );
		  upd();
		}
    
		public function get selectedIndex():int{
		  return (cur != null) ? cur.idy : 0;
		}
		
		public function set selectedIndex( idy:int ):void{
		  if ( idy >= 0  &&  idy < length ){
			onItemClick( items[idy], false );
			scrollToCur();
		  }
		}
    
		public function get length():uint{
			return items.length;
		}
		public override function get width():Number{
			return w;
		}
		public override function get height():Number{
			return Math.min(length, ITEMS_COUNT_TO_SCROLL) * ITEM_H;
		}
    
		// ---------------------------------------------------------------------------- internal methods.
		internal function setItemActive( item:* ):void{
			if ( hl != null )
			// hl.txt.textColor = 0;
		  
			hl = item;
			if (item)
				sel.y = item.y;
			// item.txt.textColor = 0xffffff;
		}
    
		internal function onItemClick( item:*, b:Boolean ):void{
			cur = item;
			setItemActive( item );
			dispatchEvent( new Event( Event.CHANGE ) );
		}
    
		internal function reset():void{
			setItemActive( cur );
			scrollToCur();
		}
    
		internal function get selY():int{
			return sel.y;
		}
		////////////////////////////////////////////////////////////////////////////////////////////////
		//// -------------------------------------------------------------------------- private methods
		////////////////////////////////////////////////////////////////////////////////////////////////
		private function addItemHelper( s:* ):void{
			var idy:int = length;
			s.idy = idy;
			s.n_txt.text = idy + 1;

			if ( idy == 0 ){
				cur = s;
				hl = s;
				setItemActive( s );
			}
			items.push( s );
		}
		private function upd():void {
			if ( length > ITEMS_COUNT_TO_SCROLL ){
				sb.init( length - ITEMS_COUNT_TO_SCROLL, ITEMS_COUNT_TO_SCROLL );
				sb.visible = true;
			}
			reDraw();
		}
		private function scrollToCur():void{
			if ( cur.y < 0  ||  cur.y >= ITEMS_COUNT_TO_SCROLL * ITEM_H  ){
				sb.scrollPosition = cur.idy - ITEMS_COUNT_TO_SCROLL / 3;
				reDraw();
			}
		}
		private function scrollToBounds( item:* ):void{
			if ( item.y < 0 ){
				sb.scrollPosition = item.idy;
			} else if ( item.y >= ITEMS_COUNT_TO_SCROLL * ITEM_H ){
				sb.scrollPosition = item.idy - ITEMS_COUNT_TO_SCROLL ;
			}
			reDraw();
		}
		private function maskRect():DrawRect{
			var ss:DrawRect = new DrawRect(0x000000, w, ITEMS_COUNT_TO_SCROLL * ITEM_H, 1);
			addChild( ss );
			return ss;
		}
		private function reDraw():void{
			clearLayout();
			var yy:int = -ITEM_H * Math.round( sb.scrollPosition );
			for ( var i:uint = 0; i < items.length; ++i ){
				items[i].y = yy;
				yy += ITEM_H;
				if ( items[i].y > -ITEM_H  &&  items[i].y < height ) {
					addChild( items[i] );
				}
			}

			setChildIndex( sb, numChildren - 1 );
			setItemActive( hl );
		}
		private function clearLayout():void{
			while ( numChildren > 2 ) // the first two children are "sel" and "sel mask"
				removeChildAt( numChildren - 1 );
			addChild( sb );
		}
		/////////////////////////////////////////////////////////////////////////////////////////
		//// --------------------------------------------------------------------- Event handlers
		/////////////////////////////////////////////////////////////////////////////////////////
		private function onKeyDown( e:KeyboardEvent ):void{
			enMouse = false;
			if ( e.keyCode == 38 ){
				if ( selectedIndex > 0 ){
				onItemClick( items[selectedIndex - 1], false );
				scrollToBounds( cur );
				hl.graphics.clear();
				}
			} else
			if ( e.keyCode == 40 ){
				if ( selectedIndex < length - 1 ){
				onItemClick( items[selectedIndex + 1], false );
				scrollToBounds( cur );
				hl.graphics.clear();
				}
			}
			addEventListener( MouseEvent.MOUSE_MOVE, function(e:MouseEvent):void { enMouse = true; } );
		}
    
		internal function onComboKeyDown( e:KeyboardEvent ):void{
			enMouse = false;
			if ( e.keyCode == 13 ){
				onItemClick( hl, true );
			} else if ( e.keyCode == 38 ){
				if ( hl.idy > 0 ){
					setItemActive( items[hl.idy - 1] );
					scrollToBounds( hl );
				}
			} else if ( e.keyCode == 40 ){
				if ( hl.idy < length - 1 ){
					setItemActive( items[hl.idy + 1] );
					scrollToBounds( hl );
				}
			}
			addEventListener( MouseEvent.MOUSE_MOVE, function(e:MouseEvent):void { enMouse = true; } );
		}
	    private function onScroll( e:Event ):void{
			reDraw();
		}

		private function onWheel( e:MouseEvent ):void{
			enMouse = true;
			sb.scrollPosition -= e.delta/3;
			reDraw();
		}
		//////////////////////////////////////////////////////////////////////////////////////////////////
		/////-------------------------------------------------------------------------- MouseWheel.capture
		//////////////////////////////////////////////////////////////////////////////////////////////////
		private function onOver( e:MouseEvent ):void{
			if ( e.target == this){
				MouseWheel.capture();
			}
		}
		private function onOut( e:MouseEvent ):void{
			if ( e.target == this){
				MouseWheel.release();
			}
		} 
	}
}
