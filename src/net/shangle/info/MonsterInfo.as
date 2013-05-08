package net.shangle.info
{
	import net.shangle.vo.MonsterVO;

	public class MonsterInfo
	{
		public function MonsterInfo()
		{
			init();
		}
		
		private var data:Vector.<MonsterVO>;
		
		private function init():void
		{
			this.data=new Vector.<MonsterVO>();
		}
		
		public function addMonsterVO(monsterVO:MonsterVO):void
		{
			this.data.push(monsterVO);
		}
		
		public function getMonsterVO(resID:int):MonsterVO
		{
			for each(var monsterVO:MonsterVO in this.data)
			{
				if(monsterVO.resID==resID)
				{
					return monsterVO;
				}
			}
			return null;
		}
	}
}