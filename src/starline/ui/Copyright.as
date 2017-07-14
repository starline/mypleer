package starline.ui {
	

	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.events.ContextMenuEvent;
	
	import starline.ui.text.CreateTextField;
	
	/*
	* Guzhva Andrey
	* http://starline-studio.com
	* 05.01.2011
	* MusicBox player | radio
	*/
	
	public final class Copyright {
		
		public static var URL:URLRequest = new URLRequest( "http://vkontakte.ru/starline" );
		
		public static function createContextMenu(version:String, link:Boolean = true):ContextMenu {
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			var cmi1:ContextMenuItem = new ContextMenuItem( "Версия: " + version );
			var cmi2:ContextMenuItem = new ContextMenuItem( "Разработчик: Андрей Гужва" );
			if(link){
				cmi2.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, function(e:ContextMenuEvent):void { navigateToURL( URL, "_blank" ); } );
			}
			cm.customItems.push( cmi1 );
			cm.customItems.push( cmi2 );
			return cm;
		}
		public static function createTextCopyright():CreateTextField {
			var txt:CreateTextField = new CreateTextField(10, 'Tahoma', 0xffffff, 'left', false, true);
			txt.alpha = 0.3;
			txt.text = "© Андрей Гужва";
			txt.x = 690;
			txt.y = 565;
			return txt;
		}
	}
}