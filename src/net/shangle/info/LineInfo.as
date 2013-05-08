package net.shangle.info
{
	import net.shangle.vo.LineVO;

	public class LineInfo
	{
		public var chapter:int;
		
		public function LineInfo()
		{
			init();
		}

		private var data : Vector.<LineVO>;

		public function init() : void
		{
			this.data = new Vector.<LineVO>();
		}

		public function addLineVO(lineVO : LineVO) : void
		{
			this.data.push(lineVO);
		}

		public function getLineVO(id : int , camp : int) : LineVO
		{
			for each(var lineVO : LineVO in this.data)
			{
				if(lineVO.id == id && lineVO.camp == camp)
				{
					return lineVO;
				}
			}
			return null;
		}
		
		public function get lineVOArr():Vector.<LineVO>
		{
			return this.data;
		}
	}
}
