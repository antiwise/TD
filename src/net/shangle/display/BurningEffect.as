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
	
	public class BurningEffect extends Effect
	{
		public function BurningEffect(vo:EffectVO,instanceID:int)
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
				this.y=this.effectTarget.y-this.effectTarget.vo.height/4*3;
			}
			else
			{
				this.y=this.effectTarget.y-this.effectTarget.vo.height/2;
			}
			this.skin.gotoAndStop(EffectFrameLabel.START);
			this.active=true;
			burning();
		}
		
		
		private function onMonsterDisappear(evt:MonsterEvent):void
		{
			dispatchEvent(new EffectEvent(EffectEvent.EFFECT_COMPLETE));
		}
		
		
		private function burning():void
		{
			this.effectTarget.hurt(this.vo.value,this.vo.attackType);
		}
		
		public override function render():void
		{
			this.x=this.effectTarget.x;
			if(effectTarget.vo.moveArea==EnumArea.AIR)
			{
				this.y=this.effectTarget.y-this.effectTarget.vo.height/4*3;
			}
			else
			{
				this.y=this.effectTarget.y-this.effectTarget.vo.height/2;
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
			return new BurningEffect(this.vo,instanceID);
		}
		
		public override function clear():void
		{
			this.active=false;
			this.effectTarget.removeEventListener(MonsterEvent.DIE,onMonsterDisappear);
			this.effectTarget.removeEventListener(MonsterEvent.REACH_THE_END,onMonsterDisappear);
		}
	}
}