package com.philips {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import starline.player.panels.skin.SkinLine;
	import starline.player.components.ChooseSkin;

	/**
	 * @author 	Guzhva Andrey (http://aguzhva.com)
	 * @date 	18.02.2013
	 */
	
	public class ChooseSkinEx extends ChooseSkin {
		
		private var _root:*;
		private var _player:*;
		
		public function ChooseSkinEx(root:Sprite, player:Sprite) {
			
			this._root = root;
			this._player = player;
			
			// ставить два блока со скинами
			// Кнопки в позицию "применить"
			// По нажатии, менять скин, сохранять выбранный скин
			// Выводить блок всем при загрузке
			
			var p1:Object = new Object();
			p1.bid = 60;
			p1.url = 'sk060.jpg';
			p1.prev_url = 'pr060.jpg';
			p1.price = 0;
			p1.order = 1;
			p1.teg = '';
			
			var skinM:SkinLine = new SkinLine(_root, _player, 1, p1);
			skinM.x = 145;
			skinM.y = 100;
			addChild(skinM);
			
			var p2:Object = new Object();
			p2.bid = 61;
			p2.url = 'sk059.jpg';
			p2.prev_url = 'pr059.jpg';
			p2.price = 0;
			p2.order = 1;
			p2.teg = '';
			
			var skinF:SkinLine = new SkinLine(_root, _player, 2, p2);
			skinF.x = 333;
			skinF.y = 100;
			addChild(skinF);
			
			// Переход по ссылке
			inGroup_btn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				navigateToURL(new URLRequest("http://vk.com/testedonanimals"));
			});	
        }
	}
}