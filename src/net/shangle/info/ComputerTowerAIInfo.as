package net.shangle.info
{
	import net.shangle.vo.ComputerTowerAIVO;
	
	public class ComputerTowerAIInfo
	{
		public function ComputerTowerAIInfo()
		{
			init();
		}
		
		private var data:Vector.<ComputerTowerAIVO>;
		
		public function init():void
		{
			this.data=new Vector.<ComputerTowerAIVO>();
		}
		
		public function addComputerTowerAIVO(computerTowerAIVO:ComputerTowerAIVO):void
		{
			this.data.push(computerTowerAIVO);
		}
		
		public function get computerTowerAIVOArr():Vector.<ComputerTowerAIVO>
		{
			return this.data;
		}
	}
}