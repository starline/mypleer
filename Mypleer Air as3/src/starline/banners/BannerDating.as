package starline.banners{

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.net.*;

	// http://starline-studio.com
	// Guzhva Andrey
	// 27.10.2010

	public class BannerDating extends MovieClip {

		public var loader:Loader = new Loader();
		public var request:URLRequest = new URLRequest();

		public function BannerDating(banner_url:String, user_profile:Object):void {
			
			var gender:String;
			(user_profile.sex == 1)?gender = 'm':gender = 'f';
			request.url = banner_url + '&first_name=' + user_profile.first_name + '&sex=' + user_profile.sex + '&gender=' + gender + 
			'&bdate=' + user_profile.bdate + '&photo_url=' + user_profile.photo_medium;
			
			/*в баннер нужно передавать 
			flashVars
			ref_id - реф-ид
			first_name - юзернейм
			sex - пол юзернейма
			gender - пол ботов
			bdate - дата рождения
			photo_url - фотка

			gender - пол ботов
			m - показывать мальчиков
			f - показывать девочек*/
			
			loader.load(request);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, displayImage);
			// -------------------------------------------------------------------------Btn
			addEventListener(MouseEvent.ROLL_OVER, select_over);
			addEventListener(MouseEvent.ROLL_OUT, select_out);
			addEventListener(MouseEvent.CLICK, select_clik);
		}
		private function select_over(event:MouseEvent):void {
			//
		}
		private function select_out(event:MouseEvent):void {
			//
		}
		private function select_clik(event:MouseEvent):void {
			//
		}
		// -------------------------------------------------------- loader
		private function displayImage(evt:Event):void {
			loader.alpha = 0;
			addChild(loader);
			addEventListener(Event.ENTER_FRAME, vanishing);
		}
		private function vanishing(event:Event):void {
			if (loader.alpha < 1) {
				loader.alpha += 0.1;
			}else {
				removeEventListener(Event.ENTER_FRAME, vanishing);
			}
		}
	}
}