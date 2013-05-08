package net.shangle.display
{
	import net.shangle.event.ProgressBarEvent;
	
	public class BuildingBar extends ProgressBar
	{
		
		public function BuildingBar(maxValue:int)
		{
			super(0xffd800,0x5f4b00,0,maxValue);
		}
		
		protected override function setProgress():void
		{
			if(this.currentValue==this.maxValue)
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