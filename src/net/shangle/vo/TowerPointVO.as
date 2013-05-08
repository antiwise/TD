package net.shangle.vo
{
	
	/**
	 * 防御塔位置VO
	 * @author Shangle
	 */
	public class TowerPointVO
	{
		/**
		 * 防御塔位置VO
		 */
		public function TowerPointVO()
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
		 * 皮肤地址
		 */ 
		public var skinUrl:String;
		
		/**
		 * 皮肤帧
		 */ 
		public var skinFrame:String;
	}
}