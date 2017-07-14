package starline.banners{

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.net.*;
	import com.f2fmedia.ads.F2FBanner;

	// http://starline-studio.com
	// Guzhva Andrey
	// 10.11.2010

	public class BannerF2f extends MovieClip {

		public var root_var:*;

		public function BannerF2f(root_var:*):void {
			
			this.root_var = root_var;
			
			/** убеждаемся что F2FAds.swc подключен,
			 * создаем экземпляр баннера и передаем конструктору place_id - идентификатор площадки
			 * вешаем слушатель на Event.COMPLETE,
			 * в нем вешаем слушатель на MouseEvent.CLICK (чтобы сработал только после загрузки баннера),
			 * там сами определяем каким образом будет осуществляться переход по ссылке, используя
			 * свойство link баннера (напрмер с помощью navigateToURL)
			 * */
			
			var banner:F2FBanner = new F2FBanner(26);
			banner.addEventListener(Event.COMPLETE, h_bannerLoadingComplete);
			banner.x = 30;
			addChild(banner);
		}
		private function h_bannerLoadingComplete(e:Event):void{
			// Слушатель события Event.COMPLETE
			var target:F2FBanner = e.currentTarget as F2FBanner;
			target.addEventListener(MouseEvent.CLICK, h_bannerClicked);
		}

		public function h_bannerClicked(e:MouseEvent):void{
			// Слушатель события MouseEvent.CLICK
			var target:F2FBanner = e.currentTarget as F2FBanner;
			navigateToURL(target.link, '_blank');
			root_var.send_Ads();
		}
	}
}