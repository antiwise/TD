package net.shangle.pool
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	import net.shangle.manager.GlobalFlashManager;
	import net.shangle.uint.BitmapMCFrameInfo;
	import net.shangle.util.MovieClipCacheUtil;

	public class BitmapMCFrameInfoPool
	{
		private var allKinds:Dictionary;
		private var mc:MovieClip;
		
		public function BitmapMCFrameInfoPool()
		{
			allKinds = new Dictionary();
		}
		
		private static var instance:BitmapMCFrameInfoPool;
		
		public static function getInstance():BitmapMCFrameInfoPool
		{
			if(instance==null)
			{
				instance=new BitmapMCFrameInfoPool();
			}
			return instance;
		}
		
		public function getBitmapMCFrameInfoArr(url:String):Vector.<BitmapMCFrameInfo>
		{
			if(allKinds[url])
			{
				return allKinds[url];
			}else
			{
				mc=GlobalFlashManager.getInstance().getClassInstance(url);
				allKinds[url]=MovieClipCacheUtil.cache(mc);
				return allKinds[url];
			}
		}
	}
}