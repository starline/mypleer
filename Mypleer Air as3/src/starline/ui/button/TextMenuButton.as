package starline.ui.button {
	
	import flash.display.*;
	import flash.geom.ColorTransform;
	import flash.text.*;
	import flash.events.*;
	 
	import starline.player.components.MenuBtn;
  
	/**
	 * ...
	 * @author Andrey Guzhva
	 */
	
	public class TextMenuButton extends Sprite {
		
		private var _label:String = 'кнопка';
		private var _size:uint = 100;
		
		// Interface
		private var hit_mc:Sprite = new Sprite();
		private var bg_sp:Sprite = new Sprite();
		private var sbg_sp:Sprite = new Sprite();
		private var textFormat: TextFormat = new TextFormat();
		private var txt:TextField = new TextField();
		
		private var isSelected:Boolean = false;
		
		public var id:uint;
		public var panel:*;
		
		public function TextMenuButton( label:String, size:uint):void {
			this._label = label;
			this._size = size;
			createBtn();
		}
		private function createBtn():void {
			
			textFormat.font = "Arial";
			textFormat.size = _size;
			textFormat.color = 0xFFFFFF;
			txt.wordWrap = false;
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.defaultTextFormat = textFormat;
			txt.htmlText = _label;
			
			bg_sp.graphics.beginFill(0xFFFFFF);
			bg_sp.graphics.drawRoundRect(-3, 0, txt.width+6, txt.height, 5);
			bg_sp.graphics.endFill();
			bg_sp.alpha = 0.3;
			
			addChild(bg_sp);
			addChild(txt);
			
			this.buttonMode = true;
			this.useHandCursor  = true;
			
			addEventListener( MouseEvent.MOUSE_OVER, onOver );
			addEventListener( MouseEvent.MOUSE_OUT, onOut );
			
		}
		// ----------------------------------------------------------------- Internal methods.
		public function setSel( _s:Boolean ):void{
			isSelected = _s;
			txt.textColor = isSelected ? 0x0099FF: 0xFFFFFF;
		}
		// ----------------------------------------------------------------- Mouse events.
		private function onOver( e:MouseEvent ):void{
			if ( !isSelected )
			txt.textColor = 0x0099FF;
		}
    
		private function onOut( e:MouseEvent ):void{
			if ( !isSelected )
			setSel( isSelected );
		}	
	}

}