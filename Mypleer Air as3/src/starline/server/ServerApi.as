package starline.server {

	import flash.display.Sprite;
	import flash.net.*;
	import flash.events.*;
	import flash.xml.*;
	
	import starline.utils.*;

	// http://starline-studio.com
	// Guzhva Andrey
	// 10.01.2010

	public class ServerApi extends Sprite {

		public var _root:*;
		
		private var viewer_id:uint;
		private var server_url:String;
		
		
		public function ServerApi(_root:*, viewer_id:uint, server_url:String):void {
			this._root = _root;
			this.viewer_id = viewer_id;
			this.server_url = server_url;
		}
		// -------------------------------------------------------------------------------- Api add_last_au
		public function setLastAudio(last_au:String):void {
			var method:String = 'set_last_audio';
			var server_loader:URLLoader = new URLLoader();
			var server_request:URLRequest = new URLRequest(server_url + 'api.php');
			var url_vars:URLVariables = new URLVariables();
			url_vars['method'] = method;
			url_vars['last_au'] = last_au;
			url_vars['uid'] = viewer_id;
			server_request.method = URLRequestMethod.POST;
			server_request.data = url_vars;
			server_listeners(server_loader, method);
			server_loader.load(server_request);
		}
		
		// -------------------------------------------------------------------------------- Api get_stations
		public function getStations(teg:String):void {
			var method:String = 'get_stations';
			var server_loader:URLLoader = new URLLoader();
			var server_request:URLRequest = new URLRequest(server_url + 'api.php');
			var url_vars:URLVariables = new URLVariables();
			url_vars['method'] = method;
			url_vars['teg'] = teg;
			url_vars['uid'] = viewer_id;
			server_request.method = URLRequestMethod.POST;
			server_request.data = url_vars;
			server_listeners(server_loader, method);
			server_loader.load(server_request);
		}
		
		// -------------------------------------------------------------------------------- Api add_stations
		public function addStations(stid:uint):void {
			var method:String = 'add_stations';
			var server_loader:URLLoader = new URLLoader();
			var server_request:URLRequest = new URLRequest(server_url + 'api.php');
			var url_vars:URLVariables = new URLVariables();
			url_vars['method'] = method;
			url_vars['stid'] = stid;
			url_vars['uid'] = viewer_id;
			server_request.method = URLRequestMethod.POST;
			server_request.data = url_vars;
			server_listeners(server_loader, method);
			server_loader.load(server_request);
		}
		
		// -------------------------------------------------------------------------------- pay_votes
		public function payVotes(votes:uint):void {
			var method:String = 'pay_votes';
			var server_loader:URLLoader = new URLLoader();
			var server_request:URLRequest = new URLRequest(server_url + 'api.php');
			var url_vars:URLVariables = new URLVariables();
			url_vars['method'] = method;
			url_vars['votes'] = votes;
			url_vars['uid'] = viewer_id;
			server_request.method = URLRequestMethod.POST;
			server_request.data = url_vars;
			server_listeners(server_loader, method);
			server_loader.load(server_request);
		}
		
		// -------------------------------------------------------------------------------- Pay bg
		public function payBg(bid:uint):void {
			var method:String = 'pay_bg';
			var server_loader:URLLoader = new URLLoader();
			var server_request:URLRequest = new URLRequest(server_url + 'api.php');
			var url_vars:URLVariables = new URLVariables();
			url_vars['method'] = method;
			url_vars['uid'] = viewer_id;
			url_vars['bid'] = bid;
			server_request.method = URLRequestMethod.POST;
			server_request.data = url_vars;
			server_listeners(server_loader, method);
			server_loader.load(server_request);
		}
		
		// -------------------------------------------------------------------------------- Save bg
		public function saveBg(bid:uint):void {
			var method:String = 'save_bg';
			var server_loader:URLLoader = new URLLoader();
			var server_request:URLRequest = new URLRequest(server_url + 'api.php');
			var url_vars:URLVariables = new URLVariables();
			url_vars['method'] = method;
			url_vars['uid'] = viewer_id;
			url_vars['bid'] = bid;
			server_request.method = URLRequestMethod.POST;
			server_request.data = url_vars;
			server_listeners(server_loader, method);
			server_loader.load(server_request);
		}
		
		// -------------------------------------------------------------------------------- API get_bg
		public function getBg(teg:String):void {
			var method:String = 'get_bg';
			var server_loader:URLLoader = new URLLoader();
			var server_request:URLRequest = new URLRequest(server_url + 'api.php');
			var url_vars:URLVariables = new URLVariables();
			url_vars['method'] = method;
			url_vars['uid'] = viewer_id;
			//url_vars['teg'] = teg;
			server_request.method = URLRequestMethod.POST;
			server_request.data = url_vars;
			server_listeners(server_loader, method);
			server_loader.load(server_request);
		}
		
		// -------------------------------------------------------------------------------- API get_cash
		public function getCash():void {
			var method:String = 'get_cash';
			var server_loader:URLLoader = new URLLoader();
			var server_request:URLRequest = new URLRequest(server_url + 'api.php');
			var url_vars:URLVariables = new URLVariables();
			url_vars['method'] = method;
			url_vars['uid'] = viewer_id;
			server_request.method = URLRequestMethod.POST;
			server_request.data = url_vars;
			server_listeners(server_loader, method);
			server_loader.load(server_request);
		}
		
		// -------------------------------------------------------------------------------- API auth_user
		public function authUser(first_name:String, last_name:String, sex:int, fid:int):void {
			var method:String = 'auth_user';
			var server_loader:URLLoader = new URLLoader();
			var server_request:URLRequest = new URLRequest(server_url + 'api.php');
			var url_vars:URLVariables = new URLVariables();
			url_vars['method'] = method;
			url_vars['uid'] = viewer_id;
			url_vars['first_name'] = first_name;
			url_vars['last_name'] = last_name;
			url_vars['sex'] = sex;
			if (fid != viewer_id) {
				url_vars['fid'] = fid;
			}else {
				url_vars['fid'] = 0;
			}
			server_request.method = URLRequestMethod.POST;
			server_request.data = url_vars;
			server_listeners(server_loader, method);
			server_loader.load(server_request);
		}
		// -------------------------------------------------------------------------------- API add_ads
		public function add_ads():void {
			var method:String = 'add_ads';
			var server_loader:URLLoader = new URLLoader();
			var server_request:URLRequest = new URLRequest(server_url + 'api.php');
			var url_vars:URLVariables = new URLVariables();
			url_vars['method'] = method;
			url_vars['uid'] = viewer_id;
			server_request.method = URLRequestMethod.POST;
			server_request.data = url_vars;
			server_listeners(server_loader, method);
			server_loader.load(server_request);
		}
		// --------------------------------------------------------------------------------------Make SIG
		/*private function makeSig( arr:Array ):String {
			var sig:String = "" + viewer_id;
			arr.sortOn( "pn" );
			for (var i:uint = 0; i < arr.length; i++) {
				sig += arr[i].pn + "=" + arr[i].pv;
			}
			sig += api_secret;
			return MD5.encrypt(sig);
		}*/
		// -------------------------------------------------------------------------- Helper methods
		private function delQuotes( s_:String ):String{
			var s:String = s_;
			if ( s ){
				s = s.replace( /<br>/g, "\n" );
				s = s.replace( /&amp;/g, "\&" );
				s = s.replace( /&quot;/g, "\"" );
				s = s.replace( /&\#34;/g, "\"" );
				s = s.replace( /&\#39;/g, "\'" );
			}
			return s;
		}
		/////////////////////////////////////////////////////////////////////////////////////////
		////--------------------------------------------------------------------------- Listeners
		/////////////////////////////////////////////////////////////////////////////////////////
		private function server_listeners(dispatcher:IEventDispatcher, method:String):void {
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function (e:SecurityErrorEvent):void {
					trace("securityErrorHandler: " + e);
				});
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
					trace("ioErrorHandler: " + e);
				});
			dispatcher.addEventListener(Event.COMPLETE, function (e:Event):void {
				trace(e.target.data);
				var loader:URLLoader = URLLoader(e.target);
				if (method == 'get_stations') {parseGetStations(loader.data);}
				if (method == 'add_stations') {}
				if (method == 'auth_user') {parseAuthUser(loader.data);}
				if (method == 'add_ads') {}
				if (method == 'get_cash') {parseGetCash(loader.data);}
				if (method == 'get_bg') {parseGetBg(loader.data);}
				if (method == 'save_bg') {}
				if (method == 'pay_bg') {parsePayBg(loader.data);}
				if (method == 'pay_votes') {parsePayVotes(loader.data);}
				if (method == 'set_last_audio') {}
			});
		}
		/////////////////////////////////////////////////////////////////////////////////////
		////-------------------------------------------------------------------------- Parse
		/////////////////////////////////////////////////////////////////////////////////////
		private function parseGetStations(data:String):void {
			var jsonObj:* = MyJson.decode(data);
			if (jsonObj.response != null) {
				var response:Array = jsonObj.response;
				var radio:Array = new Array();
				for ( var i:int = 0; i < response.length; ++i ){
					var p:* = response[i];
					radio.push( { "url":p.url, "stid":p.stid, "photo":p.photo, "name":delQuotes(p.name), "teg":p.teg } );
				}
				_root.player_mc.radioList_mc.onRadioList(radio);
			}
        }
		private function parseGetCash(data:String):void {
			var jsonObj:* = MyJson.decode(data);
			if (jsonObj.response != null) {
				var response:Array = jsonObj.response;
				_root.user_settings.cash = response[0].cash;
				_root.player_mc.setStarCount(response[0].cash);
			}
		}
		private function parseAuthUser(data:String):void {
			var jsonObj:* = MyJson.decode(data);
			if (jsonObj.response != null) {
				_root.onAuthUser(jsonObj.response[0]);
			}
		}
		private function parseGetBg(data:String):void {
			var jsonObj:* = MyJson.decode(data);
			if (jsonObj.response != null) {
				var response:Array = jsonObj.response;
				var skin:Array = new Array();
				for ( var i:int = 0; i < response.length; ++i ){
					var p:* = response[i];
					skin.push( { "bid":p.bid, "url":p.url, "prev_url":p.prev_url, "price":p.price, "teg":p.teg, "order":p.order } );
				}
				_root.player_mc.skinList_mc.onList(skin);
			}
		}
		private function parsePayBg(data:String):void {
			var jsonObj:* = MyJson.decode(data);
			if (jsonObj.response != null) {
				_root.loaderBar_spr.visible = false;
				_root.player_mc.skinList_mc.setApplyBgByBid(jsonObj.response);
				_root.send_server.getCash();
			}
		}
		private function parsePayVotes(data:String):void {
			_root.loaderBar_spr.visible = false;
			var jsonObj:* = MyJson.decode(data);
			if (jsonObj.response != null) {
				_root.user_settings.cash = jsonObj.response ;
				_root.player_mc.setStarCount(jsonObj.response);
			}
		}
	}
}