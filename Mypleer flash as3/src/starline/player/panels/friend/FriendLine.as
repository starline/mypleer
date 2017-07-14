package starline.player.panels.friend {
        
	import flash.display.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import starline.ui.simple.DrawRect;
	import flash.filters.GlowFilter; 
	import flash.events.*;
	
	/*
	* Guzhva Andrey
	* http://starline-studio.com
	* 07.01.2011
	* MusicBox player | radio
	*/
	
	public class FriendLine extends Sprite {
			
		private var _parent:*;
		
		// Vars
		public var n:int;
		public var idy:int;
		public var uid:int;
		public var first_name:String;
		public var last_name:String;
		public var sex:String;

		// Interface
		private var rollOverBg_sp:Sprite = new Sprite();
		private var clickBg_sp:Sprite = new Sprite();
		private var dclickBg_sp:Sprite = new Sprite();
		public var a_txt:TextField = new TextField();
		public var n_txt:TextField = new TextField();
		
		public function FriendLine(_parent:*, n:int, p:*):void {
			this._parent = _parent;
			this.n = n;
			this.uid = p.uid;
			this.first_name = p.first_name;
			this.last_name = p.last_name;
			this.sex = p.sex;

			createInterface();
			
			a_txt.htmlText = first_name+' '+last_name;
			
			// Listener
			dclickBg_sp.addEventListener(MouseEvent.ROLL_OVER, selectOver);
			dclickBg_sp.addEventListener(MouseEvent.ROLL_OUT, selectOut);
			dclickBg_sp.addEventListener(MouseEvent.CLICK, selectClick);
			dclickBg_sp.doubleClickEnabled  = true;
			dclickBg_sp.addEventListener(MouseEvent.DOUBLE_CLICK, selectDclick);
		}
		// ---------------------------------------------------------------------------------Listener
		// наведене мышки
		private function selectOver(event:MouseEvent):void { 
			rollOverBg_sp.alpha = 0.2;      
		}
		// отвидение мышки
		private function selectOut(event:MouseEvent):void { 
			rollOverBg_sp.alpha = 0.1;      
		}
		// нажатие на аудиозапись
		private function selectClick(event:MouseEvent):void { 
			_parent.onClick(n);
		}
		// двойное нажатие на аудиозапись
		private function selectDclick(event:MouseEvent):void { 
			_parent.onDclick(n);
		}
		public function onClick():void {
			clickBg_sp.alpha = 0.1;
		}
		public function onDclick():void {
			dclickBg_sp.alpha = 0.4;
		}
		public function unClick():void {
			clickBg_sp.alpha = 0;
		}
		public function unDclick():void {
			dclickBg_sp.alpha = 0;
		}
		// ------------------------------------------------------------------------------- Interface
		private function createInterface():void {
				
			rollOverBg_sp.graphics.beginFill(0xFFFFFF);
			rollOverBg_sp.graphics.drawRoundRect(0, 0, 260, 30, 5);
			rollOverBg_sp.graphics.endFill();
			rollOverBg_sp.alpha = 0.1;
			addChild(rollOverBg_sp);
			
			clickBg_sp.graphics.beginFill(0xFFFFFF);
			clickBg_sp.graphics.drawRoundRect(0, 0, 260, 30, 5);
			clickBg_sp.graphics.endFill();
			clickBg_sp.alpha = 0;
			addChild(clickBg_sp);
			
			dclickBg_sp.graphics.beginFill(0x0099FF);
			dclickBg_sp.graphics.drawRoundRect(0, 0, 260, 30, 5);
			dclickBg_sp.graphics.endFill();
			dclickBg_sp.alpha = 0;
			addChild(dclickBg_sp);
			
			var a_tf:TextFormat = new TextFormat();
			a_tf.font = "Arial";
			a_tf.size = 10;
			a_tf.bold = true;
			a_tf.color = 0x000000;
			a_txt.selectable = false;
			a_txt.mouseEnabled = false;
			//a_txt.autoSize = TextFieldAutoSize.LEFT;
			a_txt.defaultTextFormat = a_tf;
			a_txt.x = 5;   a_txt.y = 6;
			a_txt.height = 25;	a_txt.width = 250;
			addChild(a_txt);
		}
    }
}