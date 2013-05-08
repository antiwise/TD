package net.shangle.pool
{
	import flash.utils.Dictionary;
	
	import net.shangle.display.Effect;
	import net.shangle.display.Monster;
	import net.shangle.display.Tower;
	
	
	
	public class EffectPool
	{
		
		private var allKinds:Dictionary;
		private var allInstance:Dictionary;
		private var spawned:Effect;
		private var reused:Boolean;
		private var instance:Effect;
		private static var instance:EffectPool;
		
		public static function getInstance():EffectPool
		{
			if(instance==null)
			{
				instance=new EffectPool();
			}
			return instance;
		}
		
		public function EffectPool()
		{
			allKinds = new Dictionary();
			allInstance = new Dictionary();
		}
		
		public function showInfo():void
		{
			var active:int;
			var num:int;
			var obj:Object
			var j:int;
			for each(obj in allInstance)
			{
				for(j=0;j<obj.length;j++)
				{
					num++;
					if(obj[j].active)
					{
						active++;
					}
				}
			}
			trace("魔法管理池总共资源:",num,"可用资源",num-active);
			
		}
		
		public function define(name:String,cloneSource:Effect):void
		{
			allKinds[name] = cloneSource;
		}	
		
		public function spawn(name:String,effectTarget:Monster,monsterArr:Vector.<Monster>,tower:Tower):Effect
		{
			spawned = null;
			reused = false;
			if (allKinds[name])
			{
				if (allInstance[name])
				{
					for each (instance in allInstance[name]) 
					{
						if (!instance.active)
						{
							instance.respawn(effectTarget,monsterArr,tower);
							spawned = instance;
							reused = true;
							//trace("特效:"+name+"在内存池中找到可利用对象,目前数量:"+allInstance[name].length);
							return spawned;
						}
					}
				}
				else
				{
					allInstance[name] = new Vector.<Effect>();
				}
				if (!reused)
				{
					spawned = allKinds[name].clone(allInstance[name].length);
					spawned.respawn(effectTarget,monsterArr,tower);
					allInstance[name].push(spawned);
					//trace("特效:"+name+"在内存池中无可利用对象,已重新生成,目前数量:"+allInstance[name].length);
					return spawned;
				}
			}
			else
			{
				trace("错误:没找到: " + name);
			}
			return spawned;
		}
	}
}