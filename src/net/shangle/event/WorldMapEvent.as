package net.shangle.event
{
	
	public class WorldMapEvent
	{
		public static function getEventType(chapterID:int):String
		{
			return "playEnd"+chapterID;
		}
		
		public static function getChapterID(type:String):int
		{
			return int(type.slice(type.length-1));
		}
	}
}