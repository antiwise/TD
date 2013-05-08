package net.shangle.display
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import net.shangle.event.BarrackEvent;
	import net.shangle.event.BarrackPointEvent;
	import net.shangle.event.CemeteryEvent;
	import net.shangle.event.CircleMenuEvent;
	import net.shangle.event.EffectEvent;
	import net.shangle.event.MonsterEvent;
	import net.shangle.event.TowerEvent;
	import net.shangle.event.TowerPointEvent;
	import net.shangle.info.ComputerBarrackAIInfo;
	import net.shangle.info.ComputerBossAIInfo;
	import net.shangle.info.ComputerCreepAIInfo;
	import net.shangle.info.ComputerInfo;
	import net.shangle.info.ComputerTowerAIInfo;
	import net.shangle.manager.GlobalFlashManager;
	import net.shangle.manager.GlobalInfoManager;
	import net.shangle.manager.GlobalTriggerManager;
	import net.shangle.pool.BarrackPool;
	import net.shangle.pool.EffectPool;
	import net.shangle.pool.MonsterPool;
	import net.shangle.pool.TowerPool;
	import net.shangle.uint.IAnimator;
	import net.shangle.util.ChapterMapAssetsClassName;
	import net.shangle.util.EnumCamp;
	import net.shangle.util.FlashAssetsFileName;
	import net.shangle.util.MonsterGridArr;
	import net.shangle.vo.BarrackPointVO;
	import net.shangle.vo.BarrackVO;
	import net.shangle.vo.ComputerBarrackAIVO;
	import net.shangle.vo.ComputerBossAIVO;
	import net.shangle.vo.ComputerCreepAIVO;
	import net.shangle.vo.ComputerTowerAIVO;
	import net.shangle.vo.EffectVO;
	import net.shangle.vo.LineVO;
	import net.shangle.vo.MonsterVO;
	import net.shangle.vo.TowerPointVO;
	import net.shangle.vo.TowerVO;
	
	public class GroundScene extends Sprite
	{
		public var playerMonsterArr : Vector.<Monster>;
		public var computerMonsterArr : Vector.<Monster>;
		private var monstertArr:Vector.<Monster>;
		private var depthRenderArr : Vector.<Sprite>;
		private var depthRenderScene : Sprite;
		private var barrackPointArr:Vector.<BarrackPoint>;
		private var towerPointArr:Vector.<TowerPoint>;
		private var barrackArr:Vector.<Barrack>;
		private var towerArr:Vector.<Tower>;
		private var depthSortTriggerID:int;
		private var effectScene:Sprite;
		private var effectArr:Vector.<Effect>;
		public var map:MovieClip;
		private var bossTriggerArr:Vector.<int>;
		private var cemeteryArr:Vector.<Cemetery>;
		private var computerMonsterGridArr:MonsterGridArr;
		private var playerMonsterGridArr:MonsterGridArr;
		
		
		
		
		
		
		
		
		//局部参数
		private var sprite:Sprite;
		private var depthSortI:int;
		private var depthSortLenth:int;
		private var iAnimator:IAnimator;
		private var barrack:Barrack;
		private var barrackVO:BarrackVO;
		private var barrackPoint:BarrackPoint;
		private var barrackPointVO:BarrackPointVO;
		private var monster:Monster;
		private var monsterVO:MonsterVO;
		private var tower:Tower;
		private var towerVO:TowerVO;
		private var towerPoint:TowerPoint;
		private var towerPointVO:TowerPointVO;
		private var effect:Effect;
		private var effectVO:EffectVO;
		private var lineVO:LineVO;
		private var lineID:int;
		private var cemetery:Cemetery;
		private var i:int;
		
		public function GroundScene()
		{
			super();
			initMap();
			initDepthRenderScene();
			initEffectScene();
		}
		
		private function initMap():void
		{
			map=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.CHAPTER_MAP,ChapterMapAssetsClassName.getClassName(GlobalInfoManager.getInstance.chapterInfo.currentChapter));
			this.addChild(map);
		}
		
		private function initDepthRenderScene():void
		{
			this.depthRenderScene=new Sprite();
			this.addChild(this.depthRenderScene);
		}
		
		private function initEffectScene():void
		{
			this.effectScene=new Sprite();
			this.effectScene.mouseChildren=false;
			this.effectScene.mouseEnabled=false;
			this.addChild(this.effectScene);
		}
		
		public function start():void
		{
			initArr();
			initPlayer();
			initComputer();
			depthSortTriggerID=GlobalTriggerManager.getInstance().addTrigger(0.5,depthSort);
		}
		
		private function initArr() : void
		{
			this.playerMonsterArr = new Vector.<Monster>();
			this.computerMonsterArr = new Vector.<Monster>();
			this.barrackArr=new Vector.<Barrack>();
			this.barrackPointArr=new Vector.<BarrackPoint>();
			this.towerArr=new Vector.<Tower>();
			this.towerPointArr=new Vector.<TowerPoint>();
			this.depthRenderArr=new Vector.<Sprite>();
			this.effectArr=new Vector.<Effect>();
			this.bossTriggerArr=new Vector.<int>();
			this.cemeteryArr=new Vector.<Cemetery>();
			this.monstertArr=new Vector.<Monster>();
			this.playerMonsterGridArr=new MonsterGridArr(this.map.width,this.map.height);
			this.computerMonsterGridArr=new MonsterGridArr(this.map.width,this.map.height);
		}
		
		private function initPlayer() : void
		{
//			var barrackPointVO : BarrackPointVO;
			var barrackPointVOArr : Vector.<BarrackPointVO> = GlobalInfoManager.getInstance.chapterInfo.barrackPointInfo.barrackPointVOArr;
			for each(barrackPointVO in barrackPointVOArr)
			{
				if(barrackPointVO.camp == EnumCamp.PLAYER)
				{
					loadBarrackPoint(barrackPointVO);
				}
			}
			
//			var towerPointVO : TowerPointVO;
			var towerPointVOArr : Vector.<TowerPointVO> = GlobalInfoManager.getInstance.chapterInfo.towerPointInfo.towerPointVOArr;
			for each(towerPointVO in towerPointVOArr)
			{
				if(towerPointVO.camp == EnumCamp.PLAYER)
				{
					loadTowerPoint(towerPointVO);
				}
			}
		}
		
		private function loadBarrackPoint(barrackPointVO:BarrackPointVO):void
		{
//			var barrackPoint : BarrackPoint;
			barrackPoint = new BarrackPoint(barrackPointVO);
			barrackPoint.x = barrackPointVO.x;
			barrackPoint.y = barrackPointVO.y;
			addBarrackPoint(barrackPoint);
		}
		
		private function loadTowerPoint(towerPointVO:TowerPointVO):void
		{
//			var towerPoint : TowerPoint;
			towerPoint = new TowerPoint(towerPointVO);
			towerPoint.x = towerPointVO.x;
			towerPoint.y = towerPointVO.y;
			addTowerPoint(towerPoint);
		}
		
