package net.shangle.info
{
	public class PlayerInfo
	{
		public function PlayerInfo()
		{
			init();
		}
		
		public var chapter:int;
		
		public var playerCastleBlood:int;
		
		public var money:int;
		
		public var playerBarrackLimitInfo:PlayerBarrackLimitInfo;
		
		public var playerTowerLimitInfo:PlayerTowerLimitInfo;
		
		public var playerScoreInfo:PlayerScoreInfo;
		
		private function init():void
		{
			this.playerBarrackLimitInfo=new PlayerBarrackLimitInfo();
			this.playerTowerLimitInfo=new PlayerTowerLimitInfo();
			this.playerScoreInfo=new PlayerScoreInfo();
		}
	}
}