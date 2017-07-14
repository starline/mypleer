package starline.player.panels.cabinet.panels {
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import starline.player.components.BayVotes;
	
	/**
	 * @author Andrey Guzhva
	 * @date 15.10.2012
	 */
	
	public class PayStar extends BayVotes{
		
		public var _root:*;
		
		public function PayStar(_root:*) {
			this._root = _root;
			
			pay_votes_1.addEventListener(MouseEvent.CLICK, onPayVotes1);
			pay_votes_3.addEventListener(MouseEvent.CLICK, onPayVotes3);
			pay_votes_5.addEventListener(MouseEvent.CLICK, onPayVotes5);
		}
		
		
		private function onPayVotes1(e:MouseEvent):void { 
			_root.vkCallMethod.showOrderBox('item', 1);
		}
		
		
		private function onPayVotes3(e:MouseEvent):void { 
			_root.vkCallMethod.showOrderBox('item', 2);
		}
		
		
		private function onPayVotes5(e:MouseEvent):void { 
			_root.vkCallMethod.showOrderBox('item', 3);
		}
	}
}