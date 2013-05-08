package net.shangle.display
{
	import flash.geom.Point;
	
	import net.shangle.event.EffectEvent;
	import net.shangle.event.MonsterEvent;
	import net.shangle.manager.GlobalFlashManager;
	import net.shangle.manager.GlobalTriggerManager;
	import net.shangle.util.EffectFrameLabel;
	import net.shangle.util.EnumAttackType;
	import net.shangle.util.PointUtil;
	import net.shangle.vo.EffectVO;
	
	public class FatalBlowEffect extends Effect
	{
		
		private var dx:int;
		private var dy:int;
		private var angle:Number;
		private const 	EFFECT_WIDTH:int=125;
		private var scale:Number;
		private var distance:int;
		private var targetX:int;
		private var targetY:int;
		private const OFFEST_Y:int=65;
		
		public function FatalBlowEffect(vo:EffectVO,instanceID:int)
		{
			super(vo,instanceID);
		}
		
		
		public override function respawn(effectTarget:Monster,monsterArr:Vector.<Monster>,tower:Tower):void
		{
			this.monsterArr=monsterArr;
			this.effectTarget=effectTarget;
			this.x=tower.x;
			this.y=tower.y-OFFEST_Y;
			this.skin.gotoAndStop(EffectFrameLabel.START);
			this.targetX=this.effectTarget.x;
			this.targetY=this.effectTarget.y-this.effectTarget.vo.height/2
			this.dx = this.targetX - this.x;
			this.dy = this.targetY - this.y;
			this.angle = Math.atan2(this.dy , this.dx)/ Math.PI * 180;
			this.rotation=this.angle;
//			this.distance=Point.distance(new Point(this.x,this.y),new Point(this.effectTarget.x,this.effectTarget.y));
			this.distance=PointUtil.distance(this.x,this.y,this.effectTarget.x,this.effectTarget.y);
			this.skin.scaleX=this.distance/EFFECT_WIDTH;
			this.active=true;
			attack();
		}
		
		
		private function attack():void
		{
			this.effectTarget.hurt(this.effectTarget.vo.maxBlood,this.vo.attackType);
		}
		
		public override function render():void
		{	
			if(this.skin.currentFrameLabel==EffectFrameLabel.END)
			{
				dispatchEvent(new EffectEvent(EffectEvent.EFFECT_COMPLETE));
			}
			else
			{
				this.skin.nextFrame();
			}
		}
		
		public override function clone(instanceID:int):Effect
		{
			return new FatalBlowEffect(this.vo,instanceID);
		}
		
		public override function clear():void
		{
			this.active=false;
		}
	}
}