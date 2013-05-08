package net.shangle.display
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import net.shangle.uint.IAnimator;
	import net.shangle.vo.EffectVO;
	
	public class Effect extends Sprite implements IAnimator
	{
		
		public var vo:EffectVO;
		private var _active:Boolean;
		protected var skin:BitmapMovieClip;
		protected var instanceID:int;
		protected var monsterArr:Vector.<Monster>;
		protected var effectTarget:Monster;
		protected var tower:Tower;
		
		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function set active(value:Boolean):void
		{
			_active=value;
		}
		
		public function Effect(vo:EffectVO,instanceID:int)
		{
			
			this.vo=vo;
			this.instanceID=instanceID;
			this.mouseChildren=false;
			this.mouseEnabled=false;
			loadSkin();
		}
		
		private function loadSkin():void
		{
			this.skin=new BitmapMovieClip(this.vo.bitmapMCFrameInfoArr);
			this.addChild(this.skin);
		}
		
		public function respawn(attackTarget:Monster,enemyArr:Vector.<Monster>,tower:Tower):void
		{
			
		}
		
		public function render():void
		{
		
		}
		
		public function resume():void
		{
//			this.skin.play();
		}
		
		public function pause():void
		{
//			this.skin.stop();
		}
		
		
		public function clone(instanceID:int):Effect
		{
			return null;
		}
		
		public function clear():void
		{
		
		}
	}
}