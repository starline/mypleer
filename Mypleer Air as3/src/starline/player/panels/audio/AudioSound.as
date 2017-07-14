package starline.player.panels.audio {

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
	
	public class AudioSound {
			
		private var _parent:*;
		
		// Sound
		public var snd:Sound = new Sound();
		public var sndChannel:SoundChannel;
		public var sndReq:URLRequest = new URLRequest();
		public var sndContext:SoundLoaderContext = new SoundLoaderContext(0, true);
		// Flag
		public var play_flag:Boolean = false;
		public var comlete_flag:Boolean = true;
		// Vars
		public var load_progress:Number;
		public var pouse_position:int;
		
		public function AudioSound(_parent:*):void {
			this._parent = _parent;
				
		}
		public function onNewSound(url:String):void {
			if (play_flag) { sndChannel.stop();}
			if (!comlete_flag) { snd.close(); }
			comlete_flag = false;
			play_flag = true;
			snd = new Sound();
			sndReq.url = url;
			snd.load(sndReq, sndContext);
			snd.addEventListener(ProgressEvent.PROGRESS, sndLoadProgress);
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
			sndChannel = snd.play(pouse_position);
			sndChannel.addEventListener(Event.SOUND_COMPLETE, sndComplete);
		}
		public function onPlayRound():void {
			sndChannel = snd.play();
			sndChannel.addEventListener(Event.SOUND_COMPLETE, sndComplete);
		}
		public function onPouse():void {
			play_flag = false;
			pouse_position = sndChannel.position;
			sndChannel.stop();
		}
		public function onPosition(scale:Number):void {
			if (play_flag) {
					pouse_position = scale * snd.length;
					onPlay()
			}else {
					pouse_position = scale * snd.length;
			}
		}
		// ------------------------------------------------------------------------------------- Events 
		private function sndLoadComplete(event:Event):void {
			comlete_flag = true;
		}
		private function sndLoadProgress(event:ProgressEvent):void {
			load_progress = snd.bytesLoaded / snd.bytesTotal;
			_parent.soundBar_mc.setPosition(load_progress);	
		}
		private function sndComplete(event:Event):void {
			if(_parent.audioList_mc.round_flag){
				onPlayRound();
			}else{
				_parent.audioList_mc.onNext();
			}
		}
		private function sndLoadError(event:IOErrorEvent):void {
			comlete_flag = true;
			_parent.setLastAudio('В данный момент сервер аудиозаписи недоступен');
		}
	}
}