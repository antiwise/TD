package net.shangle.info
{
	import net.shangle.vo.BarrackVO;

	public class BarrackInfo
	{
		public function BarrackInfo()
		{
			init();
		}
		
		private var data:Vector.<BarrackVO>;
		
		private function init():void
		{
			this.data=new Vector.<BarrackVO>();
		}
		
		public function addBarrackVO(monsterVO:BarrackVO):void
		{
			this.data.push(monsterVO);
		}
		
		public function getBarrackVO(resID:int):BarrackVO
		{
			for each(var barrackVO:BarrackVO in this.data)
			{
				if(barrackVO.resID==resID)
				{
					return barrackVO;
				}
			}
			return null;
		}
		
		public function get barrackVOArr():Vector.<BarrackVO>
		{
			return this.data;
		}
	}
}