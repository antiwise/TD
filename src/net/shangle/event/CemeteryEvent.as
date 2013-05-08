package net.shangle.event
{
	import flash.events.Event;
	
	public class CemeteryEvent extends Event
	{
		
		public static const ADD_MONSTER:String="addMonster";
		
		public var monsterResID:int;
		public var lineID:int
		
		public function CemeteryEvent(type:String,monsterResID:int,lineID:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.monsterResID=monsterResID;
			this.lineID=lineID;
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new CemeteryEvent(type,monsterResID,lineID,bubbles,cancelable);
		}
	}
}