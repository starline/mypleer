package vk.api {
  
  import flash.errors.*;
  import flash.events.*;
  import flash.net.*;
  
  import vk.api.serialization.json.*;
  
  public class DataProvider {
	
	private var _api_sid: String;
	private var _api_url: String = "http://api.vkontakte.ru/api.php";
    private var _api_id: Number;
    private var _api_secret: String;
    private var _viewer_id: Number;
    private var _request_params: Array;
    
    private var _global_options: Object;
    
    
    
    public function DataProvider(api_url: String, api_id: Number, api_sid: String, api_secret: String, viewer_id: Number) {
	  _api_secret = api_secret;
	  _api_sid	  = api_sid;
	  _api_url	  = api_url;
	  _api_id     = api_id;
	  _viewer_id  = viewer_id;
    }
    
    public function setup(options: Object): void {
      _global_options = options;
    }
    
    public function request(method: String, options: Object = null):void {
      var onComplete: Function, onError: Function;
      if (options == null) {
        options = new Object();
      }
      options.onComplete = options.onComplete ? options.onComplete : (_global_options.onComplete ? _global_options.onComplete : null);
      options.onError = options.onError ? options.onError : (_global_options.onError ? _global_options.onError : null);
      _sendRequest(method, options);
    }
    
    
    
    /********************
     * Private methods
     ********************/
	private function _sendRequest(method:String, options:Object):void {
		var self:Object = this;
      
		var request_params: Object = {method: method};
		request_params.api_id = _api_id;
		request_params.format = "JSON";
		request_params.v = "3.0";

		if (options.params) {
			for (var i: String in options.params) {
				request_params[i] = options.params[i];
			}
		}
      
		var variables:URLVariables = new URLVariables();
		for (var j: String in request_params) {
			variables[j] = request_params[j];
		}
		
		variables['sig'] = _generate_signature(request_params);
		variables['sid'] = _api_sid;
		var request:URLRequest = new URLRequest();
		request.url = _api_url;
		request.method = URLRequestMethod.POST;
		request.data = variables;
      
		var loader:URLLoader = new URLLoader();
		loader.dataFormat = URLLoaderDataFormat.TEXT;
		
		// Если задана функция обработки ошибок onError
		if (options.onError) {
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
				options.onError("VK.API.Method:" + method + ". Ошибка в подключении:" + e);
			});
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:SecurityErrorEvent):void {
				options.onError("VK.API.Method:" + method + ". Ошибка безопасности среды:" + e);
			});
		}
      
		// Слушает положительный ответ
		loader.addEventListener(Event.COMPLETE, function(e:Event):void{
			var loader:URLLoader = URLLoader(e.target);
			
			trace(loader.data);
			
			if (loader.data) {
				var data: Object = JSON.decode(loader.data);
				
				// Положительный ответ
				if ((data.response || data.response == 0) && options.onComplete) {
					options.onComplete(data.response);
					
				// Положительный ответ об ошибке
				// 201 	нед доступа к аудиозапися пользователя
				// 15 	нет доступа, аудиозаписи группы отключены
				// 6 	слишком много запросов в секунду, максимум 3
				// 9	
				} else {
					
					// 
					if((data.error.error_code == 9 || data.error.error_code == 6) && options.onError){
						options.onError(data.error.error_code);
						
					// Ошибка о невозможности доступа
					} else if (data.error.error_code == 201 || data.error.error_code == 15) {
						options.onComplete(data.error.error_code);
						
					// Остальные ошибки
					} else {
						options.onError('VK.API.Method:' + method + ".  " +loader.data);
					}
				}
			} else {
				options.onError('VK.API.Method:' + method + ". " +loader.data)
			}
		});
		
		try {
			loader.load(request);
		} catch (error:Error) {
			options.onError('VK.API.Method:' + method + ". " + error);
		}
    }

	
    /**
     * Generates signature
     */
    private function _generate_signature(request_params: Object): String {
		var signature: String = "";
		var sorted_array: Array = new Array();
		for (var key: String in request_params) {
			sorted_array.push(key + "=" + request_params[key]);
		}	
		sorted_array.sort();
		
		// Note: make sure that the signature parameter is not already included in
		// request_params array.
		for (key in sorted_array) {
			signature += sorted_array[key];
		}
		if (_viewer_id > 0) signature = _viewer_id.toString() + signature;
		signature += _api_secret;
		return MD5.encrypt(signature);
    }
  }
}