package starline.ui {
	

	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.text.*;
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	
	/*
	* Guzhva Andrey
	* http://starline-studio.com
	* 05.01.2011
	* MusicBox player | radio
	*/
	
	public final class Copyright {
		
		public static var _version:String = "3.0.0";
		public static var _url:URLRequest = new URLRequest( "http://vkontakte.ru/starline" );
		
		public static function createContextMenu():ContextMenu {
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			var cmi1:ContextMenuItem = new ContextMenuItem( "Версия: " + _version );
			var cmi2:ContextMenuItem = new ContextMenuItem( "Разработчик: Андрей Гужва" );
			cmi2.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, function(e:ContextMenuEvent):void{navigateToURL( _url, "_blank" )});
			cm.customItems.push( cmi1 );
			cm.customItems.push( cmi2 );
			return cm;
		}
		public static function createTextCopyright():TextField {
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Tahoma";
			textFormat.size = 10;
			textFormat.color = 0xFFFFFF;
			
			var txt:TextField = new TextField();
			txt.wordWrap = false;
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.defaultTextFormat = textFormat;
			txt.alpha = 0.3;
			txt.htmlText = "© Андрей Гужва";
			txt.x = 710;
			txt.y = 565;
			return txt;
		}
	}
}