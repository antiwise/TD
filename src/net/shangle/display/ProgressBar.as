package net.shangle.display
{
	import flash.display.Sprite;
	
	public class ProgressBar extends Sprite
	{
		private var _currentValue:int;
		private var _maxValue:int;
		private var progress:Sprite;
		private var PROGRESS_WIDTH:int=20;
		private var PROGRESS_HEIGHT:int=4;
		private var progressColor:uint;
		private var backgroundColor:uint
		
		public function ProgressBar(progressColor:uint,backgroundColor:uint,currentValue:int,maxValue:int)
		{
			super();
			this.progressColor=progressColor;
			this.backgroundColor=backgroundColor;
			this._currentValue=currentValue;
			this._maxValue=maxValue;
			init();
			setProgress();
		}
		
		public function get currentValue():int
		{
			return this._currentValue;
		}
		
		public function set currentValue(value:int):void
		{
			this._currentValue=value;
			setProgress();
		}
		
		public function get maxValue():int
		{
			return this._maxValue;
		}
		
		public function set maxValue(value:int):void
		{
			this._maxValue=value;
			setProgress();
		}
		
		private function init():void
		{
			progress=new Sprite();
			progress.graphics.beginFill(progressColor);
			progress.graphics.lineTo(0,PROGRESS_HEIGHT);
			progress.graphics.lineTo(PROGRESS_WIDTH,PROGRESS_HEIGHT);
			progress.graphics.lineTo(PROGRESS_WIDTH,0);
			progress.graphics.lineTo(0,0);
			progress.graphics.endFill();
			progress.x=-PROGRESS_WIDTH/2;
			progress.y=-PROGRESS_HEIGHT;
			this.addChild(progress);
			this.graphics.beginFill(backgroundColor);
			this.graphics.drawRect(-PROGRESS_WIDTH/2,-PROGRESS_HEIGHT,PROGRESS_WIDTH,PROGRESS_HEIGHT);
			this.graphics.endFill();
		}
		
		protected function setProgress():void
		{
			progress.scaleX=this.currentValue/this.maxValue;
		}
		
		public function clear():void
		{

		}
	}
}