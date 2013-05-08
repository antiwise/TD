package net.shangle.event
{
	import flash.events.Event;
	
	
	public class TowerPointEvent extends Event
	{
		
		public static const ADD_TOWER : String = "addTower";
		public var towerResID : int;
		
		public function TowerPointEvent(type : String , towerResID : int , bubbles : Boolean = false , cancelable : Boolean = false)
		{
			super(type , bubbles , cancelable);
			this.towerResID = towerResID;
		}
		
		public override function clone() : Event
		{
			return new TowerPointEvent(type , towerResID , bubbles , cancelable);
		}
	}
}
