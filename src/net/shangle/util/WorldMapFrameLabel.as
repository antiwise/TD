package net.shangle.util
{
	public class WorldMapFrameLabel
	{
		public function WorldMapFrameLabel()
		{
		}
		
		public static function getChapterStartFrameLabel(chapter:int):String
		{
			return (chapter-1)+"to"+chapter;
		}
		
		public static function getChapterEndFrameLable(chapter:int):String
		{
			return (chapter-1)+"to"+chapter+"End";
		}
	}
}