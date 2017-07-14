package starline.player.panels.cabinet {
        
        import flash.display.*;
        import flash.events.*;
		import starline.player.components.StarPanel;
        
        import starline.ui.button.DrawRect;
        import starline.ui.scroll.ScrollBox;
        
        /*
        * Guzhva Andrey
        * http://starline-studio.com
        * 07.01.2011
        * MusicBox player | radio
        */
        
        public class CabinetList extends Sprite {
                
            private var _root:*;
            private var _parent:*;
            // Interface
			public var menu_mc:CabinetMenu;
			public var starPanel_mc:StarPanel = new StarPanel();
                
            public function CabinetList(_root:*, _parent:*) :void {
				this._root = _root;
				this._parent = _parent;
	
				menu_mc = new CabinetMenu(_root, this);
				addChild(menu_mc);
				
				starPanel_mc.visible = false;
				starPanel_mc.y = 45;
				starPanel_mc.pay_votes_1.addEventListener(MouseEvent.CLICK, onPayVotes1);
				starPanel_mc.pay_votes_3.addEventListener(MouseEvent.CLICK, onPayVotes3);
				starPanel_mc.pay_votes_5.addEventListener(MouseEvent.CLICK, onPayVotes5);
				starPanel_mc.add_friend_btn.addEventListener(MouseEvent.CLICK, onAddFriend);
				addChild(starPanel_mc);
            }             
			private function onPayVotes1(e:MouseEvent):void { 
				_root.payVotes(100);
			}
			private function onPayVotes3(e:MouseEvent):void { 
				_root.payVotes(300);
			}
			private function onPayVotes5(e:MouseEvent):void { 
				_root.payVotes(500);
			}
			private function onAddFriend(e:MouseEvent):void { 
				_root.showInviteBox();
			}
		}

}