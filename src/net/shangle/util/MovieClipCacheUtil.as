package net.shangle.util
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.shangle.uint.BitmapMCFrameInfo;

	public class MovieClipCacheUtil
	{
		public function MovieClipCacheUtil()
		{
		}
		
		private static const pt:Point=new Point();
		private static var x:int;
		private static var y:int;
		private static var rect:Rectangle;
		private static var realRect:Rectangle;

		/**
		 * 将mc cache为bitmapData数组
		 * @param mc 资源动画
		 * @param smoothing 是否平滑
		 * @return BitmapMCFrameInfo数组
		 */ 
		public static function cache(mc:MovieClip,smoothing:Boolean=false):Vector.<BitmapMCFrameInfo>
		{
			var bitmapMCFrameInfoArr:Vector.<BitmapMCFrameInfo>=new Vector.<BitmapMCFrameInfo>();
			var i:int;
			var length:int=mc.totalFrames;
			for(i=0;i<length;i++)
			{
				mc.gotoAndStop(i+1);
				bitmapMCFrameInfoArr.push(cacheFrame(mc,smoothing));
			}
			return bitmapMCFrameInfoArr;
		}
		
		private static function cacheFrame(mc:MovieClip,smoothing:Boolean):BitmapMCFrameInfo
		{
			rect = mc.getBounds(mc);
			x = Math.round(rect.x);
			y = Math.round(rect.y);
			
			//防止空白帧报错
			if (rect.isEmpty())
			{
				rect.width = 1;
				rect.height = 1;
			}
			//截图
			var bitmapData:BitmapData = new BitmapData(Math.ceil(rect.width), Math.ceil(rect.height), true, 0x000000);
			bitmapData.draw(mc, new Matrix(1, 0, 0, 1, -x, -y), null, null, null, smoothing);
			
			//剔除透明边界
			realRect = bitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
			
			if (!realRect.isEmpty() && (bitmapData.width != realRect.width || bitmapData.height != realRect.height))
			{
				
				var realBitData:BitmapData = new BitmapData(realRect.width, realRect.height, true, 0x000000);
				realBitData.copyPixels(bitmapData, realRect, pt);
				
				bitmapData.dispose();
				bitmapData = realBitData;
				x += realRect.x;
				y += realRect.y;
				
			}
			
			var bitmapMCFrameInfo:BitmapMCFrameInfo=new BitmapMCFrameInfo();
			bitmapMCFrameInfo.bitmapData=bitmapData;
			bitmapMCFrameInfo.frameLabel=mc.currentLabel;
			bitmapMCFrameInfo.x=x;
			bitmapMCFrameInfo.y=y;
			bitmapMCFrameInfo.frame=mc.currentFrame;
			return bitmapMCFrameInfo;
		}
	}
}