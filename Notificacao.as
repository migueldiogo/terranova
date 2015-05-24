package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import fl.containers.UILoader;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Strong;

	public class Notificacao extends MovieClip implements IEventDispatcher
	{
		static public var NOTIFICACAO_ACABOU = "notificacaoFinish";
		private var _parentMovieClip : MovieClip;
		
		private var _windowWidth : Number;
		private var _windowHeight : Number;
		private var _icon : UILoader;
		private var _titulo : TextField;
		
		private var _tween : Tween;
		private var _timer : Timer;
		
		private var _slot : uint;
		public function Notificacao(parentMovieClip : MovieClip, x : int = 0, y : int = 0, windowWidth : Number = 100, windowHeight : Number = 100, slot : uint = 0)
		{
			super();
			
			_parentMovieClip = parentMovieClip;
			_slot = slot;

			_windowWidth = windowWidth;
			_windowHeight = windowHeight;
			this.x = x;
			this.y = y;
			
			
			
			graphics.beginFill(parseInt(Pretty.COLOR_POPUP), 0.8);
			graphics.drawRoundRect(0, 0, _windowWidth, _windowHeight, 15);
			graphics.endFill();

			
			_icon = new UILoader();
			_icon.scaleContent = false;
			_icon.maintainAspectRatio = true;
			_icon.x = 5;
			_icon.y = _windowHeight/2 - 32/2;
			addChild(_icon);
			
			_titulo = new TextField();
			_titulo.defaultTextFormat = Pretty.BODY;
			_titulo.x = _icon.x + 32 + 5;
			_titulo.y = _icon.y;
			
			_titulo.width = _windowWidth - _titulo.x;

			
			
			addChild(_titulo);
			
			_parentMovieClip.addChild(this);
			
			
		}
		
		public function get slot():uint
		{
			return _slot;
		}

		public function set slot(value:uint):void
		{
			_slot = value;
		}

		public function get titulo():TextField
		{
			return _titulo;
		}

		public function set titulo(value:TextField):void
		{
			_titulo = value;
		}

		public function get icon():UILoader
		{
			return _icon;
		}

		public function set icon(value:UILoader):void
		{
			_icon = value;
		}

		public function start() {
			_tween = new Tween(this, "x", Strong.easeOut, x, x - _windowWidth, 0.5, true);
			_tween.addEventListener(TweenEvent.MOTION_FINISH, notificationTweenFinish);
			_tween.start();

		}
		
		private function notificationTweenFinish(e : TweenEvent) {
			e.target.removeEventListener(TweenEvent.MOTION_FINISH, notificationTweenFinish);
			_timer = new Timer(3000, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, notificationTimerFinish);
			_timer.start();
		}
		
		private function notificationTimerFinish(e : TimerEvent) {
			e.target.removeEventListener(TimerEvent.TIMER_COMPLETE, notificationTimerFinish);

			_tween = new Tween(this, "x", Strong.easeOut, x, x + _windowWidth, 0.5, true);
			_tween.addEventListener(TweenEvent.MOTION_FINISH, notificationTweenFinishOut);
			_tween.start();
		}
		
		private function notificationTweenFinishOut(e : TweenEvent) {
			e.target.removeEventListener(TweenEvent.MOTION_FINISH, notificationTweenFinishOut);

			_parentMovieClip.removeChild(this);
			var event : Event = new Event(NOTIFICACAO_ACABOU);
			dispatchEvent(event);
		}
	}
	
	
	
	
	
	
	
}