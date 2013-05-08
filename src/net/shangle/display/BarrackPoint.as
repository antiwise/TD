package net.shangle.display
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import net.shangle.event.BarrackPointEvent;
	import net.shangle.event.CircleMenuEvent;
	import net.shangle.manager.GlobalFilterManager;
	import net.shangle.manager.GlobalFlashManager;
	import net.shangle.manager.GlobalInfoManager;
	import net.shangle.manager.GlobalTooltipManager;
	import net.shangle.util.CircleMenuBtnAssetsClassName;
	import net.shangle.util.EnumCamp;
	import net.shangle.util.FlashAssetsFileName;
	import net.shangle.util.TooltipAssetsClassName;
	import net.shangle.util.TooltipDefaultLabel;
	import net.shangle.vo.BarrackPointVO;
	import net.shangle.vo.BarrackVO;
	import net.shangle.vo.MonsterVO;
	import net.shangle.vo.PlayerBarrackLimitVO;

	public class BarrackPoint extends Sprite
	{
		public var vo : BarrackPointVO;
		private var circleMenu : CircleMenu;
		private var skin : MovieClip;
		private var isClickedThis:Boolean;
		private var tooltip:MovieClip;

		public function BarrackPoint(vo : BarrackPointVO)
		{
			this.vo = vo;
			loadSkin();
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK , onClick);
			this.addEventListener(MouseEvent.ROLL_OVER , onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT , onRollOut);
			super();
		}

		private function loadSkin() : void
		{
			this.skin=GlobalFlashManager.getInstance().getClassInstance(this.vo.skinUrl);
			this.addChild(this.skin);
			this.skin.gotoAndStop(this.vo.skinFrame);
		}


		private function onClick(evt : MouseEvent) : void
		{
			isClickedThis=true;
			if(this.circleMenu==null)
				addMenu();
		}

		private function addMenu() : void
		{
			this.circleMenu = new CircleMenu();
			var playerBarrackLimitVO : PlayerBarrackLimitVO;
			var barrackVO : BarrackVO;
			var monsterVO:MonsterVO;
			var barrackVOArr : Vector.<BarrackVO> = GlobalInfoManager.getInstance.barrackInfo.barrackVOArr;
			var money : int;
			var icon : MovieClip;
			for each(barrackVO in barrackVOArr)
			{
				if(barrackVO.level == 1 && barrackVO.camp == EnumCamp.PLAYER)
				{
					playerBarrackLimitVO = GlobalInfoManager.getInstance.chapterInfo.playerInfo.playerBarrackLimitInfo.getPlayerBarrackLimitVO(barrackVO.resID)
					if(playerBarrackLimitVO != null)
					{
						money = barrackVO.money;
						icon = GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.CIRCLE_MENU_BTN,CircleMenuBtnAssetsClassName.getBarrackBtnClassName(barrackVO.resID));
						icon.moneyText.text = money.toString();
						monsterVO=GlobalInfoManager.getInstance.monsterInfo.getMonsterVO(barrackVO.monsterResID);
						this.circleMenu.addOption(icon ,GlobalTooltipManager.getInstance().addBarrackPointTooltip,[barrackVO,monsterVO], onOptionSelected , money , barrackVO.resID);
					}
					else
					{
						this.circleMenu.addOption(GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.CIRCLE_MENU_BTN,CircleMenuBtnAssetsClassName.LOCK_BTN),GlobalTooltipManager.getInstance().addDefaultTooltip,[TooltipDefaultLabel.LOCK]);
					}
				}
			}
			this.circleMenu.y = this.y - 20;
			this.circleMenu.x = this.x;
			this.dispatchEvent(new CircleMenuEvent(CircleMenuEvent.ADD_CIRCLE_MENU,this.circleMenu));
			this.stage.addEventListener(MouseEvent.CLICK,onStageClick);
		}

		private function onOptionSelected(barrackResID : int) : void
		{
			removeMenu();
			this.dispatchEvent(new BarrackPointEvent(BarrackPointEvent.ADD_BARRACKS , barrackResID));
		}

		private function onStageClick(evt : MouseEvent) : void
		{
			if(isClickedThis==false)
			{
				removeMenu();
			}
			else
			{
				isClickedThis=false;
			}
		}

		private function removeMenu() : void
		{
			this.dispatchEvent(new CircleMenuEvent(CircleMenuEvent.REMOVE_CIRCLE_MENU,this.circleMenu));
			this.stage.removeEventListener(MouseEvent.CLICK , onStageClick);
			this.circleMenu.clear();
			this.circleMenu = null;
		}

		private function onRollOver(evt : MouseEvent) : void
		{
			this.skin.filters = [GlobalFilterManager.getInstance().yellowGlowFilter];
			addToolTip();
		}

		private function onRollOut(evt : MouseEvent) : void
		{
			this.skin.filters = [];
			removeTooltip();
		}
		
		private function addToolTip():void
		{
			if(this.tooltip==null)
			{
				;
				this.tooltip=GlobalTooltipManager.getInstance().addDefaultTooltip(TooltipDefaultLabel.BARRACK_POINT);
			}
		}
		
		private function removeTooltip():void
		{
			if(this.tooltip)
			{
				GlobalTooltipManager.getInstance().removeTip(this.tooltip);
				this.tooltip=null;
			}
		}
		

		public function clear() : void
		{
			if(this.circleMenu!=null)
			{
				removeMenu();
			}
			removeTooltip();
			this.removeEventListener(MouseEvent.CLICK , onClick);
			this.removeEventListener(MouseEvent.ROLL_OVER , onRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT , onRollOut);
			this.vo=null;
			this.skin=null;
		}
	}
}
