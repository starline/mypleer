package {
	
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import starline.utils.SistemInfo;
	
	
	/**
	 * ...
	 * @author Andrey Guzhva
	 */
	
	public class Main extends Sprite {
		
		public function Main():void {
			var sis_mc:SistemInfo = new SistemInfo();
			addChild(sis_mc);
			
			var mb:MainAIR = new MainAIR();
			addChild(mb);
			
			/*var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions(); 
			initOptions.transparent = false; 
			var win:NativeWindow = new NativeWindow(initOptions);
			win.activate();*/
			
			/*var htmlView1:HTMLLoader = new HTMLLoader;
			htmlView1.load(new URLRequest('http://vk.com'));
			stage.addChild( htmlView1 );*/
			
			var newWindowRectangle:Rectangle = new Rectangle(200, 100, 790, 380);
			var url:URLRequest = new URLRequest('http://vkontakte.ru/login.php');
			var posrt_vars:URLVariables = new URLVariables();
			posrt_vars.app = 1611909;
			posrt_vars.layout = 'popup';
			posrt_vars.type = 'browser'
			//posrt_vars.settings = ;
			url.data = posrt_vars;
			var htmlView:* = HTMLLoader.createRootWindow(true, null, true, newWindowRectangle);
			htmlView.load(url);
		}
		
	}
	
}



