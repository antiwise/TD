package net.shangle.display
{
	import flash.events.Event;
	
	import net.shangle.event.ProgressBarEvent;

	public class BloodBar extends ProgressBar
	{
		public function BloodBar(maxValue:int)
		{
			super(0x28d600,0xff0000,maxValue,maxValue);
		}
		
		protected override function setProgress():void
		{
			if(this.currentValue<=0)
			{
				this.dispatchEvent(new ProgressBarEvent(ProgressBarEvent.COMMON));
			}
			else
			{
				super.setProgress();
			}
		}
	}
}