package net.shangle.manager
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;

	public class GlobalFilterManager
	{
		public function GlobalFilterManager()
		{
			init();
		}
		
		private static var instance:GlobalFilterManager;
		
		public static function getInstance():GlobalFilterManager
		{
			if(instance==null)
			{
				instance=new GlobalFilterManager();
			}
			return instance;
		}
		
		private var _yellowGlowFilter:GlowFilter;
		private var _colorMatrixFilter:ColorMatrixFilter;
		private var _redGlowFilter:GlowFilter;
		
		private function init():void
		{
			this._yellowGlowFilter=new GlowFilter(0xd8be5a , 1 , 6 , 6 , 6);
			this._redGlowFilter=new GlowFilter(0xff0000 , 0.5 , 6 , 6 , 6);	
			this._colorMatrixFilter=new ColorMatrixFilter([
				0.33,0.33,0.33,0,0,
				0.33,0.33,0.33,0,0,
				0.33,0.33,0.33,0,0,
				0,0,0,1,0
				])			
		}
		
		/**
		 * 黄色外发光效果 
		 */
		public function get yellowGlowFilter():GlowFilter
		{
			return this._yellowGlowFilter;
		}
		
		/**
		 * 红色外发光效果 
		 */
		public function get redGlowFilter():GlowFilter
		{
			return this._redGlowFilter;
		}
		
		/**
		 * 灰度效果 
		 */
		public function get colorMatrixFilter():ColorMatrixFilter
		{
			return this._colorMatrixFilter;
		}
	}
}