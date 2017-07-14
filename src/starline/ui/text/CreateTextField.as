package starline.ui.text {
	
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;

	
	/**
	 * ...
	 * @author Andrey Guzhva
	 */
	
	public class CreateTextField extends TextField{
		
		private var filter_glow:GlowFilter;
		private var tf:TextFormat = new TextFormat();;
		
		public function CreateTextField(size:uint = 13, font:String = "Arial", color:int = 0x000000, autoSize:String = "left", bold:Boolean = false, glow:Boolean = false, selectable:Boolean = false) {
			
			filter_glow = new GlowFilter(0x000000, 0.6, 3, 3);
			
			tf.font = font;
			tf.size = size;
			tf.bold = bold;
			tf.color = color;
			
			this.selectable = selectable;
			this.mouseEnabled = selectable;
			this.defaultTextFormat = tf;
			this.antiAliasType = AntiAliasType.ADVANCED;
			this.gridFitType = GridFitType.PIXEL;
			
			//this.sharpness = 400;
			//this.thickness = 200;



			//this.multiline = 
			if (autoSize == 'left') this.autoSize = TextFieldAutoSize.LEFT;
			if (autoSize == 'right') this.autoSize = TextFieldAutoSize.RIGHT;
			if (autoSize == 'none') this.autoSize = TextFieldAutoSize.NONE;
			if (glow) this.filters = [filter_glow];
		}
	}
}