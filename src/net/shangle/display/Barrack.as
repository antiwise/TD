package net.shangle.display
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import net.shangle.event.BarrackEvent;
	import net.shangle.event.CircleMenuEvent;
	import net.shangle.event.ProgressBarEvent;
	import net.shangle.manager.GlobalFilterManager;
	import net.shangle.manager.GlobalFlashManager;
	import net.shangle.manager.GlobalInfoManager;
	import net.shangle.manager.GlobalTooltipManager;
	import net.shangle.manager.GlobalTriggerManager;
	import net.shangle.util.CircleMenuBtnAssetsClassName;
	import net.shangle.util.EnumCamp;
	import net.shangle.util.FlashAssetsFileName;
	import net.shangle.util.TooltipDefaultLabel;
	import net.shangle.vo.BarrackVO;
	import net.shangle.vo.LineVO;
	import net.shangle.vo.MonsterVO;
	import net.shangle.vo.PlayerBarrackLimitVO;

	public class Barrack extends Sprite
	{

		public var vo : BarrackVO;
		private var initVO:BarrackVO;
		private var buildingBar : BuildingBar;
		private var buildingTriggerID : int;
		private var trainingTriggerID : int;
		private var skin : MovieClip;
		private var buildStartSkin:MovieClip;
		private var circleMenu : CircleMenu;
		private var barrackPointID:int;
		private var isClickedThis:Boolean;
		private var buildTime:int;
		public var active:Boolean;
		private var instanceID:int;
		private var monsterVO:MonsterVO;
		private var tooltip:MovieClip;
		
		//临时变量
		private var playerBarrackLimitVO : PlayerBarrackLimitVO;
		private var barrackVO : BarrackVO;
		private var upgradeBtnSKin : MovieClip;
		

		public function Barrack(vo : BarrackVO, instanceID : int)
		{
			this.vo = vo;
			this.initVO=this.vo;
			this.instanceID=instanceID;
			loadSkin();
			super();
		}
		
		public function respawn(barrackPointID : int):void
		{
			this.barrackPointID=barrackPointID;
			this.buildingBar.alpha=1;
			this.buildingBar.currentValue=0;
			this.buildStartSkin.alpha=1;
			this.skin.alpha=0;
			this.vo=this.initVO;
			this.monsterVO=GlobalInfoManager.getInstance.monsterInfo.getMonsterVO(this.vo.resID);
			buildStart();
			this.active=true;
		}
		
		public function clone(instanceID:int):Barrack
		{
			return new Barrack(this.vo,instanceID);
		}
		
		public function resetBuildTime(buildTime:int):void
		{
			this.buildTime=buildTime;
			this.buildingBar.maxValue=buildTime;
		}

		private function loadSkin() : void
		{
			this.skin=GlobalFlashManager.getInstance().getClassInstance(this.vo.skinUrl);
			this.addChild(this.skin);
			this.skin.stop();
			this.buildStartSkin=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.BARRACKS_BUILD_START_SKIN);
			this.addChild(this.buildStartSkin);
			this.buildStartSkin.stop();
			initBuildBar();
		}

		private function initBuildBar() : void
		{
			this.buildingBar = new BuildingBar(1);
			this.buildingBar.addEventListener(ProgressBarEvent.COMMON , buildComplete);
			this.buildingBar.y = -this.vo.height;
			this.addChild(this.buildingBar);
		}

		private function buildStart() : void
		{
			buildingTriggerID = GlobalTriggerManager.getInstance().addTrigger(1 , build);
		}

		private function buildComplete(evt : ProgressBarEvent) : void
		{
			GlobalTriggerManager.getInstance().removeTrigger(buildingTriggerID);
			this.buildingBar.alpha=0;
			this.buildStartSkin.alpha=0;
			this.skin.alpha=1;
			if(this.vo.camp==EnumCamp.PLAYER)
			{
				this.buttonMode = true;
				this.addEventListener(MouseEvent.CLICK , onClick);
			}
			this.addEventListener(MouseEvent.ROLL_OVER , onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT , onRollOut);
			startTraining();
			addMonster();
		}

		private function startTraining() : void
		{
			trainingTriggerID = GlobalTriggerManager.getInstance().addTrigger(this.vo.trainingTime , addMonster);
		}

		private function build() : void
		{
			this.buildingBar.currentValue++;
		}

		private function addMonster() : void
		{
			this.dispatchEvent(new BarrackEvent(BarrackEvent.ADD_MONSTER ,this.barrackPointID));
		}

