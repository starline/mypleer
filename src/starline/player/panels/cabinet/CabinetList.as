package starline.player.panels.cabinet {
        
	import flash.display.*;
	import flash.events.*;
	import starline.player.panels.cabinet.panels.*;
	
	import starline.ui.scroll.ScrollBox;
	import starline.ui.simple.DrawRect;
	
	
	/**
	 * @authir	Guzhva Andrey (aguzhva.com)
	 * @date	12.02.2013
	 * @project	Mypleer
	 */
	
	public class CabinetList extends Sprite {
			
		public var _root:*;
		public var _parent:*;
		
		// Interface
		public var menu_mc:CabinetMenu;
		public var smsPanel_mc:SmsPanel;
		public var starPanel_mc:PayStar;
		public var lastFMLogin:LastFMLogin;
		public var topFacePanel_mc:TopFacePanel;
			
		public function CabinetList(_root:*, _parent:*) :void {
			this._root = _root;
			this._parent = _parent;
			
			smsPanel_mc = new SmsPanel(_root);
			smsPanel_mc.y = 45;
			smsPanel_mc.visible = false;
			addChild(smsPanel_mc);
			
			starPanel_mc = new PayStar(_root);
			starPanel_mc.visible = false;
			starPanel_mc.y = 45;
			addChild(starPanel_mc);
			
			
			lastFMLogin = new LastFMLogin(_root);
			lastFMLogin.y = 45;
			lastFMLogin.visible = false;
			addChild(lastFMLogin);
			
			topFacePanel_mc = new TopFacePanel(_root);
			topFacePanel_mc.y = 45;
			topFacePanel_mc.visible = false;
			addChild(topFacePanel_mc);
			
			menu_mc = new CabinetMenu(_root, this);
			addChild(menu_mc);
		}             
	}
}