//		private function onBarrackPointSkinLoadComlete(evt : SkinEvent) : void
//		{
//			var barrackPoint : BarrackPoint = evt.target as BarrackPoint;
//			barrackPoint.removeEventListener(SkinEvent.LOAD_COMPLETE , onBarrackPointSkinLoadComlete);
//			addBarrackPoint(barrackPoint);
//		}
		
		private function addBarrackPoint(barrackPoint : BarrackPoint) : void
		{
			barrackPoint.addEventListener(BarrackPointEvent.ADD_BARRACKS , onAddBarrack);
			barrackPoint.addEventListener(CircleMenuEvent.ADD_CIRCLE_MENU,onAddCircleMenu);
			barrackPoint.addEventListener(CircleMenuEvent.REMOVE_CIRCLE_MENU,onRemoveCircleMenu);
			this.barrackPointArr.push(barrackPoint);
			this.depthRenderArr.push(barrackPoint);
			this.depthRenderScene.addChild(barrackPoint);
		}
		
		private function addTowerPoint(towerPoint : TowerPoint) : void
		{
			towerPoint.addEventListener(TowerPointEvent.ADD_TOWER , onAddTower);
			towerPoint.addEventListener(CircleMenuEvent.ADD_CIRCLE_MENU,onAddCircleMenu);
			towerPoint.addEventListener(CircleMenuEvent.REMOVE_CIRCLE_MENU,onRemoveCircleMenu);
			this.towerPointArr.push(towerPoint);
			this.depthRenderArr.push(towerPoint);
			this.depthRenderScene.addChild(towerPoint);
		}
		
		private function onAddBarrack(evt : BarrackPointEvent) : void
		{
			barrackPoint=evt.target as BarrackPoint;
			barrack=BarrackPool.getInstance().spawn(evt.barrackResID.toString(),barrackPoint.vo.id);
			barrack.resetBuildTime(barrack.vo.buildTime);
			GlobalInfoManager.getInstance.money -= barrack.vo.money;
			barrack.x=barrackPoint.x;
			barrack.y=barrackPoint.y;
			removeBarrackPoint(barrackPoint);
			addBarrack(barrack);
		}
		
		private function onAddTower(evt:TowerPointEvent):void
		{
			towerPoint=evt.target as TowerPoint;
			towerVO=GlobalInfoManager.getInstance.towerInfo.getTowerVO(evt.towerResID);
			tower=TowerPool.getInstance().spawn(evt.towerResID.toString(),towerPoint.vo.id,getMonsterArr(towerVO.effectCamp));
			tower.resetBuildTime(tower.vo.buildTime);
			GlobalInfoManager.getInstance.money -= tower.vo.money;
			tower.x=towerPoint.x;
			tower.y=towerPoint.y;
			removeTowerPoint(towerPoint);
			addTower(tower);
		}
		
		private function removeTowerPoint(towerPoint : TowerPoint) : void
		{
			towerPoint.removeEventListener(TowerPointEvent.ADD_TOWER , onAddTower);
			towerPoint.removeEventListener(CircleMenuEvent.ADD_CIRCLE_MENU,onAddCircleMenu);
			
			towerPoint.clear();
			towerPoint.removeEventListener(CircleMenuEvent.REMOVE_CIRCLE_MENU,onRemoveCircleMenu);
			this.towerPointArr.splice(this.towerPointArr.indexOf(towerPoint),1);
			this.depthRenderArr.splice(this.depthRenderArr.indexOf(towerPoint) , 1);
			this.depthRenderScene.removeChild(towerPoint);

		}
		
		private function removeBarrackPoint(barrackPoint : BarrackPoint) : void
		{
			barrackPoint.removeEventListener(BarrackPointEvent.ADD_BARRACKS , onAddBarrack);
			barrackPoint.removeEventListener(CircleMenuEvent.ADD_CIRCLE_MENU,onAddCircleMenu);
			
			barrackPoint.clear();
			barrackPoint.removeEventListener(CircleMenuEvent.REMOVE_CIRCLE_MENU,onRemoveCircleMenu);
			this.barrackPointArr.splice(this.barrackPointArr.indexOf(barrackPoint),1);
			this.depthRenderArr.splice(this.depthRenderArr.indexOf(barrackPoint) , 1);
			this.depthRenderScene.removeChild(barrackPoint);

		}
		
		private function onAddCircleMenu(evt:CircleMenuEvent):void
		{
			this.addChild(evt.circleMenu);
		}
		
		private function onRemoveCircleMenu(evt:CircleMenuEvent):void
		{
			this.removeChild(evt.circleMenu);
		}
		
