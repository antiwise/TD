package net.shangle.display
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import net.shangle.event.BarrackPointEvent;
	import net.shangle.event.CircleMenuEvent;
	import net.shangle.event.TowerPointEvent;
	import net.shangle.manager.GlobalFilterManager;
	import net.shangle.manager.GlobalFlashManager;
	import net.shangle.manager.GlobalInfoManager;
	import net.shangle.manager.GlobalTooltipManager;
	import net.shangle.util.CircleMenuBtnAssetsClassName;
	import net.shangle.util.EnumCamp;
	import net.shangle.util.FlashAssetsFileName;
	import net.shangle.util.TooltipDefaultLabel;
	import net.shangle.vo.EffectVO;
	import net.shangle.vo.PlayerTowerLimitVO;
	import net.shangle.vo.TowerPointVO;
	import net.shangle.vo.TowerVO;
	
	public class TowerPoint extends Sprite
	{
		public var vo : TowerPointVO;
		private var circleMenu : CircleMenu;
		private var skin : MovieClip;
		private var isClickedThis:Boolean;
		private var tooltip:MovieClip;
		
		public function TowerPoint(vo : TowerPointVO)
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
			var playerTowerLimitVO :PlayerTowerLimitVO;
			var towerVO : TowerVO;
			var effectVO:EffectVO;
			var towerVOArr : Vector.<TowerVO> = GlobalInfoManager.getInstance.towerInfo.towerVOArr;
			var money : int;
			var icon : MovieClip;
			for each(towerVO in towerVOArr)
			{
				if(towerVO.level == 1 && towerVO.camp == EnumCamp.PLAYER)
				{
					playerTowerLimitVO = GlobalInfoManager.getInstance.chapterInfo.playerInfo.playerTowerLimitInfo.getPlayerTowerLimitVO(towerVO.resID)
					if(playerTowerLimitVO != null)
					{
						money = towerVO.money;
						icon = GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.CIRCLE_MENU_BTN,CircleMenuBtnAssetsClassName.getTowerBtnClassName(towerVO.resID));
						icon.moneyText.text = money.toString();
						effectVO=GlobalInfoManager.getInstance.effectInfo.getEffectVO(towerVO.effectResID);
						this.circleMenu.addOption(icon ,GlobalTooltipManager.getInstance().addTowerPointTooltip,[towerVO,effectVO], onOptionSelected , money , towerVO.resID);
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
		
		private function onOptionSelected(towerResID : int) : void
		{
			removeMenu();
			this.dispatchEvent(new TowerPointEvent(TowerPointEvent.ADD_TOWER , towerResID));
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
				this.tooltip=GlobalTooltipManager.getInstance().addDefaultTooltip(TooltipDefaultLabel.TOWER_POINT);
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
			this.skin.filters = [];
			this.removeEventListener(MouseEvent.CLICK , onClick);
			this.removeEventListener(MouseEvent.ROLL_OVER , onRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT , onRollOut);
			this.vo=null;
			this.skin=null;
		}
	}
}
