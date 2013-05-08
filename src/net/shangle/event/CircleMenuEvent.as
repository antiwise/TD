package net.shangle.event
{
	import flash.events.Event;
	
	import net.shangle.display.CircleMenu;
	
	public class CircleMenuEvent extends Event
	{
		public static const ADD_CIRCLE_MENU:String="addCircleMenu";
		public static const REMOVE_CIRCLE_MENU:String="removeCircleMenu";
		public var circleMenu:CircleMenu;
		
		public function CircleMenuEvent(type:String, circleMenu:CircleMenu, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.circleMenu=circleMenu;
		}
		
		public override function clone():Event
		{
			return new CircleMenuEvent(type,circleMenu,bubbles,cancelable);
		}
	}
}