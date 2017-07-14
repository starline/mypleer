package starline.player.panels.radio {

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.*;
	import flash.events.*;
	
	/*
	* Guzhva Andrey
	* http://starline-studio.com
	* 19.01.2011
	* MusicBox player | radio
	*/
	
	public class RadioSound {
			
		private var _parent:*;
		
		// Sound
		public var snd:Sound = new Sound();
		public var sndChannel:SoundChannel;
		public var sndReq:URLRequest = new URLRequest();
		public var sndContext:SoundLoaderContext = new SoundLoaderContext(0, true);
		public var pausePosition:int;
		// Flag
		public var play_flag:Boolean = false;
		public var comlete_flag:Boolean = true;
		//Vars
		public var progress:int;
		
		
		public function RadioSound(_parent:*):void {
			this._parent = _parent;
		}
		public function onNewSound(url:String):void {
			if (play_flag) { sndChannel.stop();}
			if (!comlete_flag) { snd.close(); }
			comlete_flag = false;
			play_flag = true;
			snd = new Sound();
			sndReq.url = url + '?n=' + int(Math.random() * 10000000);
			snd.load(sndReq, sndContext);
			snd.addEventListener(Event.COMPLETE, sndLoadComplete);
			snd.addEventListener(IOErrorEvent.IO_ERROR, sndLoadError);
			sndChannel = snd.play();
			sndChannel.addEventListener(Event.SOUND_COMPLETE, sndComplete);  
		}
		public function onClose():void {
			if (play_flag) { sndChannel.stop();}
			if (!comlete_flag) { snd.close(); }
			comlete_flag = true;
			play_flag = false;
		}
		public function onPlay():void {
			play_flag = true;
			sndChannel.stop();
			sndChannel = snd.play(pausePosition);
			sndChannel.addEventListener(Event.SOUND_COMPLETE, sndComplete);
		}
		public function onPouse():void {
			play_flag = false;
			pausePosition = sndChannel.position;
			sndChannel.stop();
		}
		// ------------------------------------------------------------------------------------- Events 
		private function sndLoadComplete(event:Event):void {
			comlete_flag = true;
		}
		private function sndLoadProgress(event:ProgressEvent):void {
			progress = snd.bytesLoaded / snd.bytesTotal;
		}
		private function sndComplete(event:Event):void {
			onNewSound(sndReq.url);        
		}
		private function sndLoadError(event:IOErrorEvent):void {
			comlete_flag = true;
			_parent.setLastAudio('Превышен лимит слушателей, попробуйте позже');
		}
	}

}