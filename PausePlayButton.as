package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	
	public class PausePlayButton extends MovieClip {
		public static var PAUSE = 0;
		public static var PLAY = 1;
		
		private var state : Boolean;
		
		public function PausePlayButton() {
			

			gotoAndStop("pause");;
			state = PAUSE;
			
			
		}
		
		public function setPause() {
			state = PAUSE;
			gotoAndStop("pause");
		}
		
		public function setPlay() {
			state = PLAY;
			gotoAndStop("play");
		}
		
		public function isPause() : Boolean {
			return state == PAUSE;
		}
		
		
	}
	
}
