package net.shangle.info
{
	import net.shangle.vo.BarrackPointVO;

	public class BarrackPointInfo
	{
		public var chapter:int;
		
		public function BarrackPointInfo()
		{
			init();
		}
		
		private var data:Vector.<BarrackPointVO>;
		
		public function init():void
		{
			this.data=new Vector.<BarrackPointVO>();
		}
		
		public function addBarrackPointVO(barrackPointVO:BarrackPointVO):void
		{
			this.data.push(barrackPointVO);
		}
		
		public function getBarrackPointVO(id:int):BarrackPointVO
		{
			for each(var barrackPointVO:BarrackPointVO in this.data)
			{
				if(barrackPointVO.id==id)
				{
					return barrackPointVO;
				}
			}
			return null;
		}
		
		public function get barrackPointVOArr():Vector.<BarrackPointVO>
		{
			return this.data;
		}
	}
}