package net.shangle.event
{
	import flash.events.Event;
	
	public class ClassLoaderEvent extends Event
	{
		
		public static const LOAD_COMPLETE:String="loadComplete";
		
		public function ClassLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}