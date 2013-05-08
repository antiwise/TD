package net.shangle.util
{
	public class CircleMenuBtnAssetsClassName
	{
		public function CircleMenuBtnAssetsClassName()
		{
		}
		
		public static const UPGRADE_BTN:String="UpgradeBtn";
		
		public static const SELL_BTN:String="SellBtn";
		
		public static const LOCK_BTN:String="LockBtn";
		
		public static const FULL_LEVEL_BTN:String="FullLevelBtn";
		
		public static function getBarrackBtnClassName(barrackResID:int):String
		{
			return "Barrack"+barrackResID+"Btn";
		}
		
		public static function getTowerBtnClassName(towerResID:int):String
		{
			return "Tower"+towerResID+"Btn";
		}
	}
}