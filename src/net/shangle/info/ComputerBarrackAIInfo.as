package net.shangle.info
{
	import net.shangle.vo.ComputerBarrackAIVO;

	public class ComputerBarrackAIInfo
	{
		public function ComputerBarrackAIInfo()
		{
			init();
		}
		
		private var data:Vector.<ComputerBarrackAIVO>;
		
		public function init():void
		{
			this.data=new Vector.<ComputerBarrackAIVO>();
		}
		
		public function addComputerBarrackAIVO(computerBarrackAIVO:ComputerBarrackAIVO):void
		{
			this.data.push(computerBarrackAIVO);
		}
		
		public function get computerBarrackAIVOArr():Vector.<ComputerBarrackAIVO>
		{
			return this.data;
		}
	}
}