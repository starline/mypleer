package starline.player.panels.cabinet.panels {
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import fm.last.DataAccessEvent;
    import fm.last.LastFMDataProvider;
	
	import vk.api.MD5;
    import vk.gui.Box;
	
	import starline.player.components.LastFm;
	
	
	/**
	 * LastFMLogin
	 */
	public class LastFMLogin extends LastFm {
		
		public var _root:*;
		
		/**
		 * Constructor
		 */
		public function LastFMLogin(_root:*){
			
			this._root = _root;
			
			LastFMDataProvider.getInstance();
			gotoAndStop(1);
			
			activateInterface();
		}
		
		
		/**
		 * activateInterface
		 */
		private function activateInterface():void {
			loginBtn.addEventListener(MouseEvent.CLICK, onLoginClick);
			
			psw.displayAsPassword = true;
			
			registr.useHandCursor = true;
			registr.buttonMode = true;
			registr.mouseChildren = false;
			registr.addEventListener(MouseEvent.CLICK, onRegClick);
		}
		
		
		/**
		 * onRegClick
		 */
		private function onRegClick(e:MouseEvent):void{
			navigateToURL(new URLRequest("http://www.lastfm.ru/join"));
		}
		
		
		/**
		 * onLoginClick
		 */
		private function onLoginClick(e:MouseEvent):void{
			var token:String = MD5.encrypt(login.text.toLocaleLowerCase() + MD5.encrypt(psw.text));
			LastFMDataProvider.getInstance().addEventListener(LastFMDataProvider.LF_GET_SESSION, onGetSession);
			LastFMDataProvider.getInstance().addEventListener(LastFMDataProvider.ERROR, onError);
			LastFMDataProvider.getInstance().lf_getSession(login.text, token);
			
		}
		
		
		/**
		 * onGetSession
		 */
		private function onGetSession(e:DataAccessEvent):void{
			trace('lastfm: logged in');
			
			LastFMDataProvider.getInstance().removeEventListener(LastFMDataProvider.LF_GET_SESSION, onGetSession);
			LastFMDataProvider.getInstance().removeEventListener(LastFMDataProvider.ERROR, onError);
			
			LastFMDataProvider.KEY = e.data.session.key;
			_root.MP.api("lastfm.saveLogin", {login:login.text, password:psw.text}, function(data:Object):void{ trace('lastFM login & password saved')}, _root.mpApiRequest.requestFail);
			
			loginBtn.removeEventListener(MouseEvent.CLICK, onLoginClick);
			gotoAndStop(2);
			closeBtn.addEventListener(MouseEvent.CLICK, logoutLastFM);
		}
		
		
		/**
		 * logoutLastFM
		 */
		private function logoutLastFM(e:MouseEvent):void{
			removeEventListener(MouseEvent.CLICK, logoutLastFM);
			LastFMDataProvider.KEY = null;
			
			// Необходимо реализовать отключение в базе
			
			// Показываем формы входа
			gotoAndStop(1);
			activateInterface();
		}
		
		
		/**
		 * onError
		 */
		private function onError(e:DataAccessEvent):void{
			LastFMDataProvider.getInstance().removeEventListener(LastFMDataProvider.LF_GET_SESSION, onGetSession);
			LastFMDataProvider.getInstance().removeEventListener(LastFMDataProvider.ERROR, onError);
			
			var popUp_mc:Box = new Box("Ошибка!", "Логин или Пароль введен не верно", 200, 600, ["Закрыть"] );
			
			popUp_mc.setVisible(true);
			_root.addChild(popUp_mc);
		}
		
		
		/**
		 * changeFrame
		 */
		public function changeFrame():void{
			loginBtn.removeEventListener(MouseEvent.CLICK, onLoginClick);
			gotoAndStop(2);
			closeBtn.addEventListener(MouseEvent.CLICK, logoutLastFM);
		}
	}
}