package com.hulstkamp.lab.astro.components
{
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * cheap Toggle Button 
	 * v 0.01
	 */
	public class ToggleButton extends Sprite
	{
		private var tf:TextField;
		private var textFormat:TextFormat;
		private var label:String;
		private var color:uint;
		private var toggleColor:uint;
		private var currentColor:uint;
		private var _data:Object;
		private var dsf:DropShadowFilter;
		private var _selected:Boolean;
		private var mw:int, mh:int;
		
		public function ToggleButton(label:String = null, color:uint = 0xf0f0f0, toggleColor:uint = 0xffffff, textFormat:TextFormat = null, minWidth:int = 100, minHeight:int = 20)
		{
			super();
			this.label = label;
			this.color = this.currentColor = color;
			this.toggleColor = toggleColor;
			this.textFormat = textFormat;
			this.mw = minWidth;
			this.mh = minHeight;
			init();
		}
		
		protected function init():void {
			tf = new TextField;
			tf.name = "textField";
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.selectable = false;
			tf.defaultTextFormat = textFormat;
			tf.text = label;
			tf.x = tf.y = 5;
			this.addChild(tf);
			this.buttonMode = true;
			this.mouseChildren = false;
			dsf = new DropShadowFilter();
			dsf.strength = .5;
			dsf.distance = 2;
			updateDisplay();
		}
		
		protected function toggle():void {
			if (_selected) {
				dsf.distance = 0;
				this.filters = [dsf];
				this.currentColor = toggleColor;
			} else {
				dsf.distance = 2;
				this.filters = [dsf];
				this.currentColor = color;
			}
			updateDisplay();
		}
		
		public function get selected():Boolean {
			return this._selected;
		}
		
		public function set selected(value:Boolean):void {
			this._selected = value;
			toggle();
		}
		
		public function get size():Object {
			return {width: Math.max(mw,tf.textWidth+15), height: Math.max(mh, tf.textHeight+15)};
		}
		
		protected function updateDisplay():void {
			var w:int = size.width;
			var h:int = size.height;
			tf.x = (w-tf.textWidth)/2-2;
			this.graphics.clear();
			this.graphics.beginFill (currentColor, 1);
			this.graphics.drawRoundRect(0,0, size.width, size.height, 10, 10);
			this.graphics.endFill();
			this.filters = [dsf];
		}
		
		public function get data ():Object {
			return _data;
		}
		
		public function set data (value:Object):void {
			this._data = value;
		}

	}
}