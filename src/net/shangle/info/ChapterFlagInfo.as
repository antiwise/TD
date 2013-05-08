package net.shangle.info
{
	import net.shangle.vo.ChapterFlagVO;

	public class ChapterFlagInfo
	{
		public function ChapterFlagInfo()
		{
			init();
		}
		
		private var data:Vector.<ChapterFlagVO>;
		
		public function init():void
		{
			this.data=new Vector.<ChapterFlagVO>();
		}
		
		public function addChapterFlagVO(chapterFlagVO:ChapterFlagVO):void
		{
			this.data.push(chapterFlagVO);
		}
		
		public function getChapterFlagVO(id:int):ChapterFlagVO
		{
			for each(var chapterFlagVO:ChapterFlagVO in this.data)
			{
				if(chapterFlagVO.id==id)
				{
					return chapterFlagVO;
				}
			}
			return null;
		}
		
		public function get chapterFlagVOArr():Vector.<ChapterFlagVO>
		{
			return this.data;
		}
	}
}