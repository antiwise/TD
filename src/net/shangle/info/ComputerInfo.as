package net.shangle.info
{
	public class ComputerInfo
	{
		public function ComputerInfo()
		{
			init();
		}
		
		public var chapter:int
		
		public var computerCastleBlood:int;
		
		public var computerBarrackAIInfo:ComputerBarrackAIInfo;
		
		public var computerTowerAIInfo:ComputerTowerAIInfo;
		
		public var computerBossAIInfo:ComputerBossAIInfo;
		
		public var computerCreepAIInfo:ComputerCreepAIInfo;
		
		private function init():void
		{
			this.computerBarrackAIInfo=new ComputerBarrackAIInfo();
			this.computerTowerAIInfo=new ComputerTowerAIInfo();
			this.computerBossAIInfo=new ComputerBossAIInfo();
			this.computerCreepAIInfo=new ComputerCreepAIInfo();
		}
	}
}