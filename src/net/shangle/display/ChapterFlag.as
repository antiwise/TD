package net.shangle.display
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import net.shangle.event.ChapterFlagEvent;
	import net.shangle.manager.GlobalFlashManager;
	import net.shangle.manager.GlobalFilterManager;
	import net.shangle.util.FlashAssetsFileName;
	import net.shangle.vo.ChapterFlagVO;
	
	public class ChapterFlag extends Sprite
	{
		public var vo:ChapterFlagVO;
		private var skin:MovieClip;
		
		public function ChapterFlag(vo:ChapterFlagVO)
		{
			super();
			this.vo=vo;
			this.buttonMode=true;
			initSkin();
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			this.addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		private function onMouseOver(evt:MouseEvent):void
		{
			this.skin.filters=[GlobalFilterManager.getInstance().yellowGlowFilter];
		}
		
		private function onMouseOut(evt:MouseEvent):void
		{
			this.skin.filters=[];
		}
		
		private function onMouseClick(evt:MouseEvent):void
		{
			this.dispatchEvent(new ChapterFlagEvent(ChapterFlagEvent.SELECTED));
		}
		
		public function gotoAndStop(frame:Object):void
		{
			this.skin.gotoAndStop(frame);
		}
		
		private function initSkin():void
		{
			this.skin=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.CHAPTER_FLAG_SKIN);
			this.addChild(skin);
		}
	}
}