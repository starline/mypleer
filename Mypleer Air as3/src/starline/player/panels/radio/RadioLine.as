package starline.player.panels.radio {
        
        import flash.display.*;
        import flash.net.URLRequest;
        import flash.text.TextField;
        import flash.text.TextFormat;
        import flash.text.TextFieldAutoSize;
        import flash.utils.Timer;
        import starline.ui.button.DrawRect;
        import flash.filters.GlowFilter; 
        import flash.events.*;
        
        /*
        * Guzhva Andrey
        * http://starline-studio.com
        * 07.01.2011
        * MusicBox player | radio
        */
        
        public class RadioLine extends Sprite {
                
                private var _parent:*;
                private var _root:*;
                
                // Vars
                public var n:uint;
                public var n_sort:uint;
                public var url:String;
                public var stid:uint;
                public var title:String;
                public var photo:String;
                public var teg:String;
                // Loader
                private var loader:Loader = new Loader();
                private var request:URLRequest = new URLRequest();
                // Interface
                private var rollOverBg_sp:Sprite = new Sprite();
                private var clickBg_sp:Sprite = new Sprite();
                private var dclickBg_sp:Sprite = new Sprite();
                private var n_txt:TextField = new TextField();
                private var square:Sprite = new Sprite();
                private var hit:Sprite = new Sprite();
                private var loader_mc:Sprite = new Sprite();
                
                public function RadioLine(_root:*, _parent:*, n:int, p:*):void {
                        this._root = _root;
                        this._parent = _parent;
                        this.n = n;
                        this.url= p.url;
                        this.stid = p.stid;
                        this.photo = p.photo;
                        this.title =  p.name;
                        this.teg = p.teg;
                        
                        createInterface();

                        n_txt.htmlText = title;

                        request.url = _root.server_url + "stations/" + photo;
                        loader.load(request);
                        loader.contentLoaderInfo.addEventListener(Event.COMPLETE,displayImage);
                        
                        // Listener
                        hit.addEventListener(MouseEvent.ROLL_OVER, selectOver);
                        hit.addEventListener(MouseEvent.ROLL_OUT, selectOut);
                        hit.addEventListener(MouseEvent.CLICK, selectClick);
                        hit.doubleClickEnabled  = true;
                        hit.addEventListener(MouseEvent.DOUBLE_CLICK, selectDclick);
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
                // наведене мышки
                private function selectOver(event:MouseEvent):void { 
                        rollOverBg_sp.alpha = 0.2;      
                }
                // отвидение мышки
                private function selectOut(event:MouseEvent):void { 
                        rollOverBg_sp.alpha = 0.1;      
                }
                // нажатие на аудиозапись
                private function selectClick(event:MouseEvent):void { 
                        _parent.onClick(n);
                }
                // двойное нажатие на аудиозапись
                private function selectDclick(event:MouseEvent):void { 
                        _parent.onDclick(n);
                }

                public function onClick():void {
                        clickBg_sp.alpha = 0.2;
                }
                public function onDclick():void {
                        dclickBg_sp.alpha = 0.6;
                }
                public function unClick():void {
                        clickBg_sp.alpha = 0;
                }
                public function unDclick():void {
                        dclickBg_sp.alpha = 0;
                }
                // ------------------------------------------------------------------------------- Interface
                private function createInterface():void {
                        
                        rollOverBg_sp.graphics.beginFill(0xFFFFFF);
                        rollOverBg_sp.graphics.drawRoundRect(0, 0, 100, 100, 5);
                        rollOverBg_sp.graphics.endFill();
                        rollOverBg_sp.alpha = 0.1;
                        addChild(rollOverBg_sp);
                        
                        clickBg_sp.graphics.beginFill(0xFFFFFF);
                        clickBg_sp.graphics.drawRoundRect(0, 0, 100, 100, 5);
                        clickBg_sp.graphics.endFill();
                        clickBg_sp.alpha = 0;
                        addChild(clickBg_sp);
                        
                        dclickBg_sp.graphics.beginFill(0x0099FF);
                        dclickBg_sp.graphics.drawRoundRect(0, 0, 100, 100, 5);
                        dclickBg_sp.graphics.endFill();
                        dclickBg_sp.alpha = 0;
                        addChild(dclickBg_sp);
                        
                        addChild(loader_mc);
                        
                        square.graphics.beginFill(0x0099FF);
                        square.graphics.drawRoundRect(0, 0, 100, 100, 5);
                        square.graphics.endFill();
                        addChild(square);
                        loader_mc.mask = square;
                        
                        var glow:GlowFilter = new GlowFilter(0x000000, 0.7, 4, 4);                      
                        var n_tf:TextFormat = new TextFormat();
                        n_tf.font = "Arial";
                        n_tf.size = 10;
                        n_tf.bold = true;
                        n_tf.color = 0xFFFFFF;
                        n_txt.selectable = false;
                        n_txt.mouseEnabled = false;
                        n_txt.wordWrap = true;
                        n_txt.height = 30;
                        n_txt.width = 94;
                        n_txt.defaultTextFormat = n_tf;
                        n_txt.x = 3;    n_txt.y = 70;
                        n_txt.filters = [glow];
                        addChild(n_txt);
                        
                        hit.graphics.beginFill(0x0099FF);
                        hit.graphics.drawRoundRect(0, 0, 100, 100, 5);
                        hit.graphics.endFill();
                        hit.alpha = 0;
                        addChild(hit);
                        
                }
        }

}