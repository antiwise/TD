package net.shangle.util
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	import net.shangle.display.ModalWindow;

	public class PopUpManager
	{
		private static var modalWindow:ModalWindow;
		
		public function PopUpManager()
		{
		}
		
		public static function addPopUp(window:DisplayObject,stage:Stage):void
		{
			modalWindow=new ModalWindow();
			stage.addChild(modalWindow);
			stage.addChild(window);
		}
		
		public static function removePopUp(window:DisplayObject,stage:Stage):void
		{
			stage.removeChild(modalWindow);
			stage.removeChild(window);
			modalWindow=null;
		}
	}
}