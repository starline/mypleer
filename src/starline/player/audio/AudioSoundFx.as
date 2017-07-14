package starline.player.audio {

	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.*;
	import flash.events.*;
	
	import com.anttikupila.media.SoundFX;
	import com.anttikupila.media.filters.LowpassUpFilter;
	
	/**
	 * @author 	Guzhva Andrey
	 * @date	16.02.2013
	 * @project Mypleer
	 */
	
	public class AudioSoundFx extends Sprite {
		
		// Sound
		public var snd:SoundFX = new SoundFX();
		public var sndReq:URLRequest = new URLRequest();
		public var sndContext:SoundLoaderContext = new SoundLoaderContext(0, true);
		
		// Sound Noise
		public var sndNoise:Sound = new Sound();
		public var sndChannelNoise:SoundChannel;
		public var sndTransform:SoundTransform = new SoundTransform(0.4, 0);
		
		// Filter
		public static const lowpassUp128:LowpassUpFilter = new LowpassUpFilter(128, 1.5, 1);
		public var fILTERS_ARR:Array = [lowpassUp128];
		
		// Flag
		public var play_flag:Boolean = false;
		public var comlete_flag:Boolean = true;
		public var radioFlag:Boolean = false;
		
		// Vars
		public var loadProgress:Number;
		public var pausePosition:int;
        public const AMP_MULTIPLIER:Number = 0.15;
		
		
		/**
		 * AudioSoundFx
		 */
		public function AudioSoundFx():void {
			// Конструктор
		}
		
		
		/**
		 * onNewSound
		 * Загружаем и воспроизводим новую аудиозапись
		 */
		public function onNewSound(url:String):void {
			if (radioFlag){
				destroyNoise();
				startNoise();
			}
			
			if (play_flag)
				snd.paused = true;
				
			if (!comlete_flag)
				snd.close();
			
			comlete_flag = false;
			play_flag = true;
			
			snd = new SoundFX();
			sndReq.url = (radioFlag) ? url+'?n='+int(Math.random()*10000000) : url;
			snd.load(sndReq, sndContext);
			
			snd.addEventListener(ProgressEvent.PROGRESS, sndLoadProgress, false, 0, true);
			snd.addEventListener(Event.COMPLETE, sndLoadComplete, false, 0, true);
			snd.addEventListener(Event.OPEN, sndLoadOpen, false, 0, true);
			snd.addEventListener(IOErrorEvent.IO_ERROR, sndLoadError, false, 0, true);
			
			// Add filters
			snd.filters = [];
			
			snd.play();
			snd.addEventListener(Event.SOUND_COMPLETE, sndComplete, false, 0, true); 
		}
		
		
		/**
		 * onClose
		 */
		public function onClose():void {
			if (play_flag)
				snd.paused = true;
				
			if (!comlete_flag) 
				snd.close();
				
			comlete_flag = true;
			play_flag = false;
		}
		
		
		/**
		 * onPlay
		 */
		public function onPlay():void {
			play_flag = true;
			snd.position = pausePosition;
			snd.paused = false;
			snd.addEventListener(Event.SOUND_COMPLETE, sndComplete, false, 0, true);
		}
		
		
		public function onPlayRound():void {
			snd.play();
			snd.addEventListener(Event.SOUND_COMPLETE, sndComplete, false, 0, true);
		}
		
		
		public function onPouse():void {
			play_flag = false;
			pausePosition = snd.position;
			snd.paused = true;
		}
		
		
		public function onPosition(scale:Number):void {
			if (play_flag) {
				pausePosition = scale * snd.getLength();
				onPlay();
			} else {
				pausePosition = scale * snd.getLength();
			}
		}
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////
		// ------------------------------------------------------------------------------------- Events
		///////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * sndLoadComplete
		 */
		public function sndLoadComplete(event:Event):void {
			comlete_flag = true;
		}
		
		
		/**
		 * sndLoadProgress
		 */
		public function sndLoadProgress(event:ProgressEvent):void {
			loadProgress = snd.bytesLoaded / snd.bytesTotal;
		}
		
		
		/**
		 * sndComplete
		 */
		public function sndComplete(event:Event):void {
			if (radioFlag) {
				onNewSound(sndReq.url);
			}
		}
		
		
		/**
		 * sndLoadError
		 */
		public function sndLoadError(event:IOErrorEvent):void {
			if (radioFlag) {
				destroyNoise();
				comlete_flag = true;
			} else {
				comlete_flag = true;
			}
		}
		
		
		/**
		 * sndLoadOpen
		 */
		public function sndLoadOpen(e:Event):void {
			if (radioFlag) {
				destroyNoise();
			}
		}
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////
		////------------------------------------------------------------------------------------------- Noise
		///////////////////////////////////////////////////////////////////////////////////////////////////////
		public function startNoise():void {
	  		sndNoise.addEventListener(SampleDataEvent.SAMPLE_DATA, noiseWave,false,0,true);
	  		sndChannelNoise = sndNoise.play();
			sndChannelNoise.soundTransform = sndTransform;
      	}
      	public function destroyNoise():void {
      		if (sndChannelNoise != null) {
	      		sndChannelNoise.stop();
	      		sndNoise.removeEventListener(SampleDataEvent.SAMPLE_DATA, noiseWave);
	      	}
      	}
		public function noiseWave(event:SampleDataEvent):void {
			var sample:Number;
			for (var i:int=0; i<8192; i++ ) {
				sample = Math.random() -.5; 
				event.data.writeFloat(sample * AMP_MULTIPLIER);
				event.data.writeFloat(sample * AMP_MULTIPLIER);
			}
  		}
	}
}