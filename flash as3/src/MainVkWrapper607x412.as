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
	import starline.ui.button.TextMenuButton;
	import starline.utils.external.External;
	
	import starline.*;
	import starline.ui.*;
	import starline.banners.BannerManager;
	import starline.player.*;
	import starline.effects.*;
	import starline.server.*;
	import starline.utils.*;
	import starline.ui.simple.DrawRect;
	import starline.player.components.LoaderBar;
	import starline.utils.ClassLoader;
	
	import vk.APIConnection;
	import vk.events.CustomEvent;
	
	/*
	* Guzhva Andrey
	* http://starline-studio.com
	* 24.12.2010
	* MusicBox player | radio
	*/
	
	public class MainVkWrapper607x412 extends Sprite {
		
		// Helper Vars
		public var banners_mc:BannerManager;
		public var bannerApi:ClassLoader;
		public var memController:MemoryController;
		public var frameRateControll:Framerate;
		// User Info
		public var skins:Array = new Array();
		
		public var user_settings:Object = new Object;
		public var user_profile:Object = new Object();
		// Server Vars
		public var MP:ServerApi_2;
		public var mpApiRequest:MpApiRequest;
		public var script_server_url:String = "http://api.mypleer.com/api.php";
		public var server_url:String = "http://mypleer.com/";
		private var app_secret:String = 'gsCklp2aw47785';
		private var app_type:String = 'WAPP';
		private var app_version:String = '3.5.6 Radio';
		// API Vars
		public var wrapper:* = null;
		public var flashVars:Object = new Object();				// Объект для переменнных FlashVars
		public var VK:APIConnection;
		public var vkApiRequest:VkApiRequest;
		// Other Vars
		private var pay_votes:uint;
		public var date:Date = new Date();
		// Interface
		public var player_mc:Player;
		public var loaderBar_spr:Sprite = new Sprite();
		
		public function MainVkWrapper607x412():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			wrapper = Object(parent.parent);
            if ( wrapper.external == null ){
                wrapper = stage; // Local
			

// -- Your code for local testing:
flashVars['api_id'] = 863915;
flashVars['viewer_id'] = 8570293;
flashVars['sid'] = "58b81f2873d3b6262bc6cf7e2d0823747960b2c76822d2a13ed3d74b9d04d8";
flashVars['secret'] = "03479c252a";
// -- //



				// API
				VK = new APIConnection(flashVars);
				vkApiRequest = new VkApiRequest(this);
				start();
			}else {
				flashVars = wrapper.application.parameters;
				// API
				VK = new APIConnection(flashVars);
				vkApiRequest = new VkApiRequest(this);
				// Check settings
				//CheckSettings();
				start()
			}
		}
		// ------------------------------------------------------------------------------------- Start Function
		private function start():void {
			// Безопасность
			Security.allowDomain("*");
			// Server Api
			MP = new ServerApi_2(1611909, flashVars['viewer_id'], app_secret, script_server_url);
			mpApiRequest = new MpApiRequest(this);
			// Player
			player_mc = new Player(this);	player_mc.x = -100; player_mc.y = -100;	addChild(player_mc);
			// LoaderBar
			var lbg:DrawRect = new DrawRect(0xFFFFFF, 507, 412, 0.0 );	loaderBar_spr.addChild(lbg);
			var lb:LoaderBar = new LoaderBar();	lb.x = 580;	lb.y = 20;	loaderBar_spr.addChild(lb);
			addChild(loaderBar_spr);
			// Копирайты
			contextMenu = Copyright.createContextMenu(app_version);	player_mc.addChild(Copyright.createTextCopyright());
			//
			radio();
		}
		private function radio():void {
			player_mc.menu_mc.visible = false;
			player_mc.starCount_mc.visible = false;
			player_mc.soundBar_mc.visible = false;
			player_mc.hotLink_mc.visible = false;
			player_mc.addFriends_btn.visible = false;
			player_mc.app_settings_arr['rating_btn'] = false;
			player_mc.bg_mc.imgLoader('sk005.swf');
			player_mc.volumeBar_mc.setVolume(0.5);
			player_mc.equalizer.x = 85; 																	// Позиция по X
			player_mc.equalizer.y = 120;
			player_mc.radioList_mc.scaleX = 0.9;	player_mc.radioList_mc.scaleY = 0.9;
			player_mc.radioList_mc.x = 125;	player_mc.radioList_mc.y = 175;
			player_mc.radioList_mc.menu_mc.visible = false;
			player_mc.title_txt.x = 250;		player_mc.title_txt.y = 190;
			player_mc.volumeBar_mc.x = 530;		player_mc.volumeBar_mc.y = 160;
			player_mc.play_btn.x = 143;			player_mc.play_btn.y = 123;
			player_mc.pouse_btn.x = 143;		player_mc.pouse_btn.y = 123;
			player_mc.rendomRadio_btn.x = 238;	player_mc.rendomRadio_btn.y = 141;
			
			var cur_page:int = 1;
			player_mc.menu_mc.changePage(cur_page, false);
			player_mc.app_settings_arr['main_page'] = cur_page;
			
			
			var addApp:TextMenuButton = new TextMenuButton('Открыть полную версию плеера', 18, 200, 10);
			addChild(addApp);
			addApp.addEventListener(MouseEvent.CLICK, onAddApp);
		}
		private function onAddApp(e:MouseEvent):void {
			var url:URLRequest = new URLRequest();
			var ref:String = (flashVars.user_id)?flashVars.user_id:'8570293';
			url.url = "http://vkontakte.ru/app1611909_" + ref;  
			navigateToURL( url, "_blank" );
		}
	}
}