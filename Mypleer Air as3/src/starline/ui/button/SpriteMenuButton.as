package starline.ui.button {
	
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	 
	import starline.player.components.MenuBtn;
  
	/**
	 * ...
	 * @author Andrey Guzhva
	 */
	
	public class SpriteMenuButton extends Sprite {
		
		public var _label:String = 'кнопка';
		private var _width:uint = 100;
		
		private var skin_mb:MenuBtn = new MenuBtn();
		private var bg_sp:Sprite = new Sprite();
		private var sbg_sp:Sprite = new Sprite();
		private var gloss_sp: Sprite = new Sprite();
		private var textFormat: TextFormat = new TextFormat();
		private var txt:TextField = new TextField();
		
		private var isSelected:Boolean = false;
		
		public var id:uint;
		public var panel:Sprite;
		
		public function SpriteMenuButton( label:String, width:uint):void {
			this._width = width;
			this._label = label;
			createBtn();
		}
		private function createBtn():void {
			bg_sp = skin_mb.bg;
			sbg_sp = skin_mb.select_bg;
			bg_sp.width = _width;
			sbg_sp.width = _width;
			sbg_sp.visible = false;
			addChild(bg_sp);
			addChild(sbg_sp);
			
			textFormat.font = "Arial";
			textFormat.size = 12;
			textFormat.bold = true;
			
			txt.wordWrap = false;
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.defaultTextFormat = textFormat;
			txt.htmlText = _label;
			txt.x = (_width - txt.textWidth) / 2;
			txt.y = 1;
			addChild(txt);
			
			gloss_sp.graphics.beginFill(0xFFFFFF);
			gloss_sp.graphics.drawRoundRect(0, 0, _width, 10, 0);
			gloss_sp.graphics.endFill();
			gloss_sp.alpha = 0.3;
			addChild(gloss_sp);
			
			buttonMode = true;
			useHandCursor  = true;
			
			addEventListener( MouseEvent.MOUSE_OVER, onOver );
			addEventListener( MouseEvent.MOUSE_OUT, onOut );
			
		}
		// ----------------------------------------------------------------- Internal methods.
		public function setSel( _s:Boolean ):void{
			isSelected = _s;
			isSelected ? sbg_sp.visible = true: sbg_sp.visible = false;
		}
		// ----------------------------------------------------------------- Mouse events.
		private function onOver( e:MouseEvent ):void{
			if ( !isSelected )
			sbg_sp.visible = true;
		}
    
		private function onOut( e:MouseEvent ):void{
			if ( !isSelected )
			setSel( isSelected );
		}	
	}

}