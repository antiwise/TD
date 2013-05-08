package net.shangle.uint
{
	public class Trigger
	{
		public function Trigger(id:int,currentCount:Number, frequency:Number,callBackFunc:Function,callBackArgs:Array)
		{
			this.id=id;
			this.currentCount=currentCount;
			this.frequency=frequency;
			this.callBackArgs=callBackArgs;
			this.callBackFunc=callBackFunc;
		}
		
		public var id:int;
		public var frequency:Number;
		public var currentCount:Number;
		public var callBackFunc:Function;
		public var callBackArgs:Array;
	}
}