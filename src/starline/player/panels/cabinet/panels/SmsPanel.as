package starline.player.panels.cabinet.panels {
	

	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import vk.gui.Box;
	
	
	import starline.player.components.Sms;
	
	public class SmsPanel extends Sms{
		
		public var _root:*;
		
		//Static
		public static var SMS_VALUE:int = 30;
		public static var MAX_CHARS:int = 75;
		
		public function SmsPanel(_root:*){
			super();
			this._root = _root;
			
			// Config
			count.text = String(MAX_CHARS);
			count.autoSize = TextFieldAutoSize.LEFT;
			text.maxChars = MAX_CHARS;
			
			smsBtn.addEventListener(MouseEvent.CLICK,  onSmsBtn);
			text.addEventListener(Event.CHANGE, changeHandler);
		}
		
		
		/**
		 * onSmsBtn 
		 */
		private function onSmsBtn(e:MouseEvent):void {
			if (text.text.length > 0) {
				if (_root.user_settings.cash >= SMS_VALUE) { 
					_root.MP.api('sms_send', {text:text.text}, fetchSmsSend, _root.mpApiRequest.requestFail);
					_root.loaderBar_spr.visible = true;
				} else {
					showNoCash();
				}
			}else {
				var popUp2_mc:Box = new Box( "Будьте внимательны!",
				"Чтобы вас услышали, введите текст привета."
				, 200, 600, ["Закрыть"] );
				popUp2_mc.setVisible(true);
				_root.addChild(popUp2_mc);
			}
		}
		
		
		/**
		 * fetchSmsSend
		 */
		private function fetchSmsSend(data:Object):void {
			_root.loaderBar_spr.visible = false;
			if (data != "0") {
				_root.player_mc.setStarCount(data.cash);
				
				var popUp_mc:Box = new Box(
					"Ваше сообщение увидит весь мир!",
					"Сообщение будет опубликовано в <b>" + data.public_time + "</b> по Москве.<br>"
					, 150, 600, ["Закрыть"]
				);
					
				popUp_mc.setVisible(true);
				_root.addChild(popUp_mc);
			} else {
				showNoCash();
			}
		}
		
		
		/**
		 * changeHandler
		 */
		private function changeHandler(e:Event):void {
            count.text = String(MAX_CHARS - text.length);
			if (text.length > MAX_CHARS - 10) {
				count.textColor = 0xFFFFFF;
				count.backgroundColor = 0xCC0600;
				count.background = true
			}else {
				count.background = false;
				count.textColor = 0x000000;
			}
        }
		
		
		/**
		 * onBoxButtonClicked
		 */
		private function onBoxButtonClicked( e:Event ):void{
            if ((e.target.buttonClickedIndex) == 0) {
                _root.player_mc.setCabinetPage(1);
            }
		}
		
		
		/**
		 * showNoCash
		 */
		private function showNoCash():void {
			
			var popUp_mc:Box = new Box(
				"Недостаточно звёзд.",
				"На вашем счету недостаточно звёзд для отправки сообщения." + 
				" Пожалуйста, пополните звёзды или подождите следующего бонуса" + 
				" Приятного прослушивания.",
				200, 600, ["Пополнить звёзды", "Закрыть"] );
				
			popUp_mc.addEventListener( Event.SELECT, onBoxButtonClicked );
			popUp_mc.setVisible(true);
			_root.addChild(popUp_mc);
		}
	}
}