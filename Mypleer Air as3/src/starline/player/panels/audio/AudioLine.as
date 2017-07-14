package starline.player.panels.audio {
        
	import flash.display.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.filters.GlowFilter; 
	import flash.events.*;
	
	import starline.ui.button.DrawRect;
	import starline.player.components.DelBtn;
	import starline.player.components.AddBtn;
	
	/*
	* Guzhva Andrey
	* http://starline-studio.com
	* 07.01.2011
	* MusicBox player | radio
	*/
	
	public class AudioLine extends Sprite {
			
		private var dragTimer:Timer;
		private var _parent:*;
		
		// Vars
		public var n:uint;
		public var idx:uint;
		public var url:String;
		public var aid:uint;
		public var oid:uint;
		public var artist:String;
		public var title:String;
		public var duration:uint;
		public var lyrics_id:uint;
		
		// Interface
		private var rollOverBg_sp:Sprite = new Sprite();
		private var clickBg_sp:Sprite = new Sprite();
		private var dclickBg_sp:Sprite = new Sprite();
		public var n_txt:TextField = new TextField();
		public var a_txt:TextField = new TextField();
		public var t_txt:TextField = new TextField();
		public var d_txt:TextField = new TextField();
		public var add_btn:AddBtn = new AddBtn();
		public var del_btn:DelBtn = new DelBtn();
		public var option_mc:Sprite = new Sprite();
		
		public function AudioLine(_parent:*, n:int, p:*):void {
			this._parent = _parent;
			this.n = n;
			this.url= p.url;
			this.aid = p.aid;
			this.oid = p.owner_id;
			this.artist = p.artist;
			this.title = p.title;
			this.duration = p.duration;
			
			createInterface();
			
			n_txt.text  = (n+1) + ".";
			a_txt.text = artist;
			t_txt.x = a_txt.width + 30;
			t_txt.width = 520 - a_txt.width;
			t_txt.htmlText = " -  " + title;
			var min_var:String = Math.floor(duration/60)+'';
			min_var = (min_var.length>1) ? min_var : '0'+min_var;
			var sec_var:String = (duration-Math.floor(duration/60)*60)+'';
			sec_var = (sec_var.length>1) ? sec_var : '0'+sec_var;
			d_txt.htmlText = min_var + ':' + sec_var;
			
			// Listener
			addEventListener(MouseEvent.ROLL_OVER, selectOver);
			dclickBg_sp.addEventListener(MouseEvent.CLICK, selectClick);
			dclickBg_sp.addEventListener(MouseEvent.MOUSE_DOWN, selectDown);
			dclickBg_sp.doubleClickEnabled  = true;
			dclickBg_sp.addEventListener(MouseEvent.DOUBLE_CLICK, selectDclick);
			
			// Listener add del
			add_btn.addEventListener(MouseEvent.CLICK, onAdd);
			add_btn.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void { _parent._parent.helpWindow_mc.onAction(true, ' Добавить к себе '); } );
			add_btn.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void { _parent._parent.helpWindow_mc.onAction(false); } );
			del_btn.addEventListener(MouseEvent.CLICK, onDel);
			del_btn.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void { _parent._parent.helpWindow_mc.onAction(true, ' Удалить аудиозапись '); } );
			del_btn.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void { _parent._parent.helpWindow_mc.onAction(false); } );
			
			dragTimer = new Timer(150,1);
			dragTimer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
		}
		// ---------------------------------------------------------------------------------Listener
		
		private function onAdd(e:MouseEvent):void {
			add_btn.visible = false;
			_parent.onAdd(aid, oid, n);
		}
		private function onDel(e:MouseEvent):void {
			_parent.onDel(aid, oid, n);
		}
		private function selectOver(event:MouseEvent):void { 			// наведене мышки
			removeEventListener(MouseEvent.ROLL_OVER, selectOver);
			addEventListener(MouseEvent.ROLL_OUT, selectOut);
			option_mc.visible = true;
			rollOverBg_sp.alpha = 0.2;      
		}
		private function selectOut(event:MouseEvent):void { 			// отвидение мышки
			removeEventListener(MouseEvent.ROLL_OUT, selectOut);	
			addEventListener(MouseEvent.ROLL_OVER, selectOver);
			option_mc.visible = false;
			dragTimer.reset();
			rollOverBg_sp.alpha = 0.1;      
		}
		private function selectClick(event:MouseEvent):void { 			// нажатие на аудиозапись
			dragTimer.reset();
			_parent.onClick(idx);
		}
		private function selectDclick(event:MouseEvent):void { 			// двойное нажатие на аудиозапись
			dragTimer.reset();
			_parent.onDclick(idx);
		}
		private function selectDown(event:MouseEvent):void { 			// нажатие на аудиозапись
			dragTimer.start();
		}       
		private function completeHandler(event:TimerEvent):void { 		// срабатывание таймера
			addEventListener(MouseEvent.MOUSE_UP, selectUp);
			_parent.onClick(idx);
			_parent.startDragLine(this);
		}
		private function selectUp(event:MouseEvent):void { 				// отпускание мышки аудиозаписи
			removeEventListener(MouseEvent.MOUSE_UP, selectUp);
			dragTimer.reset();
			_parent.stopDragLine(this);
		}
		public function onClick():void {
			clickBg_sp.alpha = 0.1;
		}
		public function onDclick():void {
			dclickBg_sp.alpha = 0.4;
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
			rollOverBg_sp.graphics.drawRoundRect(0, 0, 620, 30, 5);
			rollOverBg_sp.graphics.endFill();
			rollOverBg_sp.alpha = 0.1;
			addChild(rollOverBg_sp);
			
			clickBg_sp.graphics.beginFill(0xFFFFFF);
			clickBg_sp.graphics.drawRoundRect(0, 0, 620, 30, 5);
			clickBg_sp.graphics.endFill();
			clickBg_sp.alpha = 0;
			addChild(clickBg_sp);
			
			dclickBg_sp.graphics.beginFill(0x0099FF);
			dclickBg_sp.graphics.drawRoundRect(0, 0, 620, 30, 5);
			dclickBg_sp.graphics.endFill();
			dclickBg_sp.alpha = 0;
			addChild(dclickBg_sp);
			
			var glow:GlowFilter = new GlowFilter(0x000000, 0.7, 4, 4);                      
			var n_tf:TextFormat = new TextFormat();
			n_tf.font = "Arial";
			n_tf.size = 12;
			n_tf.bold = true;
			n_tf.color = 0x00CC0A;
			n_txt.selectable = false;
			n_txt.mouseEnabled = false;
			n_txt.autoSize = TextFieldAutoSize.RIGHT;
			n_txt.defaultTextFormat = n_tf;
			n_txt.x = 25;   n_txt.y = 6;
			addChild(n_txt);
			
			var a_tf:TextFormat = new TextFormat();
			a_tf.font = "Arial";
			a_tf.size = 14;
			a_tf.bold = true;
			a_tf.color = 0xFFFFFF;
			a_txt.selectable = false;
			a_txt.mouseEnabled = false;
			a_txt.autoSize = TextFieldAutoSize.LEFT;
			a_txt.defaultTextFormat = a_tf;
			a_txt.x = 35;   a_txt.y = 5;
			a_txt.filters = [glow];
			addChild(a_txt);
			
			var t_tf:TextFormat = new TextFormat();
			t_tf.font = "Arial";
			t_tf.size = 12;
			t_tf.color = 0xFFFFFF;
			t_txt.selectable = false;
			t_txt.mouseEnabled = false;
			t_txt.height = 20;
			t_txt.defaultTextFormat = t_tf;
			t_txt.x = 40;   t_txt.y = 6;
			t_txt.filters = [glow];
			addChild(t_txt);
			
			var d_tf:TextFormat = new TextFormat();
			d_tf.font = "Arial";
			d_tf.size = 12;
			d_tf.bold = true;
			d_tf.color = 0x00CC0A;
			d_txt.selectable = false;
			d_txt.mouseEnabled = false;
			d_txt.autoSize = TextFieldAutoSize.LEFT;
			d_txt.defaultTextFormat = d_tf;
			d_txt.x = 575;  d_txt.y = 6;
			addChild(d_txt);		
			
			option_mc.x = 553;	option_mc.y = 5;	option_mc.visible = false;	addChild(option_mc);
			option_mc.addChild(add_btn);	
			option_mc.addChild(del_btn);
		}
	}
}