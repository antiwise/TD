package net.shangle.vo
{
	import flash.geom.Point;

	/**
	 * 兵营位置VO
	 * @author Shangle
	 */
	public class BarrackPointVO
	{
		/**
		 * 兵营位置VO
		 */
		public function BarrackPointVO()
		{
		}
		
		/**
		 * ID
		 * @default 
		 */
		public var id:int;
		
		/**
		 * 阵营
		 */
		public var camp:int;
		
		/**
		 * X坐标
		 */
		public var x:int;
		
		/**
		 * Y坐标
		 */
		public var y:int;
		
		/**
		 * 出兵线路
		 */
		public var lineIDArr:Array;
		
		/**
		 * 皮肤地址
		 */ 
		public var skinUrl:String;
		
		/**
		 * 皮肤帧
		 */ 
		public var skinFrame:String;
		
	}
}