package starline.player {
	
	import com.equalizer.*;
	import com.equalizer.color.*;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import starline.player.components.*;
	import starline.player.control.*;
	import starline.player.panels.audio.*;
	import starline.player.panels.cabinet.CabinetList;
	import starline.player.panels.friend.FriendList;
	import starline.player.panels.group.GroupList;
	import starline.player.panels.radio.*;
	import starline.player.panels.skin.SkinList;
	import starline.ui.HelpWindow;
	
	
	
	/*
	* Guzhva Andrey
	* http://starline-studio.com
	* 06.01.2011
	* MusicBox player | radio
	*/
	
	public class Player extends Sprite {
		
		public var _root:*;
		// 
		public var playerSound:AudioSound;
		public var radioSound:RadioSound;
		// Interface
		public var bg_mc:SkinBg;
		public var menu_mc:MainMenu;
		public var soundBar_mc:SoundBar;
		public var volumeBar_mc:VolumeBar;
		public var starCount_mc:StarCount = new StarCount();
		public var title_txt:TextField = new TextField();
		public var helpWindow_mc:HelpWindow = new HelpWindow();
		// Кнопки
		private var left_cross_btn:LeftButton = new LeftButton();
		private var right_cross_btn:RightButton = new RightButton();
		private var play_btn:PlayButton = new PlayButton();
		private var pouse_btn:PouseButton = new PouseButton();
		// Page
		public var audioList_mc:AudioList;
		public var radioList_mc:RadioList;
		public var skinList_mc:SkinList;
		public var cabinetList_mc:CabinetList;
		public var friendList_mc:FriendList;
		public var groupList_mc:GroupList;
		
		// Flag
		public var audio_flag:Boolean = true;
		public var globalFocus_flag:Boolean = true;
		
		public function Player(_root:*):void {
			this._root = _root;
			// ------------------------------------------------------------------------------------ Equalizer
			var es:EqualizerSettings = new EqualizerSettings();
			es.numOfBars = 32;
			es.height = 80;
			es.barSize = 20;
			es.vgrid = true;
			es.hgrid = 5; 
			es.colorManager = new SolidBarColor(0xff0099FF);
			es.effect = EqualizerSettings.FX_REFLECTION;
			var equalizer:Equalizer = new Equalizer();
			equalizer.update(es);
			equalizer.x = 85; 																	// Позиция по X
			equalizer.y = 60; 																	// Позиция по Y
			addEventListener(Event.ENTER_FRAME, equalizer.render);
			// ----------------------------------------------------------------------------------- Создаем элементы
			bg_mc = new SkinBg(_root);
			bg_mc.mouseEnabled = true;
			soundBar_mc = new SoundBar(_root, this , 660, 20);
			volumeBar_mc = new VolumeBar(_root, this, 150, 10);
			playerSound = new AudioSound(this);
			radioSound = new RadioSound(this);
			
			radioList_mc = new RadioList(_root, this);
			audioList_mc = new AudioList(_root, this);
			skinList_mc = new SkinList(_root, this);
			cabinetList_mc = new CabinetList(_root, this);
			friendList_mc = new FriendList(_root, this);
			groupList_mc = new GroupList(_root, this);
			
			// ----------------------------------------------------------------------------------- Элементы управления
			soundBar_mc.x = 75;			soundBar_mc.y = 165;
			volumeBar_mc.x = 584;		volumeBar_mc.y = 85;
			starCount_mc.x = 618;		starCount_mc.y = 46;
			left_cross_btn.x = 75;		left_cross_btn.y = 71;
			right_cross_btn.x = 238;	right_cross_btn.y = 71;
			play_btn.x = 143;			play_btn.y = 53;			play_btn.visible = true;
			pouse_btn.x = 143;			pouse_btn.y = 53;			pouse_btn.visible = false;
			audioList_mc.x = 75;		audioList_mc.y = 195;		audioList_mc.visible = false;
			radioList_mc.x = 75;		radioList_mc.y = 195;		radioList_mc.visible = false;
			skinList_mc.x = 75;			skinList_mc.y = 195;		skinList_mc.visible = false;
			cabinetList_mc.x = 75;		cabinetList_mc.y = 195;		cabinetList_mc.visible = false;
			friendList_mc.x = 497;		friendList_mc.y = 33;		friendList_mc.visible = false;
			groupList_mc.x = 497;		groupList_mc.y = 33;		groupList_mc.visible = false;
			// ----------------------------------------------------------------------------------- Миню
			menu_mc = new MainMenu(this);
			menu_mc.x = 3;
			// ------------------------------------------------------------------------------------ Title
			var glow:GlowFilter = new GlowFilter(0x000000, 0.7, 4, 4);  
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Arial";
			textFormat.size = 11;
			textFormat.color = 0xFFFFFF;
			textFormat.bold = true;
			title_txt.wordWrap = false;
			title_txt.selectable = false;
			title_txt.mouseEnabled = false;
			title_txt.filters = [glow];
			title_txt.height = 20;	title_txt.width = 635;
			title_txt.x = 80;	title_txt.y = 144;
			title_txt.defaultTextFormat = textFormat;
			title_txt.htmlText = ('Студия ярких идей "Starline" Гужвы Андрея');
			// ------------------------------------------------------------------------------------ Listener
			pouse_btn.addEventListener(MouseEvent.MOUSE_UP, pouseSnd);
			play_btn.addEventListener(MouseEvent.MOUSE_UP, playSnd);
			right_cross_btn.addEventListener(MouseEvent.MOUSE_UP, nextSnd);
			left_cross_btn.addEventListener(MouseEvent.MOUSE_UP, prevSnd);
			bg_mc.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			// ------------------------------------------------------------------------------------Выводим на экран
			addChild(bg_mc);
			addChild(equalizer);
			addChild(soundBar_mc);
			addChild(volumeBar_mc);
			addChild(starCount_mc);
			addChild(title_txt);
            addChild(left_cross_btn);
			addChild(right_cross_btn);
			addChild(pouse_btn);
			addChild(play_btn);
			addChild(menu_mc);
			addChild(radioList_mc);
			addChild(audioList_mc);
			addChild(skinList_mc);
			addChild(cabinetList_mc);
			addChild(friendList_mc);
			addChild(groupList_mc);
			
			addChild(helpWindow_mc);
			
			starCount_mc.pay_votes_btn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { menu_mc.changePage(5);} );
		}
		/////////////////////////////////////////////////////////////////////////////////////
		////------------------------------------------------------------------ Other Function
		/////////////////////////////////////////////////////////////////////////////////////
		public function setLastAudio(title:String):void {
			title_txt.htmlText = title;
			_root.send_server.setLastAudio(title);
		}
		public function setStarCount(cunt:int):void {
			starCount_mc.cash_txt.htmlText = "<b>" + cunt + "</b>";
		}
		public function payBgFunction(bid:uint, price:uint):void {
			if (price <= _root.user_settings.cash) {
				_root.loaderBar_spr.visible = true;
				_root.send_server.payBg(bid);
			} else {
				menu_mc.changePage(5);
			}
		}
		public function getGroupAudio(gid:uint):void {
			_root.loaderBar_spr.visible = true;
			_root.VK.api('audio.get', { gid:gid }, _root.vkApiRequest.fetchGroupAudio, _root.vkApiRequest.requestFail);
		}
		public function getFriendAudio(fid:uint):void {
			_root.loaderBar_spr.visible = true;
			_root.VK.api('audio.get', { uid:fid }, _root.vkApiRequest.fetchFriendAudio, _root.vkApiRequest.requestFail);
		}
		////////////////////////////////////////////////////////////////////////////////
		//// --------------------------------------------------------------------- Music
		////////////////////////////////////////////////////////////////////////////////
		private function onKeyDown(e:KeyboardEvent):void {
			if(globalFocus_flag){
				if (e.keyCode == 32) { // Space
					if(audio_flag){
						(playerSound.play_flag)?pouseSnd():playSnd();	
					}else {
						(radioSound.play_flag)?pouseSnd():playSnd();
					}	
				}
				if(e.keyCode==40) // Down
					audioList_mc.onNext();
				if(e.keyCode==38) // Up
					audioList_mc.onPrev();
				if (e.keyCode == 39) // Right
					soundBar_mc.onCross('r');
				if (e.keyCode == 37) //Left
					soundBar_mc.onCross('l');
			}
		}

		public function onNewPlay(url:String):void {
			if (!audio_flag) {
				playerSound.onClose();
				radioSound.onNewSound(url);
				soundBar_mc.visible = false;
				left_cross_btn.visible = false;
				right_cross_btn.visible = false;
			}else {
				radioSound.onClose();
				playerSound.onNewSound(url);
				playerSound.comlete_flag
				soundBar_mc.setPosition(0);
				soundBar_mc.visible = true;
				left_cross_btn.visible = true;
				right_cross_btn.visible = true;
			}
			pouse_btn.visible = true;
			play_btn.visible = false;
		}
		private function playSnd(e:MouseEvent = null):void {
			pouse_btn.visible = true;
			play_btn.visible = false;
			(audio_flag)?playerSound.onPlay():radioSound.onPlay();
		}
		private function pouseSnd(e:MouseEvent = null): void {
			pouse_btn.visible = false;
			play_btn.visible = true;
			(audio_flag)?playerSound.onPouse():radioSound.onPouse();
		}
		private function nextSnd(e:MouseEvent):void {
			audioList_mc.onNext();
		}
		private function prevSnd(e:MouseEvent):void {
			audioList_mc.onPrev();
		}
	}
}