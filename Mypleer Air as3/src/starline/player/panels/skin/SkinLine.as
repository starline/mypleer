package starline.player.panels.skin {
        
        import flash.display.*;
        import flash.net.URLRequest;
        import flash.text.TextField;
        import flash.text.TextFormat;
        import flash.text.TextFieldAutoSize;
        import flash.utils.Timer;
        import flash.filters.GlowFilter; 
        import flash.events.*;
		
		import starline.player.components.ApplyBtn;
        import starline.player.components.BuyBtn;
		import starline.player.components.EyeBtn;
        /*
        * Guzhva Andrey
        * http://starline-studio.com
        * 07.01.2011
        * MusicBox player | radio
        */
        
        public class SkinLine extends Sprite {
                
                private var _parent:*;
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
                private var loader:Loader = new Loader();
                private var request:URLRequest = new URLRequest();
                // Interface
                private var rollOverBg_sp:Sprite = new Sprite();
                private var square:Sprite = new Sprite();
                private var loader_mc:Sprite = new Sprite();
				public var buy_btn:BuyBtn = new BuyBtn();
				public var apply_btn:ApplyBtn = new ApplyBtn();
				private var eye_btn:EyeBtn = new EyeBtn();
				
                public function SkinLine(_root:*, _parent:*, n:int, p:*):void {
					this._root = _root;
					this._parent = _parent;
					this.n = n;
					this.bid = p.bid;
					this.url= p.url;
					this.prev_url = p.prev_url;
					this.price =  p.price;
					this.order =  p.order;
					this.teg = p.teg;
					
					createInterface();
					
					request.url = _root.server_url + "skins/" + prev_url;
					loader.load(request);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE,displayImage);
					
					// Listener
					addEventListener(MouseEvent.ROLL_OVER, selectOver);
					addEventListener(MouseEvent.ROLL_OUT, selectOut);
					buy_btn.addEventListener(MouseEvent.MOUSE_UP, onBuy);
					apply_btn.addEventListener(MouseEvent.MOUSE_UP, onApply);
					eye_btn.addEventListener(MouseEvent.MOUSE_UP, onEye);
                }
                // -------------------------------------------------------- loader
                private function displayImage(evt:Event):void {
                        loader.alpha = 0;
                        loader_mc.addChild(loader);
                        addEventListener(Event.ENTER_FRAME, vanishing);
                }       
                private function vanishing(event:Event):void {
                        if (loader.alpha < 1) {
                                loader.alpha += 0.1;
                        }else {
                                removeEventListener(Event.ENTER_FRAME, vanishing);
                        }
                }
                // ---------------------------------------------------------------------------------Listener
				private function onBuy(e:MouseEvent): void {
					_root.player_mc.payBgFunction(bid, price);
				}
				private function onApply(e:MouseEvent): void {
					_root.player_mc.bg_mc.imgLoader(url);
					_root.send_server.saveBg(bid);
				}
				private function onEye(e:MouseEvent): void {
					_root.player_mc.bg_mc.eyeImgLoader(url);
				}
                // наведене мышки
                private function selectOver(event:MouseEvent):void { 
                        rollOverBg_sp.alpha = 0;      
                }
                // отвидение мышки
                private function selectOut(event:MouseEvent):void { 
                        rollOverBg_sp.alpha = 0.1;      
                }
                // ------------------------------------------------------------------------------- Interface
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