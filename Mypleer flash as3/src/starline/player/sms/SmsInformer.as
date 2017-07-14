package starline.player.sms {
		
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	
	import starline.player.components.EditBtn;
	import starline.ui.simple.DrawRoundRect;
	import starline.ui.text.CreateTextField;

	/**
	 * @author 	Guzhva Andrey (aguzhva.com)
	 * @date 	14.02.2013
	 * @project Mypleer
	 */
		
	public class SmsInformer extends Sprite{
		
		public var _root:*;
		
		// Timer
		public var smsTimer:Timer;
		private const INTERVAL:int = 300; // в секундах
		
		// Arr
		private var sms_arr:Array;
		
		// Interface
		private var name_btn:Sprite = new Sprite();
		private var bg_sp:DrawRoundRect = new DrawRoundRect(0x333333, 801, 30, 8, 1);
		private var name_txt:CreateTextField = new CreateTextField(14, "Arial", 0xFFFF00, "left", true, false);
		private var sms_txt:CreateTextField = new CreateTextField(12, "Arial", 0xFFFFFF, "left", true, false, true);
		public var online_txt:CreateTextField = new CreateTextField(12, "Arial", 0xFFFFFF, "right", true, true);
		private var addSms_btn:EditBtn = new EditBtn();
		
		//Other
		private var URL:URLRequest = new URLRequest();
		
		public function SmsInformer(_root:*):void {
			this._root = _root;
			
			addChild(bg_sp);
			addChild(sms_txt);	 			sms_txt.x = 100;			sms_txt.y = 5;	sms_txt.width = 770;
			name_btn.addChild(name_txt);	name_txt.width = 70;
			addChild(name_btn);				name_btn.x = 5;				name_btn.y = 4;
			addChild(addSms_btn);			addSms_btn.x = 775;			addSms_btn.y = 4;
			addChild(online_txt);			online_txt.x = 760;			online_txt.y = 5;
			
			name_btn.useHandCursor = true;
			name_btn.buttonMode = true;
			name_btn.mouseChildren = false;
			name_btn.addEventListener(MouseEvent.CLICK, onURL);
			
			addSms_btn.addEventListener(MouseEvent.CLICK, onAddSms);
			
			// Таймер
			smsTimer = new Timer(1000*INTERVAL, 1);
			smsTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function (e:TimerEvent):void { init(); } );
		}
		
		
		private function onAddSms(e:MouseEvent):void {
			_root.player_mc.setCabinetPage(0);
		}
		
		
		public function init():void {
			_root.MP.api("sms_get", null, fetchSmsGet, smsGetRequestFail);
		}
		
		
		private function fetchSmsGet(data:Object):void {
			URL.url = "http://vk.com/id" + data.uid;
			name_txt.text = data.first_name+':';
			sms_txt.text = data.text;
			online_txt.text = data.online + ' онлайн';
			smsTimer.reset();
			smsTimer.start();
		}
		
		
		private function smsGetRequestFail(data:Object):void {
			smsTimer.reset();
			smsTimer.start();
		}
		
		
		private function showSms(name:String, url:String, text:String):void {
		}
		
		
		private function onURL(e:MouseEvent):void {
			navigateToURL( URL, "_blank" );
		}
	}
}