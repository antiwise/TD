package net.shangle.manager
{
	import net.shangle.info.BarrackInfo;
	import net.shangle.info.ChapterFlagInfo;
	import net.shangle.info.ChapterInfo;
	import net.shangle.info.EffectInfo;
	import net.shangle.info.MonsterInfo;
	import net.shangle.info.PlayerRecordInfo;
	import net.shangle.info.TowerInfo;

	public class GlobalInfoManager
	{
		
		private static var instance:GlobalInfoManager;
		
		/**怪物VO信息*/
		public var monsterInfo:MonsterInfo;
		/**兵营VO信息*/
		public var barrackInfo:BarrackInfo;
		/**关卡标志VO信息*/
		public var chapterFlagInfo:ChapterFlagInfo;
		/**关卡信息*/
		public var chapterInfo:ChapterInfo;
		/**当前游戏的金钱*/
		public var money:int;
		/**当前游戏玩家的血量*/
		public var playerCastleBlood:int;
		/**当前游戏电脑的血量*/
		public var computerCastleBlood:int;
		/**防御塔VO信息*/
		public var towerInfo:TowerInfo;
		/**特效VO信息*/
		public var effectInfo:EffectInfo;
		/**玩家记录信息*/
		public var playerRecordInfo:PlayerRecordInfo;
		/**当前游戏的时间*/
		public var time:int;
		
		public function GlobalInfoManager()
		{
			init();
		}
		
		public static function get getInstance():GlobalInfoManager
		{
			if(instance==null)
			{
				instance=new GlobalInfoManager();
			}
			return instance;
		}
		
		private function init():void
		{
			monsterInfo=new MonsterInfo();
			barrackInfo=new BarrackInfo();
			chapterFlagInfo=new ChapterFlagInfo();
			chapterInfo=new ChapterInfo();
			towerInfo=new TowerInfo();
			effectInfo=new EffectInfo();
			playerRecordInfo=new PlayerRecordInfo();
		}
	}
}