package net.shangle.event
{
	import flash.events.Event;
	
	public class UIEvent extends Event
	{
		public static const PAUSE:String="pause";
		
		public static const SOUND:String="sound";
		
		public static const OPTION:String="option";
		
		public static const DIC:String="dic";
		
		public function UIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}