package net.shangle.util
{
	public class ChapterFlagFrameLabel
	{
		public function ChapterFlagFrameLabel()
		{
		}
		
		public static const NEW_FRAME_LABEL:String="new";
		
//		public static const COMPLETE_FRAME_LABLE:String="complete";
		
		public static function getCompleteFrameLabel(score:int):String
		{
			return "complete-"+score;
		}

	}
}