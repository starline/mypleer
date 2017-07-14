package starline.player.panels.skin {
        
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.filters.GlowFilter; 
	import flash.events.*;
	import vk.gui.Box;
	
	import starline.player.Main;
	import starline.player.components.ApplyBtn;
	import starline.player.components.BuyBtn;
	import starline.player.components.EyeBtn;
	
	/**
	 * @author	Guzhva Andrey
	 * @date	07.01.2011
	 * @project	MyPleer.com
	 */
    
	public class SkinLine extends Sprite {
		
		private var _player:*;
		private var _root:*;
		
		// Vars
		public var n:uint;
		public var bid:uint;
		public var url:String;
		public var prev_url:String;
		public var price:uint;
		public var order:uint;
		public var teg:String;
		
		// Loader
		public var loader:Loader = new Loader();
		private var request:URLRequest = new URLRequest();
		
		// Interface
		private var rollOverBg_sp:Sprite = new Sprite();
		private var square:Sprite = new Sprite();
		private var loader_mc:Sprite = new Sprite();
		public var buy_btn:BuyBtn = new BuyBtn();
		public var apply_btn:ApplyBtn = new ApplyBtn();
		private var eye_btn:EyeBtn = new EyeBtn();
		
		public function SkinLine(root:Sprite, player:Sprite, n:int, p:Object):void {
			this._root = root;
			this._player = player;
			
			this.n = n;
			this.bid = p.bid;
			this.url= p.url;
			this.prev_url = p.prev_url;
			this.price =  p.price;
			this.order =  p.order;
			this.teg = p.teg;
			
			createInterface();
			
			request.url = Main.CS_SERVER_URL + Main.SKINS_FOLDER + prev_url;
			loader.load(request);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,displayImage);
			
			// Listener
			addEventListener(MouseEvent.ROLL_OVER, selectOver);
			addEventListener(MouseEvent.ROLL_OUT, selectOut);
			buy_btn.addEventListener(MouseEvent.MOUSE_UP, onBuy);
			apply_btn.addEventListener(MouseEvent.MOUSE_UP, onApply);
			eye_btn.addEventListener(MouseEvent.MOUSE_UP, onEye);
			
			eye_btn.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void { _player.helpWindow_mc.onAction(true, ' Посмотреть оформление '); } );
			eye_btn.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void { _player.helpWindow_mc.onAction(false); } );
			buy_btn.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void { _player.helpWindow_mc.onAction(true, ' Купить оформление '); } );
			buy_btn.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void { _player.helpWindow_mc.onAction(false); } );
			apply_btn.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void { _player.helpWindow_mc.onAction(true, ' Установить оформление '); } );
			apply_btn.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void { _player.helpWindow_mc.onAction(false); } );
		}
		
		
		// -------------------------------------------------------- loader
		private function displayImage(evt:Event):void {
			loader_mc.addChild(loader);    
			//loader.alpha = 0;
			// addEventListener(Event.ENTER_FRAME, vanishing);
		}
		
		private function vanishing(event:Event):void {
			if (loader.alpha < 1) {
				loader.alpha += 0.1;
			}else {
				removeEventListener(Event.ENTER_FRAME, vanishing);
			}
		}
		
		/**
		 * payBg
		 * Купить скин
		 */
		private function onBuy(e:MouseEvent): void {
			if (price <= _root.user_settings.cash) {
				_root.loaderBar_spr.visible = true;
				_root.MP.api(
					'pay_bg',
					{bid: bid },
					function(data:Object):void {
						_root.loaderBar_spr.visible = false;
						_root.player_mc.skinList_mc.setApplyBgByBid(data);
						_root.MP.api(
							'star_get',
							{},
							function (data: Object): void {
								_root.player_mc.setStarCount(data.cash);
							},
							_root.mpApiRequest.requestFail
						);
					},
					_root.mpApiRequest.requestFail
				);
			} else {
				var popUp_mc:Box = new Box(
					"Недостаточно звёзд.",
					" На вашем счету недостаточно звёзд для покупки оформления." + 
					" Пожалуйста, пополните звёзды или подождите следующего бонуса" + 
					" Приятного прослушивания.",
					200,
					600,
					["Пополнить звёзды", "Закрыть"]
				);
				
				popUp_mc.addEventListener( Event.SELECT, function(e:Event):void {
					
					// Пополнить звезды
					if ((e.target.buttonClickedIndex) == 0) {
						_root.player_mc.setCabinetPage(2);
					}
				});
				popUp_mc.setVisible(true);
				_root.addChild(popUp_mc);
			}
		}
		
		
		/**
		 * Apply
		 * Применить скин
		 */
		private function onApply(e:MouseEvent): void {
			_player.bg_mc.imgLoader(url);
			_root.MP.api(
				'save_bg',
				{bid: bid},
				function(data:Object):void {
					_root.loaderBar_spr.visible = false;
				},
				_root.mpApiRequest.requestFail
			);
			_root.loaderBar_spr.visible = true;
		}
		
		
		/**
		 * onEye
		 */ 
		private function onEye(e:MouseEvent): void {
			_root.player_mc.bg_mc.eyeImgLoader(url);
		}
		
		
		/**
		 * наведене мышки
		 */ 
		private function selectOver(event:MouseEvent):void { 
			rollOverBg_sp.alpha = 0;      
		}
		
		
		/**
		 * отвидение мышки
		 */ 
		private function selectOut(event:MouseEvent):void { 
			rollOverBg_sp.alpha = 0.1;      
		}
		
		
		/**
		 * Interface
		 */
		private function createInterface():void {
			
			addChild(loader_mc);
			
			square.graphics.beginFill(0x0099FF);
			square.graphics.drawRoundRect(0, 0, 100, 100, 5);
			square.graphics.endFill();
			addChild(square);
			loader_mc.mask = square;
				
			rollOverBg_sp.graphics.beginFill(0x000000);
			rollOverBg_sp.graphics.drawRoundRect(0, 0, 100, 100, 5);
			rollOverBg_sp.graphics.endFill();
			rollOverBg_sp.alpha = 0.1;
			addChild(rollOverBg_sp);
			
			apply_btn.visible = (order == 1)? true: false;
			apply_btn.y = 74;
			addChild(apply_btn);
			
			buy_btn.visible = (order == 0)? true: false;
			buy_btn.price_txt.mouseEnabled = false;   
			buy_btn.price_txt.height = 20;   
			buy_btn.price_txt.htmlText = '<b>'+String(price)+'</b>';
			buy_btn.y = 74;
			addChild(buy_btn);
			
			eye_btn.x = 70;
			eye_btn.y = 5;
			addChild(eye_btn);
		}
	}
}