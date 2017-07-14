package starline.banners{

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.net.*;

	// http://starline-studio.com
	// Guzhva Andrey
	// 27.10.2010

	public class Banner extends MovieClip {

		public var link:String;
		
		public var loader:Loader = new Loader();
		public var request:URLRequest = new URLRequest();

		public function Banner(banner_url:String, link:String):void {

			this.link = link;
			this.buttonMode = true;
			request.url = banner_url;
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
			navigateToURL( new URLRequest(link), "_blank" );
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