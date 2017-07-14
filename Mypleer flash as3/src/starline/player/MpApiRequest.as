package starline.player {
	
	import flash.events.Event;
	import flash.net.*;
	import vk.gui.Box;
	
	/**
	 * @author 	Guzhva Andrey (aguzhva.com)
	 * @date 	18.02.2013
	 * @project MyPleer
	 */
	
	public class MpApiRequest {
		
		public var _root:*;

		public function MpApiRequest(_root:*):void {
			this._root = _root;	
		}
		
		
		////////////////////////////////////////////////////////////////////
		////---------------------------------------------------------- Error
		////////////////////////////////////////////////////////////////////
		public function requestFail(data: String): void {
			_root.loaderBar_spr.visible = false;
			
			// Вывести к консоль
			trace(data);
			
			_root.MP.api('save_error', { error: _root.APP_TYPE + _root.APP_VERSION + "." + data }, function():void{});
			if (data.indexOf('save_error') == -1) {
				
				var popUp_mc:Box = new Box(
					"Что-то пошло не так... Такое бывает.",
					"Не переживайте, это временный сбой сервера Mypleer.com." + 
					" Он мог возникнуть из-за плохого интернет соединения или перегрузке сервера." + 
					" Убедитесь, что ваш провайдер предоставляет качественные услуги." +
					" Данные об ошибке получены и я уже работаю над проблемой." + 
					" Ваше последнее действие скорее всего не сохранено, поэтому повторите попытку. " + 
					" Советую перезагрузить плеер, дабы установить стабильное соединение. " +
					" Приятного прослушивания",
					200,
					600,
					["Перезагрузить плеер", "Закрыть"]
				);
				
				popUp_mc.addEventListener( Event.SELECT, onReload );
				popUp_mc.setVisible(true);
				_root.addChild(popUp_mc);
			}
		}
		
		
		private function onReload(e:Event):void { 
            if ((e.target.buttonClickedIndex) == 0) {
                navigateToURL( new URLRequest('http://mypleer.com'), "_blank" );
            }
		}
	}
}