//		private function onBuildStartSkinLoadComplete(evt : SkinEvent) : void
//		{
//			skin.removeEventListener(SkinEvent.LOAD_COMPLETE , onBuildStartSkinLoadComplete);
//			initBuildBar();
//			buildStart();
//			this.dispatchEvent(new SkinEvent(SkinEvent.LOAD_COMPLETE));
//		}
		
		private function onClick(evt : MouseEvent) : void
		{
			this.isClickedThis=true;
			if(this.circleMenu==null)
				addMenu();
		}

		private function addMenu() : void
		{
			this.circleMenu = new CircleMenu();
			if(this.vo.levelUp != 0)
			{
				this.playerBarrackLimitVO = GlobalInfoManager.getInstance.chapterInfo.playerInfo.playerBarrackLimitInfo.getPlayerBarrackLimitVO(this.vo.levelUp);
				if(playerBarrackLimitVO != null)
				{
					this.barrackVO = GlobalInfoManager.getInstance.barrackInfo.getBarrackVO(this.vo.levelUp);
					this.upgradeBtnSKin = GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.CIRCLE_MENU_BTN,CircleMenuBtnAssetsClassName.UPGRADE_BTN);
					this.upgradeBtnSKin.moneyText.text = barrackVO.money.toString();
					this.circleMenu.addOption(upgradeBtnSKin ,GlobalTooltipManager.getInstance().addMonsterTooltip,[this.vo,GlobalInfoManager.getInstance.monsterInfo.getMonsterVO(this.vo.monsterResID),this.barrackVO,GlobalInfoManager.getInstance.monsterInfo.getMonsterVO(this.barrackVO.monsterResID)], upgrade , barrackVO.money);
				}
				else
				{
					this.circleMenu.addOption(GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.CIRCLE_MENU_BTN,CircleMenuBtnAssetsClassName.LOCK_BTN),GlobalTooltipManager.getInstance().addDefaultTooltip,[TooltipDefaultLabel.LOCK]);
				}
			}else
			{
				this.circleMenu.addOption(GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.CIRCLE_MENU_BTN,CircleMenuBtnAssetsClassName.FULL_LEVEL_BTN),GlobalTooltipManager.getInstance().addDefaultTooltip,[TooltipDefaultLabel.FULL_LEVEL]);
			}
			this.circleMenu.addOption(GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.CIRCLE_MENU_BTN,CircleMenuBtnAssetsClassName.SELL_BTN),GlobalTooltipManager.getInstance().addDefaultTooltip,[TooltipDefaultLabel.SELL] , sell);
			this.circleMenu.y = this.y - 20;
			this.circleMenu.x = this.x;
			this.dispatchEvent(new CircleMenuEvent(CircleMenuEvent.ADD_CIRCLE_MENU,this.circleMenu));
			this.stage.addEventListener(MouseEvent.CLICK , onStageClick);
		}

		private function upgrade() : void
		{
			removeMenu();
			GlobalTriggerManager.getInstance().removeTrigger(trainingTriggerID);
			this.vo=GlobalInfoManager.getInstance.barrackInfo.getBarrackVO(this.vo.levelUp);
			this.monsterVO=GlobalInfoManager.getInstance.monsterInfo.getMonsterVO(this.vo.resID);
			GlobalInfoManager.getInstance.money-=this.vo.money;
			startTraining();
		}

		private function sell() : void
		{
			removeMenu();
			this.dispatchEvent(new BarrackEvent(BarrackEvent.SELL,this.barrackPointID));
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
			if(this.vo.camp==EnumCamp.PLAYER)
			{
				this.skin.filters = [GlobalFilterManager.getInstance().yellowGlowFilter];
			}
			else
			{
				this.skin.filters= [GlobalFilterManager.getInstance().redGlowFilter]
			}
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
				this.tooltip=GlobalTooltipManager.getInstance().addBarrackTooltip(this.vo,this.monsterVO);
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
		
		
		public function clear():void
		{
			if(this.circleMenu!=null)
			{
				removeMenu();
			}
			removeTooltip();
			GlobalTriggerManager.getInstance().removeTrigger(buildingTriggerID);
			GlobalTriggerManager.getInstance().removeTrigger(trainingTriggerID);
			if(this.vo.camp==EnumCamp.PLAYER)
			{
				this.removeEventListener(MouseEvent.CLICK , onClick);
			}
			this.removeEventListener(MouseEvent.ROLL_OVER , onRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT , onRollOut);
			this.active=false;
		}
	}
}
