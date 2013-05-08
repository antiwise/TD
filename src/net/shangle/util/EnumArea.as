package net.shangle.util
{
	public class EnumArea
	{
		public function EnumArea()
		{
		}
		
		public static const AIR:int=2;
		private static const AIR_LABEL:String="air";
		public static const LAND:int=1;
		private static const LAND_LABEL:String="land";
		public static const BOTH:int=3;
		private static const BOTH_LABEL:String="air&land";
		
		public static function toString(value:int):String
		{
			if(value==AIR)
			{
				return AIR_LABEL;
			}
			else if(value==LAND)
			{
				return LAND_LABEL;
			}
			else 
			{
				return BOTH_LABEL;
			}
			
		}
	}
}