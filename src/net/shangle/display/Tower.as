package net.shangle.display
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import net.shangle.event.CircleMenuEvent;
	import net.shangle.event.ProgressBarEvent;
	
	import net.shangle.event.TowerEvent;
	import net.shangle.manager.GlobalFilterManager;
	import net.shangle.manager.GlobalFlashManager;
	import net.shangle.manager.GlobalInfoManager;
	import net.shangle.manager.GlobalTooltipManager;
	import net.shangle.manager.GlobalTriggerManager;
	import net.shangle.uint.IAnimator;
	import net.shangle.util.CircleMenuBtnAssetsClassName;
	import net.shangle.util.EnumCamp;
	import net.shangle.util.FlashAssetsFileName;
	import net.shangle.util.TooltipDefaultLabel;
	import net.shangle.util.TowerFrameLabel;
	import net.shangle.vo.EffectVO;
	import net.shangle.vo.PlayerTowerLimitVO;
	import net.shangle.vo.TowerVO;
	
	public class Tower extends Sprite implements IAnimator
	{
		public var vo : TowerVO;
		private var initVO:TowerVO;
		private var buildingBar : BuildingBar;
		private var buildingTriggerID : int;
		private var effectTriggerID : int;
		private var skin : MovieClip;
		private var buildStartSkin:MovieClip;
		private var circleMenu : CircleMenu;
		private var towerPointID:int;
		private var isClickedThis:Boolean;
		private var buildTime:int;
		public var active:Boolean;
		private var instanceID:int;
		private var monsterArr:Vector.<Monster>;
		private var coolDown:Boolean;
		private var tooltip:MovieClip;
		private var effectVO:EffectVO;
		
		//临时变量
		private var playerTowerLimitVO : PlayerTowerLimitVO;
		private var towerVO: TowerVO;
		private var upgradeBtnSKin : MovieClip;
		private var attackTarget:Monster;
		private var sortEnemyArr:Vector.<Monster>;
		private var i:int;
		private var j:int;
		
		
		public function Tower(vo : TowerVO, instanceID : int)
		{
			this.vo = vo;
			this.initVO=this.vo;
			this.instanceID=instanceID;
			loadSkin();
			super();
		}
		
		public function respawn(towerPointID : int,monsterArr:Vector.<Monster>):void
		{
			this.towerPointID=towerPointID;
			this.monsterArr=monsterArr;
			this.buildingBar.alpha=1;
			this.buildingBar.currentValue=0;
			this.buildStartSkin.alpha=1;
			this.skin.alpha=0;
			this.coolDown=false;
			this.vo=this.initVO;
			this.effectVO=GlobalInfoManager.getInstance.effectInfo.getEffectVO(this.vo.resID);
			buildStart();
			this.active=true;
		}
		
		public function clone(instanceID:int):Tower
		{
			return new Tower(this.vo,instanceID);
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
			this.buildStartSkin=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.TOWER_BUILD_START_SKIN);
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
			this.coolDown=true;
			//addEffect();
		}
		
		private function resetCoolDown():void
		{
			this.coolDown=false;
			effectTriggerID = GlobalTriggerManager.getInstance().addTrigger(this.vo.intervalTime , coolDownComplete);
		}
		
		private function coolDownComplete() : void
		{
			this.coolDown=true;
			GlobalTriggerManager.getInstance().removeTrigger(effectTriggerID);
		}
		
		public function render():void
		{
			if(coolDown)
			{
				if(this.monsterArr.length!=0)
				{
					this.sortEnemyArr=this.monsterArr.concat();
					for(i=0;i<this.vo.effectNum;i++)
					{
						j=Math.round(Math.random()*(this.sortEnemyArr.length-1))
						this.attackTarget=this.sortEnemyArr[j];
						addEffect(this.attackTarget);
						this.sortEnemyArr.splice(j,1);
						if(this.sortEnemyArr.length==0)
						{
							break;
						}
						
					}
					this.skin.gotoAndPlay(TowerFrameLabel.ATTACK_FRAME_LABEL);
					resetCoolDown();
				}
					//没有敌人
				else
				{
					
				}
			}
		}
		
		private function build() : void
		{
			this.buildingBar.currentValue++;
		}
		
		private function addEffect(attackTarget:Monster) : void
		{
			this.dispatchEvent(new TowerEvent(TowerEvent.ADD_EFFECT ,this.towerPointID,attackTarget));
		}
		
		
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
				this.playerTowerLimitVO = GlobalInfoManager.getInstance.chapterInfo.playerInfo.playerTowerLimitInfo.getPlayerTowerLimitVO(this.vo.levelUp);
				if(playerTowerLimitVO != null)
				{
					this.towerVO = GlobalInfoManager.getInstance.towerInfo.getTowerVO(this.vo.levelUp);
					this.upgradeBtnSKin = GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.CIRCLE_MENU_BTN,CircleMenuBtnAssetsClassName.UPGRADE_BTN);
					this.upgradeBtnSKin.moneyText.text = towerVO.money.toString();
					this.circleMenu.addOption(upgradeBtnSKin ,GlobalTooltipManager.getInstance().addEffectTooltip,[this.vo,GlobalInfoManager.getInstance.effectInfo.getEffectVO(this.vo.resID),this.towerVO,GlobalInfoManager.getInstance.effectInfo.getEffectVO(this.towerVO.resID)], upgrade , towerVO.money);
				}
				else
				{
					this.circleMenu.addOption(GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.CIRCLE_MENU_BTN,CircleMenuBtnAssetsClassName.LOCK_BTN),GlobalTooltipManager.getInstance().addDefaultTooltip,[TooltipDefaultLabel.LOCK]);
				}
			}else
			{
				this.circleMenu.addOption(GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.CIRCLE_MENU_BTN,CircleMenuBtnAssetsClassName.FULL_LEVEL_BTN),GlobalTooltipManager.getInstance().addDefaultTooltip,[TooltipDefaultLabel.FULL_LEVEL]);
			}
			this.circleMenu.addOption(GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.CIRCLE_MENU_BTN,CircleMenuBtnAssetsClassName.SELL_BTN) ,GlobalTooltipManager.getInstance().addDefaultTooltip,[TooltipDefaultLabel.SELL], sell);
			this.circleMenu.y = this.y - 20;
			this.circleMenu.x = this.x;
			this.dispatchEvent(new CircleMenuEvent(CircleMenuEvent.ADD_CIRCLE_MENU,this.circleMenu));
			this.stage.addEventListener(MouseEvent.CLICK , onStageClick);
		}
		
		private function upgrade() : void
		{
			removeMenu();
			GlobalTriggerManager.getInstance().removeTrigger(effectTriggerID);
			this.vo=GlobalInfoManager.getInstance.towerInfo.getTowerVO(this.vo.levelUp);
			this.effectVO=GlobalInfoManager.getInstance.effectInfo.getEffectVO(this.vo.resID);
			GlobalInfoManager.getInstance.money-=this.vo.money;
			resetCoolDown();
		}
		
		private function sell() : void
		{
			removeMenu();
			this.dispatchEvent(new TowerEvent(TowerEvent.SELL,this.towerPointID));
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
				;
				this.tooltip=GlobalTooltipManager.getInstance().addTowerToolTip(this.vo,this.effectVO);
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
		
		public function resume():void
		{
			this.skin.play();
		}
		
		public function pause():void
		{
			this.skin.stop();
		}
		
		public function clear():void
		{
			if(this.circleMenu!=null)
			{
				removeMenu();
			}
			removeTooltip();
			this.skin.filters = [];
			GlobalTriggerManager.getInstance().removeTrigger(buildingTriggerID);
			GlobalTriggerManager.getInstance().removeTrigger(effectTriggerID);
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
