package starline.utils.external {
	
	import flash.external.ExternalInterface;
	
	/**
	 * @author 	Andrey Guzhva
	 * @site 	aguzhva.com
	 * @date 	14.10.2012
	 */
	
	public class External {
		
		public var _root:*
		
		public function External(_root:*) {
			this._root = _root;
			
			// addCallback
			try {
				ExternalInterface.addCallback('checkSettings', checkSettings);
				ExternalInterface.addCallback('orderSuccess', orderSuccess);
				ExternalInterface.addCallback('openTopFacePanel', openTopFacePanel);
			} catch (error:Error) {
				trace(error);
			}
		}
		
		
		//////////////////////////////////////////////////////////////////////////////////
		////------------------------------------------------------------------ addCallback
		//////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * checkSettings
		 */
		private function checkSettings(param:String = null):void {
			_root.player_mc.onWindowFocus();
		}
		
		
		
		/**
		 * openTopFacePanel
		 */
		private function openTopFacePanel(param:String = null):void {
			_root.player_mc.setCabinetPage(1);
		}
		
		
		/**
		 * orderSuccess
		 * Заказ подтвержден со стороны клиента, необходимо прислать новый баланс
		 */
		private function orderSuccess(order_id:String = null):void {
			_root.MP.api(
				'star_get',
				{},
				function (data: Object): void {
					_root.player_mc.setStarCount(data.cash);
				},
				_root.mpApiRequest.requestFail
			);
		}
		
		
		
		
		//////////////////////////////////////////////////////////////////////////////////
		////------------------------------------------------------------------------- call
		//////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * call
		 * Common public static function for ExternalInterfce
		 */
		public static function call(jsFuction:String):* {
			return ExternalInterface.call(jsFuction);
		}
		
		
		/**
		 * showOrderBox
		 */
		public function showOrderBox(type:String, value:int):void {
			var answer:* = ExternalInterface.call('showOrderBox', type, value);
		}
		
		
		/**
		 * showSettingsBox
		 */
		public function showSettingsBox(settings:int):void{
			var answer:* = ExternalInterface.call('showSettingsBox', settings);
		}
		
		
		/**
		 * saveWallPost
		 */
		public function saveWallPost(hash:String):void{
			var answer:* = ExternalInterface.call('saveWallPost', hash);
		}
	}
}