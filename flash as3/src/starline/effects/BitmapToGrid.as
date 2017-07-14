package starline.effects {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
 
	/**
	 * @author 	Guzhva Andrey
	 * @date	24.12.2010
	 */
	
	public class BitmapToGrid extends Sprite {
	     
      [Embed(source='../../assets/apple.jpg')] private var ImgClass:Class; //встраиваем изображение "1.png" в swf файл
	
      private const ROWS:int = 10; //количество строк в сетке изображения   
      private const COLUMNS:int = 10; //количество столбцов в сетке изображения
      private const INTERVAL:int = 2; //расстояние между кусочками изображения

      public function BitmapToGrid() {
         var img:Bitmap = new ImgClass(); //инициализируем встроенное изображение
         imageDivision(img);
      }
 
      /**
       * Функция делит на равные части входящее изображение и отображает целое изображение,
       * собранное из маленьких кусочков, с промежутком в INTERVAL пикселей
       */
	  
      private function imageDivision(img:Bitmap):void{
         for(var i:int = 0; i < COLUMNS; i++){
            for(var j:int = 0; j < ROWS; j++){
               var bd:BitmapData = new BitmapData(img.width / COLUMNS, img.height / ROWS); //создаём битмап дату (здесь, с размерами 1/5 от размера изображения)
               var rect:Rectangle = new Rectangle(0, 0, bd.width, bd.height); //создаем область с такими же размерами как и у bd
               var matrix:Matrix = new Matrix(); //создаём новую матрицу
               matrix.tx = -bd.width * i;  //при каждом прохождении цикла смещаем матрицу изображения
               matrix.ty = -bd.height * j;
               bd.draw(img, matrix, null, null, rect); //отрисовываем заданный участок из изображения img
               var b:Bitmap = new Bitmap(bd); //создаем контейнер для битмапдаты с частью изображения
               b.x = (b.width + INTERVAL) * i; //выравнимаем контейнер
               b.y = (b.height + INTERVAL) * j;
               addChild(b); //отображаем
            }
         }
      }
   }
}