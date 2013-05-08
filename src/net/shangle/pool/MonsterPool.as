package net.shangle.pool
{
	import flash.utils.Dictionary;
	
	import net.shangle.display.Monster;
	import net.shangle.util.MonsterGridArr;
	import net.shangle.vo.LineVO;

	public class MonsterPool
	{
		
		private var allKinds:Dictionary;
		private var allInstance:Dictionary;
		private var spawned:Monster;
		private var reused:Boolean;
		private var instance:Monster;
		private static var instance:MonsterPool;
		
		public static function getInstance():MonsterPool
		{
			if(instance==null)
			{
				instance=new MonsterPool();
			}
			return instance;
		}
		
		public function MonsterPool()
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
			trace("怪物管理池总共资源:",num,"可用资源",num-active);
			
		}
		
		public function define(name:String,cloneSource:Monster):void
		{
			allKinds[name] = cloneSource;
		}	
		
		public function spawn(name:String,lineVO:LineVO,enemyGridArr:MonsterGridArr):Monster
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
							instance.respawn(lineVO,enemyGridArr);
							spawned = instance;
							reused = true;
							//trace("怪兽:"+name+"在内存池中找到可利用对象,目前数量:"+allInstance[name].length);
							return spawned;
						}
					}
				}
				else
				{
					allInstance[name] = new Vector.<Monster>();
				}
				if (!reused)
				{
					spawned = allKinds[name].clone(allInstance[name].length);
					spawned.respawn(lineVO,enemyGridArr);
					allInstance[name].push(spawned);
					//trace("怪兽:"+name+"在内存池中无可利用对象,已重新生成,目前数量:"+allInstance[name].length);
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