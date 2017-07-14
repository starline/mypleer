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
	import starline.banners.BannerManager;
	import starline.player.*;
	import starline.effects.*;
	import starline.server.*;
	import starline.utils.*;
	import starline.vk.VkApi_2;
	import starline.ui.button.DrawRect;
	import starline.player.components.LoaderBar;
	import starline.utils.ClassLoader;
	
	import vk.*;
	import vk.events.*;
	
	import com.google.analytics.AnalyticsTracker; 
	import com.google.analytics.GATracker; 
	
	/*
	* Guzhva Andrey
	* http://starline-studio.com
	* 24.12.2010
	* MusicBox player | radio
	*/
	
	public class MainAIR extends Sprite {
		
		// Helper Vars
		public var googleTracker:AnalyticsTracker;
		public var banners_mc:BannerManager;
		public var bannerApi:ClassLoader;
		// User Info
		public var skins:Array = new Array();
		
		public var user_radio:Array = new Array();
		public var user_settings:Object = new Object;
		public var user_audios:Array = new Array();
		public var user_friends:Array = new Array();
		public var user_profile:Object = new Object();
		// Server Vars
		public var send_server:ServerApi;
		public var server_url:String = "http://188.93.17.194/";
		// API Vars
		public var flashVars:Object = new Object();				// Объект для переменнных FlashVars
		public var VK:APIConnection;
		public var VK2:VkApi_2;
		public var vkApiRequest:VkApiRequest;
		// Other Vars
		private var pay_votes:uint;
		// Interface
		public var player_mc:Player;
		public var loaderBar_spr:Sprite = new Sprite();
		
		public function MainAIR():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			flashVars = stage.loaderInfo.parameters as Object; 
			if ( !flashVars.api_id){
				flashVars['api_url'] = 'http://vkontakte.ru/api.php';				



				

// -- Your code for local testing:
flashVars['api_id'] = 863915;
flashVars['viewer_id'] = 8570293;
flashVars['sid'] = "ca777e61acbc60a050a8292b6a14b15356d44580a704def1b2e1a38d924c38";
flashVars['secret'] = "9d998e030c";
// -- //





				// API
				VK = new APIConnection(flashVars);
				vkApiRequest = new VkApiRequest(this);
				start();
			}else {
				// API
				VK = new APIConnection(flashVars);
				vkApiRequest = new VkApiRequest(this);
				// Listener
				VK.addEventListener("onWindowFocus", onWindowFocus);
				VK.addEventListener("onSettingsChanged", onSettingsChanged);
				VK.addEventListener("onApplicationAdded", onApplicationAdded);
				VK.addEventListener("onBalanceChanged", onBalanceChanged);
				// Check settings
				CheckSettings();
			}
		}
		// -------------------------------------------------------------------------------------- Check settings
		private function CheckSettings():void {
			if (flashVars.is_app_user == 0) {
				VK.callMethod('showInstallBox');
			} else if ((flashVars.api_settings & 10) == 10 ) {
				VK.removeEventListener( "onSettingsChanged", onSettingsChanged);
				start();
			} else {
				VK.callMethod('showSettingsBox',267);
			}
		}
		private function onWindowFocus(e:CustomEvent):void {
			//CheckSettings();
		}
		private function onSettingsChanged(e:CustomEvent):void {
			flashVars.api_settings = e.params[0];
			CheckSettings();
		}
		private function onApplicationAdded(e:CustomEvent):void {
			VK.removeEventListener("onApplicationAdded", onApplicationAdded);
			flashVars.is_app_user = 1;
			CheckSettings();
		}
		private function onBalanceChanged(e:CustomEvent):void {
		}
		public function showInviteBox():void {
			VK.callMethod('showInviteBox');
		}

		// ------------------------------------------------------------------------------------- Start Function
		private function start():void {
			// Framerate control
			var fr:FramerateThrottling = new FramerateThrottling();
			// Подключаем Google Analitics
			googleTracker = new GATracker( this, "UA-7136699-7", "AS3", false ); 
			// First 
			VK.api('getProfiles', { uids: flashVars.viewer_id, fields: "uid,first_name,last_name,sex,bdate,city,country,photo_medium" }, vkApiRequest.fetchUserProfile, vkApiRequest.requestFail);
			loaderBar_spr.visible = true;
			addEventListener(Event.ENTER_FRAME, onUserProfile);
			// Server Api
			send_server = new ServerApi(this, flashVars.viewer_id, server_url);
			// Player
			player_mc = new Player(this);
			player_mc.y = 0;
			addChild(player_mc);
			// LoaderBar
			var lbg:DrawRect = new DrawRect(0xFFFFFF, 807, 752, 0.0 );
			loaderBar_spr.addChild(lbg);
			var lb:LoaderBar = new LoaderBar();
			lb.x = 785;	lb.y = 42;
			loaderBar_spr.addChild(lb);
			addChild(loaderBar_spr);
			//
			//ClassLoader.init(this, "BannerRotatorAS3.swf" );
			//banners_mc = ClassLoader.createBannerManager();
			// Banners
			banners_mc = new BannerManager(this);
			addChild(banners_mc);
			// Копирайты
			contextMenu = Copyright.createContextMenu();	
			player_mc.addChild(Copyright.createTextCopyright());
		}
		public function onClassLoaded():void {
				trace('onClassLoaded');
		}
		//------------------------------------------------------------------------------------------- onAPI
		public function onUserProfile(e:Event):void {
			if (user_profile.uid) {
				removeEventListener(Event.ENTER_FRAME, onUserProfile);
				addEventListener(Event.ENTER_FRAME, onCityByIdCheck);
				user_profile.city = (user_profile.city == 0)?1:user_profile.city;
				user_profile.country = (user_profile.country == 0)?1:user_profile.country;
				VK.api('places.getCityById', { cids:user_profile.city }, vkApiRequest.fetchCityById, vkApiRequest.requestFail);
				//VK.api('places.getCountryById', { cids:user_profile.country }, vkApiRequest.fetchCountryById, vkApiRequest.requestFail);
			}	
		}
		public function onCityByIdCheck(e:Event):void {
			if (user_profile.city_name ) { //&& user_profile.country_name
				////////////
				banners_mc.onIntroBanner();
				////////////
				removeEventListener(Event.ENTER_FRAME, onCityByIdCheck);
				send_server.authUser(user_profile.first_name, user_profile.last_name, user_profile.sex, flashVars.user_id);
				/////////// Timer 1
				var minuteTimer:Timer = new Timer(1000, 2);
				minuteTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer1Complete);
				minuteTimer.start();
			}
		}
		private function onTimer1Complete(e:TimerEvent):void {
			VK.api('getFriends', null, vkApiRequest.fetchUserFriends, vkApiRequest.requestFail);
			VK.api('getGroupsFull', null, vkApiRequest.fetchUserGroupsFull, vkApiRequest.requestFail);
			player_mc.audioList_mc.menu_mc.changePage(0);
			/////////// Timer 2
			var minuteTimer:Timer = new Timer(1000, 2);
			minuteTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer2Complete);
			minuteTimer.start();
		}
		private function onTimer2Complete(e:TimerEvent):void {
			addEventListener(Event.ENTER_FRAME, onFriendsCheck);
		}
		public function onFriendsCheck(e:Event):void {
			if (user_friends[0] && user_audios[0]) {
				removeEventListener(Event.ENTER_FRAME, onFriendsCheck);
				player_mc.audioList_mc.onNext();
				var friends_string:String = [user_friends.slice(0,1000)].toString();
				VK.api('getProfiles', {uids:friends_string, fields:"uid,first_name,last_name,sex" }, vkApiRequest.fetchFriendsProfiles, vkApiRequest.requestFail);
			}
		}
		public function onAuthUser(data:Object):void {
			user_settings.cash = data.cash;
			user_settings.volume = 0.5;
			
			player_mc.bg_mc.imgLoader(data.bg_url as String);
			player_mc.setStarCount(user_settings.cash);
			player_mc.volumeBar_mc.setVolume(user_settings.volume);
			
			player_mc.menu_mc.changePage(0);
			player_mc.radioList_mc.menu_mc.changePage(0);
			player_mc.skinList_mc.menu_mc.changePage(0);
			player_mc.cabinetList_mc.menu_mc.changePage(0);
		}
		//////////////////////////////////////////////////////////////////////////////
		////---------------------------------------------------------------- Pay Cash
		//////////////////////////////////////////////////////////////////////////////
		public function payVotes(votes:uint):void {
			pay_votes = votes;
			loaderBar_spr.visible = true;
			VK.api('getUserBalance', null, vkApiRequest.fetchUserBalance, vkApiRequest.requestFail);
		}
		public function checkBalanse(balanse:uint):void {
			if (balanse >= pay_votes) {
				send_server.payVotes(pay_votes);
			} else {
				VK.callMethod('showPaymentBox',pay_votes/100);
			}
		}
	}
}