package net.shangle.vo
{
	import net.shangle.uint.BitmapMCFrameInfo;

	public class TowerVO
	{
		public function TowerVO()
		{
		}
		
		/**
		 * 名字
		 */ 
		public var name:String;
		
		
		/**介绍*/
		public var introduction:String;
		
		/**
		 * 资源ID
		 */
		public var resID:int;
		
		/**
		 * 特效资源ID
		 */
		public var effectResID:int;
		
		/**
		 * 影响数量
		 */ 
		public var effectNum:int;
		
		/**
		 * 影响阵营
		 */ 
		public var effectCamp:int;
		
		/**
		 * 等级 
		 */ 
		public var level:int;
		
		/**
		 * 高度
		 */ 
		public var height:int
		
		/**
		 * 间隔时间
		 */
		public var intervalTime:int;
		
		/**
		 * 升级
		 */
		public var levelUp:int;
		
		/**
		 * 阵营
		 */ 
		public var camp:int;
		
		/**
		 * 修建时间
		 */ 
		public var buildTime:int;
		
		/**
		 * 修建金钱
		 */ 
		public var money:int;
		
		/**
		 * 皮肤地址
		 */ 
		public var skinUrl:String;
		
		/**
		 * 位图信息
		 */ 
		public var bitmapMCFrameInfoArr:Vector.<BitmapMCFrameInfo>;
		
	}
}