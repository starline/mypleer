package starline.server {
	
	import flash.net.*;
	import flash.errors.*;
	import flash.events.*;
	import starline.utils.MD5;
	import vk.api.serialization.json.JSON;
	
	/**
	 * @author 	Andrey Guzhva
	 * @site 	aguzhva.com
	 * @date 	15.10.2012
	 */
	
	public class ServerApi_2{
		
		private	var app_secret:String;
		private var app_id:int;
		private var uid:int;
		private var api_url:String;
		
		public function ServerApi_2(app_id:int, uid:int, app_secret:String, api_url:String) {
			this.app_id = app_id;
			this.uid = uid;
			this.app_secret = app_secret;
			if (!(api_url.indexOf('http://') == 0 || api_url.indexOf('https://') == 0)) {
				api_url = 'http://' + api_url;
			}
			this.api_url = api_url;
		}
		
		public function api(method:String, params:Object = null, onComplete:* = null, onError:* = null):void {
			var request_params:Object = {method: method};
			request_params.uid = uid;
			if (params) {
				for (var i: String in params) {
					request_params[i] = params[i];
				}
			}
			
			var variables:URLVariables = new URLVariables();
			for (var j: String in request_params) {
				variables[j] = request_params[j];
			}
			
			variables['sig'] = generateSignature(request_params);
			var request:URLRequest = new URLRequest();
			request.url = api_url;
			request.method = URLRequestMethod.POST;
			request.data = variables;
		  
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			
			if (onError) {
				loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
					onError("MP.API.Method:" + method + ". Ошибка в подключении:" + e);
				});
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:SecurityErrorEvent):void {
					onError("MP.API.Method:" + method + ". Ошибка безопасности среды:" + e);
				});
			}
		  
			loader.addEventListener(Event.COMPLETE, function(e:Event):void {
				var loader:URLLoader = URLLoader(e.target);
				trace(loader.data);
				if(loader.data){
					var data: Object = JSON.decode(loader.data);
					if ((data.response || data.response == 0) && onComplete) {
						onComplete(data.response);
					} else {
						if(data.error && onError){
							onError('MP.API.Method:' + method + ". " + loader.data);
						} else {
							onError('MP.API.Method:' + method + ". " + loader.data);
						}
					}
				}else {
					onError('MP.API.Method:' + method + ". " +loader.data);
				}
			});
			
			try {
				loader.load(request);
			} catch (error:Error) {
				onError('MP.API.Method:' + method + ". " + error);
			}	
		}		
		
		/////////////////////////////////////////////////////////////////////////////////////
		////------------------------------------------------------------- Generates signature
		/////////////////////////////////////////////////////////////////////////////////////
		private function generateSignature(request_params: Object): String {
			var signature: String = "";
			var sorted_array: Array = new Array();
			
			request_params.app_id = app_id.toString();
			
			for (var key: String in request_params) {
				sorted_array.push(key + "=" + request_params[key]);
			}
			sorted_array.sort();

			// Note: make sure that the signature parameter is not already included in
			//       request_params array.
			for (key in sorted_array) {
				signature += sorted_array[key];
			}
			signature += app_secret;
			return MD5.encrypt(signature);
		}
	}
}