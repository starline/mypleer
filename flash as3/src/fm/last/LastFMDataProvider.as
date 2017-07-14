package fm.last {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import vk.api.MD5;
	import vk.api.serialization.json.JSON;
	

    public class LastFMDataProvider extends EventDispatcher {
		
		//------ LAST FM --
		public static var ERROR:String 		= "error";
		
		public static var LF_ARTIST_GET_INFO:String 		= "artist.getInfo";
		public static var LF_ARTIST_GET_TOP_ALBUMS:String 	= "artist.getTopAlbums";
		public static var LF_ARTIST_GET_SIMILAR:String 		= "artist.getSimilar";
		public static var LF_ALBUM_GET_INFO:String 			= "album.getInfo";
		
		public static var LF_TRACK_GET_INFO:String 			= "track.getInfo";
		
		public static var LF_GET_SESSION:String 			= "auth.getMobileSession";
		
		public static var LF_UPDATE_NOW_PLAYING:String 		= "track.updateNowPlaying";
		public static var LF_SCROBBLE:String 				= "track.scrobble";
        
		
		public static const API_URL:String = "http://ws.audioscrobbler.com/2.0/";
		public static const API_KEY:String = "e626a21620dd4412f482969e245d68b5";
		public static const SECRET:String = "f3799397597bbd2badcf63320456d8ff";
		
		public static var KEY:String;
		
		private var _global_options:Object;
		
		private static var inst:LastFMDataProvider;
		
		
		public static function getInstance():LastFMDataProvider{
			if (!inst)
				inst =  new LastFMDataProvider;
			return inst;
		}
		
		
		public function LastFMDataProvider(){
        }
        
		
		//---------------------------------------------
		public function lf_getSession(username:String, authToken:String):void{
			var params: Object = new Object();
			params['username'] 	= username;
			params['authToken']	= authToken;
			callLFMethod(LF_GET_SESSION, params);	 
		}
		
		
		//---------------------------------------------
		public function lf_updateNowPlaying(artist:String, track:String ):void{
			var params: Object = new Object();
			params['track'] 	= track;
			params['artist']	= artist;
			params['sk']		= KEY;
			callLFMethod(LF_UPDATE_NOW_PLAYING, params);				
		}
		
		
		//---------------------------------------------
		public function lf_scrobble(artist:String, track:String):void{
			var params: Object = new Object();
			params['track'] 	= [track];
			params['artist']	= [artist];
			params['timestamp']	= [int(((new Date).time)/1000)];
			params['sk']		= KEY;
			callLFMethod(LF_SCROBBLE, params);				
		}
		
		
		//---------------------------------------------
		private function callLFMethod(method:String, params:Object):void{
			request(method, {
				params: params,
				onComplete: function(data:Object):void {
					var e:DataAccessEvent = new DataAccessEvent(method);
					e.data = data;
					dispatchEvent(e);
				},
				onError: function(error:Object):void {
					var e:DataAccessEvent = new DataAccessEvent(ERROR);
					e.error = error;
					dispatchEvent(e);
				}
			});
		}
		
		
		//---------------------------------------------
        public function request(method:String, options:Object = null):void{
            var onComplete:Function, onError:Function;
            if (options == null){
                options = new Object();
            }
            options.onComplete = options.onComplete ? options.onComplete : (_global_options.onComplete ? _global_options.onComplete : null);
            options.onError = options.onError ? options.onError : (_global_options.onError ? _global_options.onError : null);
            _sendAppRequest(method, options);
        }
		
		
        private function _sendAppRequest(method:String, options:Object):void {
			
            var request_params:Object = { method: method };
			request_params['api_key'] = API_KEY;
          //  request_params['autocorrect'] = "1";
			
			
            if (options.params){
                for (var i:String in options.params){
                    request_params[i] = options.params[i];
                }
            }
			request_params['api_sig'] = _generate_signature(request_params);
			request_params['format'] = "json";
            var variables:URLVariables = new URLVariables();
            for (var j:String in request_params){
                variables[j] = request_params[j];
            }
			
            var request:URLRequest = new URLRequest();
            request.url = API_URL;
            request.method = URLRequestMethod.POST;
            request.data = variables;
			
            var loader:URLLoader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.TEXT;
            if (options.onError){
                var error:Object = new Object;
                loader.addEventListener(IOErrorEvent.IO_ERROR, function():void{
                    error.message = "Connection error occured";
                    options.onError(error);
                });
                loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function():void{
                    error.message = "Security error occured";
                    options.onError(error);
                });
            }
			
            loader.addEventListener(Event.COMPLETE, function(e:Event):void{
                var loader:URLLoader = URLLoader(e.target);
                var data:Object = JSON.decode(loader.data);
                if (data.error){
                    options.onError(data);
                } else if (options.onComplete && data){
                    options.onComplete(data);
                }
            });
            try{
                loader.load(request);
            }catch(error:Error){
                options.onError(error);
            }
        }
		
		
		private function _generate_signature(request_params: Object): String {
			var signature: String = "";
			var sorted_array: Array = new Array();
			for (var key: String in request_params) {
				sorted_array.push(key + request_params[key]);
			}
			sorted_array.sort();
			
			// Note: make sure that the signature parameter is not already included in
			//       request_params array.
			for (key in sorted_array) {
				signature += sorted_array[key];
			}
			
			signature += SECRET;
			return MD5.encrypt(signature);
		}
    }
}