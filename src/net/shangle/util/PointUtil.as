package net.shangle.util
{
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class PointUtil
	{
		public function PointUtil()
		{
		}
		
		private static var dx:int;
		private static var dy:int;
		
		public static function distance(xa:int,ya:int,xb:int,yb:int):int
		{
			dx=xa-xb;
			dy=ya-yb;
			return Math.sqrt(dx*dx+dy*dy);
		}
		
	}
}