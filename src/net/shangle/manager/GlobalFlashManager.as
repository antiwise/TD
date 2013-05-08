package net.shangle.manager
{
	import deng.fzip.FZipLibrary;
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;


	public class GlobalFlashManager
	{
		public function GlobalFlashManager()
		{

		}
		
		private static var instance:GlobalFlashManager;
		
		private var lib:FZipLibrary;
		
		public static function getInstance():GlobalFlashManager
		{
			if(instance==null)
			{
				instance=new GlobalFlashManager();
			}
			return instance;
		}
		
		/**
		 * 初始化
		 * @param lib 资源库
		 */ 
		public function init(lib:FZipLibrary):void
		{
			this.lib=lib;
		}
		
		/**
		 * 获取资源库中的实例
		 * @param fileName 资源的文件名
		 * @param className 资源的类名
		 * @return 资源实例 
		 */ 
		public function getClassInstance(fileName:String,className:String="Default"):MovieClip
		{
			return new (lib.getDefinition(fileName, className) as Class);
		}
	}
}