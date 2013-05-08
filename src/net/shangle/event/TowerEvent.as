package net.shangle.event
{
	import flash.events.Event;
	
	import net.shangle.display.Monster;
	
	public class TowerEvent extends Event
	{
		
		public static const ADD_EFFECT : String = "addEffect";
		public static const SELL : String = "sell";
		public var effectTarget:Monster;
		public var towerPointID : int;
		
		public function TowerEvent(type : String , towerPointID : int=0 ,effectTarget:Monster=null, bubbles : Boolean = false , cancelable : Boolean = false)
		{
			super(type , bubbles , cancelable);
			this.towerPointID = towerPointID;
			this.effectTarget=effectTarget;
		}
		
		public override function clone() : Event
		{
			return new TowerEvent(type , towerPointID ,effectTarget, bubbles , cancelable);
		}
	}
}
