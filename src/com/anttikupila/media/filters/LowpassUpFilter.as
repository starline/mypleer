
/**
 * @Ported from http://www.musicdsp.org/archive.php?classid=3#235
 * @author Andrey Guzhva
 */

package com.anttikupila.media.filters {
	import com.anttikupila.media.SoundFX;	

	public class LowpassUpFilter implements IFilter {
		
		
		//---------------------------------------------------------------------
		//  Variables
		//---------------------------------------------------------------------
		
		protected var frgain : Number;
		protected var cap : Number;
		
		protected var ratio : Number;
		protected var frequency : Number;
		protected var gain : Number;
		
		protected var output : Number;
		private var channelCopy : LowpassUpFilter;
		
		
		//---------------------------------------------------------------------
		//  Constructor
		//---------------------------------------------------------------------
		
		public function LowpassUpFilter(frequency:Number = 60, ratio:Number = 1, gain:Number = 1) {
			frgain = cap = 0;
			
			this.ratio = ratio;
			this.frequency  = frequency;
			this.gain = gain;
			
			calculateParameters();
		}
		
		
		
		
		//---------------------------------------------------------------------
		//  Protected methods
		//---------------------------------------------------------------------
		
		protected function calculateParameters():void {
			frgain = 1.0 / (frequency + 1.0);
		}
		
		
		
		//---------------------------------------------------------------------
		//  Public methods
		//---------------------------------------------------------------------
		
		public function process(input:Number):Number {
			cap = (input + cap * frequency) * frgain;
			return saturate((input + cap * ratio) * gain);
		}
		
		
		/**
		 * saturate - подовлять
		 * Стабилизируем звук в диапазоен -1,0 1,0
		 */
		private function saturate(x:Number):Number {
			return Math.min(Math.max(-1.0, x), 1.0);
		}
		
		
		public function duplicate() : IFilter {
			channelCopy = new LowpassUpFilter();
			return channelCopy;
		}
		
		public function set setSelectivity(s:Number):void {
			frequency = s;
			calculateParameters();
		}
	}
}