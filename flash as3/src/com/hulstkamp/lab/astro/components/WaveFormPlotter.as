package com.hulstkamp.lab.astro.components
{
	import flash.display.Sprite;

	/**
	 * quick'n dirty plotter
	 * v 0.01
	 */
	public class WaveFormPlotter extends Sprite
	{
		private var pw:int;
		private var ph:int;
		
		private var lineColor:uint;
		private var gridColor:uint;
		private var bgColor:uint;
		
		private var grid:Sprite;
		
		public function WaveFormPlotter(w:int = 300, h:int = 200, bgColor:uint = 0x303030, gridColor:uint = 0x404040, lineColor:uint = 0x00ff00)
		{
			super();
			this.lineColor = lineColor;
			this.gridColor = gridColor;
			this.bgColor = bgColor;
			this.pw = w;
			this.ph = h;
			init();
		}
		
		protected function init():void {
			drawGrid();
		}
		
		protected function drawGrid():void {
			grid = new Sprite();
			grid.graphics.beginFill(bgColor, 1);
			grid.graphics.drawRoundRect (0,0, pw, ph, 10, 10);
			grid.graphics.endFill();
			grid.graphics.lineStyle(1, gridColor);
			grid.graphics.moveTo(0, ph/2);
			grid.graphics.lineTo(pw, ph/2);
			this.addChild(grid);
			
			var mask:Sprite = new Sprite();
			mask.graphics.beginFill (0xff0000,1);
			mask.graphics.drawRoundRect (0,0, pw, ph, 10, 10);
			mask.graphics.endFill();
			//masking seems to affect audio-play in beat after while (15sec)????
			//can't believe but seems so.
			//grid.mask = mask;
			//this.addChild(mask);
		}
		
		public function clear():void {
			grid.graphics.clear();
			drawGrid();
			resetPlot();
		}
		
		private function resetPlot():void {
			grid.graphics.moveTo (0, ph/2);
			grid.graphics.lineStyle(1, lineColor);
		}
		
		public function plot(x:Number, y:Number, maxAmp:Number, waveLength:Number):void {
			x *= pw / waveLength;
			y *= ph/2/maxAmp;
			grid.graphics.lineTo (x, ph/2 - y);
		}
	}
}