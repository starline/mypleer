// LinkButton DisplayState
package vk.gui{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
  
	  /**
	  * @author Alexey Kharkov
	  */
	internal class LinkButtonDS extends Sprite {
	  
		public function LinkButtonDS( bt:uint, state:uint, s:String, fs:uint, tf:uint, w:uint, h:uint ):void {
			
			// fs - Font Size
			// tf - Text Format
		  
			tf |= Utils.TXT_AUTOSIZE;
		  
			if ( state == 1 )
				tf |= Utils.TXT_UNDERLINE;
		  
			if ( w > 0  &&  h > 0 )
				tf |= Utils.TXT_MULTILINE;
		  
			var txt:TextField = Utils.addText( 0, 0, w, fs, s, Utils.BUT1_TXT_COL, tf, h );
			var glow:GlowFilter = new GlowFilter(0x000000, 0.7, 4, 4);    
			txt.filters = [glow];
		  
			addChild( txt );
		}
	}
}
