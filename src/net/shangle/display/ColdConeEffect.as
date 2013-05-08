package net.shangle.display
{
	
	import flash.geom.Point;
	
	import net.shangle.event.EffectEvent;
	import net.shangle.event.MonsterEvent;
	import net.shangle.manager.GlobalFlashManager;
	import net.shangle.util.EffectFrameLabel;
	import net.shangle.util.EnumAttackType;
	import net.shangle.util.PointUtil;
	import net.shangle.vo.EffectVO;
	
	public class ColdConeEffect extends Effect
	{
		private const DISTANCE:int=10;

		
		private var distance:int;
		private var monster:Monster;
		private var attackEnemyArr:Vector.<Monster>;
		
		public function ColdConeEffect(vo:EffectVO,instanceID:int)
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
			this.skin.gotoAndStop(EffectFrameLabel.EFFECT_START);
			this.active=true;
		}
		
		public override function clone(instanceID:int):Effect
		{
			return new ColdConeEffect(this.vo,instanceID);
		}
		
		
		private function attack():void
		{
			this.attackEnemyArr=this.monsterArr.concat();
			for each(this.monster in this.attackEnemyArr)
			{
				//this.distance=Point.distance(new Point(this.x,this.y),new Point(this.monster.x,this.monster.y));
				this.distance=PointUtil.distance(this.x,this.y,this.monster.x,this.monster.y);
				if(distance<this.vo.area)
				{
					this.monster.hurt(this.vo.value,this.vo.attackType);
				}
			}
			this.attackEnemyArr=null;
		}		
		
		public override function render():void
		{
			if(this.skin.currentFrameLabel==EffectFrameLabel.EFFECT_END)
			{
				attack();
				//this.skin.gotoAndPlay(EffectFrameLabel.START);
				this.skin.nextFrame();
			}
			else if(this.skin.currentFrameLabel==EffectFrameLabel.END)
			{
				dispatchEvent(new EffectEvent(EffectEvent.EFFECT_COMPLETE))
			}
			else
			{
				this.skin.nextFrame();
			}
		}
		
		public override function clear():void
		{
			this.active=false;
//			this.skin.stop();
		}
	}
}