package net.shangle.display
{
	import flash.events.EventDispatcher;
	
	import net.shangle.event.CemeteryEvent;
	import net.shangle.manager.GlobalTriggerManager;
	import net.shangle.vo.ComputerCreepAIVO;

	public class Cemetery extends EventDispatcher
	{
		
		private var vo:ComputerCreepAIVO;
		private var buildingTriggerID : int;
		private var trainingTriggerID : int;
		
		private var i:int;
		
		public function Cemetery(vo:ComputerCreepAIVO)
		{
			this.vo=vo;
			buildStart();
		}
		
		private function buildStart() : void
		{
			this.buildingTriggerID = GlobalTriggerManager.getInstance().addTrigger(this.vo.showTime , buildComplete);
		}
		
		private function buildComplete():void
		{
			GlobalTriggerManager.getInstance().removeTrigger(this.buildingTriggerID);
			addMonster();
			startTraining();
		}
		
		private function startTraining() : void
		{
			this.trainingTriggerID = GlobalTriggerManager.getInstance().addTrigger(this.vo.intervalTime , addMonster);
		}
		
		private function addMonster():void
		{
			for(i=0;i<this.vo.num;i++)
			{
				this.dispatchEvent(new CemeteryEvent(CemeteryEvent.ADD_MONSTER,this.vo.monsterResID,this.vo.lineID));
			}
		}
		
		public function clear():void
		{
			GlobalTriggerManager.getInstance().removeTrigger(this.buildingTriggerID);
			GlobalTriggerManager.getInstance().removeTrigger(this.trainingTriggerID);
		}
	}
}