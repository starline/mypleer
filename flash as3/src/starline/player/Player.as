package starline.player {
	
	import com.equalizer.*;
	import com.equalizer.color.*;

	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import starline.player.components.*;
	import starline.player.control.*;
	import starline.player.audio.AudioSoundFx;

	import starline.player.panels.audio.*;
	import starline.player.panels.cabinet.CabinetList;
	import starline.player.panels.friend.FriendList;
	import starline.player.panels.group.GroupList;
	import starline.player.panels.radio.*;
	import starline.player.panels.skin.SkinList;
	import starline.player.panels.smart.SmartList;
	import starline.ui.HelpWindow;
	import starline.ui.button.TextMenuButton;
	import starline.ui.text.CreateTextField;
	import starline.utils.external.External;
	
	import com.anttikupila.demo.Knob;
	
	
	import vk.events.CustomEvent;
	
	import fm.last.LastFMDataProvider;
	
	/**
	 * @author 	Guzhva Andrey (aguzhva.com)
	 * @date 	16.02.2013
	 * @project Mypleer.com
	 */
	
	public class Player extends AudioSoundFx {
		
		public var _root:*;
		
		// Interface
		public var bg_mc:SkinBg;
		public var menu_mc:MainMenu;
		public var soundBar_mc:SoundBar;
		public var volumeBar_mc:VolumeBar;
		public var starCount_mc:StarCount = new StarCount();
		public var title_txt:CreateTextField = new CreateTextField(12, "Arial", 0xFFFFFF, "none", true, true, true);
		public var helpWindow_mc:HelpWindow = new HelpWindow();
		public var hotLink_mc:TextMenuButton = new TextMenuButton('Добавить в левое меню', 13, 6, 564);
		public var addFriends_btn:TextMenuButton = new TextMenuButton('Рассказать друзьям', 13, 600, 110);
		
		// Equalizer
		public var equalizer:Equalizer = new Equalizer();
		public var es:EqualizerSettings = new EqualizerSettings();
		
		// Кнопки
		public var left_cross_btn:LeftButton = new LeftButton();
		public var right_cross_btn:RightButton = new RightButton();
		public var play_btn:PlayButton = new PlayButton();
		public var pouse_btn:PouseButton = new PouseButton();
		public var rendomRadio_btn:RendomRadioBtn = new RendomRadioBtn();
		public var knob:Knob;
		
		// Array
		public var app_settings_arr:Array = new Array();
		private var track_Obj:Object;
		
		// Page
		public var audioList_mc:AudioList;
		public var radioList_mc:RadioList;
		public var skinList_mc:SkinList;
		public var cabinetList_mc:CabinetList;
		public var friendList_mc:FriendList;
		public var groupList_mc:GroupList;
		public var smartList_mc:SmartList;
		
		// Timer
		public var setLastTimer:Timer = new Timer(1000, 20);
		
		// Flag
		public var audio_flag:Boolean = true;
		public var globalFocus_flag:Boolean = true;
		public var first_play:Boolean = true;
		
		// Id
		public var stid:uint;
		public var aid:uint;
		
		public function Player(root:*):void {
			this._root = root;
			
			// app settings
			app_settings_arr['main_page'] = 1; 			// выбранная раздел при старте
			app_settings_arr['audio_page'] = 0; 		// выбранная вкладка в аудиозаписях
			app_settings_arr['myaudio_comlete'] = 0; 	// данные о аудиозаписях загружены
			app_settings_arr['radio_page'] = 0; 		// выбранная вкладка в радиостанциях
			app_settings_arr['radio_comlete'] = 0; 		// данные о радиостанциях загружены
			app_settings_arr['smart_tag'] = 0; 			// вкл/откл умный плеер
			app_settings_arr['friend_comlete'] = 0; 	// данные о друзьях загружены
			app_settings_arr['group_comlete'] = 0; 		// данные о группах загружены
			app_settings_arr['skin_page'] = 0; 			// выбранная вкладка в оформлениях
			app_settings_arr['skin_comlete'] = 0; 		// данные о оформлениях загружены
			app_settings_arr['cabinet_page'] = 0; 		// выбранная вкладка в личном кабинете
			app_settings_arr['cabinet_comlete'] = 0; 	// данные о кабинете загружены
			app_settings_arr['rating_btn'] = false; 	// вкл/отк доступ к голосованию за станцию
			app_settings_arr['station_post'] = false;	// вкл/откл постинг станции на стену
			
			// Equalizer
			es.numOfBars = 32;
			es.height = 80;
			es.barSize = 20;
			es.vgrid = true;
			es.hgrid = 5; 
			es.colorManager = new SolidBarColor(0xff0099FF);
			es.effect = EqualizerSettings.FX_REFLECTION;
			equalizer.update(es);
			equalizer.x = 85; 																	// Позиция по X
			equalizer.y = 60; 																	// Позиция по Y
			addEventListener(Event.ENTER_FRAME, equalizer.render);								// Отрисовываем эквалайзер
			
			// Создаем элементы
			bg_mc = new SkinBg(_root);
			bg_mc.mouseEnabled = true;
			soundBar_mc = new SoundBar(_root, this , 660, 20);
			volumeBar_mc = new VolumeBar(_root, this, 150, 10);
			
			radioList_mc = new RadioList(_root, this);
			audioList_mc = new AudioList(_root, this);
			skinList_mc = new SkinList(_root, this);
			cabinetList_mc = new CabinetList(_root, this);
			friendList_mc = new FriendList(_root, this);
			groupList_mc = new GroupList(_root, this);
			smartList_mc = new SmartList(_root, this);
			
			// Меню
			menu_mc = new MainMenu(_root, this);
			
			// Title
			title_txt.height = 20;	title_txt.width = 635;
			title_txt.text = 'Mypleer разработан студией Андрея Гужвы. Приятного прослушивания :)';
			
			////////////////////////////////////////////////////////////////////////////////////////////////////
			//// ------------------------------------------------------------------------------ Выводим на экран
			////////////////////////////////////////////////////////////////////////////////////////////////////
			addChild(bg_mc);
			addChild(equalizer);
			addChild(addFriends_btn);
			addChild(menu_mc);			menu_mc.x = 3;
			addChild(soundBar_mc);		soundBar_mc.x = 75;			soundBar_mc.y = 165;
			addChild(volumeBar_mc);		volumeBar_mc.x = 584;		volumeBar_mc.y = 85;
			addChild(starCount_mc);		starCount_mc.x = 618;		starCount_mc.y = 46;
			addChild(title_txt);		title_txt.x = 80;			title_txt.y = 144;
			addChild(left_cross_btn);	left_cross_btn.x = 75;		left_cross_btn.y = 71;		left_cross_btn.visible = false;
			addChild(right_cross_btn);	right_cross_btn.x = 238;	right_cross_btn.y = 71;		right_cross_btn.visible = false;
			addChild(rendomRadio_btn);	rendomRadio_btn.x = 238;	rendomRadio_btn.y = 71;		rendomRadio_btn.visible = false;
			addChild(play_btn);			play_btn.x = 143;			play_btn.y = 53;			play_btn.visible = true;
			addChild(pouse_btn);		pouse_btn.x = 143;			pouse_btn.y = 53;			pouse_btn.visible = false;
			addChild(audioList_mc);		audioList_mc.x = 75;		audioList_mc.y = 195;		audioList_mc.visible = false;
			addChild(radioList_mc);		radioList_mc.x = 75;		radioList_mc.y = 195;		radioList_mc.visible = false;
			addChild(skinList_mc);		skinList_mc.x = 75;			skinList_mc.y = 195;		skinList_mc.visible = false;
			addChild(cabinetList_mc);	cabinetList_mc.x = 75;		cabinetList_mc.y = 195;		cabinetList_mc.visible = false;
			
			//addChild(smartList_mc);		smartList_mc.x = 75;		smartList_mc.y = 195;		//smartList_mc.visible = false;
			
			addChild(friendList_mc);	friendList_mc.x = 497;		friendList_mc.y = 33;		friendList_mc.visible = false;
			addChild(groupList_mc);		groupList_mc.x = 497;		groupList_mc.y = 33;		groupList_mc.visible = false;
			addChild(hotLink_mc);		hotLink_mc.visible = ((_root.flashVars.api_settings & 256) == 256)?false:true;
			addChild(helpWindow_mc);

			// Timer				
			setLastTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onSetLastTimer);
			
			// Listener
			rendomRadio_btn.addEventListener(MouseEvent.MOUSE_UP, onRendomRadio);
			rendomRadio_btn.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void { helpWindow_mc.onAction(true, ' Подобрать радиостанцию '); } );
			rendomRadio_btn.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void { helpWindow_mc.onAction(false); } );
			
			pouse_btn.addEventListener(MouseEvent.MOUSE_UP, pouseSnd);
			pouse_btn.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void { helpWindow_mc.onAction(true, ' Пауза '); } );
			pouse_btn.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void { helpWindow_mc.onAction(false); } );
			
			play_btn.addEventListener(MouseEvent.MOUSE_UP, playSnd);
			play_btn.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void { helpWindow_mc.onAction(true, ' Плей '); } );
			play_btn.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void { helpWindow_mc.onAction(false); } );
			
			right_cross_btn.addEventListener(MouseEvent.MOUSE_UP, nextSnd);
			right_cross_btn.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void { helpWindow_mc.onAction(true, ' Следующая аудиозапись '); } );
			right_cross_btn.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void { helpWindow_mc.onAction(false); } );
			
			left_cross_btn.addEventListener(MouseEvent.MOUSE_UP, prevSnd);
			left_cross_btn.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void { helpWindow_mc.onAction(true, ' Предыдущая аудиозапись '); } );
			left_cross_btn.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void { helpWindow_mc.onAction(false); } );
			
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			starCount_mc.pay_votes_btn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { setCabinetPage(2); } );
			hotLink_mc.addEventListener(MouseEvent.CLICK, addHotLink);
			addFriends_btn.addEventListener(MouseEvent.CLICK, onAddFriend);
			
		}
		
		
		/////////////////////////////////////////////////////////////////////////////////////
		////--------------------------------------------------------------------- Change Page
		/////////////////////////////////////////////////////////////////////////////////////
		public function setCabinetPage(page:int):void {
			app_settings_arr['cabinet_page'] = page;
			menu_mc.changePage(5);
			cabinetList_mc.menu_mc.changePage(page);
		}
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////
		////------------------------------------------------------------------ set Last Title
		/////////////////////////////////////////////////////////////////////////////////////
		public function setCurrentAudio(track_Obj:Object):void {
			this.track_Obj = track_Obj;
			title_txt.text = track_Obj.artist + " - " + track_Obj.title;
			setLastTimer.reset();	
			setLastTimer.start()
			if (LastFMDataProvider.KEY){
				LastFMDataProvider.getInstance().lf_updateNowPlaying(track_Obj.artist, track_Obj.title);
			}
		}
		
		
		private function onSetLastTimer(e:TimerEvent):void {
			if (LastFMDataProvider.KEY){
				LastFMDataProvider.getInstance().lf_scrobble(track_Obj.artist, track_Obj.title);
			}
		}
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////
		////---------------------------------------------------------------------- RadioState
		/////////////////////////////////////////////////////////////////////////////////////
		public function setRadioState(state:uint):void {
			_root.MP.api(
				"station.setState",
				{stid: stid, state: state },
				function(date: Object): void { },
				_root.mpApiRequest.requestFail
			);
		}
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////
		////------------------------------------------------------------------------ Hot Link
		/////////////////////////////////////////////////////////////////////////////////////
		public function onWindowFocus(e:String = null):void {
			_root.VK.api(
				'getUserSettings',
				null,
				onSettingsChanged,
				_root.vkApiRequest.requestFail
			);
		}
		
		
		private function addHotLink(e:MouseEvent):void {
			_root.vkCallMethod.showSettingsBox(256);
		}
		
		
		private function onSettingsChanged(data:Object):void {
			//trace(data as Number & 256);
			if((data as Number & 256) == 256){
				hotLink_mc.visible = false;
			}
		}
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////
		////------------------------------------------------------------------ Other Function
		/////////////////////////////////////////////////////////////////////////////////////
		
		/*** onAddFriend ***/
		public function onAddFriend(e:MouseEvent = null):void { 
			External.call('showInviteBox');
		}
		
		/*** setStarCount ***/
		public function setStarCount(cunt:int):void {
			_root.user_settings.cash = cunt;
			starCount_mc.cash_txt.htmlText = "<b>" + cunt + "</b>";
		}
		
		
		
		////////////////////////////////////////////////////////////////////////////////
		//// --------------------------------------------------------------------- Music
		////////////////////////////////////////////////////////////////////////////////
		/**
		 * onKeyDown
		 * Управление воспроизведения кнопками
		 */
		private function onKeyDown(e:KeyboardEvent):void {
			if(globalFocus_flag){
				if (e.keyCode == 32) { 		// Space
					(super.play_flag) ? pouseSnd() : playSnd();	
				}
				if (e.keyCode==40) 			// Down
					audioList_mc.onNext();
				if (e.keyCode==38) 			// Up
					audioList_mc.onPrev();
				if (e.keyCode == 39) 		// Right
					soundBar_mc.onCross('r');
				if (e.keyCode == 37) 		//Left
					soundBar_mc.onCross('l');
			}
		}
		
		
		/**
		 * onRendomRadio
		 */
		public function onRendomRadio(e:MouseEvent = null):void {
			radioList_mc.onNext();
		}
		
		
		/**
		 * onNewPlay
		 * Запуск нового звука
		 */
		public function onNewPlay(url:String):void {
			if (audio_flag) {
				super.radioFlag = false;
				super.comlete_flag
				soundBar_mc.setPosition(0);
				rendomRadio_btn.visible = false;
				soundBar_mc.visible = true;
				left_cross_btn.visible = true;
				right_cross_btn.visible = true;
			} else {
				super.radioFlag = true;
				rendomRadio_btn.visible = true;
				soundBar_mc.visible = false;
				left_cross_btn.visible = false;
				right_cross_btn.visible = false;
			}
			
			super.onNewSound(url);
			
			pouse_btn.visible = true;
			play_btn.visible = false;
		}
		
		
		/**
		 * playSnd
		 */
		private function playSnd(e:MouseEvent = null):void {
			pouse_btn.visible = true;
			play_btn.visible = false;
			if (first_play) {
				if (app_settings_arr['main_page'] == 0){
					audioList_mc.onNext();
				}else { 
					radioList_mc.onDclick(0);
				}
				first_play = false;
			} else {
				super.onPlay();
			}
		}
		
		
		/**
		 * pouseSnd
		 */
		private function pouseSnd(e:MouseEvent = null): void {
			pouse_btn.visible = false;
			play_btn.visible = true;
			super.onPouse();
		}
		
		
		/**
		 * nextSnd
		 */
		private function nextSnd(e:MouseEvent):void {
			audioList_mc.onNext();
		}
		
		
		/**
		 * prevSnd
		 */
		private function prevSnd(e:MouseEvent):void {
			audioList_mc.onPrev();
		}
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////
		// ------------------------------------------------------------------------------------- Events
		///////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * sndLoadProgress
		 * Extends AudioSoundFx
		 */
		override public function sndLoadProgress(event:ProgressEvent):void {
			super.loadProgress = super.snd.bytesLoaded / super.snd.bytesTotal;
			if (!super.radioFlag) {
				soundBar_mc.setPosition(super.loadProgress);
			}
		}
		
		
		/**
		 * sndComplete
		 * Extends AudioSoundFx
		 */
		override  public function sndComplete(event:Event):void {
			if (super.radioFlag) {
				super.onNewSound(sndReq.url);
			} else {
				if (audioList_mc.round_flag) {
					super.onPlayRound();
				} else {
					audioList_mc.onNext();
				}
			}
		}
		
		
		/**
		 * sndLoadError
		 * Extends AudioSoundFx
		 */
		override public function sndLoadError(event:IOErrorEvent):void {
			if (super.radioFlag) {
				super.destroyNoise();
				super.comlete_flag = true;
				title_txt.text = 'Превышен лимит слушателей, попробуйте позже';
				setRadioState(0);
			} else {
				super.comlete_flag = true;
				title_txt.text = 'В данный момент сервер аудиозаписи недоступен';
			}
		}
		
		
		/**
		 * sndLoadOpen
		 * Extends AudioSoundFx
		 */
		override public function sndLoadOpen(e:Event):void {
			if (super.radioFlag) {
				super.destroyNoise();
				setRadioState(1);
			}
		}
	}
}