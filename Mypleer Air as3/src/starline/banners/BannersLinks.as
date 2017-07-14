package starline.banners{

	import flash.display.Sprite; ;

	// http://starline-studio.com
	// Guzhva Andrey
	// 24.11.2010

	public class BannersLinks extends Sprite  {
		
		public var banner_arr:Array = [
				//['1', '1'], 																																	// Fase 2 fase
				//['http://www.ad.admitad.com/fbanner/c623a286a6427083158c928ec2673f', 'http://www.ad.admitad.com/goto/c623a286a6427083158c928ec2673f'], 		// Arena RU
				///////Фотострана
				//['http://widgets.fotocash.ru/728x90/728x90_8.swf', 'http://fotostrana.ru/start/getpet?ref_id=407234907&myPetId=26'], 							// Фотострана Петы
				//['http://start.fotostrana.ru/vkontakte/part_dating/fotostrana_partners_600x120.swf?ref_id=493672589', '0'], 									// Фотострана dating
				//['http://start.fotostrana.ru/vkontakte/dating/600x120/600x120_guess_drink.swf?ref_id=493672589', '0'], 
				//['http://start.fotostrana.ru/vkontakte/dating/600x120/600x120_gift.swf?ref_id=493672589', '0'], 
				//['http://start.fotostrana.ru/vkontakte/part_dating/fotostrana_partners_600x120_v3.swf?ref_id=400651350', '2'], 								// Фотострана dating
				['http://start.fotostrana.ru/vkontakte/part_dating/600x120_marks.swf?ref_id=400651350', '0'], 													// Фотострана dating
				['http://start.fotostrana.ru/vkontakte/part_dating/fotostrana_partners_600x120_v2.swf?ref_id=979564132', '2'], 									// Фотострана dating
				//////////////
				//['http://gameleads.ru/promo/957/957/728x90_siloy_misly2.swf', 'http://gameleads.ru/guide.php?cid=b2789a9c9c63631fbe255bb25d429480'],			// 
				//['3','3'],																																		// Adflow
				//['4','4'],																																		// Tackru
			];
		
		public function BannersLinks() {
		}
		
		public function getBannersArr():Array {
			return banner_arr;
		}
	}
}