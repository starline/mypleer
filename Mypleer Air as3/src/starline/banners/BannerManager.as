package starline.banners {
	
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.system.*;
	import flash.utils.Timer;
	import starline.ui.button.DrawRect;
	
	/**
	 * ...
	 * @author Andrey Guzhva
	 */
	
	public class BannerManager extends Sprite {
		
		public var _root:*;
				
		public var banner_delay:Timer = new Timer(60000, 1);		// скорость ротации баннеров
		public var banner_box:Sprite = new Sprite();
		public var banner_links:BannersLinks = new BannersLinks();
		
		public function BannerManager(_root:*) {
			this._root = _root;
			banner_delay.addEventListener(TimerEvent.TIMER_COMPLETE, bannerManager);
		}
		/////////////////////////////////////////////////////////////////////////////////////////
		////
		/////////////////////////////////////////////////////////////////////////////////////////
		public function onFooterBanner():void {
			var banner_podval:bannerPodval = new bannerPodval('http://w01.mobmental.com/banner/', 123255, _root.flashVars.viewer_id);
			banner_podval.y = 592;
			banner_podval.x = 37;
			addChild (banner_podval);
		}
		public function onIntroBanner():void {
			var banner_intro:BannerIntro = new BannerIntro("http://w01.mobmental.com/banner/", 123270, _root.flashVars.viewer_id);
			banner_intro.y = 0;
			banner_intro.x = 0;
			addChild (banner_intro);
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////
		////------------------------------------------------------------------- ТОП БАННЕР 728х90
		/////////////////////////////////////////////////////////////////////////////////////////
		public function onTopBannerRotator():void {
			// Set Mask
			var banner_mask:DrawRect = new DrawRect(0x000000, 728, 90);
			addChild(banner_mask);
			banner_box.mask = banner_mask;
			addChild(banner_box);
			bannerManager();	
		}
		public function bannerManager(e:TimerEvent = null):void {
			if (banner_box.numChildren > 0) { banner_box.removeChildAt(0); }
			
			var banner_arr:Array = banner_links.getBannersArr()
			var max:uint = banner_arr.length-1;
			var min:uint = 0;
			var random:uint = Math.floor(Math.random() * (max - min + 1)) + min;// случайное число от (min) и до (max)
			var link:String = banner_arr[random][1]; 
			var banner_url:String = banner_arr[random][0];
			
			if (banner_arr[random][1] == '0') {// Запускаем баннер от фотострана дейтинг v1
				var bannerDating_mc:BannerDating = new BannerDating(banner_url, _root.user_profile);
				banner_box.addChild(bannerDating_mc);
			}else if (banner_arr[random][1] == '2') {// Запускаем баннер от фотострана дейтинг v2
				var bannerDating2_mc:BannerDating2 = new BannerDating2(banner_url, _root.user_profile);
				banner_box.addChild(bannerDating2_mc);
			}else{// Запускаем баннер + ссылка сверху
				var banner_mc:Banner = new Banner(banner_url, link);
				banner_box.addChild(banner_mc);
			}
			banner_delay.start();
		}
	}
}