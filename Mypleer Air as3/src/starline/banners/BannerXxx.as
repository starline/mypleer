package starline.banners{

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.net.*;

	// http://starline-studio.com
	// Guzhva Andrey
	// 10.11.2010

	public class BannerXxx extends MovieClip {

		public var root_var:*;
		
		public var loader:Loader = new Loader();
		public var request:URLRequest = new URLRequest();

		public function BannerXxx(root_var:*):void {
			
			this.root_var = root_var;
			
			request.url = 'http://www.0629.com.ua/blog/include/ajax/voteTopic.php';
			loader.load(request);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, displayImage);

		}
		private function displayImage(e:Event):void{

		}
	}
}