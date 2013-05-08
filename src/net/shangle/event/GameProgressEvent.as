package net.shangle.event
{
	import flash.events.ProgressEvent;
	
	public class GameProgressEvent extends ProgressEvent
	{
		public static const LOAD_CONFIG:String="loadConfig";
		
		public static const LOAD_CONFIG_COMPLETE:String="loadConfigComplete";
		
		public static const LOAD_FLASH:String="loadFlash";
		
		public static const LOAD_FLASH_COMPLETE:String="loadFlashComplete";
		
		public static const LOAD_SOUND:String="loadSound";
		
		public static const LOAD_SOUND_COMPLETE:String="loadSoundComplete";
		
		public function GameProgressEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, bytesLoaded:Number=0, bytesTotal:Number=0)
		{
			super(type, bubbles, cancelable, bytesLoaded, bytesTotal);
		}
	}
}