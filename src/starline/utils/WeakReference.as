/*
	import utils.WeakReference;
	...
	function getWR(data):WeakReference {
		return new WeakReference(data);
	}
	...
	function doSome(object:BigComplexObject):void{
		
		// получаем weak ссылку на объект
		var weakBigObject:BigComplexObject = getWR(object).get() as BigComplexObject;
		
		// работаем как с обычным объектом
		weakBigObject.Run();
	}
*/
	
package starline.utils {
	
	import flash.utils.Dictionary;
	
	public class WeakReference {
		private var dictionary:Dictionary;
		
		public function WeakReference(p_object:Object) {
			dictionary = new Dictionary(true); // weakKeys = true
			dictionary[p_object] = null; // За счет возможности использования weakKeys, получаем weakReference
		}
		
		public function get object():Object {
			// Пробегаемся по ключам словаря, позвращаем первый попавшийся
			for (var n:Object in dictionary) { return n; } 
		}
	}
}