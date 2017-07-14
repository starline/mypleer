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
	import starline.player.Main;
	import starline.effects.*;
	import starline.server.*;
	import starline.utils.*;
	import starline.ui.simple.DrawRect;
	import starline.player.components.LoaderBar;
	import starline.utils.ClassLoader;
	
	/**
	 * @author Guzhva Andrey
	 * @site http://aguzhva.com
	 * @date 20.03.2012
	 * @project MyPleer player | radio
	 */
	
	[SWF(width="807",height="566")]
	
	public class MainWebRadio extends Main {
		
		// Helper Vars
		public var bannerApi:ClassLoader;
		public var memController:MemoryController;
		public var frameRateControll:Framerate;
		
		// User Info
		public var skins:Array = new Array();		
		public var user_radio:Array = new Array();
		public var user_settings:Object = new Object;
		public var user_audios:Array = new Array();
		public var user_friends:Array = new Array();
		public var user_profile:Object = new Object();
		
		// Server Vars
		public var MP:ServerApi_2;
		public var mpApiRequest:MpApiRequest;

		// Static Vars
		public static const APP_TYPE:String = 		'WebRadio';
		public static const APP_VERSION:String = 	'3.7.2';
		
		/* Flash Vars
		 * 
		 * skin_src
		 * 
		 */
		public var flashVars:Object = new Object(); // Объект для переменнных FlashVars
		
		// Other Vars
		private var pay_votes:uint;
		public var date:Date = new Date();
		
		// Interface
		public var player_mc:Player;
		public var loaderBar_spr:Sprite = new Sprite();
		
		public function MainWebRadio():void {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// get flashvars
			flashVars = stage.loaderInfo.parameters as Object;
			
			if (!flashVars.skin_src)
				flashVars.skin_src = 'sk022.swf';

			start();
		}
		
		// ------------------------------------------------------------------------------------- Start Function
		private function start():void {
			// Безопасность
			Security.allowDomain("*");
			// Server Api
			MP = new ServerApi_2(APP_ID, VIEWER_ID, APP_SECRET, MP_API_URL);
			mpApiRequest = new MpApiRequest(this);
			// Player
			player_mc = new Player(this);
			player_mc.x = 0;
			player_mc.y = -24;
			addChild(player_mc);
			// LoaderBar
			var lbg:DrawRect = new DrawRect(0xFFFFFF, 807, 752, 0.0);
			loaderBar_spr.addChild(lbg);
			var lb:LoaderBar = new LoaderBar();
			lb.x = 780;
			lb.y = 25;
			loaderBar_spr.addChild(lb);
			addChild(loaderBar_spr);
			// Копирайты
			contextMenu = Copyright.createContextMenu(APP_VERSION + ' ' + APP_TYPE);
			player_mc.addChild(Copyright.createTextCopyright());
			//
			StartRadio();
		}
		
		//------------------------------------------------------------------------------------------- onAPI
		public function StartRadio():void {
			player_mc.menu_mc.visible = false;
			player_mc.starCount_mc.visible = false;
			player_mc.soundBar_mc.visible = false;
			player_mc.hotLink_mc.visible = false;
			player_mc.addFriends_btn.visible = false;
			player_mc.app_settings_arr['rating_btn'] = false;
			
			var cur_page:int = 1;
			player_mc.bg_mc.imgLoader(flashVars.skin_src);
			player_mc.volumeBar_mc.setVolume(0.5);
			
			player_mc.menu_mc.changePage(cur_page, false);
			player_mc.app_settings_arr['main_page'] = cur_page;
		}
	}
}