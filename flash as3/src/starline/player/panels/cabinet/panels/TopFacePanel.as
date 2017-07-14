package starline.player.panels.cabinet.panels {
	

	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import starline.utils.external.External;
	import vk.gui.Box;
	
	
	import starline.player.components.TopFace;
	
	public class TopFacePanel extends TopFace{
		
		public var _root:*;
		
		// Static
		public static var TOPFACE_VALUE:int = 100;
		public static var MAX_CHARS:int = 75;
		
		public function TopFacePanel(_root:*) {
			this._root = _root;
			
			// Config
			count.text = String(MAX_CHARS);
			count.autoSize = TextFieldAutoSize.LEFT;
			text.maxChars = MAX_CHARS;
			
			topFaceBtn.addEventListener(MouseEvent.CLICK,  onSmsBtn);
			text.addEventListener(Event.CHANGE, changeHandler);
		}
		
		
		/**
		 * onSmsBtn
		 */
		private function onSmsBtn(e:MouseEvent):void {
			if (_root.user_settings.cash >= TOPFACE_VALUE) { 
				_root.MP.api('user.addTopFace', {text:text.text}, fetchResponse, _root.mpApiRequest.requestFail);
				_root.loaderBar_spr.visible = true;
			} else {
				var popUp_mc:Box = new Box( "Недостаточно звёзд.",
				"На вашем счету недостаточно звёзд для отправки сообщения." + 
				" Пожалуйста, пополните звёзды или подождите следующего бонуса"
				, 200, 600, ["Пополнить звёзды", "Закрыть"] );
				popUp_mc.addEventListener( Event.SELECT, onBoxButtonClicked );
				popUp_mc.setVisible(true);
				_root.addChild(popUp_mc);
			}
		}
		
		
		/**
		 * fetchResponse
		 * брабатываем ответ от MPAPI
		 */
		private function fetchResponse(data:Object):void {
			_root.loaderBar_spr.visible = false;
			
			if (data != "0") {
				_root.player_mc.setStarCount(data.cash);
				
				var popUp_mc:Box = new Box (
					"Отлично!",
					"Добро пожаловать на доску почета :)",
					150,
					600,
					["Закрыть"]
				);
					
				popUp_mc.setVisible(true);
				_root.addChild(popUp_mc);
				
				// Обновляем доску почета
				External.call('getTopFace');
			}
		}
		
		
		/*** changeHandler ***/
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
		
		
		/*** onBoxButtonClicked ***/
		private function onBoxButtonClicked( e:Event ):void{
            if ((e.target.buttonClickedIndex) == 0) {
                _root.player_mc.setCabinetPage(1);
            }
		}
	}
}