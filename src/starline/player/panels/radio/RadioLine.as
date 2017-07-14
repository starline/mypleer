package starline.player.panels.radio {
        
	import com.adobe.images.JPGEncoder;
	import flash.display.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.filters.GlowFilter; 
	import flash.events.*;
	import starline.ui.simple.DrawRoundRect;
	import starline.ui.text.CreateTextField;
	
	import starline.player.Main;
	import starline.player.components.StidStar;
	import starline.player.components.StidState;
	import starline.ui.simple.DrawRect;
	import vk.api.serialization.json.JSON;
	import com.adobe.images.PNGEncoder;
	import name.acorp.MultipartData;

	
	/**
	* @author 		Guzhva Andrey
	* @siet 		http://aguzhva.com
	* @date			06.02.2013
	* @project	 	Mypleer.com
	*/
	
	public class RadioLine extends Sprite {
			
		private var _parent:*;
		private var _root:*;
		
		// Vars
		public var n:uint;
		public var n_sort:uint;
		public var url:String;
		public var stid:uint;
		public var artist:String = "Radio";
		public var title:String;
		public var photo:String;
		public var city:String;
		public var teg:String;
		public var stid_rating:int;
		public var uid_rating:int;
		public var state:uint;
		// Loader
		public var loader:Loader = new Loader();
		private var request:URLRequest = new URLRequest();
		private var loaderBitmapData:BitmapData;
		// Interface
		private var rollOverBg_sp:DrawRoundRect = new DrawRoundRect(0xffffff, 100 , 100, 5);
		private var clickBg_sp:DrawRoundRect = new DrawRoundRect(0xffffff, 100 , 100, 5);
		private var dclickBg_sp:DrawRoundRect = new DrawRoundRect(0x0099FF, 100 , 100, 5);
		private var n_txt:TextField = new TextField();
		private var square:DrawRoundRect = new DrawRoundRect(0x000000, 100 , 100, 5);
		private var hit:DrawRoundRect = new DrawRoundRect(0x0099FF, 100 , 100, 5);
		private var loader_mc:Sprite = new Sprite();
		private var stidStar_mc:StidStar = new StidStar();
		private var stidState_mc:StidState = new StidState();
		
		public function RadioLine(_root:*, _parent:*, n:int, p:*, ratBtn_flag:Boolean = false):void {
			this._root = _root;
			this._parent = _parent;
			this.n = n;
			this.url= p.url;
			this.stid = p.stid;
			this.photo = p.photo;
			this.title =  p.name;
			//this.city = p.city;
			this.teg = p.teg;
			this.stid_rating = p.stid_rating;
			this.uid_rating = p.uid_rating;
			this.state = p.state;
			
			createInterface();

			n_txt.text = title;
			stidStar_mc.count_txt.text = String(stid_rating);
			stidStar_mc.starOn_mc.visible = (uid_rating > 0)?true:false;
			stidState_mc.stateOn_mc.visible = (state == 1)?true:false;
			showRating(false);

			request.url = Main.CS_SERVER_URL + Main.STATIONS_FOLDER + photo;
			var loaderContext:LoaderContext = new LoaderContext(true);
			loader.load(request, loaderContext);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, displayImage, false, 0, true);
			
			// Listener
			addEventListener(MouseEvent.ROLL_OVER, selectOver, false,0,true);
			addEventListener(MouseEvent.ROLL_OUT, selectOut, false,0,true);
			hit.addEventListener(MouseEvent.CLICK, selectClick);
			hit.doubleClickEnabled  = true;
			hit.addEventListener(MouseEvent.DOUBLE_CLICK, selectDclick, false, 0, true);
			
			// Rating
			if(ratBtn_flag){
				stidStar_mc.starOn_mc.addEventListener(MouseEvent.CLICK, cutRating, false,0,true);
				stidStar_mc.starOff_mc.addEventListener(MouseEvent.CLICK, addRating, false, 0, true);
			}else {
				stidStar_mc.starOff_mc.mouseEnabled = false;
				stidStar_mc.starOn_mc.mouseEnabled = false;
			}
		}
		
		
		// -------------------------------------------------------- loader
		private function displayImage(evt:Event):void {
			loader_mc.addChild(loader.content);
			loader.alpha = 0;
			addEventListener(Event.ENTER_FRAME, vanishing, false,0,true);
		}       
		
		private function vanishing(event:Event):void {
			if (loader.alpha < 1) {
					loader.alpha += 0.1;
			}else {
					removeEventListener(Event.ENTER_FRAME, vanishing);
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////
		// ------------------------------------------------------------------------- Line MouseEvent
		////////////////////////////////////////////////////////////////////////////////////////////
		private function selectOver(event:MouseEvent):void { 
			rollOverBg_sp.alpha = 0.2;      // наведене мышки
			showRating(true);
		}
		private function selectOut(event:MouseEvent):void { 
			rollOverBg_sp.alpha = 0.1;     // отвидение мышки 
			showRating(false);
		}
		private function selectClick(event:MouseEvent):void { 
			_parent.onClick(n);				// нажатие на аудиозапись
		}
		private function selectDclick(event:MouseEvent):void { 
			_parent.onDclick(n);			// двойное нажатие на аудиозапись
		}
		public function onClick():void {
			clickBg_sp.alpha = 0.2;
		}
		public function onDclick():void {
			dclickBg_sp.alpha = 0.6;
		}
		public function unClick():void {
			clickBg_sp.alpha = 0;
		}
		public function unDclick():void {
			dclickBg_sp.alpha = 0;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////
		// ------------------------------------------------------------------------------     Rating
		////////////////////////////////////////////////////////////////////////////////////////////
		private function addRating(e:MouseEvent):void {
			stidStar_mc.starOn_mc.visible = true;
			stidStar_mc.count_txt.text = String(stid_rating += 1);
			_root.MP.api(
				'station.setRating',
				{stid: stid, rating: 1},
				function(data:Object):void {
					_root.loaderBar_spr.visible = false;
				},
				_root.mpApiRequest.requestFail
			);
			_root.loaderBar_spr.visible = true;
			if(_root.player_mc.app_settings_arr['station_post'] == true){
				_root.VK.api('wall.getPhotoUploadServer', {uid:_root.flashVars['viewer_id']}, fetchPhotoUploadServer, _root.vkApiRequest.requestFail);
			}
		}
		
		private function cutRating(e:MouseEvent):void {
			stidStar_mc.starOn_mc.visible = false;
			stidStar_mc.count_txt.text = String(stid_rating -= 1);
			_root.MP.api(
				'station.setRating',
				{stid: stid, rating: 0 },
				function(data:Object):void {
					_root.loaderBar_spr.visible = false;
				},
				_root.mpApiRequest.requestFail
			);
			_root.loaderBar_spr.visible = true;
		}
		
		private function showRating(visible:Boolean):void {
			if (uid_rating > 0) {
				stidStar_mc.count_txt.visible = visible;
			}else {
				stidStar_mc.visible = visible;
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////
		// --------------------------------------------------------------------------- wall.savePost
		////////////////////////////////////////////////////////////////////////////////////////////
		private function fetchPhotoUploadServer(data:Object):void {
			createPost(data.upload_url);
		}
		
		
		private function createPost(uploadUrl:String):void {
			/*var myBitmapData:BitmapData = new BitmapData(100, 75);
			var screen_mc:Sprite = new Sprite();
			var text2size:uint = 22;
			if (title.length > 13) { text2size = 15;}
			var text1:CreateTextField = new CreateTextField( 13, "Tahoma", 0x016EB6, 'left', true);
			var text2:CreateTextField = new CreateTextField( text2size, "Tahoma", 0x009900, 'left', true);
			var text3:CreateTextField = new CreateTextField( 20, "Tahoma", 0x000000, 'left', true);
			
			text1.text = 'Я слушаю радиостанцию';	text1.x = 120;	text2.y = 70;	screen_mc.addChild(text1);
			text2.text = title;						text2.x = 110;	text2.y = 25;	screen_mc.addChild(text2);
			text3.text = String(stid_rating);		text3.x = 160;	text3.y = 65;	screen_mc.addChild(text3);

			var starBmD:BitmapData = new BitmapData(30, 30);
			starBmD.draw(stidStar_mc.starOn_mc);
			var starBmp:Bitmap = new Bitmap(starBmD);
			starBmp.x = 130;	starBmp.y = 65;	screen_mc.addChild(starBmp);

			myBitmapData.draw(screen_mc);
			*/
			
			var logoBD:BitmapData = new BitmapData(100, 100);
			logoBD.draw(loader.content);
			//myBitmapData.copyPixels(logoBD, new Rectangle(0, 0, logoBD.width, logoBD.height), new Point(0,0));
			
			//var bmp:Bitmap = new Bitmap(myBitmapData); // Выводим пост на экран 
			//_root.addChild(bmp);
			
			var encoder:JPGEncoder = new JPGEncoder(90);
			//На входе - ссылка на объект BitmapData, на выходе - ссылка на объект ByteArray, представляющий бинарный код готовой картинки.
			var picture:ByteArray = encoder.encode(logoBD);
 
			var urlRequest: URLRequest = new URLRequest();
			urlRequest.url = uploadUrl;
	        var data:MultipartData = new MultipartData();
            data.addFile(picture, "photo");
			urlRequest.data = data.data;
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.requestHeaders.push(new URLRequestHeader("Content-type", "multipart/form-data; boundary=" + MultipartData.BOUNDARY));
			// Configure listeners
			var file:URLLoader = new URLLoader();
			file.addEventListener( Event.COMPLETE, onImageCreated); //--функция обработчик  события создания фотки
			try {
				file.load(urlRequest);
			} catch (error:Error) {
				trace(error);
			}
		}
		
		private function onImageCreated(e:Event): void {
			trace('Data: ' + e.target.data);
			//showLoader(false);
			var data:Object = JSON.decode(e.target.data);
			if (data.photo) {
				data.message = 'Я слушаю '+ title + '. Рейтинг станции: ' + stid_rating + ' звёзд.';
				data.wall_id = _root.flashVars['viewer_id'];
				data.post_id = stid;
				_root.VK.api('wall.savePost', data, function(response: Object): void {
					_root.vkCallMethod.saveWallPost(response.post_hash);
					}, _root.vkApiRequest.requestFail);
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////
		// ------------------------------------------------------------------------------- Interface
		////////////////////////////////////////////////////////////////////////////////////////////
		private function createInterface():void {
			rollOverBg_sp.alpha = 0.1;	addChild(rollOverBg_sp);
			clickBg_sp.alpha = 0;	addChild(clickBg_sp);
			dclickBg_sp.alpha = 0;	addChild(dclickBg_sp);
			
			addChild(loader_mc);	addChild(square);
			loader_mc.mask = square;
			
			var glow:GlowFilter = new GlowFilter(0x000000, 0.7, 4, 4);                      
			var n_tf:TextFormat = new TextFormat();
			n_tf.font = "Arial";
			n_tf.size = 10;
			n_tf.bold = true;
			n_tf.color = 0xFFFFFF;
			n_txt.selectable = false;
			n_txt.mouseEnabled = false;
			n_txt.wordWrap = true;
			n_txt.height = 30;
			n_txt.width = 94;
			n_txt.defaultTextFormat = n_tf;
			n_txt.x = 3;    n_txt.y = 70;
			n_txt.filters = [glow];
			addChild(n_txt);
			
			hit.alpha = 0;
			addChild(hit);
			
			stidStar_mc.x = 2;    stidStar_mc.y = 2;
			stidStar_mc.count_txt.mouseEnabled = false;
			addChild(stidStar_mc);
			
			stidState_mc.x = 87;    stidState_mc.y = 3;
			addChild(stidState_mc);
					
		}
	}
}