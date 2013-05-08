package net.shangle.manager
{
	import avmplus.FLASH10_FLAGS;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import net.shangle.util.EnumArea;
	import net.shangle.util.EnumAttackFrequency;
	import net.shangle.util.EnumAttackType;
	import net.shangle.util.EnumMoveSpeed;
	import net.shangle.util.FlashAssetsFileName;
	import net.shangle.util.TooltipAssetsClassName;
	import net.shangle.vo.BarrackVO;
	import net.shangle.vo.EffectVO;
	import net.shangle.vo.MonsterVO;
	import net.shangle.vo.TowerVO;

	public class GlobalTooltipManager
	{
		
		private var barrackTooltip:MovieClip;
		private var barrackPointTooltip:MovieClip;
		private var monsterTooltip:MovieClip;
		private var towerTooltip:MovieClip;
		private var towerPointTooltip:MovieClip;
		private var effectTooltip:MovieClip;
		private var defaultTooltip:MovieClip;
		
		public function GlobalTooltipManager()
		{
			this.barrackTooltip=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.TOOLTIP,TooltipAssetsClassName.BARRACK_TOOLTIP);
			this.barrackPointTooltip=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.TOOLTIP,TooltipAssetsClassName.BARRACK_POINT_TOOLTIP);
			this.monsterTooltip=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.TOOLTIP,TooltipAssetsClassName.MONSTER_TOOLTIP);
			this.towerTooltip=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.TOOLTIP,TooltipAssetsClassName.TOWER_TOOLTIP);
			this.towerPointTooltip=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.TOOLTIP,TooltipAssetsClassName.TOWER_POINT_TOOLTIP);
			this.effectTooltip=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.TOOLTIP,TooltipAssetsClassName.EFFECT_TOOLTIP);
			this.defaultTooltip=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.TOOLTIP);
		}
		private static var instance : GlobalTooltipManager;
		
		private var tipScene:Sprite;
		//private var tip:MovieClip;
		
		public static function getInstance() : GlobalTooltipManager
		{
			if(instance == null)
			{
				instance = new GlobalTooltipManager();
			}
			return instance;
		}
		
		/**
		 * 初始化
		 * @param tipScene tip容器
		 */ 
		public function init(tipScene:Sprite):void
		{
			this.tipScene=tipScene;
		}
		

		private function addTooltip(tooltip:MovieClip):void
		{
			if((this.tipScene.mouseX+tooltip.width)>this.tipScene.stage.stageWidth)
			{
				tooltip.x=this.tipScene.stage.stageWidth-tooltip.width;
			}
			else
			{
				tooltip.x=this.tipScene.mouseX;
			}
			if(this.tipScene.mouseY-tooltip.height-20<0)
			{
				tooltip.y=tooltip.height;
			}
			else
			{
				tooltip.y=this.tipScene.mouseY-20;
			}
			this.tipScene.addChild(tooltip);
		}
		
		/**
		 * 添加普通tip
		 * @param text 文本文字  
		 * @return tip实例
		 */
		public function addDefaultTooltip(text:String):MovieClip
		{
			this.defaultTooltip.defaultTextField.text=text;
			addTooltip(this.defaultTooltip);
			return this.defaultTooltip;
		}
		
		/**
		 * 添加防御塔建造点tip
		 * @param towerVO 防御塔VO
		 * @param effectVO 特效VO  
		 * @return tip实例
		 */
		public function addTowerPointTooltip(towerVO:TowerVO,effectVO:EffectVO):MovieClip
		{
			this.towerPointTooltip.nameTextField.text=towerVO.name;
			this.towerPointTooltip.introductionTextField.text=towerVO.introduction;
			this.towerPointTooltip.attackTypeTextField.text=EnumAttackType.toString(effectVO.attackType);
			this.towerPointTooltip.numTextField.text=towerVO.effectNum;
			this.towerPointTooltip.intervalTextField.text=towerVO.intervalTime;
			if(effectVO.value==0)
			{
				this.towerPointTooltip.valueTextField.text="∞";
			}else
			{
				this.towerPointTooltip.valueTextField.text=effectVO.value;
			}
			if(effectVO.area==0)
			{
				this.towerPointTooltip.areaTextField.text="--";
			}
			else
			{
				this.towerPointTooltip.areaTextField.text=effectVO.area;
			}
			addTooltip(this.towerPointTooltip);
			return this.towerPointTooltip;
		}
		
		/**
		 * 添加兵营建造点tip
		 * @param barrackVO 兵营VO
		 * @param monsterVO 怪物VO  
		 * @return tip实例
		 */
		public function addBarrackPointTooltip(barrackVO:BarrackVO,monsterVO:MonsterVO):MovieClip
		{
			this.barrackPointTooltip.nameTextField.text=monsterVO.name;
			this.barrackPointTooltip.introductionTextField.text=monsterVO.introduction;
			this.barrackPointTooltip.damageTextField.text=monsterVO.attackDamage;
			this.barrackPointTooltip.attackTypeTextField.text=EnumAttackType.toString(monsterVO.attackType);
			this.barrackPointTooltip.attackSpeedTextField.text=EnumAttackFrequency.toString(monsterVO.attackFrequency);
			this.barrackPointTooltip.mvoeSpeedTextField.text=EnumMoveSpeed.toString(monsterVO.speed);
			this.barrackPointTooltip.bloodTextField.text=monsterVO.maxBlood;
			this.barrackPointTooltip.trainingTimeTextField.text=barrackVO.trainingTime;
			this.barrackPointTooltip.attackAreaTextField.text=EnumArea.toString(monsterVO.attackArea);
			this.barrackPointTooltip.moveAreaTextField.text=EnumArea.toString(monsterVO.moveArea);
			this.barrackPointTooltip.armorTextField.text=monsterVO.armor;
			this.barrackPointTooltip.magicResistanceTextField.text=monsterVO.magicResistance;
			addTooltip(this.barrackPointTooltip);
			return this.barrackPointTooltip;
		}
		
		/**
		 * 添加兵营tip
		 * @param barrackVO 兵营VO
		 * @param monsterVO 怪物VO  
		 * @return tip实例
		 */
		public function addBarrackTooltip(barrackVO:BarrackVO,monsterVO:MonsterVO):MovieClip
		{
			this.barrackTooltip.nameTextField.text=barrackVO.name;
			this.barrackTooltip.levelTextField.text=barrackVO.level;
			this.barrackTooltip.introductionTextField.text=monsterVO.name+" : "+monsterVO.introduction;
			this.barrackTooltip.damageTextField.text=monsterVO.attackDamage;
			this.barrackTooltip.attackTypeTextField.text=EnumAttackType.toString(monsterVO.attackType);
			this.barrackTooltip.attackSpeedTextField.text=EnumAttackFrequency.toString(monsterVO.attackFrequency);
			this.barrackTooltip.mvoeSpeedTextField.text=EnumMoveSpeed.toString(monsterVO.speed);
			this.barrackTooltip.bloodTextField.text=monsterVO.maxBlood;
			this.barrackTooltip.trainingTimeTextField.text=barrackVO.trainingTime;
			this.barrackTooltip.attackAreaTextField.text=EnumArea.toString(monsterVO.attackArea);
			this.barrackTooltip.moveAreaTextField.text=EnumArea.toString(monsterVO.moveArea);
			this.barrackTooltip.armorTextField.text=monsterVO.armor;
			this.barrackTooltip.magicResistanceTextField.text=monsterVO.magicResistance;
			addTooltip(this.barrackTooltip);
			return this.barrackTooltip;
		}
		
		/**
		 * 添加防御塔tip
		 * @param towerVO 防御塔VO
		 * @param effectVO 特效VO  
		 * @return tip实例
		 */
		public function addTowerToolTip(towerVO:TowerVO,effectVO:EffectVO):MovieClip
		{
			this.towerTooltip.nameTextField.text=towerVO.name;
			this.towerTooltip.levelTextField.text=towerVO.level;
			this.towerTooltip.attackTypeTextField.text=EnumAttackType.toString(effectVO.attackType);
			this.towerTooltip.introductionTextField.text=effectVO.name+" : "+towerVO.introduction;
			this.towerTooltip.numTextField.text=towerVO.effectNum;
			this.towerTooltip.intervalTextField.text=towerVO.intervalTime;
			if(effectVO.value==0)
			{
				this.towerTooltip.valueTextField.text="∞";
			}else
			{
				this.towerTooltip.valueTextField.text=effectVO.value;
			}
			if(effectVO.area==0)
			{
				this.towerTooltip.areaTextField.text="--";
			}
			else
			{
				this.towerTooltip.areaTextField.text=effectVO.area;
			}
			addTooltip(this.towerTooltip);
			return this.towerTooltip;
		}
		
		/**
		 * 添加特效升级tip
		 * @param oldTowerVO 旧防御塔VO
		 * @param oldEffectVO 旧特效VO
		 * @param newTowerVO 新防御塔VO
		 * @param newEffectVO 新特效VO
		 * @return tip实例
		 */
		public function addEffectTooltip(oldTowerVO:TowerVO,oldEffectVO:EffectVO,newTowerVO:TowerVO,newEffectVO:EffectVO):MovieClip
		{
			this.effectTooltip.nameTextField.text=oldEffectVO.name;
			this.effectTooltip.levelTextField.text=oldTowerVO.level+" -> "+newTowerVO.level;
			this.effectTooltip.attackTypeTextField.text=EnumAttackType.toString(oldEffectVO.attackType);
			this.effectTooltip.numTextField.text=oldTowerVO.effectNum+" -> "+newTowerVO.effectNum;
			this.effectTooltip.intervalTextField.text=oldTowerVO.intervalTime+" -> "+newTowerVO.intervalTime;
			if(oldEffectVO.value==0)
			{
				this.effectTooltip.valueTextField.text="∞";
			}else
			{
				this.effectTooltip.valueTextField.text=oldEffectVO.value+" -> "+newEffectVO.value;
			}
			if(oldEffectVO.area==0)
			{
				this.effectTooltip.areaTextField.text="--";
			}
			else
			{
				this.effectTooltip.areaTextField.text=oldEffectVO.area+" -> "+newEffectVO.area;
			}
			addTooltip(this.effectTooltip);
			return this.effectTooltip;
		}
		
		/**
		 * 添加怪物升级tip
		 * @param oldBarrackVO 旧兵营VO
		 * @param oldMonsterVO 旧怪物VO
		 * @param newBarrackVO 新兵营VO
		 * @param newMonsterVO 新怪物VO
		 * @return tip实例
		 */
		public function addMonsterTooltip(oldBarrackVO:BarrackVO,oldMonsterVO:MonsterVO,newBarrackVO:BarrackVO,newMonsterVO:MonsterVO):MovieClip
		{
			this.monsterTooltip.nameTextField.text=oldBarrackVO.name;
			this.monsterTooltip.levelTextField.text=oldBarrackVO.level+" -> "+newBarrackVO.level;
			this.monsterTooltip.damageTextField.text=oldMonsterVO.attackDamage+" -> "+newMonsterVO.attackDamage;
			this.monsterTooltip.attackTypeTextField.text=EnumAttackType.toString(oldMonsterVO.attackType);
			this.monsterTooltip.attackSpeedTextField.text=EnumAttackFrequency.toString(oldMonsterVO.attackFrequency);
			this.monsterTooltip.mvoeSpeedTextField.text=EnumMoveSpeed.toString(oldMonsterVO.speed);
			this.monsterTooltip.bloodTextField.text=oldMonsterVO.maxBlood+" -> "+newMonsterVO.maxBlood;
			this.monsterTooltip.trainingTimeTextField.text=oldBarrackVO.trainingTime+" -> "+newBarrackVO.trainingTime;
			this.monsterTooltip.attackAreaTextField.text=EnumArea.toString(oldMonsterVO.attackArea);
			this.monsterTooltip.moveAreaTextField.text=EnumArea.toString(oldMonsterVO.moveArea);
			this.monsterTooltip.armorTextField.text=oldMonsterVO.armor;
			this.monsterTooltip.magicResistanceTextField.text=oldMonsterVO.magicResistance;
			addTooltip(this.monsterTooltip);
			return this.monsterTooltip;
		}
		
		/**
		 * 移除tip
		 * @param toolTip tip实例
		 */ 
		public function removeTip(toolTip:MovieClip):void
		{
			this.tipScene.removeChild(toolTip);
		}
	}
}