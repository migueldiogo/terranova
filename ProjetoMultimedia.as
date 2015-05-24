package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import fl.containers.UILoader;
	import fl.controls.Label;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Strong;
	

	public class ProjetoMultimedia extends MovieClip
	{
		
		public function ProjetoMultimedia()
		{
			stop();	
			/*
			opaqueBackground = 0x000000;
			introBackground.visible = false;
			
			var universidade : TextField = new TextField();
			universidade.name = "universidade";
			universidade.defaultTextFormat = Pretty.HEADING_1;
			universidade.text = "UNIVERSIDADE DE COIMBRA";
			universidade.width = universidade.textWidth;
			universidade.x = stage.stageWidth/2 - universidade.textWidth/2;
			universidade.y = stage.stageHeight/2 - universidade.textHeight/2;
			addChild(universidade);
			
			var tween : Tween = new Tween(universidade, "alpha", Strong.easeIn, 0, 1, 1, true);
			tween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinished);
			tween.start();
			
			*/
			new Menu(this);


		}
		/*
		private function tweenFinished(e : TweenEvent) {
			var pause : Timer = new Timer(2000, 1);
			pause.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			pause.start();

		}
		
		private function timerComplete(e : TimerEvent) {
			opaqueBackground = null;
			introBackground.visible = true;

			removeChild(getChildByName("universidade"));
			new Menu(this);
			
		}
		*/
		
		
		
		
	}
	
	
}

