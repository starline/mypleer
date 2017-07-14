package starline.effects {

	import flash.display.*;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.display.Stage;

	public class SnowMaker extends Sprite {
		private var _maxFlakes:Number;
		private var _height:Number;
		private var _width:Number;
		private var _speed:Number;
		private var _stg:MovieClip;
		private var currentFlakes:Number = 0;
		private var angle:Number = 0;
		private var flakeBlur:BlurFilter;
		
		/**
		 * Guzhva Andrey
		 * http://starline-studio.com
		 * Snow Maker. Version 1.1
		 * 24.12.2010
		 */
		
		public function SnowMaker(maxFlakes:Number, speed:Number, stg:MovieClip):void { //Just send this parameters over when creating the instance.
			_maxFlakes = maxFlakes;
			_stg = stg;
			_width = _stg.width;
			_height = _stg.height;
			_speed = speed;
			addEventListener(Event.ENTER_FRAME, makeSnow);
		}

		private function makeSnow(e:Event):void {
			if(currentFlakes <= _maxFlakes){
				var cont:MovieClip = new MovieClip();
				/*flakeBlur = new BlurFilter(2,2,1);
				var filterArray:Array = new Array(flakeBlur);
				cont.filters = filterArray;*/
				_stg.addChild(cont);
				var flake:Sprite = new Sprite();
				flake.graphics.beginFill(0xFFFFFF,(Math.random()));
				flake.graphics.drawCircle(0, 0, (Math.random()*4+1));
				cont.x = Math.random() * _width;
				cont.y = Math.random() * _height - _height;
				cont.yspeed = Math.random() * _speed + _speed; //flake fall speed
				cont.xmove = Math.random()*20+50;
				cont.addEventListener(Event.ENTER_FRAME, flakeFall);
				cont.addChild(flake);
				currentFlakes++;
			}
		}
		
		/*
		 * Функция клонирует MovieClip как BitmapData. Повышает производительность при массовом клонировании
		*/
		private function cloneMovieClip(original:MovieClip, clone:MovieClip):void{
			var tempData:BitmapData=new BitmapData(original.width,original.height,false,0xffffff);
			var tempBitmap:Bitmap=new Bitmap(tempData);
			tempData.draw(original);
			clone.addChild(tempBitmap);
		}

		private function flakeFall(e:Event):void {

			var dieFlake:MovieClip = e.currentTarget as MovieClip;
			dieFlake.y += dieFlake.yspeed;
			dieFlake.x = dieFlake.x+(Math.sin(angle/dieFlake.xmove)); //Oscillating X movement
			angle+=0.01;

			if (e.currentTarget.y >= _height) {
				currentFlakes--;
				dieFlake.removeEventListener(Event.ENTER_FRAME, flakeFall);
				_stg.removeChild(dieFlake);
			}
		}
	}
}