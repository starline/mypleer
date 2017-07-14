package starline.ui {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Andrey Guzhva
	 */
	
	public class HelpWindow extends Sprite {
		
		private var selectHelp:String;
		public var help_txt:TextField = new TextField();
		public var delay:Timer = new Timer(500, 1); 
		
		public function HelpWindow() {
			
			delay.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComlete);
			// Всплывающее окно
			var t_tf:TextFormat = new TextFormat();
			t_tf.font = "Arial";
			t_tf.size = 12;
			t_tf.color = 0x000000;
			help_txt.selectable = false;
			help_txt.mouseEnabled = false;
			help_txt.autoSize = TextFieldAutoSize.LEFT;
            help_txt.background = true;
            help_txt.border = true;
			help_txt.visible = false;
			addChild(help_txt);
			
		}
		public function onAction(action:Boolean, selectHelp:String = ''):void {
			this.selectHelp = selectHelp;
			if (action) {
				delay.start();
			}
			if (!action) {
				removeEventListener(Event.ENTER_FRAME, upDate);
				delay.reset();
				help_txt.visible = false;
			}
		}
		private function onDelayComlete(event:TimerEvent = null):void {
			addEventListener(Event.ENTER_FRAME, upDate);
			help_txt.htmlText = selectHelp;
		}
		private function upDate(e:Event):void {
				help_txt.x = mouseX+20;
				help_txt.y = mouseY;
				help_txt.visible = true;
		}
		
	}

}