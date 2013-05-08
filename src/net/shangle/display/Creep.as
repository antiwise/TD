package net.shangle.display
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	
	import net.shangle.event.MonsterEvent;
	import net.shangle.event.ProgressBarEvent;
	import net.shangle.manager.GlobalFlashManager;
	import net.shangle.manager.GlobalInfoManager;
	import net.shangle.manager.GlobalTriggerManager;
	import net.shangle.util.EnumAttackFrequency;
	import net.shangle.util.EnumAttackType;
	import net.shangle.util.EnumMonsterState;
	import net.shangle.util.MonsterFrameLabel;
	import net.shangle.util.PointUtil;
	import net.shangle.vo.LineVO;
	import net.shangle.vo.MonsterVO;
	
	public class Creep extends Monster
	{
		
		
		private var attackTarget : Monster;
		
		public function Creep(vo : MonsterVO , instanceID:int)
		{
			super(vo,instanceID);
		}
		
		
		public override function clone(instanceID:int):Monster
		{
			return new Creep(this.vo,instanceID);
		}
		
		protected override function initBloodBar() : void
		{
			this.bloodBar = new BloodBar(this.vo.maxBlood);
			this.bloodBar.addEventListener(ProgressBarEvent.COMMON , dying);
			this.bloodBar.y = -this.vo.height;
			this.addChild(bloodBar);
		}
		
		private function searchEnemy() : Monster
		{
			for each(this.enemy in this.enemyGridArr.getNearByMonsters(this.gridPoint))
			{
				if(isEnemyInAttackRange(this.enemy))
				{
					if(isEnemyInAttackArea(this.enemy))
					{
						//	if(isEnemyInSameLine(enemy))
						{
							return this.enemy;
						}
					}
				}
			}
			return null;
		}
		
		
		private function attack() : void
		{
			attackTarget.hurt(this.vo.attackDamage , this.vo.attackType);
		}
		
		
		protected override function dying(evt : ProgressBarEvent) : void
		{
			if(attackTarget!=null)
				clearAttackTarget(null);
			this.bloodBar.alpha=0;
			this.dispatchEvent(new MonsterEvent(MonsterEvent.DYING));
			//this.skin.addEventListener(SkinEvent.DIE,die);
			this.skin.gotoAndStop(MonsterFrameLabel.DYING_FRAME_LABEL);
			this.state=EnumMonsterState.DIE;
		}
		
		
		private function clearAttackTarget(evt : MonsterEvent) : void
		{
			this.attackTarget.removeEventListener(MonsterEvent.DYING , clearAttackTarget);
			this.attackTarget.removeEventListener(MonsterEvent.REACH_THE_END , clearAttackTarget);
			this.attackTarget = null;
		}
		
		public override function clear() : void
		{
			GlobalTriggerManager.getInstance().removeTrigger(this.attackTriggerID);
			//this.skin.stop();
			if(attackTarget != null)
			{
				clearAttackTarget(null);
			}
			this.enemyArr = null;
			this.lineVO=null;
			this.active=false;
		}
		
		public override function render() : void
		{
			//			this.currentFrameLabel==this.skin.currentFrameLabel
			//			if(this.currentFrameLabel==MonsterFrameLabel.RUN_FRAME_LABEL)
			//			{
			//				this.skin.nextFrame();
			//				move();
			//			}
			//			else if(this.currentFrameLabel==MonsterFrameLabel.ATTACK_FRAME_LABEL)
			//			{
			//				this.skin.nextFrame();
			//			}
			//			else if(this.currentFrameLabel==MonsterFrameLabel.DYING_FRAME_LABEL)
			//			{
			//				this.skin.nextFrame();
			//			}
			//			else if(this.currentFrameLabel==MonsterFrameLabel.RUN_END_FRAME_LABEL)
			//			{
			//				this.skin.gotoAndStop(MonsterFrameLabel.RUN_FRAME_LABEL);
			//				move();
			//			}
			//			else if(this.currentFrameLabel==MonsterFrameLabel.DYING_END_FRAME_LABEL)
			//			{
			//				die();
			//			}
			
			//死亡状态
			if(this.state==EnumMonsterState.DIE)
			{
				
				//死亡动画播放完毕
				if(this.skin.currentFrameLabel==MonsterFrameLabel.DYING_END_FRAME_LABEL)
				{
					die();
				}
				else
				{
					this.skin.nextFrame();
				}
			}
			else
			{
				//目标非空，判断是否仍在范围内,如果不在则清空目标
				if(this.attackTarget != null)
				{
					if(!isEnemyInAttackRange(attackTarget))
					{
						clearAttackTarget(null);
					}
				}
				//目标为空，重新搜寻目标
				if(this.attackTarget == null)
				{
					this.attackTarget = searchEnemy();
					if(this.attackTarget != null)
					{
						this.attackTarget.addEventListener(MonsterEvent.DYING , clearAttackTarget);
						this.attackTarget.addEventListener(MonsterEvent.REACH_THE_END , clearAttackTarget);
					}
				}
				//目标为空
				if(this.attackTarget == null)
				{
					//判断攻击动画是否已播放完毕
					if(this.state==EnumMonsterState.ATTACK)
					{
						if(this.skin.currentFrameLabel==MonsterFrameLabel.ATTACK_END_FRAME_LABEL || this.skin.currentFrameLabel==MonsterFrameLabel.ATTACK_END_REP_FRAME_LABEL)				
						{
							this.skin.gotoAndStop(MonsterFrameLabel.RUN_FRAME_LABEL);
							this.state=EnumMonsterState.RUN;
						}
						else
						{
							this.skin.nextFrame();
						}
					}
						//行走
					else if(this.state==EnumMonsterState.RUN)
					{
						//this.point = this.lineVO.line[this.nextPointIndex];
						//						this.distance = Point.distance(this.point , new Point(x , y));
						if(this.skin.currentFrameLabel==MonsterFrameLabel.RUN_END_FRAME_LABEL)
						{
							this.skin.gotoAndStop(MonsterFrameLabel.RUN_FRAME_LABEL);
						}
						else
						{
							this.skin.nextFrame();
						}
						
						this.distance=PointUtil.distance(this.point.x,this.point.y,this.x,this.y);
						if(this.distance < DISTANCE)
						{
							this.nextPointIndex++; //进入下一个拐弯点
							if(this.nextPointIndex == this.lineLength)
							{
								this.dispatchEvent(new MonsterEvent(MonsterEvent.REACH_THE_END));
							}
							else
							{
								this.point = this.lineVO.line[this.nextPointIndex];
							}
						}
						else
						{
							this.dx = this.point.x - this.x;
							this.dy = this.point.y - this.y;
							this.angle = Math.atan2(this.dy , this.dx);
							this.x += this.vo.speed * Math.cos(this.angle);
							this.y += this.vo.speed * Math.sin(this.angle);
							if(this.angle >= -Math.PI / 2 && angle < Math.PI / 2)
								this.skin.scaleX = 1;
							else
								this.skin.scaleX = -1;
						}
					}
				}
					//目标非空
				else
				{
					if(this.state==EnumMonsterState.RUN)
					{
						this.state=EnumMonsterState.ATTACK;
						this.skin.gotoAndStop(MonsterFrameLabel.ATTACK_END_FRAME_LABEL);
					}
					else	//攻击状态中
					{
						//更正方向
						this.dx = attackTarget.x - this.x;
						this.dy = attackTarget.y - this.y;
						this.angle = Math.atan2(dy , dx);
						if(this.angle >= -Math.PI / 2 && this.angle < Math.PI / 2)
							this.skin.scaleX = 1;
						else
							this.skin.scaleX = -1;
						if(coolDown)
						{
							attack();
							this.skin.gotoAndStop(MonsterFrameLabel.ATTACK_FRAME_LABEL);
							this.state=EnumMonsterState.ATTACK;
							resetCoolDown();
						}
						else
						{
							if(this.skin.currentFrameLabel==MonsterFrameLabel.ATTACK_FRAME_LABEL ||this.skin.currentFrameLabel==MonsterFrameLabel.ATTACK_END_FRAME_LABEL)
							{
								this.skin.nextFrame();
							}
							else if(this.skin.currentFrameLabel==MonsterFrameLabel.ATTACK_END_REP_FRAME_LABEL)
							{
								this.skin.gotoAndStop(MonsterFrameLabel.ATTACK_END_FRAME_LABEL);
							}
						}
					}
				}
			}
			
		}
	}
}
