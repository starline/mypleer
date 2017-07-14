package com.anttikupila.demo {
	import flash.display.CapsStyle;	
	import flash.events.MouseEvent;	
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;	

	/**
	 * @author Antti Kupila
	 */
	public class Timeline extends Sprite {
		
		//---------------------------------------------------------------------
		//
		//  Variables
		//
		//---------------------------------------------------------------------
		
		private var bufferIndicator : Sprite;
		private var positionIndicator : Shape;
		
		private var totalWidth : Number;
		
		private var position : Number;
		
		
		//---------------------------------------------------------------------
		//
		//  Constructor
		//
		//---------------------------------------------------------------------
		
		public function Timeline( width : Number ) {
			totalWidth = width;
			
			bufferIndicator = new Sprite( );
			bufferIndicator.graphics.lineStyle( 20, 0x00FFFF, 0, false, LineScaleMode.NONE, CapsStyle.NONE );
			bufferIndicator.graphics.lineTo( width, 0 );
			bufferIndicator.graphics.moveTo( 0, 0 );
			bufferIndicator.graphics.lineStyle( 1, 0xFFFFFF, 0.2, false, LineScaleMode.NONE );
			bufferIndicator.graphics.lineTo( width, 0 );
			bufferIndicator.buttonMode = true;
			bufferIndicator.addEventListener( MouseEvent.CLICK, bufferClickHandler );
			addChild( bufferIndicator );
			
			positionIndicator = new Shape( );
			positionIndicator.graphics.lineStyle( 1, 0xFFEE00, 0.5, false, LineScaleMode.NONE );
			positionIndicator.graphics.lineTo( width, 0 );
			addChild( positionIndicator );
			
			bufferIndicator.scaleX = positionIndicator.scaleX = 0;
		}
		
		
		//---------------------------------------------------------------------
		//
		//  Events
		//
		//---------------------------------------------------------------------
		
		protected function bufferClickHandler( event : MouseEvent ) : void {
			position = bufferIndicator.mouseX * bufferIndicator.scaleX / totalWidth;
		}

		
		//---------------------------------------------------------------------
		//
		//  Public methods
		//
		//---------------------------------------------------------------------
		
		public function update( loaded : Number, position : Number ) : void {
			bufferIndicator.scaleX = loaded;
			positionIndicator.scaleX = position;
		}
		
		public function getPosition() : Number {
			return position;
		}
	}
}
