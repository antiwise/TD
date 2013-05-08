package net.shangle.vo
{
	import net.shangle.uint.BitmapMCFrameInfo;

	/**
	 * 怪物VO
	 * @author Shangle
	 */
	public class MonsterVO
	{
		/**
		 * 怪物VO
		 */
		public function MonsterVO()
		{
		}
		
		/**
		 * 介绍
		 */ 
		public var introduction:String;
		
		/**
		 * 名字
		 */ 
		public var name:String;
		
		/**
		 * 类型
		 */ 
		public var type:int;
		
		/**
		 * 资源ID
		 */ 
		public var resID:int;
		
		/**
		 * 阵营
		 */ 
		public var camp:int;
		
		/**
		 * 移动速度
		 */
		public var speed:Number;
		
		/**
		 * 高度
		 */
		public var height:int;
		
		/**
		 * 血量
		 */
		public var maxBlood:int;
		
		/**
		 * 攻击力
		 */
		public var attackDamage:int;
		
		/**
		 * 攻击频率
		 */
		public var attackFrequency:Number;
		
		/**
		 * 攻击范围
		 */
		public var attackRange:int;
		
		/**
		 * 攻击区域
		 */
		public var attackArea:int;
		
		/**
		 * 移动区域
		 */
		public var moveArea:int;
		
		/**
		 * 攻击类型
		 */
		public var attackType:int;
		
		/**
		 * 护甲
		 */
		public var armor:int;
		
		/**
		 * 魔抗
		 */
		public var magicResistance:int;
		
		/**
		 * 金钱
		 */ 
		public var money:int;
		
		/**
		 * 摧毁城堡的血量
		 */ 
		public var destoryCastleBlood:int;
		
		/**
		 * 资源地址
		 */ 
		public var skinUrl:String;
		
		/**
		 * 位图信息
		 */ 
		public var bitmapMCFrameInfoArr:Vector.<BitmapMCFrameInfo>;
	}
}