package net.shangle.util
{
	import flash.geom.Point;
	
	import net.shangle.display.Monster;

	public class MonsterGridArr
	{
		private var data:Array;
		private var col:int;
		private var row:int;
		private var x:int;
		private var y:int;
		//private var gap:int;
		private var monsters:Vector.<Monster>;
		private var i:int;
		private var j:int;
		private var k:int;
		
		private var vGap:int;
		private var hGap:int;
		
		public function MonsterGridArr(mapWidth:int,mapHeight:int,hGap:int=100,vGap:int=30)
		{
			this.data=new Array();
			this.col=mapWidth/hGap;
			this.row=mapHeight/vGap;
//			this.gap=gap;
			this.vGap=vGap;
			this.hGap=hGap;
			for(this.i=0;this.i<=col;this.i++)
			{
				data.push(new Array());
				for(this.j=0;this.j<=row;this.j++)
				{
					data[this.i].push(new Vector.<Monster>());
				}
			}
		}
		
		public function update(monster:Monster):void
		{
			this.x=Math.floor(monster.x/this.hGap);
			this.y=Math.floor(monster.y/this.vGap);
			if(monster.gridPoint.x!=this.x || monster.gridPoint.y!=this.y)
			{
				removeMonster(monster);
				monster.gridPoint.x=this.x;
				monster.gridPoint.y=this.y;
				addMonster(monster);
			}
		}
		
		public function updateGridPoint(monster:Monster):void
		{
			monster.gridPoint.x=Math.floor(monster.x/this.hGap);
			monster.gridPoint.y=Math.floor(monster.y/this.vGap);
		}

		public function addMonster(monster:Monster):void
		{
			this.monsters=this.data[monster.gridPoint.x][monster.gridPoint.y];
			this.monsters.push(monster);
		}
		
		public function removeMonster(monster:Monster):void
		{
			this.monsters=this.data[monster.gridPoint.x][monster.gridPoint.y];
			this.monsters.splice(this.monsters.indexOf(monster),1);
		}
		
		public function getNearByMonsters(gridPoint:Point):Vector.<Monster>
		{
			this.x=gridPoint.x;
			this.y=gridPoint.y;
			this.monsters=this.data[x][y];
			if(x>0)
			{
				this.monsters=this.monsters.concat(this.data[x-1][y]);
			}
			if(y>0)
			{
				this.monsters=this.monsters.concat(this.data[x][y-1]);
			}
			if(x>0 && y>0)
			{
				this.monsters=this.monsters.concat(this.data[x-1][y-1]);
			}
			if(x<(col-1))
			{
				this.monsters=this.monsters.concat(this.data[x+1][y]);
			}
			if(y<(row-1))
			{
				this.monsters=this.monsters.concat(this.data[x][y+1]);
			}
			if(x<(col-1) && y<(row-1))
			{
				this.monsters=this.monsters.concat(this.data[x+1][y+1]);
			}
			if(x<(col-1) && y>0)
			{
				this.monsters=this.monsters.concat(this.data[x+1][y-1]);
			}
			if(x>0 && y<(row-1))
			{
				this.monsters=this.monsters.concat(this.data[x-1][y+1]);
			}
			return this.monsters;
		}
		
		public function get length():int
		{
			k=0;
			for(this.i=0;this.i<=col;this.i++)
			{
				for(this.j=0;this.j<=row;this.j++)
				{
					k+=this.data[i][j].length;
				}
			}
			return k;
		}
	}
}