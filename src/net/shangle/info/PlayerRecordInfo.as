package net.shangle.info
{
	import net.shangle.uint.PlayerRecord;

	public class PlayerRecordInfo
	{
		public function PlayerRecordInfo()
		{
			init();
			
		}
		
		private var data:Vector.<PlayerRecord>;
		
		private function init():void
		{
			data=new Vector.<PlayerRecord>();
		}

		public function getPlayerRecord(chapterID:int):PlayerRecord
		{
			var playerRecord:PlayerRecord;
			for each(playerRecord in this.data)
			{
				if(playerRecord.id==chapterID)
				{
					return playerRecord;
				}
			}
			return null;
		}
		
		public function get playerRecordArr():Vector.<PlayerRecord>
		{
			return this.data;
		}
		
		public function addPlayerRecord(playerRecord:PlayerRecord):void
		{
			this.data.push(playerRecord);
		}
		
		public function getLastPlayerRecordID():int
		{
			var length:int=this.data.length;
			if(length>0)
			{
				return this.data[length-1].id;
			}
			else
			{
				return 0;
			}	
		}
	}
}