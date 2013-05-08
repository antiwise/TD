package net.shangle.display
{
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import net.shangle.event.GameEvent;
	import net.shangle.event.UIEvent;
	import net.shangle.manager.GlobalFlashManager;
	import net.shangle.manager.GlobalInfoManager;
	import net.shangle.manager.GlobalSoundManager;
	import net.shangle.manager.GlobalTooltipManager;
	import net.shangle.manager.GlobalTriggerManager;
	import net.shangle.pool.BarrackPool;
	import net.shangle.pool.EffectPool;
	import net.shangle.pool.MonsterPool;
	import net.shangle.pool.TowerPool;
	import net.shangle.util.ClockUtil;
	import net.shangle.util.FlashAssetsFileName;
	import net.shangle.util.PopUpManager;
	import net.shangle.vo.PlayerScoreVO;

	public class Game extends Sprite
	{
		private var defeatPanel:MovieClip;
		private var victoryPanel:MovieClip;
		private var optionPanel:MovieClip;
		private var pausedPanel:MovieClip;
		private var instructionsPanel:MovieClip;
		private var groundScene:GroundScene;
		private var tipScene:Sprite;
		private var uiScene:UIScene;
		private var currentMouseX:int;
		private var addMoneyNum:int;
		private const ADD_MONEY_MAX_NUM:int=500;
		private const ADD_MONEY_FREQUENCY:int=20;
		private var addMoneyTriggerID:int;
		
		
		
		private var mousePoint:Point;
		private var mouseDx:int;
		private var playerScoreVO:PlayerScoreVO

		public function Game()
		{
			super();
			initScene();		
		}
		
		private function initScene():void
		{
			this.groundScene=new GroundScene();
			this.addChild(this.groundScene);
			this.uiScene=new UIScene();
			this.addChild(this.uiScene);
			this.tipScene=new Sprite();
			this.tipScene.mouseChildren=false;
			this.tipScene.mouseEnabled=false;
			this.addChild(this.tipScene);
			GlobalTooltipManager.getInstance().init(this.tipScene);
		}
		
		private function optionHandler(evt:UIEvent):void
		{
			pause();
			addOptionPanel();
		}
		
		private function addOptionPanel():void
		{
			this.optionPanel=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.OPTION_PANEL);
			this.optionPanel.x=this.stage.stageWidth/2;
			this.optionPanel.y=-250;
			this.optionPanel.restartBtn.addEventListener(MouseEvent.CLICK,optionPanelRestartHandler);
			this.optionPanel.resumeBtn.addEventListener(MouseEvent.CLICK,optionPanelResumeHandler);
			this.optionPanel.quitBtn.addEventListener(MouseEvent.CLICK,optionPanelQuitHandler);
			Tweener.addTween(this.optionPanel,{y:140,time:1});
			PopUpManager.addPopUp(this.optionPanel,this.stage);
		}
		
		private function removeOptionPanel():void
		{
			this.optionPanel.restartBtn.removeEventListener(MouseEvent.CLICK,optionPanelRestartHandler);
			this.optionPanel.resumeBtn.removeEventListener(MouseEvent.CLICK,optionPanelResumeHandler);
			this.optionPanel.quitBtn.removeEventListener(MouseEvent.CLICK,optionPanelQuitHandler);
			PopUpManager.removePopUp(this.optionPanel,this.stage);
			this.optionPanel=null;
		}
		
		private function optionPanelResumeHandler(evt:MouseEvent):void
		{
			resume();
			removeOptionPanel();
		}
		
		private function optionPanelQuitHandler(evt:MouseEvent):void
		{
			removeOptionPanel();
			clear();
			this.dispatchEvent(new GameEvent(GameEvent.RETURN_MENU));
		}
		
		private function optionPanelRestartHandler(evt:MouseEvent):void
		{
			removeOptionPanel();
			clear();
			start();
		}
		
		private function soundHandler(evt:UIEvent):void
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
		
		private function pauseHandler(evt:UIEvent):void
		{
			addPausedPanel();
			pause();
		}
		
		private function addPausedPanel():void
		{
			this.pausedPanel=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.PAUSED_PANEL);
			this.pausedPanel.x=this.stage.stageWidth/2;
			this.pausedPanel.y=this.stage.stageHeight/2;	
			this.pausedPanel.addEventListener(MouseEvent.CLICK,pausedPanelHandler);
			PopUpManager.addPopUp(this.pausedPanel,this.stage);
		}
		
		private function pausedPanelHandler(evt:MouseEvent):void
		{
			removePausedPanel();
			resume();
		}
		
		private function removePausedPanel():void
		{
			this.pausedPanel.removeEventListener(MouseEvent.CLICK,pausedPanelHandler);
			PopUpManager.removePopUp(this.pausedPanel,this.stage);
			this.pausedPanel=null;
		}
		
		private function addInstructionsPanel(panelName:String):void
		{
			this.instructionsPanel=GlobalFlashManager.getInstance().getClassInstance(panelName);
			this.instructionsPanel.x=this.stage.stageWidth/2;
			this.instructionsPanel.y=this.stage.stageHeight/2;	
			this.instructionsPanel.btnSkip.addEventListener(MouseEvent.CLICK,instructionsPanelHandler);
			this.instructionsPanel.btnNext.addEventListener(MouseEvent.CLICK,instructionsPanelHandler);
			this.instructionsPanel.btnClose.addEventListener(MouseEvent.CLICK,instructionsPanelHandler);
			PopUpManager.addPopUp(this.instructionsPanel,this.stage);
		}
		
		private function instructionsPanelHandler(evt:MouseEvent):void
		{
			if(evt.currentTarget==this.instructionsPanel.btnNext)
			{
				this.instructionsPanel.play();
			}
			else
			{
				removeInstructionsPanel();
				resume();
			}

		}
		
		private function removeInstructionsPanel():void
		{
			this.instructionsPanel.btnSkip.removeEventListener(MouseEvent.CLICK,instructionsPanelHandler);
			this.instructionsPanel.btnNext.removeEventListener(MouseEvent.CLICK,instructionsPanelHandler);
			this.instructionsPanel.btnClose.removeEventListener(MouseEvent.CLICK,instructionsPanelHandler);
			PopUpManager.removePopUp(this.instructionsPanel,this.stage);
			this.instructionsPanel=null;

		}
		

		
		private function onGroundSceneMouseDown(evt:MouseEvent):void
		{
			this.mousePoint.x=evt.localX;
			this.mousePoint.y=evt.localY;
			this.currentMouseX=this.groundScene.localToGlobal(this.mousePoint).x;
			this.groundScene.addEventListener(MouseEvent.MOUSE_MOVE,onGroundSceneMouseMove);
			this.groundScene.addEventListener(MouseEvent.MOUSE_UP,onGroundSceneMouseUp);
			this.stage.addEventListener(Event.MOUSE_LEAVE,onScreenMouseLeave);
			this.groundScene.addEventListener(MouseEvent.MOUSE_OUT,onGroundSceneMouseOut);
		}
		
		private function onGroundSceneMouseMove(evt:MouseEvent):void
		{
			this.mouseDx=evt.stageX-this.currentMouseX;
			if(this.groundScene.x+this.mouseDx+this.groundScene.map.width>=this.stage.stageWidth && this.groundScene.x+this.mouseDx<=0)
			{
				this.currentMouseX=evt.stageX;
				this.groundScene.x+=this.mouseDx;
			}
		}
		
		private function onScreenMouseLeave(evt:Event):void
		{
			dragComplete();
		}
		
		private function onGroundSceneMouseUp(evt:MouseEvent):void
		{
			dragComplete();
		}
		
		private function onGroundSceneMouseOut(evt:MouseEvent):void
		{
			dragComplete();
		}
		
		private function dragComplete():void
		{
			this.groundScene.removeEventListener(MouseEvent.MOUSE_UP,onGroundSceneMouseUp);
			this.groundScene.removeEventListener(MouseEvent.MOUSE_MOVE,onGroundSceneMouseMove);
			this.stage.removeEventListener(Event.MOUSE_LEAVE,onScreenMouseLeave);
			this.groundScene.removeEventListener(MouseEvent.MOUSE_OUT,onGroundSceneMouseOut);
		}

		public function start() : void
		{
			mousePoint=new Point();
			this.groundScene.start();
			this.uiScene.start(this.groundScene.playerMonsterArr,this.groundScene.computerMonsterArr,this.groundScene.map);
			addMoneyNum=10;
			GlobalTriggerManager.getInstance().start();
			addMoneyTriggerID=GlobalTriggerManager.getInstance().addTrigger(ADD_MONEY_FREQUENCY,addMoney);
			this.addEventListener(Event.ENTER_FRAME , render);
			this.groundScene.addEventListener(MouseEvent.MOUSE_DOWN,onGroundSceneMouseDown);
			this.uiScene.addEventListener(UIEvent.PAUSE,pauseHandler);
			this.uiScene.addEventListener(UIEvent.OPTION,optionHandler);
			this.uiScene.addEventListener(UIEvent.SOUND,soundHandler);
			checkInstructions();
		}
		
		private function checkInstructions():void
		{
			switch(GlobalInfoManager.getInstance.chapterInfo.currentChapter)
			{
				case 1:
				{
					addInstructionsPanel(FlashAssetsFileName.INSTRUCTIONS_PANEL_1);
					pause();
					break;
				}
				case 3:
				{
					addInstructionsPanel(FlashAssetsFileName.INSTRUCTIONS_PANEL_3);
					pause();
					break;
				}
				case 4:
				{
					addInstructionsPanel(FlashAssetsFileName.INSTRUCTIONS_PANEL_4);
					pause();
					break;
				}
			}
		}
		
		private function addMoney():void
		{
			GlobalInfoManager.getInstance.money+=addMoneyNum;
			if(addMoneyNum+10<=ADD_MONEY_MAX_NUM)
				addMoneyNum+=10;
		}

		public function resume() : void
		{
			GlobalTriggerManager.getInstance().resume();
			this.addEventListener(Event.ENTER_FRAME , render);
			this.groundScene.addEventListener(MouseEvent.MOUSE_DOWN,onGroundSceneMouseDown);
			this.groundScene.resume();
		}

		public function pause() : void
		{
			GlobalTriggerManager.getInstance().pause();
			this.removeEventListener(Event.ENTER_FRAME , render);
			this.groundScene.removeEventListener(MouseEvent.MOUSE_DOWN,onGroundSceneMouseDown);
			this.groundScene.pause();
		}

		private function render(evt : Event) : void
		{
			groundScene.render();
			uiScene.render();
			if(GlobalInfoManager.getInstance.computerCastleBlood<=0)
				victory();
			if(GlobalInfoManager.getInstance.playerCastleBlood<=0 || GlobalInfoManager.getInstance.time>=3600)//超时处理
				defeat();
		}
		
		private function defeat():void
		{
			addDefeatPanel();
			pause();
		}
		
		private function addDefeatPanel():void
		{
			this.defeatPanel=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.DEFEAT_PANEL);
			this.defeatPanel.y=-500;
			this.defeatPanel.x=this.stage.stageWidth/2;
			this.defeatPanel.btnRestart.addEventListener(MouseEvent.CLICK,defeatPanelRestartHandler);
			this.defeatPanel.btnQuit.addEventListener(MouseEvent.CLICK,defeatPanelQuitHandler);
			PopUpManager.addPopUp(this.defeatPanel,this.stage);
			Tweener.addTween(this.defeatPanel,{y:0,time:2});
		}
		
		private function removeDefeatPanel():void
		{
			PopUpManager.removePopUp(this.defeatPanel,this.stage);
			this.defeatPanel.btnRestart.removeEventListener(MouseEvent.CLICK,defeatPanelRestartHandler);
			this.defeatPanel.btnQuit.removeEventListener(MouseEvent.CLICK,defeatPanelQuitHandler);
			this.defeatPanel=null;
		}
		
		private function defeatPanelQuitHandler(evt:MouseEvent):void
		{
			removeDefeatPanel();
			clear();
			this.dispatchEvent(new GameEvent(GameEvent.RETURN_MENU));
		}
		
		private function defeatPanelRestartHandler(evt:MouseEvent):void
		{
			removeDefeatPanel();
			clear();
			start();
		}
		
		private function victoryPanelRestartHandler(evt:MouseEvent):void
		{
			removeVictoryPanel();
			clear();
			start();
		}
		
		private function victory():void
		{
			addVictoryPanel();
			pause();
			this.dispatchEvent(new GameEvent(GameEvent.VICTORY,GlobalInfoManager.getInstance.chapterInfo.playerInfo.playerScoreInfo.getScore(GlobalInfoManager.getInstance.time,GlobalInfoManager.getInstance.playerCastleBlood),ClockUtil.getClock(GlobalInfoManager.getInstance.time)));
		}
		
		private function addVictoryPanel():void
		{
			this.victoryPanel=GlobalFlashManager.getInstance().getClassInstance(FlashAssetsFileName.VICTORY_PANEL);
			this.victoryPanel.star.setStar(GlobalInfoManager.getInstance.chapterInfo.playerInfo.playerScoreInfo.getScore(GlobalInfoManager.getInstance.time,GlobalInfoManager.getInstance.playerCastleBlood));
			this.victoryPanel.x=this.stage.stageWidth/2;
			this.victoryPanel.btnRestart.addEventListener(MouseEvent.CLICK,victoryPanelRestartHandler);
			this.victoryPanel.btnContinue.addEventListener(MouseEvent.CLICK,victoryPanelContinueHandler);
			PopUpManager.addPopUp(this.victoryPanel,this.stage);
		}
		
		private function removeVictoryPanel():void
		{
			PopUpManager.removePopUp(this.victoryPanel,this.stage);
			this.victoryPanel.btnRestart.removeEventListener(MouseEvent.CLICK,victoryPanelRestartHandler);
			this.victoryPanel.btnContinue.removeEventListener(MouseEvent.CLICK,victoryPanelContinueHandler);
			this.victoryPanel=null;
		}
		
		private function victoryPanelContinueHandler(evt:MouseEvent):void
		{
			removeVictoryPanel();
			clear();
			this.dispatchEvent(new GameEvent(GameEvent.RETURN_MENU));
		}
		
		private function clear():void
		{
			trace("----------场景清理---------")
			groundScene.clear();
			uiScene.clear();
			this.uiScene.removeEventListener(UIEvent.PAUSE,pauseHandler);
			this.uiScene.removeEventListener(UIEvent.OPTION,optionHandler);
			this.uiScene.removeEventListener(UIEvent.SOUND,soundHandler);
			this.groundScene.removeEventListener(MouseEvent.MOUSE_DOWN,onGroundSceneMouseDown);
			dragComplete();
			GlobalTriggerManager.getInstance().removeTrigger(addMoneyTriggerID);
			this.groundScene.x=0;
			trace("触发器数量:",GlobalTriggerManager.getInstance().triggerNum);
			GlobalTriggerManager.getInstance().reset();
			TowerPool.getInstance().showInfo();
			EffectPool.getInstance().showInfo();
			BarrackPool.getInstance().showInfo();
			MonsterPool.getInstance().showInfo();
			trace("----------场景清理完毕---------")
		}
	}
}
