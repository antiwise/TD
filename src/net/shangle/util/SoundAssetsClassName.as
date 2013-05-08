package net.shangle.util
{
	public class SoundAssetsClassName
	{
		public function SoundAssetsClassName()
		{
		}
		
		public static const BACKGROUND_SOUND:String="BackgroundSound";
		
		public static function getChapterSound(chapter:int):String
		{
			return "Chapter"+chapter+"Sound";
		}
	}
}