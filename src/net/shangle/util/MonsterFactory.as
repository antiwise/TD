package net.shangle.util
{
	import net.shangle.display.Boss;
	import net.shangle.display.Creep;
	import net.shangle.display.Monster;
	import net.shangle.display.NormalMonster;
	import net.shangle.vo.MonsterVO;

	public class MonsterFactory
	{
		public function MonsterFactory()
		{
		}
		
		private static const NORMAL:int=1;
		
		private static const BOSS:int=2;
		
		private static const CREEP:int=3;
		
		public static function getMonster(vo:MonsterVO,instanceID:int):Monster
		{
			switch(vo.type)
			{
				case NORMAL:
				{
					return new NormalMonster(vo,instanceID);
				}
				case BOSS:
				{
					return new Boss(vo,instanceID);
				}
				case CREEP:
				{
					return new Creep(vo,instanceID);
				}
			}
			return null;
		}
	}
}