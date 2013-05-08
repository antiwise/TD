package net.shangle.display
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import net.shangle.event.UIEvent;
	import net.shangle.manager.GlobalFlashManager;
	import net.shangle.manager.GlobalInfoManager;
	import net.shangle.manager.GlobalTriggerManager;
	import net.shangle.util.ClockUtil;
	import net.shangle.util.FlashAssetsFileName;
	
	public class UIScene extends Sprite
	{
		private var moneyTextField : TextField;
		private var playerCastleBloodTextField:TextField;
		private var computerCastleBloodTextFeild:TextField;
		private var thumbnails:Thumbnails;
		private var skin:MovieClip;
		//private var time:int;
		private var timeTriggerID:int;
		
		private const THUMBNAILS_MIN_WIDTH:int=50;
		private const MAP_MIN_WIDTH:int=700;
		
		public function UIScene()
		{
			super();
			loadSkin();
			initThumbnails();
		}
		
		private function loadSkin():void
		{
			this.skin=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.UI_SKIN);
			this.addChild(this.skin);
		}
		
		private function pauseHandler(evt:MouseEvent):void
		{
			this.dispatchEvent(new UIEvent(UIEvent.PAUSE));
		}
		
		private function musicHandler(evt:MouseEvent):void
		{
			this.dispatchEvent(new UIEvent(UIEvent.SOUND));
		}
		
		private function optionHandler(evt:MouseEvent):void
		{
			this.dispatchEvent(new UIEvent(UIEvent.OPTION));
		}
		
//
//		
//		private function dicHandler(evt:MouseEvent):void
//		{
//			
//		}
		
		private function initThumbnails():void
		{
			this.thumbnails=new Thumbnails();
			this.thumbnails.x=10;
			this.thumbnails.y=532;
			this.addChild(this.thumbnails);
//			this.skin.thumbnailsContainer.addChild(this.thumbnails);
		}
		
		public function start(playerArr:Vector.<Monster>,computerArr:Vector.<Monster>,map:MovieClip):void
		{
			this.skin.pauseBtn.addEventListener(MouseEvent.CLICK,pauseHandler);
			this.skin.soundBtn.addEventListener(MouseEvent.CLICK,musicHandler);
			this.skin.optionBtn.addEventListener(MouseEvent.CLICK,optionHandler);
			//this.skin.dicBtn.addEventListener(MouseEvent.CLICK,dicHandler);
			GlobalInfoManager.getInstance.playerCastleBlood=GlobalInfoManager.getInstance.chapterInfo.playerInfo.playerCastleBlood;
			GlobalInfoManager.getInstance.computerCastleBlood=GlobalInfoManager.getInstance.chapterInfo.computerInfo.computerCastleBlood;
			GlobalInfoManager.getInstance.money=GlobalInfoManager.getInstance.chapterInfo.playerInfo.money;
			GlobalInfoManager.getInstance.time=0;
			this.thumbnails.start(playerArr,computerArr,map);
			this.timeTriggerID=GlobalTriggerManager.getInstance().addTrigger(1,addTime);
		}
		
		private function addTime():void
		{
			GlobalInfoManager.getInstance.time++;
		}
		
		public function render():void
		{
			this.skin.playerCastleBloodTextField.text=GlobalInfoManager.getInstance.playerCastleBlood.toString();
			this.skin.computerCastleBloodTextField.text=GlobalInfoManager.getInstance.computerCastleBlood.toString();
			this.skin.moneyTextField.text = GlobalInfoManager.getInstance.money.toString();
			this.skin.timeTextField.text=ClockUtil.getClock(GlobalInfoManager.getInstance.time);
			this.thumbnails.render();
		}
		
		public function clear():void
		{
			this.thumbnails.clear();
			GlobalTriggerManager.getInstance().removeTrigger(this.timeTriggerID);
			this.skin.pauseBtn.removeEventListener(MouseEvent.CLICK,pauseHandler);
			this.skin.soundBtn.removeEventListener(MouseEvent.CLICK,musicHandler);
			this.skin.optionBtn.removeEventListener(MouseEvent.CLICK,optionHandler);
//			this.skin.dicBtn.removeEventListener(MouseEvent.CLICK,dicHandler);
		}
	}
}