package{
	
	import adobe.utils.CustomActions;
	import starline.player.panels.other.GetBonusEx;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.*;
	
	import fm.last.DataAccessEvent;
	import fm.last.LastFMDataProvider;
	
	import starline.*;
	import starline.effects.*;
	import starline.player.*;
	import starline.player.Main;
	import starline.player.components.LoaderBar;
	import starline.server.ServerApi_2;
	import starline.ui.*;
	import starline.ui.simple.DrawRect;
	import starline.utils.*;
	import starline.utils.external.External;
	import starline.player.sms.SmsInformer;
	
	import vk.APIConnection;
	import vk.events.CustomEvent;
	import vk.api.serialization.json.JSON;
	import vk.gui.Box;
	
	/**
	 * @author 	Andrey Guzhva (http://aguzhva.com)
	 * @date 	14.10.2012
	 * @project Mypleer | VK APP
	 */
	
	[SWF(width="807",height="625")]
	
	public class MainVK extends Main {
		
		// Helper Vars
		public var memController:MemoryController;
		public var frameRateControll:Framerate;
		
		// User Info
		public var skins:Array = new Array();
		public var user_settings:Object = new Object;
		public var user_profile:Object = new Object();
		
		// Server Class
		public var MP:ServerApi_2;
		public var mpApiRequest:MpApiRequest;
		
		// Static Vars
		public const APP_TYPE:String = 		'VK APP';
		public const APP_VERSION:String = 	'3.8.2';
		
		// Flash Vars. Объект для переменнных FlashVars
		public var flashVars:Object = new Object();
		
		// VK API Class
		public var VK:APIConnection;
		public var vkApiRequest:VkApiRequest;
		public var vkCallMethod:External;
		
		// Other Vars
		private var pay_votes:uint;
		public var date:Date = new Date();
		
		// Interface
		public var player_mc:Player;
		public var smsInformer_mc:SmsInformer;
		public var loaderBar_spr:Sprite = new Sprite();
		
		
		
		
		/**
		 * MainVK
		 * Constructor
		 */
		public function MainVK():void {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		
		/**
		 * init
		 * Запускаем приложение
		 */
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Собираем FlashVars
			flashVars = stage.loaderInfo.parameters as Object;
			
			// Если нет айди приложения, значит запустили локально
			if (!flashVars.api_id) {
				flashVars['api_url'] = 'http://api.vk.com/api.php';
				
				
// -- Your code for local testing:
flashVars['api_id'] = 2650242;
flashVars['viewer_id'] = 8570293;
flashVars['sid'] = "a74ef1cd8d38f3d1d3baadd31c26856b70e7cd0cbd6d0ed936093542ba9d1c1af30d98dd361191c9b9489";
flashVars['secret'] = "8c919d7d0c";
// -- //

				
				setInitialSattings();
				
				// First Request
				VK.api('getProfiles', {uids: flashVars.viewer_id, fields: "uid,first_name,last_name,sex,bdate,city,country,photo_medium"}, onUserProfile, vkApiRequest.requestFail);
				loaderBar_spr.visible = true;
				
				
			} else {
				setInitialSattings();
				CheckSettings();
			}
		}
		
		
		
		
		/**
		 * CheckSettings
		 * Проверем минимальные настройки приложения у пользователя
		 */
		private function CheckSettings():void {
			if (flashVars.is_app_user == 0) {
				External.call('showInstallBox');
			} else if ((flashVars.api_settings & 10) == 10) {
				fetchApiResult();
			} else {
				vkCallMethod.showSettingsBox(267);
			}
		}
		
		
		
		/**
		 * fetchApiResult
		 * Обрабатываем result
		 */
		private function fetchApiResult():void {
			if (flashVars['api_result']) {
				var data:Object = JSON.decode(flashVars['api_result']);
				if (data.response || data.response == 0) {
					
					// First Request
					onUserProfile(data.response);
				} else {
					MP.api('save_error', {error: APP_TYPE + "." + APP_VERSION + ".VK.API.Result:" + data}, function():void{});
				}
			} else {
				MP.api('save_error', {error: APP_TYPE + "." + APP_VERSION + ".VK.API. Failure api_result"}, function():void{});
			}
		}
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////
		//------------------------------------------------------------------------ InitialSattings
		///////////////////////////////////////////////////////////////////////////////////////////
		private function setInitialSattings():void {
			
			// Security
			Security.allowDomain("*");
			
			// CallMethod
			vkCallMethod = new External(this);
			
			// VK API
			VK = new APIConnection(flashVars);
			vkApiRequest = new VkApiRequest(this);
			
			// MP Server Api
			MP = new ServerApi_2(APP_ID, flashVars['viewer_id'], APP_SECRET, MP_API_URL);
			mpApiRequest = new MpApiRequest(this);
			
			// Player 
			player_mc = new Player(this);
			player_mc.y = 33;
			addChild(player_mc);
			
			// SmsInformer
			smsInformer_mc = new SmsInformer(this);
			addChild(smsInformer_mc);
			smsInformer_mc.x = 3;
			smsInformer_mc.y = 0;
			
			// LoaderBar
			var lbg:DrawRect = new DrawRect(0xFFFFFF, 807, 752, 0.0);
			loaderBar_spr.addChild(lbg);
			var lb:LoaderBar = new LoaderBar();
			lb.x = 780;
			lb.y = 85;
			loaderBar_spr.addChild(lb);
			addChild(loaderBar_spr);
			
			// Copyright
			contextMenu = Copyright.createContextMenu(APP_TYPE + ' ' + APP_VERSION);
			player_mc.addChild(Copyright.createTextCopyright());
		}
		
		
		
		/**
		 * onUserProfile
		 * Формируем данные пользователя для выборки его настроек
		 */
		public function onUserProfile(data:Object):void {
			this.user_profile = data[0];
			
			// Age by Bdate
			if (user_profile.bdate) {
				var bDate_arr:Array = user_profile.bdate.split('.');
				if (!bDate_arr[2]){
					bDate_arr[2] = 0;
				} if (!bDate_arr[1]){
					bDate_arr[1] = 0;
				} if (!bDate_arr[0]){
					bDate_arr[0] = 0;
				}
				var age:uint = date.fullYear - bDate_arr[2];
				
				user_profile.age = age;
				user_profile.bdate_ymd = bDate_arr[2] + '-' + bDate_arr[1] + '-' + bDate_arr[0];
			} else {
				user_profile.age = 0;
				user_profile.bdate_ymd = 0;
				user_profile.bdate = 0;
			}
			
			user_profile.city = (!user_profile.city) ? 0 : user_profile.city;
			user_profile.country = (!user_profile.country) ? 0 : user_profile.country;
			user_profile.sex = (!user_profile.sex) ? 0 : user_profile.sex;
			
			// user_id
			flashVars['user_id'] = (flashVars['user_id']) ? flashVars['user_id'] : 0;
			
			loaderBar_spr.visible = true;
			MP.api(
				'user_auth',
				{
					first_name: user_profile.first_name,
					last_name: user_profile.last_name,
					sex: user_profile.sex,
					bdate: user_profile['bdate_ymd'],
					fid: flashVars['user_id'],
					city_name: user_profile.city,
					country_name: user_profile.country
				},
				fetchAuthUser,
				mpApiRequest.requestFail
			);
		}
		
		
		/*** fetchAuthUser ***/
		public function fetchAuthUser(data:Object):void {
			
			// Visual Settings
			player_mc.addFriends_btn.visible = false;
			player_mc.app_settings_arr['station_post'] = true;
			player_mc.app_settings_arr['rating_btn'] = true;
			
			// Default volume
			user_settings.volume = 0.5;
			
			player_mc.bg_mc.imgLoader(data.bg_url as String);
			player_mc.setStarCount(data.cash);
			player_mc.volumeBar_mc.setVolume(user_settings.volume);
			player_mc.menu_mc.changePage(data.cur_page, false);
			player_mc.app_settings_arr['main_page'] = data.cur_page;
			
			// Start SmsInformer
			smsInformer_mc.init();
			
			// last.fm
			login(data.login, data.password);
			
			// getBonus
			getBonus();
		}
		
		
		
		
		////////////////////////////////////////////////////////////////////////////
		////--------------------------------------------------------------- getBonus
		////////////////////////////////////////////////////////////////////////////
		public function getBonus():void {
			loaderBar_spr.visible = true;
			VK.api(
				'friends.getAppUsers',
				null,
				function (data: Object): void {
					
					// Если ответ не array
					if (data as Array == null) {
						data = new Array();
					}
					
					user_profile.app_friends = data as Array;
					MP.api(
						'star_bonus',
						{app_friends_count: user_profile.app_friends.length},
						function (data: Object): void {
							loaderBar_spr.visible = false;
							if (data != "0") {
								player_mc.setStarCount(data.cash);
								
								var starBonusCount:GetBonusEx = new GetBonusEx(player_mc, data);
								var popUp_mc:Box = new Box(
									"Поздравляю! Вы заработали бонус :)",
									starBonusCount,
									50,
									600,
									["Закрыть"]
								);
								
								popUp_mc.setVisible(true);
								addChild(popUp_mc);
							}
						},
						mpApiRequest.requestFail
					);
				},
				vkApiRequest.requestFail
			);
		}
		
		
		
		
		////////////////////////////////////////////////////////////////////////////
		////---------------------------------------------------------------- LastFM
		////////////////////////////////////////////////////////////////////////////
		private function login(login:String, password:String):void {
			if (login != "0" && password != "0"){
				var token:String = MD5.encrypt(login.toLowerCase() + password);
				LastFMDataProvider.getInstance().addEventListener(LastFMDataProvider.LF_GET_SESSION, onGetSession);
				LastFMDataProvider.getInstance().lf_getSession(login, token);
			}
		}
		
		
		private function onGetSession(e:DataAccessEvent):void {
			LastFMDataProvider.getInstance().removeEventListener(LastFMDataProvider.LF_GET_SESSION, onGetSession);
			LastFMDataProvider.KEY = e.data.session.key;
			player_mc.cabinetList_mc.lastFMLogin.changeFrame();
		}
	}
}