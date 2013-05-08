package net.shangle.info
{
	import net.shangle.vo.ComputerBossAIVO;
	
	public class ComputerBossAIInfo
	{
		public function ComputerBossAIInfo()
		{
			init();
		}
		
		private var data:Vector.<ComputerBossAIVO>;
		
		public function init():void
		{
			this.data=new Vector.<ComputerBossAIVO>();
		}
		
		public function addComputerBossAIVO(computerBossAIVO:ComputerBossAIVO):void
		{
			this.data.push(computerBossAIVO);
		}
		
		public function get computerBossAIVOArr():Vector.<ComputerBossAIVO>
		{
			return this.data;
		}
	}
}