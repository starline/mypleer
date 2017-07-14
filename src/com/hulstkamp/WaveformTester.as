//
// Testing Flash 10 beta sound features
// fo whatever you want at your own risk. keep volumne down when
// experimenting 
//
package com.hulstkamp {
	import __AS3__.vec.Vector;
	
	import com.hulstkamp.lab.astro.components.ToggleButton;
	import com.hulstkamp.lab.astro.components.WaveFormPlotter;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	 [SWF(backgroundColor="0xf4f4f4", width="530", height="310")]
	 
	 /**
	 * quick setup to test flash 10 beta sound features
	 * gui is throwaway sondgenerators need optimization and
	 * refactoring 
	 * @author andy hulstkamp
	 * 
	 */
	 
	public class WaveformTester extends Sprite
	{
		public const AMP_MULTIPLIER:Number = 0.15;
		public const BASE_FREQ:int = 440;
		public const SAMPLING_RATE:int = 44100;
		public const TWO_PI:Number = 2*Math.PI;
		public const TWO_PI_OVER_SR:Number = TWO_PI/SAMPLING_RATE;
		
		private var phase:Number = new Number();
		private var freq:Number = BASE_FREQ;
		
		private var generatorFunctions:Vector.<Function> = new Vector.<Function>();
		private var activeGeneratorIndex:int = 0;
		
		private var sound:Sound = new Sound();
		private var soundChannel:SoundChannel;
		private	var isPlaying:Boolean;
		
		private var waveButtons:Array;
		
		private var desctf:TextField = new TextField();
		private var perftf:TextField = new TextField();
		
		private var t0:int;
		private var totalTime:int;
		private var tick:int;
		
		private var guiText:Array = new Array();
		private var plotter:WaveFormPlotter;
		
		public function WaveformTester()
		{
			init();
			initSounds();
		}
		
		protected function init():void {
			buildCrapGUI();
		}
		
		//throw together throwaway-gui
		protected function buildCrapGUI():void {
			
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.color = 0x404040;
			
			plotter = new WaveFormPlotter(310, 200, 0x303030, 0x606060, 0x88CC22);
			plotter.x = plotter.y = 10;
			this.addChild(plotter);
			plotter.visible = true;
			
			waveButtons = new Array();
			var labels:Vector.<String> = new Vector.<String>();
			labels.push ("Noise", "Sine", "Square1", "Square2", "Pulse", "AM-PWM Pulse", "Fkdp Pulse 1", "Fkdp Pulse 2");
			var xp:int = 10, yp:int = 60;
			for (var i:int = 0; i < labels.length; i++) {
				var btn:ToggleButton = new ToggleButton(labels[i], 0x88CC22, 0x99dd33, format, 48, 20);
				btn.x = xp;
				btn.y = stage.stageHeight - btn.height - yp;
				btn.data = {index: i};
				btn.addEventListener(MouseEvent.CLICK, waveTogglerHandler);
				this.addChild(btn);
				waveButtons[i] = btn;
				xp += btn.width + 10;
				if (xp > 300) {
					xp = 16;
					yp = 20;
				}
			}
			initUglyHardcodedText();			
		}
		
		private function initSounds():void {
			
			generatorFunctions[0] = noiseWave;
			generatorFunctions[1] = sineWave2;
			generatorFunctions[2] = squareWave1;
			generatorFunctions[3] = squareWave2;
			generatorFunctions[4] = pulseWave1;
			generatorFunctions[5] = pulseWaveMod1;
			generatorFunctions[6] = pulseWaveMod2;
			generatorFunctions[7] = pulseWaveMod3;
      	}
  		private function startSound():void {
	  		sound.addEventListener(Event.SAMPLE_DATA, dispatcher);
	  		soundChannel = sound.play();
	  		tick = 0;
	  		isPlaying = true;
      	}
      	
      	private function destroySound():void {
      		if (soundChannel != null) {
	      		soundChannel.stop();
	      		sound.removeEventListener(Event.SAMPLE_DATA, dispatcher);
	      	}
      	}
      	
      	private function waveTogglerHandler (event:MouseEvent):void {
      		var btn:ToggleButton = ToggleButton (event.currentTarget);
  			var index:int = btn.data.index;
      		if ((index == activeGeneratorIndex) && isPlaying) {
      			destroySound();
      			btn.selected = false;
      			isPlaying = false;
      			desctf.text = guiText[guiText.length-1];
      		} else {
      			ToggleButton (waveButtons[activeGeneratorIndex]).selected = false;
      			activeGeneratorIndex = index;
      			ToggleButton (waveButtons[activeGeneratorIndex]).selected = true;
      			destroySound();
      			startSound();
      			isPlaying = true;
      			desctf.text = guiText[activeGeneratorIndex];
      		}
      	}
      	
      	private function dispatcher(event:SampleDataEvent):void {
      		generatorFunctions[activeGeneratorIndex](event);
      	}
      	
      	private function plot(data:ByteArray, scaleAmp:Number = 1):void {
      		try {
	      		clearPlot();
	      		var waveLen:int = SAMPLING_RATE/BASE_FREQ;
	      		//offset is 2 * 4 (2 for stereo and 4 bytes/float);
	      		data.position -= 2 * 4 * waveLen;
	      		for (var x:Number = 0; x < waveLen; x++) {
	      			var sample:Number = (data.readFloat() + data.readFloat())/2;
	      			plotter.plot (x, sample, AMP_MULTIPLIER/scaleAmp, waveLen);
	      		}
	      	} catch(error:Error) {
	      		desctf.text = error.name + error.errorID;
	      	}
      	}
      	
      	private function plotWaveForm(x:Number, y:Number, maxAmp:Number, waveLen:Number):void {
      		plotter.plot(x, y, maxAmp, waveLen);
      	}
      	
      	private function clearPlot():void {
      		plotter.clear();
      	}
      	
      	private function updatePerformanceMeter(type:int):void{
      		if (type == 0) {
      			if (tick == 0) {
      				totalTime = 0;
      			}
      			t0 = getTimer();
      		} else {
      			totalTime += getTimer() - t0;
      			var d:Number = Math.round (totalTime/++tick*1000)/1000;
	      		perftf.text = "Time per 8192 samples: " + (d < 1 ? "<1" : d) + " ms";
      		}
      	}

      	private function enterCycle():void {
      		updatePerformanceMeter(0);
      	}
      	
      	private function exitCycle(event:SampleDataEvent, scale:Number = 1):void {
      		updatePerformanceMeter(1);
			plot(event.data, scale);
      	}
      	
		private function noiseWave(event:SampleDataEvent):void {
			enterCycle();
			var sample:Number;
			for (var i:int=0; i<8192; i++ ) {
				sample = Math.random() -.5; 
				event.data.writeFloat(sample * AMP_MULTIPLIER);
				event.data.writeFloat(sample * AMP_MULTIPLIER);
			}
			exitCycle(event);
  		}
  		
		private function sineWave1(event:SampleDataEvent):void {
			enterCycle();
			var sample:Number
			for (var i:int=0; i<8192; i++) {
		  		sample = Math.sin((i+event.position) * TWO_PI_OVER_SR * BASE_FREQ);
				event.data.writeFloat(sample * AMP_MULTIPLIER);
				event.data.writeFloat(sample * AMP_MULTIPLIER);
			}
			exitCycle(event, .5);
		}
  		
  		//same as above but explicitly keep track of phase
		private function sineWave2(event:SampleDataEvent):void {
			enterCycle();
			var sample:Number;
			for (var i:int; i < 8192; i++) {
				sample = Math.sin(phase);
				phase = phase + (TWO_PI_OVER_SR * BASE_FREQ);
				phase = phase < TWO_PI ? phase : phase - TWO_PI;
				event.data.writeFloat(sample * AMP_MULTIPLIER);
				event.data.writeFloat(sample * AMP_MULTIPLIER);
			}
			exitCycle(event, .5);
		}
		
		//the square wave implemented via sine, duty cycle for a square is 1:2
		private function squareWave1(event:SampleDataEvent):void {
			enterCycle();
			//get this out
			var amp:Number = 0.075;
			var sample:Number;
			for (var i:int=0; i<8192; i++) {
		  		sample = Math.sin((i + event.position) * TWO_PI_OVER_SR * BASE_FREQ) > 0  ? amp : -amp;
				event.data.writeFloat(sample);
				event.data.writeFloat(sample);
			}
			exitCycle(event);
		}
		
		//Square wave using explicit phase, getting rid of sine gives better performance
		private function squareWave2(event:SampleDataEvent):void {
			enterCycle();
			// get this out
			var amp:Number = 0.075;
			var sample:Number;
			for (var i:int; i < 8192; i++) {
				sample = phase < Math.PI ? amp : -amp;
				phase = phase + (TWO_PI_OVER_SR * BASE_FREQ);
				phase = phase > TWO_PI ? phase-TWO_PI : phase;
				event.data.writeFloat(sample);
				event.data.writeFloat(sample);
			}
			exitCycle(event);
		}
		
		//pulse wave with a dc of 1/5
		private function pulseWave1(event:SampleDataEvent):void {
			enterCycle();
			// get this out
			var amp:Number = 0.075;
			var pw:Number = TWO_PI * .2;
			var sample:Number;
			for (var i:int; i < 8192; i++) {
				sample = phase < pw ? amp : -amp;
				phase = phase + (TWO_PI_OVER_SR * BASE_FREQ);
				phase = phase > TWO_PI ? phase-TWO_PI : phase;
				event.data.writeFloat(sample);
				event.data.writeFloat(sample);
			}
			exitCycle(event);
		}
		
		//modulated pulse, one lfo modulates pulse-width, another one the amplitude
		private function pulseWaveMod1(event:SampleDataEvent):void {
			enterCycle();
			// get those out
			var amp:Number = 0.075;
			var pwr:Number = Math.PI/1.05;
			var dpw:Number;
			var am:Number;
			var pos:Number;
			var sample:Number;
			for (var i:int=0; i<8192; i++) {
				pos = i + event.position;
				dpw = Math.sin (pos/0x4800) * pwr; //LFO -> PW
		  		sample = phase < Math.PI - dpw ? amp : -amp;
				phase = phase + (TWO_PI_OVER_SR * BASE_FREQ);
				phase = phase > TWO_PI ? phase-TWO_PI : phase;
		  		am = Math.sin (pos/0x1000); //LFO -> AM
				event.data.writeFloat(sample * am);
				event.data.writeFloat(sample * am);
			}
			exitCycle(event);
		}
		
		//modulated pulse, lfo modulates pulse-width, another one the amplitude
		//Pulse generated via sine, loosing in perfomrance, better implementation above
		private function pulseWaveMod2(event:SampleDataEvent):void {
			enterCycle();
			// get those out
			var sample:Number;
			var amp:Number = 0.075;
			var pw:Number;
			var am:Number;
			var pos:Number;
			var freq:int = 2 * BASE_FREQ;
			for (var i:int=0; i<8192; i++) {
				pos = i + event.position;
				//LFO, but starting above the fundamental Freq. Introduces another
				//sound in hearing range, then Frequencey slowly passes out of HR
				pw = Math.sin (pos * TWO_PI_OVER_SR * 2 * freq/(1+pos/0x8ffff));
		  		sample = Math.sin(pos * TWO_PI_OVER_SR * freq) > pw ? amp : -amp;
		  		am = Math.sin (pos/0x1000); //LFO -> AM
				event.data.writeFloat(sample * am);
				event.data.writeFloat(sample * am);
			}
			exitCycle(event);
		}
		
		//modulated pulse, lfo modulates pulse-width, another one the amplitude, pw is fed
		//into modulation of am-frequency
		//Pulse generated via sine, loosing in perfomrance, better implementation above
		private function pulseWaveMod3(event:SampleDataEvent):void {
			enterCycle();
			// get those out
			var amp:Number = 0.075;
			var dc:Number = 1/2;
			var pw:Number = TWO_PI*dc;
			var freq:int = 2 * BASE_FREQ;
			var am:Number;
			var pos:Number;
			var sample:Number;
			var offset:int = Math.random() * 3 + 1;
			for (var i:int=0; i<8192; i++) {
				pos = i + event.position;
				//Same as above but random shifts in octaves
				pw = Math.sin (pos * TWO_PI_OVER_SR * offset * freq/(1+pos/0xffff));
		  		sample = Math.sin(pos * TWO_PI_OVER_SR * 1/offset * freq/offset) > pw ? amp : -amp;
		  		am =  Math.sin (pos/0x2000/(pw+2)); //LFO -> AM, Frequency modulated by PW
				event.data.writeFloat(sample * am);
				event.data.writeFloat(sample * am);
			}
			exitCycle(event);
		}
		
		private function initUglyHardcodedText():void {
			
			guiText[0] = "Noise: Although not sounding very exciting, treat it nicely. " + 
					"Combined with filters and modulation it makes a great source for percussive sounds."; 
			guiText[1] = "Sine: Pure waveform, no harmonics. Almost every waveform can " + 
					"be built by combining sine waves of different lengths."; 
			guiText[2] = "Square: Special form of a pulse, with a duty cycle of 1:2. " + 
					"Base for many cool tunes on retro consoles."
			guiText[3] = "Square 2: Different implementation to Square 1. Same wave, same sound but better performance"
			guiText[4] = "Pulse: Rich in sound with a couple of harmonics. Sounds from hollow to nasal depending on the " + 
					"duty cycle (let’s just say the ratio of the upper rectangle’s width to wavelength). " + 
					"If you ever listened to Martin Galway’s SID-Music then you know what a pulse wave can do!";
			guiText[5] = "AM:-PWM Pulse: two LFO’s (Oscillator that operates [far] below " + 
					"hearing range). One modulates the pulse-width, the other one the amplitude. " + 
					"Now the frequency and the amplitude of the LFO’s could be modulated too, would make things less static.";
			guiText[6] = "FKDP-Pulse 1:  One Oscillator simply modulates the amplitude, " + 
					"thus the tremelo. Another Oscillator modulates the pulse-width: " + 
					"But this time it starts one octave above the base-frequency. " + 
					"So pulse-width-modulation is in hearing range. " + 
					"It’s frequency is then slowly decreased until it goes well under 20Hz" + 
					" and out of the hearing range. If you wait long enough the sound will develop into " + 
					"something similar to the the AM-PWM Square example. Go get a cup of tea."
			guiText[7] = "FKDP-Pulse 2: This pulse is in serious trouble! Same as " + 
					"FKDP-Square but this time the signal of the pulse-width-modulator is fed " + 
					"into the am-modulator too. To get things even worse, " + 
					"frequencies are randomly shifted by a couple of octaves."
			guiText[8] = "The plot is far from accurate. " + 
					"Only on cycle per SampleDataEvent is drawn. Proportions are not correct, however enough to get an idea of the shape."


			var tfFormat:TextFormat = new TextFormat();
			tfFormat.size = 10;
			tfFormat.color = 0x505050;
			tfFormat.font = "Verdana";
			tfFormat.letterSpacing = 0;
			tfFormat.kerning
			desctf.defaultTextFormat = tfFormat;
			desctf.text = guiText[guiText.length-1];
			desctf.width = 200;
			desctf.height = 200;
			desctf.wordWrap = true;
			desctf.x = 323;
			desctf.y = 10;
			this.addChild(desctf);
			
			tfFormat.color = 0xc08020;
			perftf.defaultTextFormat = tfFormat;
			perftf.text;
			perftf.autoSize = TextFieldAutoSize.LEFT;
			perftf.x = 15; 
			perftf.y = 192;
			this.addChild(perftf);
		}
	}
}
