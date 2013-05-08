package net.shangle.info
{
	import net.shangle.vo.TowerPointVO;
	
	public class TowerPointInfo
	{
		public var chapter:int;
		
		public function TowerPointInfo()
		{
			init();
		}
		
		private var data:Vector.<TowerPointVO>;
		
		public function init():void
		{
			this.data=new Vector.<TowerPointVO>();
		}
		
		public function addTowerPointVO(towerPointVO:TowerPointVO):void
		{
			this.data.push(towerPointVO);
		}
		
		public function getTowerPointVO(id:int):TowerPointVO
		{
			for each(var towerPointVO:TowerPointVO in this.data)
			{
				if(towerPointVO.id==id)
				{
					return towerPointVO;
				}
			}
			return null;
		}
		
		public function get towerPointVOArr():Vector.<TowerPointVO>
		{
			return this.data;
		}
	}
}