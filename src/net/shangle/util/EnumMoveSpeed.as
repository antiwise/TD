package net.shangle.util
{
	public class EnumMoveSpeed
	{
		public function EnumMoveSpeed()
		{
		}
		
		private static const VERY_FAST:Number=2.5;
		private static const VERY_FAST_LABEL:String="very fast";
		private static const FAST:Number=2;
		private static const FAST_LABEL:String="fast";
		private static const MIDDLE:Number=1.5;
		private static const MIDDLE_LABEL:String="middle";
		private static const SLOW:Number=1;
		private static const SLOW_LABEL:String="slow";
		private static const VERY_SLOW_LABEL:String="very slow";
		
		public static function toString(value:Number):String
		{
			if(value>=VERY_FAST)
			{
				return VERY_FAST_LABEL;
			}
			else if(value >=FAST)
			{
				return FAST_LABEL;
			}
			else if(value >= MIDDLE)
			{
				return MIDDLE_LABEL;
			}
			else if(value>=SLOW)
			{
				return SLOW_LABEL;
			}
			else
			{
				return VERY_SLOW_LABEL;
			}
		}
		
		
	}
}