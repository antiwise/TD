package net.shangle.util
{
	public class ClockUtil
	{
		public function ClockUtil()
		{
		}
		
		private static var min:int;
		
		public static function getClock(time:int):String
		{
			min=time/60;
			time-=min*60;
			min+=100;
			time+=100
			return min.toString().slice(1)+":"+time.toString().slice(1);
		}
	}
}