package net.shangle.manager
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import net.shangle.uint.Trigger;

	public class GlobalTriggerManager
	{

		private var timer : Timer;
		private var triggerID : uint;
		private var triggerArr : Vector.<Trigger>;
		private const FREQUENCY : Number = 0.5;
		private static var instance : GlobalTriggerManager;
		private var tempTriggerArr:Vector.<Trigger>;

		public function GlobalTriggerManager()
		{
			init();
		}

		public static function getInstance() : GlobalTriggerManager
		{
			if(instance == null)
			{
				instance = new GlobalTriggerManager();
			}
			return instance;
		}

		private function init() : void
		{
			this.triggerArr = new Vector.<Trigger>();
			this.timer = new Timer(FREQUENCY * 1000);
			this.timer.addEventListener(TimerEvent.TIMER , timerHandler);
		}
		
		/**当前触发器的数量*/
		public function get triggerNum():int
		{
			return this.triggerArr.length;
		}
		
		/**开始*/
		public function start() : void
		{
			this.timer.reset();
			this.timer.start();
		}
		
		/**暂停*/
		public function pause() : void
		{
			this.timer.stop();
		}
		
		/**恢复*/
		public function resume():void
		{
			this.timer.start();
		}
		
		/**复原*/
		public function reset():void
		{
			this.triggerID=0;
		}

		private function timerHandler(evt : TimerEvent) : void
		{
			this.tempTriggerArr=this.triggerArr.concat();
			for each(var trigger:Trigger in this.tempTriggerArr)
			{
				trigger.currentCount += FREQUENCY;
				if(trigger.currentCount == trigger.frequency)
				{
					trigger.callBackFunc.apply(null , trigger.callBackArgs);
					trigger.currentCount = 0;
				}
			}
		}
		
		/**
		 * 添加触发器
		 * @param frequency 触发频率
		 * @param callBackFunc 回调函数
		 * @param callBackArgs 回调函数参数
		 * @return 触发器ID
		 */ 
		public function addTrigger(frequency : Number , callBackFunc : Function , callBackArgs : Array = null) : uint
		{
			var trigger:Trigger  = new Trigger(this.triggerID++ , 0 , frequency , callBackFunc , callBackArgs);
			this.triggerArr.push(trigger);
			return trigger.id;
		}
		
		/**
		 * 移除触发器
		 * @param id 触发器ID
		 */ 
		public function removeTrigger(id : int) : void
		{
			var length : int = this.triggerArr.length;
			var i : int;
			for(i = 0 ; i < length ; i++)
			{
				if(this.triggerArr[i].id == id)
				{
					var trigger:Trigger =this.triggerArr.splice(i , 1)[0];
					trigger.callBackArgs=null;
					trigger.callBackFunc=null;
					trigger=null;
					break;
				}
			}
		}
	}
}
