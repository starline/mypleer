package fm.last
{

	import flash.events.Event;

	public class DataAccessEvent extends Event
	{
	  private var _error: Object = new Object;
		private var _data: Object = new Object();

		public function DataAccessEvent(type:String, bubbles:Boolean = false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get data():Object
		{
			return _data;
		}
		public function set data(d:Object):void
		{
			_data = d;
		}
		public function get error():Object
		{
			return _error;
		}
		public function set error(e:Object):void
		{
			_error = e;
		}

	}
}