package net.shangle.event
{
	import flash.events.Event;
	
	public class ProgressBarEvent extends Event
	{
		public static const COMMON:String="common";
		
		public function ProgressBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new ProgressBarEvent(type,bubbles,cancelable);
		}
	}
}