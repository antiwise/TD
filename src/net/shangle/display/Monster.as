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
	import net.shangle.uint.IAnimator;
	import net.shangle.util.EnumAttackFrequency;
	import net.shangle.util.EnumAttackType;
	import net.shangle.util.EnumMonsterState;
	import net.shangle.util.MonsterFrameLabel;
	import net.shangle.util.MonsterGridArr;
	import net.shangle.util.PointUtil;
	import net.shangle.vo.LineVO;
	import net.shangle.vo.MonsterVO;

	public class Monster extends Sprite implements IAnimator
	{
		public var vo : MonsterVO;
		protected var lineVO : LineVO;
		protected var lineLength : int;
		protected var nextPointIndex : int;
		protected var bloodBar : BloodBar;
		protected var enemyArr : Vector.<Monster>;
		protected var attackTriggerID : int;
		protected const ATTACK_DAMAGE_REDUCTION_BASE_NUMBER:int=100;
		//protected var skin:MovieClip;
		protected var skin:BitmapMovieClip;
//		protected var currentFrameLabel:String;
		protected var state:int;
		public var active:Boolean;
		protected var instanceID:int;
		protected const DISTANCE:int=10;
		protected var dx : int;
		protected var dy : int;
		protected var angle : Number;
		protected var point : Point;
		protected var distance : int;
		protected var enemy : Monster;
		protected var coolDown:Boolean;
		public var gridPoint:Point;
		protected var enemyGridArr:MonsterGridArr;

		public function Monster(vo : MonsterVO , instanceID:int)
		{
			this.vo=vo;
			this.instanceID=instanceID;
			this.mouseChildren=false;
			this.mouseEnabled=false;
			gridPoint=new Point();
			loadSkin();
		}
		
		public function respawn(lineVO:LineVO,enemyGridArr:MonsterGridArr):void
		{
			this.lineVO = lineVO;
			this.nextPointIndex = 1;
			this.point = this.lineVO.line[this.nextPointIndex];
			this.lineLength = this.lineVO.line.length;
//			this.enemyArr = enemyArr;
			this.enemyGridArr=enemyGridArr;
			//this.skin.gotoAndPlay(MonsterFrameLabel.RUN_FRAME_LABEL);
			this.skin.gotoAndStop(MonsterFrameLabel.RUN_FRAME_LABEL);
			this.bloodBar.alpha=1;
			this.bloodBar.currentValue=this.vo.maxBlood;
			this.skin.scaleX = 1;
			this.state=EnumMonsterState.RUN;
			this.coolDown=true;
			this.active=true;
		}
		
		public function clone(instanceID:int):Monster
		{
			return null;
		}
		
		protected function loadSkin():void
		{
//			this.skin=GlobalFlashManager.getInstance().getClassInstance(this.vo.skinUrl);
//			this.skin.cacheAsBitmap=true;
//			this.skin.stop();
//			this.addChild(this.skin);
			this.skin=new BitmapMovieClip(this.vo.bitmapMCFrameInfoArr);
			this.skin.cacheAsBitmap=true;
			this.addChild(this.skin);
			initBloodBar();

		}

		protected function initBloodBar() : void
		{
			
		}
		
		protected function resetCoolDown():void
		{
			this.coolDown=false;
			this.attackTriggerID = GlobalTriggerManager.getInstance().addTrigger(this.vo.attackFrequency , coolDownComplete);
		}
		
		protected function coolDownComplete() : void
		{
			this.coolDown=true;
			GlobalTriggerManager.getInstance().removeTrigger(this.attackTriggerID);
		}

		protected function isEnemyInAttackArea(enemy : Monster) : Boolean
		{
			if(this.vo.attackArea & enemy.vo.moveArea)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		protected function isEnemyInAttackRange(enemy : Monster) : Boolean
		{
			//垂直距离小于50
			if(PointUtil.distance(this.x,this.y,enemy.x,enemy.y)<= this.vo.attackRange && Math.abs(this.y-enemy.y)<=30)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		protected function isEnemyInSameLine(enemy:Monster):Boolean
		{
			if(enemy.lineVO.id==this.lineVO.id)
			{
				return true;
			}
			else
			{
				return false;
			}
		}


		public function hurt(attackDamage : int , attackType : int) : void
		{
			this.bloodBar.currentValue -= attackDamage * (1 - attackDamageReduce(attackDamage , attackType));
		}
		
		public function heal(healValue:int):void
		{
			if((this.bloodBar.maxValue-this.bloodBar.currentValue)>healValue)
			{
				this.bloodBar.currentValue+=healValue;
			}
			else
			{
				this.bloodBar.currentValue=this.bloodBar.maxValue;
			}
		}

		protected function dying(evt : ProgressBarEvent) : void
		{

		}
		
		protected function die():void
		{
			this.dispatchEvent(new MonsterEvent(MonsterEvent.DIE));
		}

		protected function attackDamageReduce(attackDamage : int , attackType : int) : Number
		{
			if(attackType == EnumAttackType.MAGIC)
			{
				return this.vo.magicResistance / (this.vo.magicResistance + ATTACK_DAMAGE_REDUCTION_BASE_NUMBER);
			}
			else if(attackType == EnumAttackType.PHYSICAL)
			{
				return this.vo.armor / (this.vo.armor + ATTACK_DAMAGE_REDUCTION_BASE_NUMBER);
			}
			else if(attackType==EnumAttackType.HOLY)
			{
				return 0;
			}
			return 0;
		}


		public function clear() : void
		{

		}

		public function render() : void
		{
		}

	}
}
