package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	
	import fl.containers.ScrollPane;
	import fl.containers.UILoader;
	import fl.controls.ScrollPolicy;
	import fl.controls.TextArea;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Strong;
	
	public class MenuGame extends MovieClip
	{
		private var opcoes : Vector.<MovieClip>;
		//var _expedicao : Array;
		//var _settings : Array;
		

		
		private var _mainGame : MainGame;
		
		private var _opcaoEscolhida : uint;
		
		
		private var _miniJogo1 : MiniJogo1;
		private var _settings : SettingsPanel;
		private var _scrollPaneHelp : ScrollPane;
		
		private var _miniJogoCoolDownCounter : TextField;
		
		public function MenuGame(mainGame : MainGame)
		{
			super();
			_mainGame = mainGame;
			
			var opcoesText : Vector.<String> = new <String>["Laboratório", "Expedição", "Configurações", "Ajuda", "Sair"];
			opcoes = new Vector.<MovieClip>;
			
			for (var i : uint = 0; i < opcoesText.length; i++) {
				opcoes[i] = new MovieClip();
				var icon : UILoader = new UILoader();
				icon.maintainAspectRatio = true;
				icon.scaleContent = false;
				icon.width = 32;
				icon.height = 32;
				icon.source = "media/parametros/data7_32.png";
				icon.x = 0;
				icon.y = 50 + i*(32 + 25);
				icon.alpha = 0.8;
				icon.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
				icon.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
				icon.addEventListener(MouseEvent.CLICK, mouseClick);
				opcoes[i].addChild(icon);
				
				var label : TextField = new TextField();
				label.defaultTextFormat = Pretty.BODY_BOLD;
	
				label.text = opcoesText[i];
				label.visible = false;
				opcoes[i].addChild(label);
	
				addChild(opcoes[i]);
			}
			
			_miniJogoCoolDownCounter = new TextField();
			_miniJogoCoolDownCounter.defaultTextFormat = Pretty.BODY;
			_miniJogoCoolDownCounter.y = 50 + 1*(32 + 25);
			if (_mainGame.miniJogoCoolDown <= 0)
				_miniJogoCoolDownCounter.visible = false;
			else
				_miniJogoCoolDownCounter.text = "" + _mainGame.miniJogoCoolDown;

			
			_miniJogoCoolDownCounter.width = 32;
			_miniJogoCoolDownCounter.height = 32;
			addChild(_miniJogoCoolDownCounter);
			
			
			
		
			
		}
		
		
		public function get miniJogoCoolDownCounter():TextField
		{
			return _miniJogoCoolDownCounter;
		}

		public function set miniJogoCoolDownCounter(value:TextField):void
		{
			_miniJogoCoolDownCounter = value;
		}

		private function mouseOver (e : MouseEvent) {
			e.currentTarget.parent.getChildAt(1).visible = true;
			e.currentTarget.parent.getChildAt(1).x = e.currentTarget.x + e.target.width + 10;
			e.currentTarget.parent.getChildAt(1).y = e.currentTarget.y + e.target.height/2 - e.currentTarget.parent.getChildAt(1).textHeight/2;
			
			
			e.currentTarget.alpha = 1;
		}
		
		private function mouseOut (e : MouseEvent) {
			e.currentTarget.parent.getChildAt(1).visible = false;
			e.currentTarget.alpha = 0.8;

		}
		
		private function mouseClick (e : MouseEvent) {
			if (e.currentTarget.parent == opcoes[0])
				_opcaoEscolhida = 0;
			else if (e.currentTarget.parent == opcoes[1])
				_opcaoEscolhida = 1;
			else if (e.currentTarget.parent == opcoes[2])
				_opcaoEscolhida = 2;
			else if (e.currentTarget.parent == opcoes[3])
				_opcaoEscolhida = 3;
			else if (e.currentTarget.parent == opcoes[4])
				_opcaoEscolhida = 4;
			
			if (_opcaoEscolhida != 1 || _opcaoEscolhida == 1 && _mainGame.miniJogoCoolDown == 0) {
				var tween : Tween = new Tween(this, "x", Strong.easeInOut, 10, -40, 0.25, true);
				new Tween(_mainGame.menuButton, "x", Strong.easeInOut, _mainGame.menuButton.x, -40, 0.25, true);
				tween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinish);
			}
			else
				trace ("MINI JOGO EM COOLDOWN - DISPONIVEL EM " + _mainGame.miniJogoCoolDown + " segundos");
		
			
		}
		
		private function abreOpcao(e : TweenEvent) {
			var voltarButton : UILoader = new UILoader();
			voltarButton.maintainAspectRatio = true;
			voltarButton.scaleContent = false;
			voltarButton.source = "media/header/backArrow_20.png";
			voltarButton.x = -40;
			voltarButton.y = 10;
			voltarButton.addEventListener(MouseEvent.CLICK, voltarButtonClick);
			voltarButton.addEventListener(MouseEvent.MOUSE_OVER, _mainGame.overButton);
			voltarButton.addEventListener(MouseEvent.MOUSE_OUT, _mainGame.outButton);
			_mainGame.mainMovieClip.addChild(voltarButton);
			
			new Tween(voltarButton, "x", Strong.easeInOut, -40, 10, 0.5, true);
			
			if (_opcaoEscolhida == 0) {
				_mainGame.laboratorio.visible = true;
				_mainGame.container.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.mainMovieClip.background.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.mainMovieClip.alienPlanet.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
			}	
			else if (_opcaoEscolhida == 1) {
				_miniJogo1 = new MiniJogo1(_mainGame.planeta, _mainGame);
				_mainGame.mainMovieClip.addChild(_miniJogo1);
				_mainGame.container.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.mainMovieClip.background.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.mainMovieClip.alienPlanet.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
			}
			
			else if (_opcaoEscolhida == 2) {
				_settings = new SettingsPanel(_mainGame.mainMovieClip);
				_mainGame.mainMovieClip.addChild(_settings);
				_mainGame.container.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.mainMovieClip.background.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.mainMovieClip.alienPlanet.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
			}
			else if (_opcaoEscolhida == 3) {
				_scrollPaneHelp = new ScrollPane();
				_scrollPaneHelp.y = 40;
				_scrollPaneHelp.height = 325;
				_scrollPaneHelp.width = 640;
				_scrollPaneHelp.horizontalScrollPolicy = ScrollPolicy.OFF;
				
				
				var helpText : TextField = new TextField();
				helpText.width = _scrollPaneHelp.width;
				//helpText.height = 200;

				helpText.defaultTextFormat = Pretty.BODY;
				//helpText.opaqueBackground = Pretty.COLOR_POPUP;
				helpText.wordWrap = true;
				helpText.text = "fdsafkdsafjlasdjfkldsajf ljsdakfj lsadkfjks dajflsdajkfjsdaklfjlasdj lfjdsklf jldsjflksda jflksajdlfkjasdlfjlsd jflkasdjfljsdlkfjsa lkjflkjsdfkljsd lkfjas ljfla  sjdkfljaslkfjklasdjfklajsklfjasklfjkl sadjfklasj fkljasklfjklsajf  klasjkfjklsajflksjkf ljsdklafj lsdfjçs lkjflasfs";
				
				_scrollPaneHelp.source = helpText;
				_mainGame.mainMovieClip.addChild(_scrollPaneHelp); 
				_mainGame.container.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.mainMovieClip.background.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.mainMovieClip.alienPlanet.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
			}
			else if (_opcaoEscolhida == 4) {
				stage.removeChild(_mainGame.mainMovieClip);
				var newMovieClip : MovieClip = new MovieClip();
				stage.addChild(newMovieClip);
				new Menu(newMovieClip);
			}
			
			
			
		}
		
		private function voltarButtonClick (e : MouseEvent) {
			var tween : Tween = new Tween(e.currentTarget, "x", Strong.easeInOut, 10, -40, 0.25, true);
			tween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinishVoltar);
			
			if (_opcaoEscolhida == 0) {
				_mainGame.laboratorio.visible = false;

			}
			else if (_opcaoEscolhida == 1) {
				_mainGame.mainMovieClip.removeChild(_miniJogo1);
			}
			
			else if (_opcaoEscolhida == 2) {
				_mainGame.mainMovieClip.removeChild(_settings);
			}
			
			else if (_opcaoEscolhida == 3) {
				_mainGame.mainMovieClip.removeChild(_scrollPaneHelp);
			}
			
			else if (_opcaoEscolhida == 4) {
				_mainGame.mainMovieClip.removeChild(_miniJogo1);
			}
			
			
			_mainGame.container.filters = [];
			_mainGame.mainMovieClip.background.filters = [];
			_mainGame.mainMovieClip.alienPlanet.filters = [];

		}
		
		private function tweenFinishVoltar (e : TweenEvent) {
			new Tween(_mainGame.menuButton, "x", Strong.easeInOut, -40, 10, 0.5, true);

		}
		private function tweenFinish (e : TweenEvent) {
			_mainGame.tweenFinish(e);
			abreOpcao(e);
		}
		
		
	}
}