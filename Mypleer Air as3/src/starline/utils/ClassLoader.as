package starline.utils {
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	
	/**
	 * ...
	 * @author Andrey Guzhva
	 * 01.02.2011
	 */
	
	public class ClassLoader {
		
		public static var BannerManager:Class = null;
	
		public static function init( obj:*, url:String ):void{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, function(e:Event):void{
				BannerManager = loader.contentLoaderInfo.applicationDomain.getDefinition( "Main" ) as Class;
				obj.onClassLoaded();
			} );
		  
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{
				trace( e.toString() );
			}, false, 0, true );
		  
			loader.load( new URLRequest( url ), new LoaderContext( false, ApplicationDomain.currentDomain ) );
		}
		///////////////////////////////////////////////////////////////////////////////////////
		////---------------------------------------------------------------------------- method
		///////////////////////////////////////////////////////////////////////////////////////
		public static function createBannerManager( _root:*):*{
			return new BannerManager();
		}
		
	}

}