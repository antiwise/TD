package net.shangle.pool
{
	import flash.utils.Dictionary;
	
	import net.shangle.display.Barrack;
	
	public class BarrackPool
	{
		
		private var allKinds:Dictionary;
		private var allInstance:Dictionary;
		private var spawned:Barrack;
		private var reused:Boolean;
		private var instance:Barrack;
		private static var instance:BarrackPool;
		
		public static function getInstance():BarrackPool
		{
			if(instance==null)
			{
				instance=new BarrackPool();
			}
			return instance;
		}
		
		public function BarrackPool()
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
			trace("兵营管理池总共资源:",num,"可用资源",num-active);
			
		}
		
		public function define(name:String,cloneSource:Barrack):void
		{
			allKinds[name] = cloneSource;
		}	
		
		public function spawn(name:String,barrackPointID : int):Barrack
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
							instance.respawn(barrackPointID);
							spawned = instance;
							reused = true;
							//trace("兵营:"+name+"在内存池中找到可利用对象,目前数量:"+allInstance[name].length);
							return spawned;
						}
					}
				}
				else
				{
					allInstance[name] = new Vector.<Barrack>();
				}
				if (!reused)
				{
					spawned = allKinds[name].clone(allInstance[name].length);
					spawned.respawn(barrackPointID);
					allInstance[name].push(spawned);
					//trace("兵营:"+name+"在内存池中无可利用对象,已重新生成,目前数量:"+allInstance[name].length);
					return spawned;
				}
			}
			else
			{
				trace("----错误----:没找到: " + name);
			}
			return spawned;
		}
	}
}