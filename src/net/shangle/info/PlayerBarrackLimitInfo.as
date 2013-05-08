package net.shangle.info
{
	import net.shangle.vo.PlayerBarrackLimitVO;

	public class PlayerBarrackLimitInfo
	{
		public function PlayerBarrackLimitInfo()
		{
			init();
		}
		
		private var data:Vector.<PlayerBarrackLimitVO>;
		
		public function init():void
		{
			this.data=new Vector.<PlayerBarrackLimitVO>();
		}
		
		public function addPlayerBarrackLimitVO(playerBarrackLimitVO:PlayerBarrackLimitVO):void
		{
			this.data.push(playerBarrackLimitVO);
		}
		
		public function get playerBarrackLimitVOArr():Vector.<PlayerBarrackLimitVO>
		{
			return this.data;
		}
		
		public function getPlayerBarrackLimitVO(resID:int):PlayerBarrackLimitVO
		{
			var playerBarrackLimitVO:PlayerBarrackLimitVO
			for each(playerBarrackLimitVO in this.data)
			{
				if(playerBarrackLimitVO.barrackResID==resID)
					return playerBarrackLimitVO;
			}
			return null;
		}
	}
}