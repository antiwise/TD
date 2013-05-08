package net.shangle.display
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import net.shangle.manager.GlobalFilterManager;
	import net.shangle.manager.GlobalInfoManager;
	import net.shangle.manager.GlobalTooltipManager;
	import net.shangle.manager.GlobalTriggerManager;

	public class CircleMenuOption extends Sprite
	{
		
		private var money : int;
		private var icon :MovieClip;
		private var iconTooltipFunc:Function;
		private var iconTooltipArgs:Array;
		private var clickCallBackFunc : Function;
		private var tooltipInfo:Array;
		private var args : Array;
		private var renderTriggerID:int;
		private var tooltip:MovieClip;
		
		public function CircleMenuOption(icon :MovieClip ,iconTooltipFunc:Function,iconTooltipArgs:Array , clickCallBackFunc : Function , money : int ,  args : Array)
		{
			this.icon = icon;
			this.iconTooltipFunc=iconTooltipFunc;
			this.iconTooltipArgs=iconTooltipArgs;
			this.money = money;
			this.clickCallBackFunc = clickCallBackFunc;
			this.args = args;
			this.icon.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.icon.addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			if(this.clickCallBackFunc!=null)
			{
				this.icon.buttonMode=true;

				if(this.money!=0)
				{
					this.renderTriggerID = GlobalTriggerManager.getInstance().addTrigger(1 , render);
					render();
				}
			}
			else
			{
				this.icon.buttonMode=false;
			}
			this.icon.addEventListener(MouseEvent.CLICK,onMouseClick);
			this.addChild(this.icon);
		}
		
		private function onMouseOver(evt:MouseEvent):void
		{
			if(this.icon.buttonMode==true)
			{
				this.icon.filters = [GlobalFilterManager.getInstance().yellowGlowFilter];
			}
			if(this.iconTooltipFunc!=null)
				this.tooltip=this.iconTooltipFunc.apply(null,this.iconTooltipArgs);
		}
		
		private function onMouseOut(evt:MouseEvent):void
		{
			if(this.icon.buttonMode==true)
			{
				this.icon.filters = [];
			}
			if(this.iconTooltipFunc!=null)
			{
				GlobalTooltipManager.getInstance().removeTip(this.tooltip);
				tooltip=null;
			}
				
		}
		
		private function onMouseClick(evt:MouseEvent):void
		{
			evt.stopPropagation();
			if(this.icon.buttonMode==true)
			{
				this.clickCallBackFunc.apply(null,this.args);	
			}
		}
		
		public function render():void
		{
			if(this.money > GlobalInfoManager.getInstance.money)
			{
				if(this.icon.buttonMode == true)
				{
					this.icon.filters = [GlobalFilterManager.getInstance().colorMatrixFilter];
					this.icon.buttonMode = false;
				}
			}
			else
			{
				if(this.icon.buttonMode == false)
				{
					this.icon.filters = [];
					this.icon.buttonMode = true;
				}
			}
		}
		
		public function clear():void
		{
			this.icon.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.icon.removeEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			if(this.clickCallBackFunc!=null)
			{

				if(this.money!=0)
				{
					GlobalTriggerManager.getInstance().removeTrigger(this.renderTriggerID);
				}
			}
			if(this.tooltip)
			{
				GlobalTooltipManager.getInstance().removeTip(this.tooltip);
				this.tooltip=null;
			}
			this.icon.removeEventListener(MouseEvent.CLICK,onMouseClick);
		}
	}
}
