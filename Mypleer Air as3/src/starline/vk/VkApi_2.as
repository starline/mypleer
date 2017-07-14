package starline.vk{

	import flash.display.Sprite;
	import flash.net.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	
	import starline.utils.*;

	// http://starline-studio.com
	// Guzhva Andrey
	// 03.01.2010

	public class VkApi_2 extends Sprite {
		
		// API vars
		private var _root:*;
		private var viewer_id:int;
		private var api_id:int;
		private var api_url:String;
		private var api_secret:String;
		private var test_mode:int;
		
		// help vars
		private var select_api:String;
		private var min_price:Number;

		public function VkApi_2(_root:*,viewer_id:int,api_id:int,api_url:String,api_secret:String,test_mode:int) {
			this._root = _root;
			this.viewer_id = viewer_id;
			this.api_id = api_id;
			this.api_url = api_url;
			this.api_secret = api_secret;
			this.test_mode = test_mode;
		}
		// -------------------------------------------------------------------------------- Api messages_get
		public function messagesGet():void {
			select_api = 'messages_get';
			var loader_api:URLLoader = new URLLoader();
			var request_api:URLRequest = new URLRequest(api_url);
			var p_arr:Array = new Array();
			p_arr.push( { pn: "api_id", pv: api_id } );
			p_arr.push( { pn: "method", pv:'messages.get' } );
			p_arr.push( { pn: "count", pv: '100' } );
			p_arr.push( { pn: "v", pv: '2.0' } );
			p_arr.push( { pn: "test_mode", pv: test_mode } );
			p_arr.push( { pn: "format", pv: 'JSON' } );
			var url_vars:URLVariables = new URLVariables();
			for (var i:uint = 0; i < p_arr.length; i++) {
				url_vars[ (p_arr[i].pn) ] = p_arr[i].pv;
			}
			url_vars["sig"] = makeSig( p_arr );
			request_api.method = URLRequestMethod.POST;
			request_api.data = url_vars;
			listenersApi(loader_api);
			loader_api.load(request_api);
		}
		
		// -------------------------------------------------------------------------------- Api getAds
		public function getAds(min_price:Number = 0.1):void {
			this.min_price = min_price;
			select_api = 'getAds';
			var loader_api:URLLoader = new URLLoader();
			var request_api:URLRequest = new URLRequest(api_url);
			var p_arr:Array = new Array();
			p_arr.push( { pn: "api_id", pv: api_id } );
			p_arr.push( { pn: "method", pv:'getAds' } );
			p_arr.push( { pn: "count", pv: '1' } );
			p_arr.push( { pn: "type", pv: '3' } );
			//p_arr.push( { pn: "min_price", pv: min_price } );
			p_arr.push( { pn: "v", pv: '2.0' } );
			p_arr.push( { pn: "test_mode", pv: test_mode } );
			p_arr.push( { pn: "format", pv: 'JSON' } );
			var url_vars:URLVariables = new URLVariables();
			for (var i:uint = 0; i < p_arr.length; i++) {
				url_vars[ (p_arr[i].pn) ] = p_arr[i].pv;
			}
			url_vars["sig"] = makeSig( p_arr );
			request_api.method = URLRequestMethod.POST;
			request_api.data = url_vars;
			listenersApi(loader_api);
			loader_api.load(request_api);
		}
		// -------------------------------------------------------------------------------- Api getFriends
		public function getFriends():void {
			_root.muteButton.appendText('getFriends \n');  // Output
			_root.load_bar_mc.visible = true;
			select_api = 'getFriends';
			var loader_api:URLLoader = new URLLoader();
			var request_api:URLRequest = new URLRequest(api_url);
			var p_arr:Array = new Array();
			p_arr.push( { pn: "api_id", pv: api_id } );
			p_arr.push( { pn: "method", pv:'getFriends' } );
			p_arr.push( { pn: "v", pv: '2.0' } );
			p_arr.push( { pn: "test_mode", pv: test_mode } );
			p_arr.push( { pn: "format", pv: 'JSON' } );
			var url_vars:URLVariables = new URLVariables();
			for (var i:uint = 0; i < p_arr.length; i++) {
				url_vars[ (p_arr[i].pn) ] = p_arr[i].pv;
			}
			url_vars["sig"] = makeSig( p_arr );
			request_api.method = URLRequestMethod.POST;
			request_api.data = url_vars;
			listenersApi(loader_api);
			loader_api.load(request_api);
		}
		// -------------------------------------------------------------------------------- Api getGroups
		public function getGroups():void {
			_root.muteButton.appendText('getFriends \n');  // Output
			_root.load_bar_mc.visible = true;
			select_api = 'getGroups';
			var loader_api:URLLoader = new URLLoader();
			var request_api:URLRequest = new URLRequest(api_url);
			var p_arr:Array = new Array();
			p_arr.push( { pn: "api_id", pv: api_id } );
			p_arr.push( { pn: "method", pv:'getGroups' } );
			p_arr.push( { pn: "v", pv: '2.0' } );
			p_arr.push( { pn: "test_mode", pv: test_mode } );
			p_arr.push( { pn: "format", pv: 'JSON' } );
			var url_vars:URLVariables = new URLVariables();
			for (var i:uint = 0; i < p_arr.length; i++) {
				url_vars[ (p_arr[i].pn) ] = p_arr[i].pv;
			}
			url_vars["sig"] = makeSig( p_arr );
			request_api.method = URLRequestMethod.POST;
			request_api.data = url_vars;
			listenersApi(loader_api);
			loader_api.load(request_api);
		}
		// -------------------------------------------------------------------------------- Api getGroupsFull
		public function getGroupsFull(gids:String):void {
			_root.muteButton.appendText('getProfiles \n');  // Output
			_root.load_bar_mc.visible = true;
			select_api = 'getGroupsFull';
			var loader_api:URLLoader = new URLLoader();
			var request_api:URLRequest = new URLRequest(api_url);
			var p_arr:Array = new Array();
			p_arr.push( { pn: "api_id", pv: api_id } );
			p_arr.push( { pn: "uids", pv: gids } );
			p_arr.push( { pn: "method", pv:'getGroupsFull' } );
			p_arr.push( { pn: "v", pv: '2.0' } );
			p_arr.push( { pn: "test_mode", pv: test_mode } );
			p_arr.push( { pn: "format", pv: 'JSON' } );
			var url_vars:URLVariables = new URLVariables();
			for (var i:uint = 0; i < p_arr.length; i++) {
				url_vars[ (p_arr[i].pn) ] = p_arr[i].pv;
			}
			url_vars["sig"] = makeSig( p_arr );
			request_api.method = URLRequestMethod.POST;
			request_api.data = url_vars;
			listenersApi(loader_api);
			loader_api.load(request_api);
		}
		// -------------------------------------------------------------------------------- Api getProfiles
		public function getProfiles(uids:String):void{
			_root.muteButton.appendText('getProfiles \n');  // Output
			_root.load_bar_mc.visible = true;
			select_api = 'getProfiles';
			var loader_api:URLLoader = new URLLoader();
			var request_api:URLRequest = new URLRequest(api_url);
			var p_arr:Array = new Array();
			p_arr.push( { pn: "api_id", pv: api_id } );
			p_arr.push( { pn: "uids", pv: uids } );
			p_arr.push( { pn: "name_case", pv: 'nom' } );
			p_arr.push( { pn: "fields", pv: 'uid,first_name,last_name,sex,photo_rec,photo_medium,city,country,bdate' } );
			p_arr.push( { pn: "method", pv:'getProfiles' } );
			p_arr.push( { pn: "v", pv: '2.0' } );
			p_arr.push( { pn: "test_mode", pv: test_mode } );
			p_arr.push( { pn: "format", pv: 'JSON' } );
			var url_vars:URLVariables = new URLVariables();
			for (var i:uint = 0; i < p_arr.length; i++) {
				url_vars[ (p_arr[i].pn) ] = p_arr[i].pv;
			}
			url_vars["sig"] = makeSig( p_arr );
			request_api.method = URLRequestMethod.POST;
			request_api.data = url_vars;
			listenersApi(loader_api);
			loader_api.load(request_api);
		}
		// -------------------------------------------------------------------------------- Api getCityById
		public function getCityBiId(cids:String):void {
			select_api = 'getCityById';
			var loader_api:URLLoader = new URLLoader();
			var request_api:URLRequest = new URLRequest(api_url);
			var p_arr:Array = new Array();
			p_arr.push( { pn: "api_id", pv: api_id } );
			p_arr.push( { pn: "method", pv:'places.getCityById' } );
			p_arr.push( { pn: "cids", pv: cids } );
			p_arr.push( { pn: "v", pv: '2.0' } );
			p_arr.push( { pn: "test_mode", pv: test_mode } );
			p_arr.push( { pn: "format", pv: 'JSON' } );
			var url_vars:URLVariables = new URLVariables();
			for (var i:uint = 0; i < p_arr.length; i++) {
				url_vars[ (p_arr[i].pn) ] = p_arr[i].pv;
			}
			url_vars["sig"] = makeSig( p_arr );
			request_api.method = URLRequestMethod.POST;
			request_api.data = url_vars;
			listenersApi(loader_api);
			loader_api.load(request_api);
		}
		// -------------------------------------------------------------------------------- Api getCountryById
		public function getCountryById(cids:String):void {
			select_api = 'getCountryById';
			var loader_api:URLLoader = new URLLoader();
			var request_api:URLRequest = new URLRequest(api_url);
			var p_arr:Array = new Array();
			p_arr.push( { pn: "api_id", pv: api_id } );
			p_arr.push( { pn: "method", pv:'places.getCountryById' } );
			p_arr.push( { pn: "cids", pv: cids } );
			p_arr.push( { pn: "v", pv: '2.0' } );
			p_arr.push( { pn: "test_mode", pv: test_mode } );
			p_arr.push( { pn: "format", pv: 'JSON' } );
			var url_vars:URLVariables = new URLVariables();
			for (var i:uint = 0; i < p_arr.length; i++) {
				url_vars[ (p_arr[i].pn) ] = p_arr[i].pv;
			}
			url_vars["sig"] = makeSig( p_arr );
			request_api.method = URLRequestMethod.POST;
			request_api.data = url_vars;
			listenersApi(loader_api);
			loader_api.load(request_api);
		}
		// -------------------------------------------------------------------------------- Api audio_reorder
		public function audioReorder(aid:int, after:int, before:int):void {
			_root.muteButton.appendText('audio_reorder aid:'+aid+' after:'+after+' before:'+before+' \n');  // Output
			_root.load_bar_mc.visible = true;
			select_api = 'audio_reorder';
			var loader_api:URLLoader = new URLLoader();
			var request_api:URLRequest = new URLRequest(api_url);
			var p_arr:Array = new Array();
			p_arr.push( { pn: "api_id", pv: api_id } );
			p_arr.push( { pn: "aid", pv: aid } );
			p_arr.push( { pn: "after", pv: after } );
			p_arr.push( { pn: "before", pv: before } );
			p_arr.push( { pn: "method", pv:'audio.reorder' } );
			p_arr.push( { pn: "v", pv: '2.0' } );
			p_arr.push( { pn: "test_mode", pv: test_mode } );
			p_arr.push( { pn: "format", pv: 'JSON' } );
			var url_vars:URLVariables = new URLVariables();
			for (var i:uint = 0; i < p_arr.length; i++) {
				url_vars[ (p_arr[i].pn) ] = p_arr[i].pv;
			}
			url_vars["sig"] = makeSig( p_arr );
			request_api.method = URLRequestMethod.POST;
			request_api.data = url_vars;
			listenersApi(loader_api);
			loader_api.load(request_api);
		}
		// -------------------------------------------------------------------------------- Api audio_delete
		public function audioDelete(aid:int, oid:int):void {
			_root.muteButton.appendText('audio_delete aid:'+aid+' oid:'+oid+' \n');  // Output
			_root.load_bar_mc.visible = true;
			select_api = 'audio_delete';
			var loader_api:URLLoader = new URLLoader();
			var request_api:URLRequest = new URLRequest(api_url);
			var p_arr:Array = new Array();
			p_arr.push( { pn: "api_id", pv: api_id } );
			p_arr.push( { pn: "aid", pv: aid } );
			p_arr.push( { pn: "oid", pv: oid } );
			p_arr.push( { pn: "method", pv:'audio.delete' } );
			p_arr.push( { pn: "v", pv: '2.0' } );
			p_arr.push( { pn: "test_mode", pv: test_mode } );
			p_arr.push( { pn: "format", pv: 'JSON' } );
			var url_vars:URLVariables = new URLVariables();
			for (var i:uint = 0; i < p_arr.length; i++) {
				url_vars[ (p_arr[i].pn) ] = p_arr[i].pv;
			}
			url_vars["sig"] = makeSig( p_arr );
			request_api.method = URLRequestMethod.POST;
			request_api.data = url_vars;
			listenersApi(loader_api);
			loader_api.load(request_api);
		}
		// -------------------------------------------------------------------------------- Api audio_add
		public function audioAdd(aid:int, oid:int):void {
			_root.muteButton.appendText('audio_add aid:'+aid+' oid:'+oid+' \n');  // Output
			_root.load_bar_mc.visible = true;
			select_api = 'audio_add';
			var loader_api:URLLoader = new URLLoader();
			var request_api:URLRequest = new URLRequest(api_url);
			var p_arr:Array = new Array();
			p_arr.push( { pn: "api_id", pv: api_id } );
			p_arr.push( { pn: "aid", pv: aid } );
			p_arr.push( { pn: "oid", pv: oid } );
			p_arr.push( { pn: "method", pv:'audio.add' } );
			p_arr.push( { pn: "v", pv: '2.0' } );
			p_arr.push( { pn: "test_mode", pv: test_mode } );
			p_arr.push( { pn: "format", pv: 'JSON' } );
			var url_vars:URLVariables = new URLVariables();
			for (var i:uint = 0; i < p_arr.length; i++) {
				url_vars[ (p_arr[i].pn) ] = p_arr[i].pv;
			}
			url_vars["sig"] = makeSig( p_arr );
			request_api.method = URLRequestMethod.POST;
			request_api.data = url_vars;
			listenersApi(loader_api);
			loader_api.load(request_api);
		}
		// -------------------------------------------------------------------------------- Api audio_search
		public function audioSearch(q:String):void {
			_root.muteButton.appendText('audio_search q:'+q+' \n'); // Output
			_root.load_bar_mc.visible = true;
			select_api = 'audio_search';
			var loader_api:URLLoader = new URLLoader();
			var request_api:URLRequest = new URLRequest(api_url);
			var p_arr:Array = new Array();
			p_arr.push( { pn: "api_id", pv: api_id } );
			p_arr.push( { pn: "q", pv: q } );
			p_arr.push( { pn: "count", pv: '200' } );
			p_arr.push( { pn: "method", pv:'audio.search' } );
			p_arr.push( { pn: "v", pv: '2.0' } );
			p_arr.push( { pn: "test_mode", pv: test_mode } );
			p_arr.push( { pn: "format", pv: 'JSON' } );
			var url_vars:URLVariables = new URLVariables();
			for (var i:uint = 0; i < p_arr.length; i++) {
				url_vars[ (p_arr[i].pn) ] = p_arr[i].pv;
			}
			url_vars["sig"] = makeSig( p_arr );
			request_api.method = URLRequestMethod.POST;
			request_api.data = url_vars;
			listenersApi(loader_api);
			loader_api.load(request_api);
		}
		// -------------------------------------------------------------------------------- Api audio_get
		public function audioGet(uid:int,gid:int= 0):void {
			_root.muteButton.appendText('audio_get uid:'+uid+' \n'); // Output
			_root.load_bar_mc.visible = true;
			select_api = 'audio_get';
			var loader_api:URLLoader = new URLLoader();
			var request_api:URLRequest = new URLRequest(api_url);
			var p_arr:Array = new Array();
			p_arr.push( { pn: "api_id", pv: api_id } );
			p_arr.push( { pn: "uid", pv: uid } );
			p_arr.push( { pn: "gid", pv: gid } );
			p_arr.push( { pn: "method", pv:'audio.get' } );
			p_arr.push( { pn: "v", pv: '2.0' } );
			p_arr.push( { pn: "test_mode", pv: test_mode } );
			p_arr.push( { pn: "format", pv: 'JSON' } );
			var url_vars:URLVariables = new URLVariables();
			for (var i:uint = 0; i < p_arr.length; i++) {
				url_vars[ (p_arr[i].pn) ] = p_arr[i].pv;
			}
			url_vars["sig"] = makeSig( p_arr );
			request_api.method = URLRequestMethod.POST;
			request_api.data = url_vars;
			listenersApi(loader_api);
			loader_api.load(request_api);
		}
		// -------------------------------------------------------------------------------- Api getUserBalance
		public function getUserBalance():void {
			_root.load_bar_mc.visible = true;
			select_api = 'getUserBalance';
			var loader_api:URLLoader = new URLLoader();
			var request_api:URLRequest = new URLRequest(api_url);
			var p_arr:Array = new Array();
			p_arr.push( { pn: "api_id", pv: api_id } );
			p_arr.push( { pn: "method", pv:'getUserBalance' } );
			p_arr.push( { pn: "v", pv: '2.0' } );
			p_arr.push( { pn: "test_mode", pv: test_mode } );
			p_arr.push( { pn: "format", pv: 'JSON' } );
			var url_vars:URLVariables = new URLVariables();
			for (var i:uint = 0; i < p_arr.length; i++) {
				url_vars[ (p_arr[i].pn) ] = p_arr[i].pv;
			}
			url_vars["sig"] = makeSig( p_arr );
			request_api.method = URLRequestMethod.POST;
			request_api.data = url_vars;
			listenersApi(loader_api);
			loader_api.load(request_api);
		}
		
		// --------------------------------------------------------------------------------------Make SIG
		private function makeSig( arr:Array ):String {
			var sig:String = "" + viewer_id;
			arr.sortOn( "pn" );
			for (var i:uint = 0; i < arr.length; i++) {
				sig += arr[i].pn + "=" + arr[i].pv;
			}
			sig += api_secret;
			return MD5.encrypt(sig);
		}
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
		// --------------------------------------------------------------------------- Listeners
		private function listenersApi(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		private function completeHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			trace(loader.data);
			if (select_api == 'audio_get') {
				parse_audio(loader.data);
			}
			if (select_api == 'audio_search') {
				parse_audio_search(loader.data);
			}
			if (select_api == 'audio_add') {
			}
			if (select_api == 'audio_delete') {
			}
			if (select_api == 'audio_reorder') {
			}
			if (select_api == 'getProfiles') {
				parse_profiles(loader.data);
			}
			if (select_api == 'getCityById') {
				parse_city(loader.data);
			}
			if (select_api == 'getCountryById') {
				parse_country(loader.data);	
			}
			if (select_api == 'getGroupsFull') {
				parse_groups_full(loader.data);
			}
			if (select_api == 'getFriends') {
				parse_friends(loader.data);
			}
			if (select_api == 'getGroups') {
				parse_groups(loader.data);
			}
			if (select_api == 'getAds') {
				parse_ads(loader.data);
			}
			if (select_api == 'getUserBalance') {
				parse_balanse(loader.data);
			}
		}
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("loade api security Error:" + event);
		}
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("loade api io Error:" + event);
		}
		
		// -------------------------------------------------------------------------- Parse
		private function parse_ads(data:String):void {
			var jsonObj:* = MyJson.decode(data);
		}        
		private function parse_friends(data:String):void {
			var jsonObj:* = MyJson.decode(data);
		}
		private function parse_groups_full(data:String):void {
			var jsonObj:* = MyJson.decode(data);
		}
		private function parse_groups(data:String):void {
			var jsonObj:* = MyJson.decode(data);
		}
		private function parse_balanse(data:String):void {
			var jsonObj:* = MyJson.decode(data);
		}
		private function parse_profiles(data:String):void {
			var jsonObj:* = MyJson.decode(data);
		}
		private function parse_city(data:String):void {
			var jsonObj:* = MyJson.decode(data);
		}
		private function parse_country(data:String):void {
			var jsonObj:* = MyJson.decode(data);

		}
		private function parse_audio(data:String):void {
			var jsonObj:* = MyJson.decode(data);
		}
		private function parse_audio_search(data:String):void {
			var jsonObj:* = MyJson.decode(data);
		}
	}
}