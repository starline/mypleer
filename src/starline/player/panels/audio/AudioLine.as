package starline.player.panels.audio {
        
	import flash.display.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.filters.GlowFilter; 
	import flash.events.*;
	
	import vk.gui.LinkButton;
	
	import starline.ui.simple.DrawRect;
	import starline.ui.simple.DrawRoundRect;
	import starline.player.components.DelBtn;
	import starline.player.components.AddBtn;
	import starline.player.components.ArtistSearchBtn;
	import starline.player.components.OffBtn;
	import starline.player.components.OnBtn;
	import starline.player.components.EditBtn;
	import starline.ui.text.CreateTextField;
	
	/**
	 * Guzhva Andrey
	 * http://starline-studio.com
	 * 07.01.2011
	 * MusicBox player | radio
	 */
	
	public class AudioLine extends Sprite {
			
		private var dragTimer:Timer;
		private var _parent:*;
		
		// Vars
		public var n:int;
		public var idy:int;
		public var url:String;
		public var aid:int;
		public var oid:int;
		public var artist:String;
		public var title:String;
		public var duration:int;
		public var lyrics_id:int;
		
		// Interface
		private var rollOverBg_sp:DrawRoundRect = new DrawRoundRect(0xffffff, 620 , 30, 5);
		private var clickBg_sp:DrawRoundRect = new DrawRoundRect(0xffffff, 620 , 30, 5);
		private var dclickBg_sp:DrawRoundRect = new DrawRoundRect(0x0099FF, 620 , 30, 5);
		public var n_txt:CreateTextField = new CreateTextField(12, "Tahoma", 0x00CC0A, 'right', true);
		public var a_txt:CreateTextField = new CreateTextField(14, "Tahoma", 0xffffff, 'left', true, true);
		public var t_txt:TextField = new CreateTextField(12, "Tahoma", 0xffffff, 'left', false, true);
		public var d_txt:TextField = new CreateTextField(12, "Tahoma", 0x00CC0A, 'left', true);
		public var artist_mask:DrawRect  =  new DrawRect(0x00, 10, 30);
		public var title_mask:DrawRect  =  new DrawRect(0x00, 10, 30);
		
		// option btn
		public var add_btn:AddBtn = new AddBtn();
		public var del_btn:DelBtn = new DelBtn();
		public var artistSearch_btn:ArtistSearchBtn = new ArtistSearchBtn();
		public var on_btn:OnBtn = new OnBtn();
		public var off_btn:OffBtn = new OffBtn();
		public var option_mc:Sprite = new Sprite();
		
		// Other
		public var on_flag:Boolean = true;
		
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
			
			n_txt.text  = (n + 1) + ".";
			
			var artist_label:String = (artist.length > 30)?artist.slice(0, 30) + '...':artist;
			a_txt.text = artist_label;
			artist_mask.x = a_txt.x;
			artist_mask.width = a_txt.width;
			
			t_txt.x = a_txt.width + 35;
			t_txt.text = "  -  " + title;
			title_mask.x = t_txt.x;
			title_mask.width = 490 - a_txt.width;

			
			var min_var:String = Math.floor(duration/60)+'';
			min_var = (min_var.length>1) ? min_var : '0'+min_var;
			var sec_var:String = (duration-Math.floor(duration/60)*60)+'';
			sec_var = (sec_var.length>1) ? sec_var : '0'+sec_var;
			d_txt.text = min_var + ':' + sec_var;
			
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
			
			artistSearch_btn.addEventListener(MouseEvent.CLICK, searchArtist);
			artistSearch_btn.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void { _parent._parent.helpWindow_mc.onAction(true, ' Поиск по исполнителю '); } );
			artistSearch_btn.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void { _parent._parent.helpWindow_mc.onAction(false); } );
			
			off_btn.addEventListener(MouseEvent.CLICK, onOff);
			off_btn.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void { _parent._parent.helpWindow_mc.onAction(true, ' Исключить из воспроизведения '); } );
			off_btn.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void { _parent._parent.helpWindow_mc.onAction(false); } );
			
			on_btn.addEventListener(MouseEvent.CLICK, onOn);
			on_btn.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void { _parent._parent.helpWindow_mc.onAction(true, ' Включить в воспроизведение '); } );
			on_btn.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void { _parent._parent.helpWindow_mc.onAction(false); } );
			
			dragTimer = new Timer(150,1);
			dragTimer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////
		// ---------------------------------------------------------------------------------Listener
		////////////////////////////////////////////////////////////////////////////////////////////
		private function onOff(e:MouseEvent):void {
			removeChild(off_btn);
			addChild(on_btn);
			on_flag = false;
		}
		private function onOn(e:MouseEvent):void {
			removeChild(on_btn);
			addChild(off_btn);
			on_flag = true;
		}
		private function searchArtist(e:MouseEvent):void {
			_parent.menu_mc.searchByArtst(artist);
		}
		private function onAdd(e:MouseEvent):void {
			_parent.onAdd(aid, oid, n);
		}
		private function onDel(e:MouseEvent):void {
			_parent.onDel(aid, oid, n);
		}
		private function selectOver(event:MouseEvent):void { 			// наведене мышки
			removeEventListener(MouseEvent.ROLL_OVER, selectOver);
			addEventListener(MouseEvent.ROLL_OUT, selectOut);
			addChild(option_mc);
			rollOverBg_sp.alpha = 0.2;      
		}
		private function selectOut(event:MouseEvent):void { 			// отвидение мышки
			removeEventListener(MouseEvent.ROLL_OUT, selectOut);	
			addEventListener(MouseEvent.ROLL_OVER, selectOver);
			removeChild(option_mc);
			dragTimer.reset();
			rollOverBg_sp.alpha = 0.1;      
		}
		private function selectClick(event:MouseEvent):void { 			// нажатие на аудиозапись
			dragTimer.reset();
			_parent.onClick(idy);
		}
		private function selectDclick(event:MouseEvent):void { 			// двойное нажатие на аудиозапись
			dragTimer.reset();
			_parent.onDclick(idy);
		}
		private function selectDown(event:MouseEvent):void { 			// нажатие на аудиозапись
			dragTimer.start();
		}       
		private function completeHandler(event:TimerEvent):void { 		// срабатывание таймера
			addEventListener(MouseEvent.MOUSE_UP, selectUp);
			_parent.onClick(idy);
			_parent.startDragLine(this);
		}
		private function selectUp(event:MouseEvent):void { 				// отпускание мышки аудиозаписи
			removeEventListener(MouseEvent.MOUSE_UP, selectUp);
			dragTimer.reset();
			_parent.stopDragLine(this);
		}
		
		
		///////////////////////////////////////////////////////////////////////////////////////////
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
		
		
		////////////////////////////////////////////////////////////////////////////////////////////
		// ------------------------------------------------------------------------------- Interface
		////////////////////////////////////////////////////////////////////////////////////////////
		private function createInterface():void {
			
			// bg
			rollOverBg_sp.alpha = 0.1;		addChild(rollOverBg_sp);
			clickBg_sp.alpha = 0;			addChild(clickBg_sp);
			dclickBg_sp.alpha = 0;			addChild(dclickBg_sp);
			
			// Text
			n_txt.x = 25;   n_txt.y = 6;	addChild(n_txt);
			a_txt.x = 40;   a_txt.y = 4;	addChild(a_txt);
			t_txt.x = 40;   t_txt.y = 6;	addChild(t_txt);
			d_txt.x = 575;  d_txt.y = 6;	addChild(d_txt);
			
			// mask
			addChild(artist_mask);	a_txt.mask = artist_mask;
			addChild(title_mask);	t_txt.mask = title_mask;
			
			// Option
			add_btn.x = 553;			add_btn.y = 5;				option_mc.addChild(add_btn);
			del_btn.x = 553;			del_btn.y = 5;				option_mc.addChild(del_btn);
			artistSearch_btn.x = 528;	artistSearch_btn.y = 5;		option_mc.addChild(artistSearch_btn);
			
			on_btn.x = 24;			on_btn.y = 5;					
			off_btn.x = 24;			off_btn.y = 5;					addChild(off_btn);
		}
	}
}