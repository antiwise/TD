package net.shangle.vo
{
	import net.shangle.uint.BitmapMCFrameInfo;

	public class EffectVO
	{
		public function EffectVO()
		{
		}
		
		/**名字*/
		public var name:String;

		
		/**资源ID*/
		public var resID:int;
		
		/**类型*/
		public var type:int;
		
		/**
		 *  攻击类型
		 */ 
		public var attackType:int;
		
//		/**升级*/
//		public var levelUp:int;
		
//		/**阵营*/
//		public var camp:int;
		
		/**伤害*/
		public var value:int;
		
		/**范围*/
		public var area:int;
		
//		/**持续时间*/
//		public var time:int;
		
		/**皮肤*/
		public var skinUrl:String;
		
		/**
		 * 位图信息
		 */ 
		public var bitmapMCFrameInfoArr:Vector.<BitmapMCFrameInfo>;
	}
}