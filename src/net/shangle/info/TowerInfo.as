package net.shangle.info
{
	import net.shangle.vo.TowerVO;
	
	public class TowerInfo
	{
		public function TowerInfo()
		{
			init();
		}
		
		private var data:Vector.<TowerVO>;
		
		public function init():void
		{
			this.data=new Vector.<TowerVO>();
		}
		
		public function addTowerVO(towerVO:TowerVO):void
		{
			this.data.push(towerVO);
		}
		
		public function getTowerVO(resID:int):TowerVO
		{
			for each(var towerVO:TowerVO in this.data)
			{
				if(towerVO.resID==resID)
				{
					return towerVO;
				}
			}
			return null;
		}
		
		public function get towerVOArr():Vector.<TowerVO>
		{
			return this.data;
		}
	}
}