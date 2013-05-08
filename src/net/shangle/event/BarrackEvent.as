package net.shangle.event
{
	import flash.events.Event;

	import net.shangle.vo.LineVO;

	public class BarrackEvent extends Event
	{

		public static const ADD_MONSTER : String = "addMonster";
		public static const SELL : String = "sell";
		public var barrackPointID : int;

		public function BarrackEvent(type : String , barrackPointID : int , bubbles : Boolean = false , cancelable : Boolean = false)
		{
			super(type , bubbles , cancelable);
			this.barrackPointID = barrackPointID;
		}

		public override function clone() : Event
		{
			return new BarrackEvent(type , barrackPointID , bubbles , cancelable);
		}
	}
}
