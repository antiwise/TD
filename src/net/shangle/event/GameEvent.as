package net.shangle.event
{
	import flash.events.Event;
	
	public class GameEvent extends Event
	{
		public static const RETURN_MENU:String="returnMenu";
		public static const VICTORY:String="victory";
		
		public var score:int;
		public var time:String;
		
		public function GameEvent(type:String,score:int=0,time:String=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.score=score;
			this.time=time;
		}
		
		public override function clone():Event
		{
			return new GameEvent(type,score,time,bubbles,cancelable);
		}
	}
}