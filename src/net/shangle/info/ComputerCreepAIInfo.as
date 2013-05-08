package net.shangle.info
{
	import net.shangle.vo.ComputerCreepAIVO;
	
	public class ComputerCreepAIInfo
	{
		public function ComputerCreepAIInfo()
		{
			init();
		}
		
		private var data:Vector.<ComputerCreepAIVO>;
		
		public function init():void
		{
			this.data=new Vector.<ComputerCreepAIVO>();
		}
		
		public function addComputerCreepAIVO(computerCreepAIVO:ComputerCreepAIVO):void
		{
			this.data.push(computerCreepAIVO);
		}
		
		public function get computerCreepAIVOArr():Vector.<ComputerCreepAIVO>
		{
			return this.data;
		}
	}
}