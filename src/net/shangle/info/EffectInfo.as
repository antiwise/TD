package net.shangle.info
{
	import net.shangle.vo.EffectVO;
	
	public class EffectInfo
	{
		public function EffectInfo()
		{
			init();
		}
		
		private var data:Vector.<EffectVO>;
		
		public function init():void
		{
			this.data=new Vector.<EffectVO>();
		}
		
		public function addEffectVO(effectVO:EffectVO):void
		{
			this.data.push(effectVO);
		}
		
		public function getEffectVO(resID:int):EffectVO
		{
			for each(var effectVO:EffectVO in this.data)
			{
				if(effectVO.resID==resID)
				{
					return effectVO;
				}
			}
			return null;
		}
		
		public function get effectVOArr():Vector.<EffectVO>
		{
			return this.data;
		}
	}
}