//		private function loadBarrack(barrackVO : BarrackVO , x : int , y : int , barrackPointID:int ,buildTime:int) : void
//		{
//			var barrack : Barrack;
//			barrack = new Barrack(barrackVO , barrackPointID ,buildTime);
//			barrack.x = x;
//			barrack.y = y;
//			barrack.addEventListener(SkinEvent.LOAD_COMPLETE , onBarrackSkinLoadComplete);
//			barrack.loadSkin();
//			barrack = null;
//		}
		
//		private function onBarrackSkinLoadComplete(evt : SkinEvent) : void
//		{
//			var barrack : Barrack = evt.target as Barrack;
//			barrack.removeEventListener(SkinEvent.LOAD_COMPLETE , onBarrackSkinLoadComplete);
//			addBarrack(barrack);
//		}
		
		private function addBarrack(barrack : Barrack) : void
		{
			barrack.addEventListener(BarrackEvent.ADD_MONSTER , onAddNormalMonster);
			barrack.addEventListener(BarrackEvent.SELL , onRemoveBarrack);
			barrack.addEventListener(CircleMenuEvent.ADD_CIRCLE_MENU,onAddCircleMenu);
			barrack.addEventListener(CircleMenuEvent.REMOVE_CIRCLE_MENU,onRemoveCircleMenu);
			this.barrackArr.push(barrack);
			this.depthRenderScene.addChild(barrack);
			this.depthRenderArr.push(barrack);
		}
		
		
		private function addTower(tower:Tower):void
		{
			tower.addEventListener(TowerEvent.ADD_EFFECT , onAddEffect);
			tower.addEventListener(TowerEvent.SELL , onRemoveTower);
			tower.addEventListener(CircleMenuEvent.ADD_CIRCLE_MENU,onAddCircleMenu);
			tower.addEventListener(CircleMenuEvent.REMOVE_CIRCLE_MENU,onRemoveCircleMenu);
			this.towerArr.push(tower);
			this.depthRenderScene.addChild(tower);
			this.depthRenderArr.push(tower);
		}
		
		private function onRemoveBarrack(evt : BarrackEvent) : void
		{
			barrack = evt.target as Barrack;
			removeBarrack(barrack);
			GlobalInfoManager.getInstance.money+=barrack.vo.money/2;
			barrackPointVO=GlobalInfoManager.getInstance.chapterInfo.barrackPointInfo.getBarrackPointVO(evt.barrackPointID);
			loadBarrackPoint(barrackPointVO);
		}
		
		private function onRemoveTower(evt : TowerEvent) : void
		{
			tower = evt.target as Tower;
			removeTower(tower);
			GlobalInfoManager.getInstance.money+=tower.vo.money/2;
			towerPointVO=GlobalInfoManager.getInstance.chapterInfo.towerPointInfo.getTowerPointVO(evt.towerPointID);
			loadTowerPoint(towerPointVO);
		}
		
		private function removeBarrack(barrack:Barrack):void
		{
			barrack.removeEventListener(BarrackEvent.ADD_MONSTER , onAddNormalMonster);
			barrack.removeEventListener(BarrackEvent.SELL , onRemoveBarrack);
			barrack.removeEventListener(CircleMenuEvent.ADD_CIRCLE_MENU,onAddCircleMenu);
			
			barrack.clear();
			barrack.removeEventListener(CircleMenuEvent.REMOVE_CIRCLE_MENU,onRemoveCircleMenu);
			this.barrackArr.splice(this.barrackArr.indexOf(barrack),1);
			this.depthRenderArr.splice(this.depthRenderArr.indexOf(barrack),1);
			this.depthRenderScene.removeChild(barrack);

		}
		
		private function removeTower(tower:Tower):void
		{
			tower.removeEventListener(TowerEvent.ADD_EFFECT , onAddEffect);
			tower.removeEventListener(TowerEvent.SELL , onRemoveTower);
			tower.removeEventListener(CircleMenuEvent.ADD_CIRCLE_MENU,onAddCircleMenu);
			tower.clear();
			tower.removeEventListener(CircleMenuEvent.REMOVE_CIRCLE_MENU,onRemoveCircleMenu);
			this.towerArr.splice(this.towerArr.indexOf(tower),1);
			this.depthRenderArr.splice(this.depthRenderArr.indexOf(tower),1);
			this.depthRenderScene.removeChild(tower);

		}
		
		private function removeEffect(effect:Effect):void
		{
			effect.removeEventListener(EffectEvent.EFFECT_COMPLETE,onEffectComplete);
			effect.clear();
			this.effectArr.splice(this.effectArr.indexOf(effect),1);
			this.effectScene.removeChild(effect);

		}
		
		private function removeCemetery(cemetery:Cemetery):void
		{
			cemetery.removeEventListener(CemeteryEvent.ADD_MONSTER,onAddCreep);
			cemetery.clear();
			this.cemeteryArr.splice(this.cemeteryArr.indexOf(cemetery),1);
		}
		
		private function onAddEffect(evt:TowerEvent):void
		{
			tower=evt.target as Tower;
			effect=EffectPool.getInstance().spawn(tower.vo.effectResID.toString(),evt.effectTarget,getMonsterArr(tower.vo.effectCamp),tower);
			addEffect(effect);
		}
		

		
		private function onAddNormalMonster(evt : BarrackEvent) : void
		{
			barrack=evt.target as Barrack;
			barrackPointVO=GlobalInfoManager.getInstance.chapterInfo.barrackPointInfo.getBarrackPointVO(evt.barrackPointID);
			lineID=barrackPointVO.lineIDArr[Math.round(Math.random() * (barrackPointVO.lineIDArr.length - 1))];
			lineVO = GlobalInfoManager.getInstance.chapterInfo.lineInfo.getLineVO(lineID , barrackPointVO.camp);
			monster=MonsterPool.getInstance().spawn(barrack.vo.monsterResID.toString(),lineVO,getEnemyMonsterGridArr(barrackPointVO.camp));
			monster.x = lineVO.line[0].x;
			monster.y = lineVO.line[0].y;
			monster.addEventListener(MonsterEvent.REACH_THE_END , onMonsterReachTheEnd);
			monster.addEventListener(MonsterEvent.DYING , onMonsterDying);
			addMonster(monster);
		}
		
		
		private function addMonster(monster:Monster) : void
		{
			getMonsterArr(monster.vo.camp).push(monster);
			getMonsterGridArr(monster.vo.camp).updateGridPoint(monster);
			getMonsterGridArr(monster.vo.camp).addMonster(monster);
			monstertArr.push(monster);
			this.depthRenderScene.addChild(monster);
			this.depthRenderArr.push(monster);
		}
		
		private function addEffect(effect:Effect):void
		{
			effect.addEventListener(EffectEvent.EFFECT_COMPLETE,onEffectComplete);
			this.effectScene.addChild(effect);
			this.effectArr.push(effect);
		}
		
		private function onEffectComplete(evt:EffectEvent):void
		{
			removeEffect(evt.target as Effect);
		}
		
		private function onMonsterDying(evt : MonsterEvent) : void
		{
			monster = evt.target as Monster;
			if(monster.vo.camp == EnumCamp.COMPUTER)
			{
				GlobalInfoManager.getInstance.money += monster.vo.money;
			}
			monster.addEventListener(MonsterEvent.DIE , onMonsterDie);
			removeMonsterFromMonsterArr(monster);
		}
		
		private function onMonsterDie(evt :MonsterEvent) : void
		{
			monster = evt.target as Monster;
			monster.removeEventListener(MonsterEvent.DIE , onMonsterDie);
			removeMonsterFromStage(evt.target as Monster);
			monster.clear();
		}
		
		private function removeMonsterFromMonsterArr(monster : Monster) : void
		{
			getMonsterGridArr(monster.vo.camp).removeMonster(monster);
			getMonsterArr(monster.vo.camp).splice(getMonsterArr(monster.vo.camp).indexOf(monster),1);
			monster.removeEventListener(MonsterEvent.REACH_THE_END , onMonsterReachTheEnd);
			monster.removeEventListener(MonsterEvent.DYING , onMonsterDying);
		}
		
		private function removeMonsterFromStage(monster : Monster) : void
		{
			this.depthRenderScene.removeChild(monster);
			this.depthRenderArr.splice(depthRenderArr.indexOf(monster) , 1);
			this.monstertArr.splice(monstertArr.indexOf(monster),1);
		}
		
		private function onMonsterReachTheEnd(evt : MonsterEvent) : void
		{
			monster = evt.target as Monster;
			if(monster.vo.camp==EnumCamp.COMPUTER)
			{
				if((GlobalInfoManager.getInstance.playerCastleBlood-monster.vo.destoryCastleBlood)>=0)
				{
					GlobalInfoManager.getInstance.playerCastleBlood-=monster.vo.destoryCastleBlood;
				}
				else
				{
					GlobalInfoManager.getInstance.playerCastleBlood=0
				}
			}else
			{
				if((GlobalInfoManager.getInstance.computerCastleBlood-monster.vo.destoryCastleBlood)>=0)
				{
					GlobalInfoManager.getInstance.computerCastleBlood-=monster.vo.destoryCastleBlood;
				}
				else
				{
					GlobalInfoManager.getInstance.computerCastleBlood=0
				}
			}
			removeMonsterFromMonsterArr(monster);
			removeMonsterFromStage(monster);
			monster.clear();
		}
		
		private function initComputer() : void
		{
			var computerBarrackAIVO : ComputerBarrackAIVO;
			var barrackPointVO : BarrackPointVO;
			var computerBarrackAIInfo:ComputerBarrackAIInfo=GlobalInfoManager.getInstance.chapterInfo.computerInfo.computerBarrackAIInfo;
			if(computerBarrackAIInfo)
			{
				var computerBarrackAIVOArr : Vector.<ComputerBarrackAIVO> = computerBarrackAIInfo.computerBarrackAIVOArr;
				for each(computerBarrackAIVO in computerBarrackAIVOArr)
				{
					barrackPointVO = GlobalInfoManager.getInstance.chapterInfo.barrackPointInfo.getBarrackPointVO(computerBarrackAIVO.barrackPointID);
					var barrack:Barrack=BarrackPool.getInstance().spawn(computerBarrackAIVO.barrackResID.toString(),barrackPointVO.id);
					barrack.x=barrackPointVO.x;
					barrack.y=barrackPointVO.y;
					barrack.resetBuildTime(computerBarrackAIVO.buildTime);
					addBarrack(barrack);
				}
			}

			
			var computerTowerAIVO : ComputerTowerAIVO;
			var towerPointVO :TowerPointVO;
			var towerVO : TowerVO;
			var computerTowerAIInfo:ComputerTowerAIInfo=GlobalInfoManager.getInstance.chapterInfo.computerInfo.computerTowerAIInfo;
			if(computerTowerAIInfo)
			{
				var computerTowerAIVOArr : Vector.<ComputerTowerAIVO> = computerTowerAIInfo.computerTowerAIVOArr;
				for each(computerTowerAIVO in computerTowerAIVOArr)
				{
					towerPointVO = GlobalInfoManager.getInstance.chapterInfo.towerPointInfo.getTowerPointVO(computerTowerAIVO.towerPointID);
					towerVO=GlobalInfoManager.getInstance.towerInfo.getTowerVO(computerTowerAIVO.towerResID);
					var tower:Tower=TowerPool.getInstance().spawn(computerTowerAIVO.towerResID.toString(),towerPointVO.id,getMonsterArr(towerVO.effectCamp));
					tower.x=towerPointVO.x;
					tower.y=towerPointVO.y;
					tower.resetBuildTime(computerTowerAIVO.buildTime);
					addTower(tower);
				}
				
			}
			
			var computerBossAIVO:ComputerBossAIVO;
			var computerBossAIInfo:ComputerBossAIInfo=GlobalInfoManager.getInstance.chapterInfo.computerInfo.computerBossAIInfo;
			if(computerBossAIInfo)
			{
				var computerBossAIVOArr:Vector.<ComputerBossAIVO>=computerBossAIInfo.computerBossAIVOArr;
				for each(computerBossAIVO in computerBossAIVOArr)
				{
					this.bossTriggerArr.push(GlobalTriggerManager.getInstance().addTrigger(computerBossAIVO.showTime,onAddBoss,[computerBossAIVO.monsterResID,computerBossAIVO.lineID,GlobalTriggerManager.getInstance().triggerNum]));
				}
			}
			
			var computerCreepAIVO:ComputerCreepAIVO;
			var computerCreepAIInfo:ComputerCreepAIInfo=GlobalInfoManager.getInstance.chapterInfo.computerInfo.computerCreepAIInfo;
			if(computerCreepAIInfo)
			{
				var computerCreepAIVOArr:Vector.<ComputerCreepAIVO>=computerCreepAIInfo.computerCreepAIVOArr;
				var cemetery:Cemetery;
				for each(computerCreepAIVO in computerCreepAIVOArr)
				{
					cemetery=new Cemetery(computerCreepAIVO);
					cemetery.addEventListener(CemeteryEvent.ADD_MONSTER,onAddCreep);
					this.cemeteryArr.push(cemetery);
				}
			}
		}
		
		private function onAddCreep(evt:CemeteryEvent):void
		{
			lineVO=GlobalInfoManager.getInstance.chapterInfo.lineInfo.getLineVO(evt.lineID,EnumCamp.COMPUTER);
			monster=MonsterPool.getInstance().spawn(evt.monsterResID.toString(),lineVO,getEnemyMonsterGridArr(EnumCamp.COMPUTER));
			monster.x = lineVO.line[0].x;
			monster.y = lineVO.line[0].y;
			monster.addEventListener(MonsterEvent.REACH_THE_END , onMonsterReachTheEnd);
			monster.addEventListener(MonsterEvent.DYING , onMonsterDying);
			addMonster(monster);
		}
		
		private function onAddBoss(monsterResID:int,lineID:int,triggerID:int):void
		{
			GlobalTriggerManager.getInstance().removeTrigger(triggerID);
			this.bossTriggerArr.splice(this.bossTriggerArr.indexOf(triggerID),1);
			lineVO=GlobalInfoManager.getInstance.chapterInfo.lineInfo.getLineVO(lineID,EnumCamp.COMPUTER);
			monster=MonsterPool.getInstance().spawn(monsterResID.toString(),lineVO,getEnemyMonsterGridArr(EnumCamp.COMPUTER));
			monster.x = lineVO.line[0].x;
			monster.y = lineVO.line[0].y;
			monster.addEventListener(MonsterEvent.REACH_THE_END , onMonsterReachTheEnd);
			monster.addEventListener(MonsterEvent.DYING , onMonsterDying);
			addMonster(monster);
		}
		
		public function resume():void
		{
			for each(tower in this.towerArr)
			{
				tower.resume();
			}
		}
		
		public function pause():void
		{
			for each(tower in this.towerArr)
			{
				tower.pause();
			}
		}
		
		public function render():void
		{
			for each(iAnimator in this.towerArr)
			{
				iAnimator.render();
			}
			for each(iAnimator in this.monstertArr)
			{
				iAnimator.render();
			}
			for each(iAnimator in this.effectArr)
			{
				iAnimator.render();
			}
			for each(monster in this.playerMonsterArr)
			{
				this.playerMonsterGridArr.update(monster);
			}
			for each(monster in this.computerMonsterArr)
			{
				this.computerMonsterGridArr.update(monster);
			}
			if(CastleFight.IS_DEBUG)
			{
				i++;
				if(i==24*5)
				{
					i=0;
					trace("-----------------");
					trace("敌军数量:",this.computerMonsterArr.length);
					trace("友军数量:",this.playerMonsterArr.length);
					trace("怪物总数量:",this.monstertArr.length);
					trace("兵营点数量:",this.barrackPointArr.length);
					trace("防御塔点数量:",this.towerPointArr.length);
					trace("兵营数量:",this.barrackArr.length);
					trace("防御塔数量:",this.towerArr.length);
					trace("魔法数量:",this.effectArr.length);
					trace("墓地数量:",this.cemeteryArr.length);
					trace("深度排序数组:",this.depthRenderArr.length);
					trace("深度排序场景:",this.depthRenderScene.numChildren);
					trace("魔法场景:",this.effectScene.numChildren);
					trace("友军怪物网格数组:",this.playerMonsterGridArr.length);
					trace("敌军怪物网格数组:",this.computerMonsterGridArr.length);
					TowerPool.getInstance().showInfo();
					EffectPool.getInstance().showInfo();
					BarrackPool.getInstance().showInfo();
					MonsterPool.getInstance().showInfo();
				}
			}
		}
		
		private function depthSort() : void
		{
			this.depthRenderArr.sort(depthSortFunction);
			depthSortLenth = this.depthRenderArr.length;
			for(depthSortI = 0 ; depthSortI < depthSortLenth ; depthSortI++)
			{
				sprite = this.depthRenderArr[depthSortI];
				if(this.depthRenderScene.getChildAt(depthSortI) != sprite)
				{
					this.depthRenderScene.setChildIndex(sprite , depthSortI);
				}
			}
		}
		
		private function depthSortFunction(s1 : Sprite , s2 : Sprite) : int
		{
			if(s1.y < s2.y)
				return -1;
			else if(s1.y > s2.y)
				return 1;
			else
				return 0;
		}
		
		private function getEnemyMonsterArr(camp:int):Vector.<Monster>
		{
			if(camp==EnumCamp.COMPUTER)
			{
				return this.playerMonsterArr;
			}
			else
			{
				return this.computerMonsterArr;
			}
		}
		
		private function getEnemyMonsterGridArr(camp:int):MonsterGridArr
		{
			if(camp==EnumCamp.COMPUTER)
			{
				return this.playerMonsterGridArr;
			}
			else
			{
				return this.computerMonsterGridArr;
			}
		}
		
		private function getMonsterArr(camp:int):Vector.<Monster>
		{
			if(camp==EnumCamp.PLAYER)
			{
				return this.playerMonsterArr;
			}
			else
			{
				return this.computerMonsterArr;
			}
		}
		
		private function getMonsterGridArr(camp:int):MonsterGridArr
		{
			if(camp==EnumCamp.PLAYER)
			{
				return this.playerMonsterGridArr;
			}
			else
			{
				return this.computerMonsterGridArr;
			}
		}
		
		public function clear():void
		{
			//var monster:Monster
			while(this.monstertArr.length>0)
			{
				monster=this.monstertArr[0];
				removeMonsterFromMonsterArr(monster);
				removeMonsterFromStage(monster);
				monster.clear();
			}
		//	var barrackPoint:BarrackPoint;
			while(this.barrackPointArr.length>0)
			{
				barrackPoint=this.barrackPointArr[0];
				removeBarrackPoint(barrackPoint);
			}
			//var towerPoint:TowerPoint;
			while(this.towerPointArr.length>0)
			{
				towerPoint=this.towerPointArr[0];
				removeTowerPoint(towerPoint);
			}
		//	var barrack:Barrack;
			while(this.barrackArr.length>0)
			{
				barrack=this.barrackArr[0];
				removeBarrack(barrack);
			}
			//var tower:Tower;
			while(this.towerArr.length>0)
			{
				tower=this.towerArr[0];
				removeTower(tower);
			}
			//var effect:Effect;
			while(this.effectArr.length>0)
			{
				effect=this.effectArr[0];
				removeEffect(effect);
			}
			//var cemetery:Cemetery;
			while(this.cemeteryArr.length>0)
			{
				cemetery=this.cemeteryArr[0];
				removeCemetery(cemetery);
			}
			GlobalTriggerManager.getInstance().removeTrigger(depthSortTriggerID);
		//	var id:int;
			while(this.bossTriggerArr.length>0)
			{
				GlobalTriggerManager.getInstance().removeTrigger(this.bossTriggerArr.shift());
			}
			
			if(CastleFight.IS_DEBUG)
			{
				trace("敌军数量:",this.computerMonsterArr.length);
				trace("友军数量:",this.playerMonsterArr.length);
				trace("怪物总数量:",this.monstertArr.length);
				trace("兵营点数量:",this.barrackPointArr.length);
				trace("防御塔点数量:",this.towerPointArr.length);
				trace("兵营数量:",this.barrackArr.length);
				trace("防御塔数量:",this.towerArr.length);
				trace("魔法数量:",this.effectArr.length);
				trace("墓地数量:",this.cemeteryArr.length);
				trace("深度排序数组:",this.depthRenderArr.length);
				trace("深度排序场景:",this.depthRenderScene.numChildren);
				trace("魔法场景:",this.effectScene.numChildren);
				trace("友军怪物网格数组:",this.playerMonsterGridArr.length);
				trace("敌军怪物网格数组:",this.computerMonsterGridArr.length);
			}
		}
	}
}