package net.shangle.manager
{
	import deng.fzip.FZipLibrary;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import net.shangle.util.SoundAssetsFileName;

	public class GlobalSoundManager
	{
		private var sound:Sound;
		private var soundChannel:SoundChannel;

		public var isPlaying:Boolean;
		private var isMute:Boolean;
		
		private var soundLoader:Loader;
		private var initCompleteCallBack:Function;
		
		public function GlobalSoundManager()
		{
		}
		
		private static var instance : GlobalSoundManager;
		
		private var lib:FZipLibrary;
		
		public static function getInstance():GlobalSoundManager
		{
			if(instance==null)
			{
				instance=new GlobalSoundManager();
			}
			return instance;
		}
		
		public function init(lib:FZipLibrary):void
		{
			this.lib=lib;
		}
		
		public function play(className:String):void
		{
			if(this.soundChannel)
			{
				this.soundChannel.stop();
			}
			this.sound=new (this.lib.getDefinition(SoundAssetsFileName.SOUND,className) as Class) as Sound;
			this.soundChannel=this.sound.play(0,int.MAX_VALUE);
			this.isPlaying=true;
			if(isMute)
			{
				mute();
			}
		}
		
		public function mute():void
		{
			var transform:SoundTransform=this.soundChannel.soundTransform;
			transform.volume=0;
			this.soundChannel.soundTransform=transform;
			this.isPlaying=false;
			this.isMute=true;
		}
		
		public function resume():void
		{
			var transform:SoundTransform=this.soundChannel.soundTransform;
			transform.volume=1;
			this.soundChannel.soundTransform=transform;
			this.isPlaying=true;
			this.isMute=false;
		}
	}
}