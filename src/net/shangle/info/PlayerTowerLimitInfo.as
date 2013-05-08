package net.shangle.info
{
	import net.shangle.vo.PlayerTowerLimitVO;
	
	public class PlayerTowerLimitInfo
	{
		public function PlayerTowerLimitInfo()
		{
			init();
		}
		
		private var data:Vector.<PlayerTowerLimitVO>;
		
		public function init():void
		{
			this.data=new Vector.<PlayerTowerLimitVO>();
		}
		
		public function addPlayerTowerLimitVO(playerTowerLimitVO:PlayerTowerLimitVO):void
		{
			this.data.push(playerTowerLimitVO);
		}
		
		public function get playerTowerLimitVOArr():Vector.<PlayerTowerLimitVO>
		{
			return this.data;
		}
		
		public function getPlayerTowerLimitVO(resID:int):PlayerTowerLimitVO
		{
			var playerTowerLimitVO:PlayerTowerLimitVO
			for each(playerTowerLimitVO in this.data)
			{
				if(playerTowerLimitVO.towerResID==resID)
					return playerTowerLimitVO;
			}
			return null;
		}
	}
}