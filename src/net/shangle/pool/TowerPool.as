package net.shangle.pool
{
	import flash.utils.Dictionary;
	
	import net.shangle.display.Monster;
	import net.shangle.display.Tower;
	
	
	public class TowerPool
	{
		
		private var allKinds:Dictionary;
		private var allInstance:Dictionary;
		private var spawned:Tower;
		private var reused:Boolean;
		private var instance:Tower;
		private static var instance:TowerPool;
		
		public static function getInstance():TowerPool
		{
			if(instance==null)
			{
				instance=new TowerPool();
			}
			return instance;
		}
		
		public function TowerPool()
		{
			allKinds = new Dictionary();
			allInstance = new Dictionary();
		}
		
		public function define(name:String,cloneSource:Tower):void
		{
			allKinds[name] = cloneSource;
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
			trace("防御塔管理池总共资源:",num,"可用资源",num-active);
			
		}
		
		public function spawn(name:String,towerPointID : int,monsterArr:Vector.<Monster>):Tower
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
							instance.respawn(towerPointID,monsterArr);
							spawned = instance;
							reused = true;
							//trace("防御塔:"+name+"在内存池中找到可利用对象,目前数量:"+allInstance[name].length);
							return spawned;
						}
					}
				}
				else
				{
					allInstance[name] = new Vector.<Tower>();
				}
				if (!reused)
				{
					spawned = allKinds[name].clone(allInstance[name].length);
					spawned.respawn(towerPointID,monsterArr);
					allInstance[name].push(spawned);
					//trace("防御塔:"+name+"在内存池中无可利用对象,已重新生成,目前数量:"+allInstance[name].length);
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