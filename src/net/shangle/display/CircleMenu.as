package net.shangle.display
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import net.shangle.manager.GlobalFlashManager;
	import net.shangle.util.FlashAssetsFileName;

	public class CircleMenu extends Sprite
	{
		private const R : int = 55;
		private var optionArr : Vector.<CircleMenuOption>;

		public function CircleMenu()
		{
			initSkin();
			optionArr = new Vector.<CircleMenuOption>();
			super();
		}

		private function initSkin() : void
		{
			this.addChild(GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.CIRCLE_MENU_SKIN));
		}

		public function addOption(icon : MovieClip ,iconTooltipFunc:Function,iconTooltipArgs:Array, clickCallBackFunc : Function = null , money : int = 0 , ... args) : void
		{
			var circleMenuOption : CircleMenuOption = new CircleMenuOption(icon ,iconTooltipFunc,iconTooltipArgs, clickCallBackFunc , money , args);
			optionArr.push(circleMenuOption);
			resetIconPosition();
			this.addChild(circleMenuOption);
		}

		private function resetIconPosition() : void
		{
			var angle : Number = 360 / this.optionArr.length;
			var option : CircleMenuOption;
			var i : int;
			var length : int = this.optionArr.length;
			for(i = 0 ; i < length ; i++)
			{
				option = this.optionArr[i];
				option.x = Math.sin(angle * i * Math.PI / 180) * R;
				option.y = -Math.cos(angle * i * Math.PI / 180) * R;
			}
		}

		public function clear() : void
		{
			var option : CircleMenuOption;
			for each(option in optionArr)
			{
				option.clear();
			}
		}
	}
}
