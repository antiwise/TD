package net.shangle.util
{
	public class EnumAttackType
	{
		public function EnumAttackType()
		{
		}
		
		public static const PHYSICAL:int=1;
		private static const PHYSICAL_LABEL:String="physical";
		public static const MAGIC:int=2;
		private static const MAGIC_LABEL:String="magic";
		public static const HOLY:int=3;
		private static const HOLY_LABEL:String="holy";
		
		public static function toString(value:int):String
		{
			if(value==PHYSICAL)
			{
				return PHYSICAL_LABEL;
			}
			else if(value==MAGIC)
			{
				return MAGIC_LABEL;
			}
			else if(value==HOLY)
			{
				return HOLY_LABEL;
			}
			else
			{
				return "--";
			}
		}
	}
}