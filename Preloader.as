package 
{
import com.greensock.TweenLite;

import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
import flash.text.TextField;
import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Senchurin Nick
	 */
	public class Preloader extends MovieClip 
	{
        private var prelMc:PreloadMc;
		
		public function Preloader() 
		{
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader

            prelMc = new PreloadMc();
            prelMc.name = 'prelMc';
            prelMc.x = stage.stageWidth/2 - prelMc.width/2
            prelMc.y = stage.stageHeight/2 - prelMc.height/2;
            prelMc.alpha = 0;
            TextField(prelMc.getChildByName("per")).text = '';
            addChild(prelMc);
            TweenLite.to(prelMc, 0.5, {alpha: 1});

		}
		
		private function ioError(e:IOErrorEvent):void {
			trace(e.text);
		}


		private function progress(e:ProgressEvent):void {
            TextField(prelMc.getChildByName("per")).text = Math.round(e.bytesLoaded/e.bytesTotal*100).toString() + "%";
		}


		private function checkFrame(e:Event):void {
			if (currentFrame == totalFrames) 
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
            prelMc.visible = false;
			startup();
		}
		
		private function startup():void 
		{
			var mainClass:Class = getDefinitionByName("MemoryPuzzle") as Class;
			if (parent == stage) stage.addChildAt(new mainClass() as DisplayObject, 0);
			else addChildAt(new mainClass() as DisplayObject, 0);
		}
		
	}
	
}