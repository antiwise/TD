package net.shangle.event
{
	import flash.events.Event;

	import net.shangle.display.BarrackPoint;

	public class BarrackPointEvent extends Event
	{

		public static const ADD_BARRACKS : String = "addBarrack";
		public var barrackResID : int;

		public function BarrackPointEvent(type : String , barrackResID : int , bubbles : Boolean = false , cancelable : Boolean = false)
		{
			super(type , bubbles , cancelable);
			this.barrackResID = barrackResID;
		}

		public override function clone() : Event
		{
			return new BarrackPointEvent(type , barrackResID , bubbles , cancelable);
		}
	}
}
