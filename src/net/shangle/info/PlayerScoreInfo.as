package net.shangle.info
{
	import net.shangle.vo.PlayerScoreVO;

	public class PlayerScoreInfo
	{
		public function PlayerScoreInfo()
		{
			init();
		}
		
		private var data:Vector.<PlayerScoreVO>;
		
		private function init():void
		{
			this.data=new Vector.<PlayerScoreVO>();
		}
		
		public function addPlayerScoreVO(playerScoreVO:PlayerScoreVO):void
		{
			this.data.push(playerScoreVO);
		}
		
		public function getScore(time:int,blood:int):int
		{
			for each(var playerScoreVO:PlayerScoreVO in this.data)
			{
				if(time<= playerScoreVO.time && blood>=playerScoreVO.blood)
				{
					return playerScoreVO.score;
				}
			}
			return 1;
		}
		
//		public function get playerScoreVOArr():Vector.<PlayerScoreVO>
//		{
//			return this.data;
//		}
	}
}