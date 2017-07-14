package {
	
	import adobe.utils.CustomActions;
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	import flash.text.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	import com.*;
	
	import starline.*;
	import starline.ui.*;
	import starline.player.*;
	import starline.effects.*;
	import starline.server.*;
	import starline.utils.*;
	import starline.ui.simple.DrawRect;
	import starline.player.components.LoaderBar;
	import starline.utils.ClassLoader;
	
	import vk.*;
	import vk.events.*;
	
	/*
	* Guzhva Andrey
	* http://starline-studio.com
	* 24.12.2010
	* Mypleer | radio
	*/
	
	public class MainWebRadioNarrow extends Sprite {
		
		// Helper Vars
		public var bannerApi:ClassLoader;
		public var memController:MemoryController;
		public var frameRateControll:Framerate;
		// User Info
		public var skins:Array = new Array();
		public var user_settings:Object = new Object();
		public var user_profile:Object = new Object();
		
		// Server Class
		public var MP:ServerApi_2;
		public var mpApiRequest:MpApiRequest;
		
		// Static Vars
		private static const 	MP_API_URL:String = 		"http://api.mypleer.com/api.php";
		private static const 	APP_ID:int = 				1611909;
		private static const 	APP_SECRET:String = 		'gsCklp2aw47785';
		public static const 	APP_TYPE:String = 			'WebRadioNarrow';
		public static const 	APP_VERSION:String = 		'3.7.1';
		
		// API Vars
		public var flashVars:Object = new Object();				// Объект для переменнных FlashVars
		public var VK:APIConnection;
		public var vkApiRequest:VkApiRequest;
		
		// Other Vars
		private var pay_votes:uint;
		public var date:Date = new Date();
		
		// Interface
		public var player_mc:Player;
		public var loaderBar_spr:Sprite = new Sprite();
		
		public function MainWebRadioNarrow():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			flashVars['api_id'] = 1611909;
			flashVars['viewer_id'] = 1;
			start();
		}
		// ------------------------------------------------------------------------------------- Start Function
		private function start():void {
			// Безопасность
			Security.allowDomain("*");
			// MP Server Api
			MP = new ServerApi_2(APP_ID, flashVars['viewer_id'], APP_SECRET, MP_API_URL);
			mpApiRequest = new MpApiRequest(this);
			// Player
			player_mc = new Player(this);	player_mc.x = -23;	player_mc.y = -26;	addChild(player_mc);
			// LoaderBar
			var lbg:DrawRect = new DrawRect(0xFFFFFF, 807, 752, 0.0 );	loaderBar_spr.addChild(lbg);
			var lb:LoaderBar = new LoaderBar();	lb.x = 740;	lb.y = 25;	loaderBar_spr.addChild(lb);
			addChild(loaderBar_spr);
			// Copyright
			contextMenu = Copyright.createContextMenu(APP_TYPE+' '+APP_VERSION);	player_mc.addChild(Copyright.createTextCopyright());

			go();

		}
		//------------------------------------------------------------------------------------------- onAPI
		public function go():void {
			player_mc.menu_mc.visible = false;
			player_mc.starCount_mc.visible = false;
			player_mc.soundBar_mc.visible = false;
			player_mc.hotLink_mc.visible = false;
			player_mc.addFriends_btn.visible = false;
			player_mc.app_settings_arr['rating_btn'] = false;
			
			var cur_page:int = 1;
			player_mc.bg_mc.imgLoader('sk005.swf');
			player_mc.volumeBar_mc.setVolume(0.5);
			
			player_mc.menu_mc.changePage(cur_page, false);
			player_mc.app_settings_arr['main_page'] = cur_page;
		}
	}
}