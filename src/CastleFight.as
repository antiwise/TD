package
{
	import deng.fzip.FZip;
	import deng.fzip.FZipEvent;
	import deng.fzip.FZipFile;
	import deng.fzip.FZipLibrary;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import net.hires.debug.Stats;
	import net.shangle.display.Barrack;
	import net.shangle.display.ChapterFlag;
	import net.shangle.display.Game;
	import net.shangle.display.Monster;
	import net.shangle.display.Tower;
	import net.shangle.event.ChapterFlagEvent;
	import net.shangle.event.GameEvent;
	import net.shangle.event.GameProgressEvent;
	import net.shangle.event.WorldMapEvent;
	import net.shangle.manager.GlobalFlashManager;
	import net.shangle.manager.GlobalInfoManager;
	import net.shangle.manager.GlobalSoundManager;
	import net.shangle.pool.BarrackPool;
	import net.shangle.pool.BitmapMCFrameInfoPool;
	import net.shangle.pool.EffectPool;
	import net.shangle.pool.MonsterPool;
	import net.shangle.pool.TowerPool;
	import net.shangle.uint.PlayerRecord;
	import net.shangle.util.ChapterFlagFrameLabel;
	import net.shangle.util.ClockUtil;
	import net.shangle.util.EffectFactory;
	import net.shangle.util.EnumCamp;
	import net.shangle.util.FlashAssetsFileName;
	import net.shangle.util.MonsterFactory;
	import net.shangle.util.MovieClipCacheUtil;
	import net.shangle.util.PopUpManager;
	import net.shangle.util.SoundAssetsClassName;
	import net.shangle.util.SoundAssetsFileName;
	import net.shangle.util.WorldMapFrameLabel;
	import net.shangle.vo.BarrackPointVO;
	import net.shangle.vo.BarrackVO;
	import net.shangle.vo.ChapterFlagVO;
	import net.shangle.vo.ComputerBarrackAIVO;
	import net.shangle.vo.ComputerBossAIVO;
	import net.shangle.vo.ComputerCreepAIVO;
	import net.shangle.vo.ComputerTowerAIVO;
	import net.shangle.vo.EffectVO;
	import net.shangle.vo.LineVO;
	import net.shangle.vo.MonsterVO;
	import net.shangle.vo.PlayerBarrackLimitVO;
	import net.shangle.vo.PlayerScoreVO;
	import net.shangle.vo.PlayerTowerLimitVO;
	import net.shangle.vo.TowerPointVO;
	import net.shangle.vo.TowerVO;

	
	/**
	 * This is a graduate design project of confrontational tower defense game by Shangle.
	 * This game is not used for any commercial purposes.
	 * For private study and reference only.
	 * All assets in the game come from the internet.
	 * I retain only the code for copyright.
	 * Thanks all my friends who always supports me.
	 * 
	 * 
	 * Shangle
	 * http://shangle.net
	 * 2012/04/23
	 */ 
	[SWF(width = "700" , height = "600" , backgroundColor = "0x000000")]
	public class CastleFight extends Sprite
	{
		private var worldMap:MovieClip;
		private var chapterFlagScene:Sprite;
		private var menuScene:Sprite;
		private var game:Game;
		private var playerRecordSO:SharedObject;
		private var configZip:FZip;
		private var soundLib:FZipLibrary;
		private var soundZip:FZip;
		private var flashZip:FZip;
		private var flashLib:FZipLibrary;
		private var chapterFlagArr:Vector.<ChapterFlag>;
		private var stats:Stats;
		private var uiSkin:MovieClip;
		private var achievementPanel:MovieClip;
		
		public static const IS_DEBUG:Boolean=false;
//		private var playerRecord:PlayerRecordInfo;
		public function CastleFight()
		{
			loadFlash();
		}
		
		private function loadConfig():void
		{
			this.configZip=new FZip();
			this.configZip.addEventListener(Event.COMPLETE,onConfigLoadComplete);
			this.configZip.addEventListener(ProgressEvent.PROGRESS,onLoadConfig);
			this.configZip.load(new URLRequest("config/config.zip"));
		}
		
		private function onLoadConfig(evt:ProgressEvent):void
		{
			this.dispatchEvent(new GameProgressEvent(GameProgressEvent.LOAD_CONFIG,false,false,evt.bytesLoaded,evt.bytesTotal));
		}
		
		private function onConfigLoadComplete(evt:Event):void
		{
			this.dispatchEvent(new GameProgressEvent(GameProgressEvent.LOAD_CONFIG_COMPLETE));
			this.configZip.removeEventListener(ProgressEvent.PROGRESS,onLoadConfig);
			this.configZip.removeEventListener(Event.COMPLETE,onConfigLoadComplete);
			var file:FZipFile;
			file=this.configZip.getFileByName("common/barrackConfig.xml");
			barrackConfigHandler(new XML(file.content));
			file=this.configZip.getFileByName("common/monsterConfig.xml");
			monsterConfigHandler(new XML(file.content));
			file=this.configZip.getFileByName("common/chapterFlagConfig.xml");
			chapterFlagConfigHanler(new XML(file.content));
			file=this.configZip.getFileByName("common/towerConfig.xml");
			towerConfigHandler(new XML(file.content));
			file=this.configZip.getFileByName("common/effectConfig.xml");
			effectConfigHandler(new XML(file.content));
			var length:int=GlobalInfoManager.getInstance.chapterFlagInfo.chapterFlagVOArr.length;
			var i:int;
			for(i=1;i<=length;i++)
			{
				GlobalInfoManager.getInstance.chapterInfo.addChapter(i);
				file=this.configZip.getFileByName("chapter"+i+"/barrackPointConfig.xml");
				barrackPointConfigHandler(new XML(file.content));
				file=this.configZip.getFileByName("chapter"+i+"/towerPointConfig.xml");
				towerPointConfigHandler(new XML(file.content));
				file=this.configZip.getFileByName("chapter"+i+"/computerConfig.xml");
				computerConfigHandler(new XML(file.content));
				file=this.configZip.getFileByName("chapter"+i+"/lineConfig.xml");
				lineConfigHandler(new XML(file.content));
				file=this.configZip.getFileByName("chapter"+i+"/playerConfig.xml");
				playerConfigHandler(new XML(file.content));
			}
			init();
		}
		
		private function loadFlash():void
		{
			this.flashZip=new FZip();
			this.flashZip.addEventListener(ProgressEvent.PROGRESS,onLoadFlash);
			this.flashLib=new FZipLibrary();
			this.flashLib.formatAsDisplayObject(".swf");
			this.flashLib.addEventListener(Event.COMPLETE,onFlashLoadComplete);
			this.flashZip.load(new URLRequest("assets/flash.zip"));
			this.flashLib.addZip(this.flashZip);
		}
		
		private function onLoadFlash(evt:ProgressEvent):void
		{
			this.dispatchEvent(new GameProgressEvent(GameProgressEvent.LOAD_FLASH,false,false,evt.bytesLoaded,evt.bytesTotal));
			
		}
		
		private function onFlashLoadComplete(evt:Event):void
		{
			this.dispatchEvent(new GameProgressEvent(GameProgressEvent.LOAD_FLASH_COMPLETE));
			this.flashZip.removeEventListener(ProgressEvent.PROGRESS,onLoadFlash);
			this.flashLib.removeEventListener(Event.COMPLETE,onFlashLoadComplete);
			GlobalFlashManager.getInstance().init(this.flashLib);
			loadSound();
		}
		
		private function loadSound():void
		{
			this.soundZip=new FZip();
			this.soundZip.addEventListener(ProgressEvent.PROGRESS,onLoadSound);
			this.soundLib=new FZipLibrary();
			this.soundLib.formatAsDisplayObject(".swf");
			this.soundLib.addEventListener(Event.COMPLETE,onSoundLoadComplete);
			this.soundZip.load(new URLRequest("assets/sound.zip"));
			this.soundLib.addZip(this.soundZip);
		}
		
		private function onLoadSound(evt:ProgressEvent):void
		{
			this.dispatchEvent(new GameProgressEvent(GameProgressEvent.LOAD_SOUND,false,false,evt.bytesLoaded,evt.bytesTotal));
		}
		
		private function onSoundLoadComplete(evt:Event):void
		{	
			this.dispatchEvent(new GameProgressEvent(GameProgressEvent.LOAD_SOUND_COMPLETE));
			this.soundZip.removeEventListener(ProgressEvent.PROGRESS,onLoadSound);
			this.soundLib.removeEventListener(Event.COMPLETE,onSoundLoadComplete);
			GlobalSoundManager.getInstance().init(this.soundLib);
			loadConfig();
			GlobalSoundManager.getInstance().play(SoundAssetsClassName.BACKGROUND_SOUND);
		}
		
		private function barrackConfigHandler(data:XML):void
		{
			var barrackXMLList:XMLList=data.children();
			var barrackVO:BarrackVO;
			for each(var barrackXML:XML in barrackXMLList)
			{
				barrackVO=new BarrackVO();
				barrackVO.name=barrackXML.@name;

				barrackVO.resID=barrackXML.@resID;
				barrackVO.monsterResID=barrackXML.@monsterResID;
				barrackVO.level=barrackXML.@level;
				barrackVO.height=barrackXML.@height;
				barrackVO.levelUp=barrackXML.@levelUp;
				barrackVO.trainingTime=barrackXML.@trainingTime;
				barrackVO.camp=barrackXML.@camp;
				barrackVO.buildTime=barrackXML.@buildTime;
				barrackVO.money=barrackXML.@money;
				barrackVO.skinUrl=barrackXML.@skinUrl;
				GlobalInfoManager.getInstance.barrackInfo.addBarrackVO(barrackVO);
				BarrackPool.getInstance().define(barrackVO.resID.toString(),new Barrack(barrackVO,0));
			}
		}
		
		private function effectConfigHandler(data:XML):void
		{
			var effectXMLList:XMLList=data.children();
			var effectVO:EffectVO;
			for each(var effectXML:XML in effectXMLList)
			{
				effectVO=new EffectVO();
				effectVO.attackType=effectXML.@attackType;
				effectVO.name=effectXML.@name;
				effectVO.resID=effectXML.@resID;
				effectVO.type=effectXML.@type;
				effectVO.value=effectXML.@value;
				effectVO.area=effectXML.@area;
				effectVO.skinUrl=effectXML.@skinUrl;
				effectVO.bitmapMCFrameInfoArr=BitmapMCFrameInfoPool.getInstance().getBitmapMCFrameInfoArr(effectVO.skinUrl);
				GlobalInfoManager.getInstance.effectInfo.addEffectVO(effectVO);
				EffectPool.getInstance().define(effectVO.resID.toString(),EffectFactory.getEffect(effectVO,0));
			}
		}
		
		private function towerConfigHandler(data:XML):void
		{
			var towerXMLList:XMLList=data.children();
			var towerVO:TowerVO;
			for each(var towerXML:XML in towerXMLList)
			{
				towerVO=new TowerVO();
				towerVO.introduction=towerXML.@introduction;
				towerVO.name=towerXML.@name;
				towerVO.resID=towerXML.@resID;
				towerVO.effectResID=towerXML.@effectResID;
				towerVO.effectNum=towerXML.@effectNum;
				towerVO.effectCamp=towerXML.@effectCamp;
				towerVO.level=towerXML.@level;
				towerVO.height=towerXML.@height;
				towerVO.levelUp=towerXML.@levelUp;
				towerVO.intervalTime=towerXML.@intervalTime;
				towerVO.camp=towerXML.@camp;
				towerVO.buildTime=towerXML.@buildTime;
				towerVO.money=towerXML.@money;
				towerVO.skinUrl=towerXML.@skinUrl;
				towerVO.bitmapMCFrameInfoArr=BitmapMCFrameInfoPool.getInstance().getBitmapMCFrameInfoArr(towerVO.skinUrl);
				GlobalInfoManager.getInstance.towerInfo.addTowerVO(towerVO);
				TowerPool.getInstance().define(towerVO.resID.toString(),new Tower(towerVO,0));
			}
			
		}
		
		private function monsterConfigHandler(data:XML):void
		{
			var monsterXMLList:XMLList=data.children();
			var monsterVO:MonsterVO;
			for each(var monsterXML:XML in monsterXMLList)
			{
				monsterVO=new MonsterVO();
				monsterVO.introduction=monsterXML.@introduction;
				monsterVO.name=monsterXML.@name;
				monsterVO.type=monsterXML.@type;
				monsterVO.camp=monsterXML.@camp;
				monsterVO.armor=monsterXML.@armor;
				monsterVO.attackArea=monsterXML.@attackArea;
				monsterVO.attackDamage=monsterXML.@attackDamage;
				monsterVO.attackFrequency=monsterXML.@attackFrequency;
				monsterVO.attackRange=monsterXML.@attackRange;
				monsterVO.attackType=monsterXML.@attackType;
				monsterVO.height=monsterXML.@height;
				monsterVO.magicResistance=monsterXML.@magicResistance;
				monsterVO.maxBlood=monsterXML.@maxBlood;
				monsterVO.moveArea=monsterXML.@moveArea;
				monsterVO.resID=monsterXML.@resID;
				monsterVO.speed=monsterXML.@speed;
				monsterVO.money=monsterXML.@money;
				monsterVO.destoryCastleBlood=monsterXML.@destoryCastleBlood;
				monsterVO.skinUrl=monsterXML.@skinUrl;
				monsterVO.bitmapMCFrameInfoArr=BitmapMCFrameInfoPool.getInstance().getBitmapMCFrameInfoArr(monsterVO.skinUrl);
				GlobalInfoManager.getInstance.monsterInfo.addMonsterVO(monsterVO);
				MonsterPool.getInstance().define(monsterVO.resID.toString(),MonsterFactory.getMonster(monsterVO,0));
			}
		}

		private function chapterFlagConfigHanler(data:XML):void
		{
			var chapterFlagXMLList:XMLList=data.children();
			var chapterFlagVO:ChapterFlagVO;
			for each(var chapterFlagXML:XML in chapterFlagXMLList)
			{
				chapterFlagVO=new ChapterFlagVO();
				chapterFlagVO.id=chapterFlagXML.@id;
				chapterFlagVO.x=chapterFlagXML.@x;
				chapterFlagVO.y=chapterFlagXML.@y;
				GlobalInfoManager.getInstance.chapterFlagInfo.addChapterFlagVO(chapterFlagVO);
			}
		}
		
		private function init():void
		{
			this.chapterFlagArr=new Vector.<ChapterFlag>();
			this.menuScene=new Sprite();
			this.addChild(this.menuScene);
			this.worldMap=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.WORLD_MAP);
			this.menuScene.addChild(this.worldMap);
			this.chapterFlagScene=new Sprite();
			this.menuScene.addChild(this.chapterFlagScene);
			this.uiSkin=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.WORLD_MAP_UI_SKIN);
			this.uiSkin.soundBtn.addEventListener(MouseEvent.CLICK,soundHandler);
			this.uiSkin.achievementBtn.addEventListener(MouseEvent.CLICK,achievementHandler);
			this.menuScene.addChild(this.uiSkin);
			this.playerRecordSO=SharedObject.getLocal("localPlayerRecord20120310");
			var chapterFlagVO:ChapterFlagVO;
			if(this.playerRecordSO.data.record!=null)
			{
				trace("再次进入游戏")
				var i:int;
				var playerRecord:PlayerRecord;
				var length:int=this.playerRecordSO.data.record.length;
				if(length==0)
				{
					trace("没有记录");
					chapterFlagVO=GlobalInfoManager.getInstance.chapterFlagInfo.getChapterFlagVO(1);
					addChapterFlag(chapterFlagVO,ChapterFlagFrameLabel.NEW_FRAME_LABEL);
				}
				else
				{
					for(i=0 ;i<length ;i++)
					{
						playerRecord=new PlayerRecord();
						playerRecord.id=this.playerRecordSO.data.record[i].id;
						playerRecord.time=this.playerRecordSO.data.record[i].time;
						playerRecord.score=this.playerRecordSO.data.record[i].score;
						GlobalInfoManager.getInstance.playerRecordInfo.addPlayerRecord(playerRecord);
						chapterFlagVO=GlobalInfoManager.getInstance.chapterFlagInfo.getChapterFlagVO(playerRecord.id);
						addChapterFlag(chapterFlagVO,ChapterFlagFrameLabel.getCompleteFrameLabel(playerRecord.score));
					}
					//非最后一关
					if(GlobalInfoManager.getInstance.chapterInfo.chpaterNum!=length)
					{
						chapterFlagVO=GlobalInfoManager.getInstance.chapterFlagInfo.getChapterFlagVO(length+1);
						addChapterFlag(chapterFlagVO,ChapterFlagFrameLabel.NEW_FRAME_LABEL);
						worldMap.gotoAndStop(WorldMapFrameLabel.getChapterEndFrameLable(length+1))	
					}
					//最后一关
					else
					{
						worldMap.gotoAndStop(WorldMapFrameLabel.getChapterEndFrameLable(length))
					}
					trace("已添加记录");
				}

			}
			else
			{
				trace("首次进入游戏")
				chapterFlagVO=GlobalInfoManager.getInstance.chapterFlagInfo.getChapterFlagVO(1);
				addChapterFlag(chapterFlagVO,ChapterFlagFrameLabel.NEW_FRAME_LABEL);
//				chapterFlagVO=GlobalInfoManager.getInstance.chapterFlagInfo.getChapterFlagVO(2);
//				addChapterFlag(chapterFlagVO,ChapterFlagFrameLabel.NEW_FRAME_LABEL);
//				chapterFlagVO=GlobalInfoManager.getInstance.chapterFlagInfo.getChapterFlagVO(3);
//				addChapterFlag(chapterFlagVO,ChapterFlagFrameLabel.NEW_FRAME_LABEL);
//				chapterFlagVO=GlobalInfoManager.getInstance.chapterFlagInfo.getChapterFlagVO(4);
//				addChapterFlag(chapterFlagVO,ChapterFlagFrameLabel.NEW_FRAME_LABEL);
//				chapterFlagVO=GlobalInfoManager.getInstance.chapterFlagInfo.getChapterFlagVO(5);
//				addChapterFlag(chapterFlagVO,ChapterFlagFrameLabel.NEW_FRAME_LABEL);
//				worldMap.gotoAndStop(WorldMapFrameLabel.getChapterEndFrameLable(5))
				this.playerRecordSO.data.record=new Array();
				this.playerRecordSO.flush();
			}
		}
		
		private function soundHandler(evt:MouseEvent):void
		{
			if(GlobalSoundManager.getInstance().isPlaying)
			{
				GlobalSoundManager.getInstance().mute();
			}
			else
			{
				GlobalSoundManager.getInstance().resume();
			}
		}
		
		private function achievementHandler(evt:MouseEvent):void
		{
			addAchievementPanel();
		}
		
		private function addAchievementPanel():void
		{
			this.achievementPanel=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.ACHIEVEMENT_PANEL);
			var playerRecordArr:Vector.<PlayerRecord>=GlobalInfoManager.getInstance.playerRecordInfo.playerRecordArr;
			var playerRecord:PlayerRecord;
			for each(playerRecord in playerRecordArr)
			{
				this.achievementPanel["rankLabel"+playerRecord.id].text=playerRecord.id.toString();
				this.achievementPanel["score"+playerRecord.id].setStar(playerRecord.score);
				this.achievementPanel["timeTextField"+playerRecord.id].text=playerRecord.time;
			}
			this.achievementPanel.backBtn.addEventListener(MouseEvent.CLICK,achievementPanelHandler);
			this.achievementPanel.x=this.stage.stageWidth/2;
			this.achievementPanel.y=this.stage.stageHeight/2;
			PopUpManager.addPopUp(this.achievementPanel,this.stage);
		}
		
		private function achievementPanelHandler(evt:MouseEvent):void
		{
			removeAchievementPanel();
		}
		
		private function removeAchievementPanel():void
		{
			this.achievementPanel.backBtn.removeEventListener(MouseEvent.CLICK,achievementPanelHandler);
			PopUpManager.removePopUp(this.achievementPanel,this.stage);
		}
		
		private function addChapterFlag(chapterFlagVO:ChapterFlagVO,frameLable:Object):void
		{
			var chapterFlag:ChapterFlag;
			chapterFlag=new ChapterFlag(chapterFlagVO);
			chapterFlag.addEventListener(ChapterFlagEvent.SELECTED,onChapterFlagSelected);
			chapterFlag.x=chapterFlagVO.x;
			chapterFlag.y=chapterFlagVO.y;
			chapterFlag.gotoAndStop(frameLable);
			this.chapterFlagArr.push(chapterFlag);
			this.chapterFlagScene.addChild(chapterFlag);
		}
		
		private function onChapterFlagSelected(evt:ChapterFlagEvent):void
		{
			var chapterFlag:ChapterFlag=evt.target as ChapterFlag;
			GlobalInfoManager.getInstance.chapterInfo.setChapter(chapterFlag.vo.id);
			this.removeChild(this.menuScene);
			initGame();
			GlobalSoundManager.getInstance().play(SoundAssetsClassName.getChapterSound(chapterFlag.vo.id));
		}
		
		private function barrackPointConfigHandler(data:XML):void
		{
			var barrackPointXMLList:XMLList=data.children();
			var barrackPointVO:BarrackPointVO;
			for each(var barrackPointXML:XML in barrackPointXMLList)
			{
				barrackPointVO=new BarrackPointVO();
				barrackPointVO.id=barrackPointXML.@id;
				barrackPointVO.x=barrackPointXML.@x;
				barrackPointVO.y=barrackPointXML.@y;
				barrackPointVO.camp=barrackPointXML.@camp;
				barrackPointVO.lineIDArr=barrackPointXML.@lineIDArr.split(",");
				barrackPointVO.skinUrl=barrackPointXML.@skinUrl;
				barrackPointVO.skinFrame=barrackPointXML.@skinFrame;
				GlobalInfoManager.getInstance.chapterInfo.barrackPointInfo.addBarrackPointVO(barrackPointVO);
			}
		}
		
		private function towerPointConfigHandler(data:XML):void
		{
			var towerPointXMLList:XMLList=data.children();
			var towerPointVO:TowerPointVO;
			for each(var barrackPointXML:XML in towerPointXMLList)
			{
				towerPointVO=new TowerPointVO();
				towerPointVO.id=barrackPointXML.@id;
				towerPointVO.x=barrackPointXML.@x;
				towerPointVO.y=barrackPointXML.@y;
				towerPointVO.camp=barrackPointXML.@camp;
				towerPointVO.skinUrl=barrackPointXML.@skinUrl;
				towerPointVO.skinFrame=barrackPointXML.@skinFrame;
				GlobalInfoManager.getInstance.chapterInfo.towerPointInfo.addTowerPointVO(towerPointVO);
			}
		}
		
		private function computerConfigHandler(data:XML):void
		{
			//兵营AI
			var computerBarrackAIXMLList:XMLList=data.computerBarrackAIConfig.children();
			var computerBarrackAIVO:ComputerBarrackAIVO;
			for each(var computerBarrackAIXML:XML in computerBarrackAIXMLList)
			{
				computerBarrackAIVO=new ComputerBarrackAIVO();
				computerBarrackAIVO.barrackPointID=computerBarrackAIXML.@barrackPointID;
				computerBarrackAIVO.barrackResID=computerBarrackAIXML.@barrackResID;
				computerBarrackAIVO.buildTime=computerBarrackAIXML.@buildTime;
				GlobalInfoManager.getInstance.chapterInfo.computerInfo.computerBarrackAIInfo.addComputerBarrackAIVO(computerBarrackAIVO);
			}
			
			//防御塔AI
			var computerTowerAIXMLList:XMLList=data.computerTowerAIConfig.children();
			var computerTowerAIVO:ComputerTowerAIVO;
			for each(var computerTowerAIXML:XML in computerTowerAIXMLList)
			{
				computerTowerAIVO=new ComputerTowerAIVO();
				computerTowerAIVO.towerPointID=computerTowerAIXML.@towerPointID;
				computerTowerAIVO.towerResID=computerTowerAIXML.@towerResID;
				computerTowerAIVO.buildTime=computerTowerAIXML.@buildTime;
				GlobalInfoManager.getInstance.chapterInfo.computerInfo.computerTowerAIInfo.addComputerTowerAIVO(computerTowerAIVO);
			}

			//BOSSAI
			var computerBossAIXMLList:XMLList=data.computerBossAIConfig.children();
			var computerBossAIVO:ComputerBossAIVO;
			for each(var computerBossAIXML:XML in computerBossAIXMLList)
			{
				computerBossAIVO=new ComputerBossAIVO();
				computerBossAIVO.monsterResID=computerBossAIXML.@monsterResID;
				computerBossAIVO.lineID=computerBossAIXML.@lineID;
				computerBossAIVO.showTime=computerBossAIXML.@showTime;
				GlobalInfoManager.getInstance.chapterInfo.computerInfo.computerBossAIInfo.addComputerBossAIVO(computerBossAIVO);
			}
			
			//野怪AI
			var computerCreepAIXMLList:XMLList=data.computerCreepAIConfig.children();
			var computerCreepAIVO:ComputerCreepAIVO;
			for each(var computerCreepAIXML:XML in computerCreepAIXMLList)
			{
				computerCreepAIVO=new ComputerCreepAIVO();
				computerCreepAIVO.monsterResID=computerCreepAIXML.@monsterResID;
				computerCreepAIVO.lineID=computerCreepAIXML.@lineID;
				computerCreepAIVO.showTime=computerCreepAIXML.@showTime;
				computerCreepAIVO.intervalTime=computerCreepAIXML.@intervalTime;
				computerCreepAIVO.num=computerCreepAIXML.@num;
				GlobalInfoManager.getInstance.chapterInfo.computerInfo.computerCreepAIInfo.addComputerCreepAIVO(computerCreepAIVO);
			}

			GlobalInfoManager.getInstance.chapterInfo.computerInfo.computerCastleBlood=data.computerCastleBlood[0].@value;
		}
		
		private function lineConfigHandler(data:XML):void
		{
			var lineXMLList:XMLList=data.children();
			var line:Vector.<Point>;
			var point:Point;
			var lineVO:LineVO;
			for each(var lineXML:XML in lineXMLList)
			{
				line=new Vector.<Point>();
				for each(var pointXML:XML in lineXML.children())
				{
					point=new Point(pointXML.@x,pointXML.@y);
					line.push(point);
					point=null;
				}
				lineVO=new LineVO();
				lineVO.id=lineXML.@id;
				lineVO.camp=EnumCamp.PLAYER;
				lineVO.line=line;
				GlobalInfoManager.getInstance.chapterInfo.lineInfo.addLineVO(lineVO);
				lineVO=new LineVO();
				lineVO.id=lineXML.@id;
				lineVO.camp=EnumCamp.COMPUTER;
				lineVO.line=line.concat().reverse();
				GlobalInfoManager.getInstance.chapterInfo.lineInfo.addLineVO(lineVO);
			}
		}
		
		private function playerConfigHandler(data:XML):void
		{
			var playerBarrackLimitXMLList:XMLList=data.playerBarrackLimitConfig.children();
			var playerBarrackLimitVO:PlayerBarrackLimitVO;
			for each(var playerBarrackLimitXML:XML in playerBarrackLimitXMLList)
			{
				playerBarrackLimitVO=new PlayerBarrackLimitVO();
				playerBarrackLimitVO.barrackResID=playerBarrackLimitXML.@barrackResID;
				playerBarrackLimitVO.levelUp=playerBarrackLimitXML.@levelUp;
				GlobalInfoManager.getInstance.chapterInfo.playerInfo.playerBarrackLimitInfo.addPlayerBarrackLimitVO(playerBarrackLimitVO);
			}
			var playerTowerLimitXMLList:XMLList=data.playerTowerLimitConfig.children();
			var playerTowerLimitVO:PlayerTowerLimitVO;
			for each(var playerTowerLimitXML:XML in playerTowerLimitXMLList)
			{
				playerTowerLimitVO=new PlayerTowerLimitVO();
				playerTowerLimitVO.towerResID=playerTowerLimitXML.@towerResID;
				playerTowerLimitVO.levelUp=playerTowerLimitXML.@levelUp;
				GlobalInfoManager.getInstance.chapterInfo.playerInfo.playerTowerLimitInfo.addPlayerTowerLimitVO(playerTowerLimitVO);
			}
			
			var playerScoreXMLList:XMLList=data.playerScoreConfig.children();
			var playerScoreVO:PlayerScoreVO;
			for each(var playerScoreXML:XML in playerScoreXMLList)
			{
				playerScoreVO=new PlayerScoreVO();
				playerScoreVO.blood=playerScoreXML.@blood;
				playerScoreVO.score=playerScoreXML.@score;
				playerScoreVO.time=playerScoreXML.@time;
				GlobalInfoManager.getInstance.chapterInfo.playerInfo.playerScoreInfo.addPlayerScoreVO(playerScoreVO);
			}
			
			GlobalInfoManager.getInstance.chapterInfo.playerInfo.playerCastleBlood=data.playerCastleBlood[0].@value;
			GlobalInfoManager.getInstance.chapterInfo.playerInfo.money=data.money[0].@value;
		}
		
		private function initGame():void
		{
			game=new Game();
			game.addEventListener(GameEvent.RETURN_MENU,onReturnMenu);
			game.addEventListener(GameEvent.VICTORY,onVictory);
			this.addChild(game);
			if(IS_DEBUG)
			{
				stats=new Stats();
				stats.x=this.stage.stageWidth-70;
				stats.y=this.stage.stageHeight-100;
				this.addChild(stats);
			}
			game.start();
		}
		
		private function removeGame():void
		{
			this.removeChild(game);
			game.removeEventListener(GameEvent.RETURN_MENU,onReturnMenu);
			game.removeEventListener(GameEvent.VICTORY,onVictory);
			game=null;
		}
		
		private function onReturnMenu(evt:GameEvent):void
		{
			removeGame();
			this.addChild(this.menuScene);
			checkNewChapter();
			GlobalSoundManager.getInstance().play(SoundAssetsClassName.BACKGROUND_SOUND);
		}
		
		private function checkNewChapter():void
		{
			var lastPlayerRecordID:int=GlobalInfoManager.getInstance.playerRecordInfo.getLastPlayerRecordID();
			if(lastPlayerRecordID!=0)
			{
				var lastChapterFlagID:int=getLastChapterFlagID();
				if(lastPlayerRecordID==lastChapterFlagID)
				{
					var chapterFlag:ChapterFlag=getChapterFlag(lastChapterFlagID);
					var playerRecord:PlayerRecord=GlobalInfoManager.getInstance.playerRecordInfo.getPlayerRecord(lastChapterFlagID);
					chapterFlag.gotoAndStop(ChapterFlagFrameLabel.getCompleteFrameLabel(playerRecord.score));
					if(lastChapterFlagID<GlobalInfoManager.getInstance.chapterInfo.chpaterNum)
					{

						this.worldMap.addEventListener(WorldMapEvent.getEventType(lastChapterFlagID+1),worldMapHandler);
						this.worldMap.gotoAndPlay(WorldMapFrameLabel.getChapterStartFrameLabel(lastChapterFlagID+1));

					}
				}
			}
		}
		
		private function worldMapHandler(evt:Event):void
		{
			this.worldMap.removeEventListener(WorldMapEvent.getEventType(WorldMapEvent.getChapterID(evt.type)),worldMapHandler);
			var chapterFlagVO:ChapterFlagVO=GlobalInfoManager.getInstance.chapterFlagInfo.getChapterFlagVO(WorldMapEvent.getChapterID(evt.type));
			addChapterFlag(chapterFlagVO,ChapterFlagFrameLabel.NEW_FRAME_LABEL);
		}
		
		private function onVictory(evt:GameEvent):void
		{
			var chapter:int=GlobalInfoManager.getInstance.chapterInfo.currentChapter;
			var playerRecord:PlayerRecord=GlobalInfoManager.getInstance.playerRecordInfo.getPlayerRecord(chapter);
			if(playerRecord==null)
			{
				playerRecord=new PlayerRecord();
				playerRecord.id=chapter;
				playerRecord.score=evt.score;
				playerRecord.time=evt.time;
				GlobalInfoManager.getInstance.playerRecordInfo.addPlayerRecord(playerRecord);
				this.playerRecordSO.data.record.push(playerRecord);
				this.playerRecordSO.flush();
			}
			else
			{
				if(evt.score>playerRecord.score)
				{
					playerRecord.score=evt.score;
					playerRecord.time=evt.time;
					var length:int=this.playerRecordSO.data.record.length;
					var i:int;
					for(i=0;i<length;i++)
					{
						if(this.playerRecordSO.data.record[i].chapter==chapter)
						{
							this.playerRecordSO.data.record[i].time=evt.time;
							this.playerRecordSO.data.record[i].score=evt.score;
							this.playerRecordSO.flush();
							break;
						}
					}
					getChapterFlag(playerRecord.id).gotoAndStop(ChapterFlagFrameLabel.getCompleteFrameLabel(playerRecord.score));
				}
			}
//			var maxChapter:int=GlobalInfoManager.getInstance.chapterFlagInfo.chapterFlagVOArr.length;
//			var chapterFlag:ChapterFlag=getChapterFlag(chapter);
//			chapterFlag.gotoAndStop("complete");
//			this.addChild(this.worldMapScene);
//			if(chapter<maxChapter)
//			{
//				this.worldMap.gotoAndPlay(chapter+"to"+(chapter+1));
//				var chapterFlagVO:ChapterFlagVO=GlobalInfoManager.getInstance.chapterFlagInfo.getChapterFlagVO(chapter+1);
//				addChapterFlag(chapterFlagVO);
//			}
		}
		
		private function getChapterFlag(id:int):ChapterFlag
		{
			var chapterFlag:ChapterFlag;
			for each(chapterFlag in this.chapterFlagArr)
			{
				if(chapterFlag.vo.id==id)
				{
					return chapterFlag;
				}
			}
			return null;
		}
		
		private function getLastChapterFlagID():int
		{
			var length:int;
			length=this.chapterFlagArr.length;
			if(length>0)
			{
				return this.chapterFlagArr[length-1].vo.id;
			}
			else
			{
				return 0;
			}
		}
	}
}
