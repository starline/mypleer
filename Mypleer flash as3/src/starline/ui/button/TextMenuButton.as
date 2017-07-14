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
		private var _size:uint = 13;
		
		// Interface
		private var bgOut_mc:Sprite = new Sprite();
		private var bgOver_mc:Sprite = new Sprite();
		private var gloss_mc:Sprite = new Sprite();
		private var textFormat: TextFormat = new TextFormat();
		private var txt:TextField = new TextField();
		
		private var isSelected:Boolean = false;
		
		public var id:uint;
		public var panel:*;
		
		public function TextMenuButton( label:String, size:uint= 13, x:int = 0, y:int = 0):void { 
			this._label = label;
			this._size = size;
			this.x = x;
			this.y = y;
			createBtn();
		}
		private function createBtn():void {
			
			textFormat.font = "Arial";
			textFormat.size = _size;
			textFormat.color = 0x000000;
			textFormat.bold = true;
			txt.wordWrap = false;
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.defaultTextFormat = textFormat;
			txt.x = 3;
			txt.htmlText = _label;
			
			bgOut_mc.graphics.beginFill(0xE0D18C);
			bgOut_mc.graphics.drawRoundRect(0, 0, txt.width+6, txt.height, 5);
			bgOut_mc.graphics.endFill();
			//bgOut_mc.alpha = 0.4;
			
			bgOver_mc.graphics.beginFill(0x009900);
			bgOver_mc.graphics.drawRoundRect(0, 0, txt.width+6, txt.height, 5);
			bgOver_mc.graphics.endFill();
			bgOver_mc.visible = false;
			
			gloss_mc.graphics.beginFill(0xFFFFFF);
			gloss_mc.graphics.drawRoundRect(0, 0, txt.width+6, txt.height/2, 5);
			gloss_mc.graphics.endFill();
			gloss_mc.alpha = 0.2;
			
			addChild(bgOut_mc);
			addChild(bgOver_mc);
			addChild(txt);
			addChild(gloss_mc);
			
			this.buttonMode = true;
			this.useHandCursor  = true;
			
			addEventListener( MouseEvent.MOUSE_OVER, onOver );
			addEventListener( MouseEvent.MOUSE_OUT, onOut );
			
		}
		////////////////////////////////////////////////////////////////////////////////////////
		//// ----------------------------------------------------------------- Internal methods.
		////////////////////////////////////////////////////////////////////////////////////////
		public function setSel( _s:Boolean ):void{
			isSelected = _s;
			txt.textColor = isSelected ? 0xFFFFFF: 0x000000;
			bgOver_mc.visible = isSelected ? true: false;
		}
		////////////////////////////////////////////////////////////////////////////////////////
		//// --------------------------------------------------------------------- Mouse events.
		////////////////////////////////////////////////////////////////////////////////////////
		private function onOver( e:MouseEvent ):void{
			if ( !isSelected )
			txt.textColor = 0xFFFFFF;
			bgOver_mc.visible = true;
		}
    
		private function onOut( e:MouseEvent ):void{
			if ( !isSelected )
			setSel( isSelected );
		}	
	}

}