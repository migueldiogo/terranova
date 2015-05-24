package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import fl.containers.UILoader;
	
	
	public class PausePlayButton extends MovieClip {
		public static var PAUSE = 0;
		public static var PLAY = 1;
		
		private var _icon : UILoader;
		private var state : Boolean;
		
		public function PausePlayButton() {
			
			_icon = new UILoader;
			_icon.scaleContent = false;
			_icon.x = 0;
			_icon.y = 0;
			_icon.source = "media/header/pause.png";
			addChild(_icon);
			stop();
			//gotoAndStop("pause");
			state = PAUSE;
			
			
		}
		
		public function setPause() {
			state = PAUSE;
			_icon.source = "media/header/pause.png";
			//gotoAndStop("pause");
		}
		
		public function setPlay() {
			state = PLAY;
			_icon.source = "media/header/play.png";

			//gotoAndStop("play");
		}
		
		public function isPause() : Boolean {
			return state == PAUSE;
		}
		
		
	}
	
}
