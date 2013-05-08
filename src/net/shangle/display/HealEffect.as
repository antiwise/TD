package net.shangle.display
{
	import net.shangle.event.EffectEvent;
	import net.shangle.event.MonsterEvent;
	import net.shangle.manager.GlobalFlashManager;
	import net.shangle.manager.GlobalTriggerManager;
	import net.shangle.util.EffectFrameLabel;
	import net.shangle.util.EnumArea;
	import net.shangle.util.EnumAttackType;
	import net.shangle.vo.EffectVO;

	public class HealEffect extends Effect
	{
		public function HealEffect(vo:EffectVO,instanceID:int)
		{
			super(vo,instanceID);
		}
		
		public override function respawn(effectTarget:Monster,monsterArr:Vector.<Monster>,tower:Tower):void
		{
			this.monsterArr=monsterArr;
			this.effectTarget=effectTarget;
			this.tower=tower;
			this.effectTarget.addEventListener(MonsterEvent.DIE,onMonsterDisappear);
			this.effectTarget.addEventListener(MonsterEvent.REACH_THE_END,onMonsterDisappear);
			this.x=this.effectTarget.x;
			if(effectTarget.vo.moveArea==EnumArea.AIR)
			{
				this.y=this.effectTarget.y-this.effectTarget.vo.height/2;
			}
			else
			{
				this.y=this.effectTarget.y;
			}
			this.skin.gotoAndStop(EffectFrameLabel.START);
			this.active=true;
			heal();
		}
		
		
		private function onMonsterDisappear(evt:MonsterEvent):void
		{
			dispatchEvent(new EffectEvent(EffectEvent.EFFECT_COMPLETE));
		}
		
		
		private function heal():void
		{
			this.effectTarget.heal(this.vo.value);
		}
		
		public override function render():void
		{
			this.x=this.effectTarget.x;
			if(effectTarget.vo.moveArea==EnumArea.AIR)
			{
				this.y=this.effectTarget.y-this.effectTarget.vo.height/2;
			}
			else
			{
				this.y=this.effectTarget.y;
			}
			if(this.skin.currentFrameLabel==EffectFrameLabel.END)
			{
				dispatchEvent(new EffectEvent(EffectEvent.EFFECT_COMPLETE));
			}else
			{
				this.skin.nextFrame()
			}
			
		}
		
		public override function clone(instanceID:int):Effect
		{
			return new HealEffect(this.vo,instanceID);
		}
		
		public override function clear():void
		{
			this.active=false;
			this.effectTarget.removeEventListener(MonsterEvent.DIE,onMonsterDisappear);
			this.effectTarget.removeEventListener(MonsterEvent.REACH_THE_END,onMonsterDisappear);
		}
	}
}