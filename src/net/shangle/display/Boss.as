package net.shangle.display
{
	import flash.geom.Point;
	
	import net.shangle.event.MonsterEvent;
	import net.shangle.event.ProgressBarEvent;
	import net.shangle.manager.GlobalTriggerManager;
	import net.shangle.util.EnumMonsterState;
	import net.shangle.util.MonsterFrameLabel;
	import net.shangle.util.MonsterGridArr;
	import net.shangle.util.PointUtil;
	import net.shangle.vo.LineVO;
	import net.shangle.vo.MonsterVO;

	public class Boss extends Monster
	{
		private var flag:Boolean;
		
		private var attackEnemyArr:Vector.<Monster>;
		
		public function Boss(vo:MonsterVO, instanceID:int)
		{
			super(vo, instanceID);
		}

		public override function clone(instanceID:int):Monster
		{
			return new Boss(this.vo, instanceID);
		}
		

		protected override function initBloodBar():void
		{
			this.bloodBar=new BloodBar(this.vo.maxBlood);
			this.bloodBar.addEventListener(ProgressBarEvent.COMMON, dying);
			this.bloodBar.y=-this.vo.height;
			this.addChild(bloodBar);
		}

		protected override function dying(evt:ProgressBarEvent):void
		{
			this.bloodBar.alpha=0;
			this.dispatchEvent(new MonsterEvent(MonsterEvent.DYING));
			this.state=EnumMonsterState.DIE;
			this.skin.gotoAndStop(MonsterFrameLabel.DYING_FRAME_LABEL);
		}

		public override function clear():void
		{
			//this.skin.stop();
			this.enemyArr=null;
			GlobalTriggerManager.getInstance().removeTrigger(this.attackTriggerID);
			this.lineVO=null;
			this.active=false;
		}
		
		private function searchEnemy() : Boolean
		{
			this.attackEnemyArr=this.enemyGridArr.getNearByMonsters(this.gridPoint);
			this.flag=false;
//			var i:int;
//			var k:int;
//			var j:int;
			for each(this.enemy in this.attackEnemyArr)
			{
				if(isEnemyInAttackRange(this.enemy))
				{
//					k++;
					if(isEnemyInAttackArea(this.enemy))
					{
//						j++;
						//正朝对方
						if((this.skin.scaleX==1 && this.enemy.x>this.x) || (this.skin.scaleX==-1 && this.enemy.x<this.x))
						{
							this.enemy.hurt(this.vo.attackDamage,this.vo.attackType);
							this.flag=true;
//							i++;
						}
					}
				}
			}
			
//			if(flag)
//			{
//				trace("----BOSS攻击：----","范围内的敌人",k,"可攻击的敌人",j,"正向敌人",i,"造成伤害",this.vo.attackDamage,"伤害类型",this.vo.attackType);
//				trace("敌军人数",this.enemyArr.length,"遍历次数",this.attackEnemyArr.length);
//			}
			this.attackEnemyArr=null;
			return flag;
		}

		public override function render():void
		{
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
				if(this.coolDown)
				{
					if(searchEnemy())
					{
						this.state=EnumMonsterState.ATTACK;
						this.skin.gotoAndStop(MonsterFrameLabel.ATTACK_FRAME_LABEL);
						resetCoolDown();
						return;
					}
				}
				//this.point=this.lineVO.line[this.nextPointIndex];
				
				if (this.skin.currentFrameLabel == MonsterFrameLabel.ATTACK_END_FRAME_LABEL)
				{
					this.skin.gotoAndStop(MonsterFrameLabel.RUN_FRAME_LABEL);
					this.state=EnumMonsterState.RUN;
				}
				else if(this.skin.currentFrameLabel==MonsterFrameLabel.ATTACK_FRAME_LABEL)
				{
					this.skin.nextFrame();
				}
				else if (this.state == EnumMonsterState.RUN)
				{
					//this.distance=Point.distance(this.point, new Point(x, y));
					if(this.skin.currentFrameLabel==MonsterFrameLabel.RUN_END_FRAME_LABEL)
					{
						this.skin.gotoAndStop(MonsterFrameLabel.RUN_FRAME_LABEL);
					}
					else
					{
						this.skin.nextFrame();
					}
					
					this.distance=PointUtil.distance(this.point.x,this.point.y,this.x,this.y);
					if (this.distance < DISTANCE)
					{
						this.nextPointIndex++; //进入下一个拐弯点
						
						if (this.nextPointIndex == this.lineLength)
						{
							//抵达终点
							this.dispatchEvent(new MonsterEvent(MonsterEvent.REACH_THE_END));
						}
						else
						{
							this.point = this.lineVO.line[this.nextPointIndex];
						}
					}
					else
					{
						this.dx=this.point.x - this.x;
						this.dy=this.point.y - this.y;
						//计算角度
						this.angle=Math.atan2(this.dy, this.dx);
						//移动
						this.x+=this.vo.speed * Math.cos(this.angle);
						this.y+=this.vo.speed * Math.sin(this.angle);
						//修正方向
						if (this.angle >= -Math.PI / 2 && angle < Math.PI / 2)
							this.skin.scaleX=1;
						else
							this.skin.scaleX=-1;
					}
				}
			}
		}
	}
}
