package net.shangle.info
{

	public class ChapterInfo
	{
		public function ChapterInfo()
		{
			init();
		}	
		public var barrackPointInfo:BarrackPointInfo;
		public var towerPointInfo:TowerPointInfo;
		public var computerInfo:ComputerInfo;
		public var playerInfo:PlayerInfo;
		public var lineInfo:LineInfo;
		public var currentChapter:int;
		public var chpaterNum:int;
		
		private var barrackPointInfoArr:Vector.<BarrackPointInfo>;
		private var towerPointInfoArr:Vector.<TowerPointInfo>;
		private var computerInfoArr:Vector.<ComputerInfo>;
		private var lineInfoArr:Vector.<LineInfo>;
		private var playerInfoArr:Vector.<PlayerInfo>;
		
		
		private function init():void
		{
			this.barrackPointInfoArr=new Vector.<BarrackPointInfo>();
			this.towerPointInfoArr=new Vector.<TowerPointInfo>();
			this.computerInfoArr=new Vector.<ComputerInfo>();
			this.lineInfoArr=new Vector.<LineInfo>();
			this.playerInfoArr=new Vector.<PlayerInfo>();
			chpaterNum=0;
		}
		
		public function setChapter(chapter:int):void
		{
			this.currentChapter=chapter;
			for each(var barrackPointInfo:BarrackPointInfo in this.barrackPointInfoArr)
			{
				if(barrackPointInfo.chapter==chapter)
				{
					this.barrackPointInfo=barrackPointInfo;
					break;
				}
			}
			for each(var towerPointInfo:TowerPointInfo in this.towerPointInfoArr)
			{
				if(towerPointInfo.chapter==chapter)
				{
					this.towerPointInfo=towerPointInfo;
					break;
				}
			}
			for each(var computerInfo:ComputerInfo in this.computerInfoArr)
			{
				if(computerInfo.chapter==chapter)
				{
					this.computerInfo=computerInfo;
					break;
				}
			}
			for each(var lineInfo:LineInfo in this.lineInfoArr)
			{
				if(lineInfo.chapter==chapter)
				{
					this.lineInfo=lineInfo;
					break;
				}
			}
			for each(var playerInfo:PlayerInfo in this.playerInfoArr)
			{
				if(playerInfo.chapter==chapter)
				{
					this.playerInfo=playerInfo;
					break;
				}
			}
		}
		
		public function addChapter(chapter:int):void
		{
			this.barrackPointInfo=new BarrackPointInfo();
			this.barrackPointInfo.chapter=chapter;
			this.barrackPointInfoArr.push(this.barrackPointInfo);
			this.towerPointInfo=new TowerPointInfo();
			this.towerPointInfo.chapter=chapter;
			this.towerPointInfoArr.push(this.towerPointInfo);
			this.computerInfo=new ComputerInfo();
			this.computerInfo.chapter=chapter;
			this.computerInfoArr.push(this.computerInfo);
			this.lineInfo=new LineInfo();
			this.lineInfo.chapter=chapter;
			this.lineInfoArr.push(this.lineInfo);
			this.playerInfo=new PlayerInfo();
			this.playerInfo.chapter=chapter;
			this.playerInfoArr.push(this.playerInfo);
			chpaterNum++;
		}
		
	}
}