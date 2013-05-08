package net.shangle.display
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import net.shangle.uint.BitmapMCFrameInfo;
	
	public class BitmapMovieClip extends Sprite
	{
		private var currentFrameInfo:BitmapMCFrameInfo;
		
		private var bitmapMCFrameInfoArr:Vector.<BitmapMCFrameInfo>;
		
		private var bitmap:Bitmap;
		
		private var maxFrame:int;
		
		private var frameInfo:BitmapMCFrameInfo;
		
		public function BitmapMovieClip(bitmapMCFrameInfoArr:Vector.<BitmapMCFrameInfo>)
		{
			super();
			this.bitmapMCFrameInfoArr=bitmapMCFrameInfoArr;
			this.currentFrameInfo=bitmapMCFrameInfoArr[0];
			this.maxFrame=bitmapMCFrameInfoArr.length;
			this.bitmap=new Bitmap();
			//this.bitmap.cacheAsBitmap=true;
			this.addChild(bitmap);
			update();
		}
		
		private function update():void
		{
			this.bitmap.bitmapData=this.currentFrameInfo.bitmapData;
			this.bitmap.x=this.currentFrameInfo.x;
			this.bitmap.y=this.currentFrameInfo.y;
		}
		
		public function gotoAndStop(frameLabel:String):void
		{
			for each(frameInfo in this.bitmapMCFrameInfoArr)
			{
				if(frameInfo.frameLabel==frameLabel)
				{
					this.currentFrameInfo=frameInfo;
					break;
				}
			}
			update();
		}

		public function nextFrame():void
		{
			if(this.currentFrameInfo.frame==this.maxFrame)
			{
				this.currentFrameInfo=this.bitmapMCFrameInfoArr[0];
			}else
			{
				this.currentFrameInfo=this.bitmapMCFrameInfoArr[this.currentFrameInfo.frame];
			}
			update();
		}
		
		public function get currentFrameLabel():String
		{
			return this.currentFrameInfo.frameLabel;
		}
	}
}