package net.shangle.event
{
	import flash.events.Event;
	
	public class ChapterFlagEvent extends Event
	{
		
		public static const SELECTED:String="selected";
		public function ChapterFlagEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}