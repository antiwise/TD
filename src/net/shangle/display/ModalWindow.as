package net.shangle.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ModalWindow extends Sprite
	{
		public function ModalWindow()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			this.addEventListener(Event.REMOVED,onRemoved);
		}
		
		private function onAddedToStage(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			this.graphics.beginFill(0x000000,0.4);
			this.graphics.drawRect(0,0,this.stage.width,this.stage.height);
			this.graphics.endFill();
			this.stage.addEventListener(MouseEvent.CLICK,onStageClick,false,10);
		}
		
		private function onRemoved(evt:Event):void
		{
			this.stage.removeEventListener(MouseEvent.CLICK,onStageClick,false);
			this.removeEventListener(Event.REMOVED,onRemoved);
		}
		
		private function onStageClick(evt:Event):void
		{
			evt.stopImmediatePropagation();
		}
	}
}