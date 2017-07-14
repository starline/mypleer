package starline.player{

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;

	// http://starline-studio.com
	// Guzhva Andrey
	// 19.02.2010

	public class SkinBg extends Sprite {
		
		public var _root:*;
		
		private var eye_Timer:Timer;
		public var loader:Loader = new Loader();
		public var request:URLRequest = new URLRequest();
		
		public var eye_loader:Loader = new Loader();
		public var eye_request:URLRequest = new URLRequest();
		
		public function SkinBg(_root:*):void {
			this._root = _root;
			eye_Timer = new Timer(1000, 7);
			eye_Timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}
		public function imgLoader(url:String):void {
			
			request.url = _root.server_url + "skins/" + url;
			loader.load(request);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, displayPreloader);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, updatePreloader);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, displayImage);
		} 
		// обработчики событий
		private function displayPreloader(evt:Event):void {
			_root.loaderBar_spr.visible = true;
		}
		private function updatePreloader(evt:ProgressEvent):void {
			//loadStatus.text = "loaded:"+evt.bytesLoaded+" from "+evt.bytesTotal;
		}
		private function displayImage(evt:Event):void {
			loader.alpha = 0;
			addChild(loader);
			_root.loaderBar_spr.visible = false;
			addEventListener(Event.ENTER_FRAME, vanishing);
		}	
		private function vanishing(event:Event):void {
			if (loader.alpha < 1) {
				loader.alpha += 0.1;
			}else {
				removeEventListener(Event.ENTER_FRAME, vanishing);
			}
		}
		// Показать BG для ознакомления
		public function eyeImgLoader(url:String):void {
			eye_Timer.reset();
			eye_request.url = _root.server_url + "skins/" + url;
			eye_loader.load(eye_request);
			eye_loader.contentLoaderInfo.addEventListener(Event.OPEN, eye_displayPreloader);
			eye_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, eye_displayImage);
		} 
		private function eye_displayPreloader(e:Event):void {
			_root.loaderBar_spr.visible = true;
		}
		private function eye_displayImage(e:Event):void {
			eye_loader.alpha = 0;
			addChild(eye_loader);
			_root.loaderBar_spr.visible = false;
			addEventListener(Event.ENTER_FRAME, eye_vanishing);
		}	
		private function eye_vanishing(event:Event):void {
			if (eye_loader.alpha < 1) {
				eye_loader.alpha += 0.1;
			}else {
				removeEventListener(Event.ENTER_FRAME, eye_vanishing);
				eye_Timer.start();
			}
		}
		private function onTimerComplete(event:TimerEvent):void {
			addEventListener(Event.ENTER_FRAME, eye_vanishing_down);
		}
		private function eye_vanishing_down(event:Event):void {
			if (eye_loader.alpha > 0) {
				eye_loader.alpha -= 0.1;
			}else {
				removeEventListener(Event.ENTER_FRAME, eye_vanishing_down);
			}
		}
	}
}