package net.shangle.display
{
	import net.shangle.event.EffectEvent;
	import net.shangle.manager.GlobalFlashManager;
	import net.shangle.util.EffectFrameLabel;
	import net.shangle.util.EnumAttackType;
	import net.shangle.vo.EffectVO;

	public class LightningEffect extends Effect
	{
		private const 	EFFECT_HEIGHT:int=325;
		
		public function LightningEffect(vo:EffectVO,instanceID:int)
		{
			super(vo,instanceID);
		}
		
		
		public override function respawn(effectTarget:Monster,monsterArr:Vector.<Monster>,tower:Tower):void
		{
			this.monsterArr=monsterArr;
			this.effectTarget=effectTarget;
			this.tower=tower;
			this.x=this.effectTarget.x;
			this.y=this.effectTarget.y;
			this.skin.scaleY=this.y/EFFECT_HEIGHT;
			this.skin.gotoAndStop(EffectFrameLabel.START);
			this.active=true;
		//	this.skin.play();
			attack();
		}
		
		private function attack():void
		{
			this.effectTarget.hurt(this.vo.value,this.vo.attackType);
		}
		
		public override function render():void
		{
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
			return new LightningEffect(this.vo,instanceID);
		}
		
		public override function clear():void
		{
			this.active=false;
		}
	}
}