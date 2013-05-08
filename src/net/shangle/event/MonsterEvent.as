package net.shangle.event
{
	import flash.events.Event;

	public class MonsterEvent extends Event
	{
		public static const REACH_THE_END : String = "reachTheEnd";
		public static const DYING : String = "dying";
		public static const DIE : String = "die";

		public function MonsterEvent(type : String ,bubbles : Boolean = false , cancelable : Boolean = false)
		{
			super(type , bubbles , cancelable);
		}

		public override function clone() : Event
		{
			return new MonsterEvent(type , bubbles , cancelable);
		}
	}
}
