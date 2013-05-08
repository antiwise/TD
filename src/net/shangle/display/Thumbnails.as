package net.shangle.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import net.shangle.manager.GlobalFlashManager;
	import net.shangle.util.FlashAssetsFileName;
	
	public class Thumbnails extends Sprite
	{
		private var mapWidth:int;
		private var mapHeight:int;
		private var map:MovieClip;
		
		private var playerArr:Vector.<Monster>;
		private var computerArr:Vector.<Monster>;
		private const THUMBNAILS_HEIGHT:int=47;
		private var thumbnailsWidth:int;
		private var tx:int;
		private var ty:int;
		private var canvas:Sprite;
		private var skin:MovieClip;
		private var scale9skin:BitmapScale9Grid;
		private const OFFSET_Y:int=8;
		private const OFFSET_X:int=17;
		private var monster:Monster;
		public function Thumbnails()
		{
			super();
			loadSkin();
			this.canvas=new Sprite();
//			this.canvas.x=-THUMBNAILS_WIDTH/2;
			this.canvas.y=OFFSET_Y;
			this.addChild(canvas);
		}
		
		private function loadSkin():void
		{
			this.skin=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.THUMBNAILS_SKIN);
			var bitmapData:BitmapData=new BitmapData(this.skin.width,this.skin.height,true, 0x000000);
			bitmapData.draw(this.skin);
			this.scale9skin=new BitmapScale9Grid(bitmapData,17,48,24,68);
			this.addChild(this.scale9skin);
		}
		
		public function start(playerArr:Vector.<Monster>,computerArr:Vector.<Monster>,map:MovieClip):void
		{
			this.playerArr=playerArr;
			this.computerArr=computerArr;
			this.map=map;
			this.thumbnailsWidth=this.map.width/this.map.height*THUMBNAILS_HEIGHT;
			this.scale9skin.width=thumbnailsWidth+OFFSET_X*2;
			this.canvas.x=OFFSET_X;
		}
		
		public function clear():void
		{
			this.canvas.graphics.clear();
			this.scale9skin.clear();
		}
		
		public function render():void
		{
			this.canvas.graphics.clear();
			
			for each(monster in this.playerArr)
			{
				this.canvas.graphics.beginFill(0x0f9f00,1);
				tx=monster.x/this.map.width*thumbnailsWidth;
				ty=monster.y/this.map.height*THUMBNAILS_HEIGHT;
				this.canvas.graphics.drawCircle(tx,ty,2);
				this.canvas.graphics.endFill();
			}
			
			for each (monster in this.computerArr)
			{
				if(monster is NormalMonster)
				{
					this.canvas.graphics.beginFill(0xff8400,1);
					tx=monster.x/this.map.width*thumbnailsWidth;
					ty=monster.y/this.map.height*THUMBNAILS_HEIGHT;
					this.canvas.graphics.drawCircle(tx,ty,2);
					this.canvas.graphics.endFill();
				}
				else if(monster is Creep)
				{
					this.canvas.graphics.beginFill(0x9ea8ab,1);
					tx=monster.x/this.map.width*thumbnailsWidth;
					ty=monster.y/this.map.height*THUMBNAILS_HEIGHT;
					this.canvas.graphics.drawCircle(tx,ty,2);
					this.canvas.graphics.endFill();
				}
				else
				{
					this.canvas.graphics.beginFill(0xff0000,1);
					tx=monster.x/this.map.width*thumbnailsWidth;
					ty=monster.y/this.map.height*THUMBNAILS_HEIGHT;
					this.canvas.graphics.drawCircle(tx,ty,4);
					this.canvas.graphics.endFill();
				}

			}
		}
	}
}