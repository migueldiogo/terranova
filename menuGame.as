package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	
	import fl.containers.UILoader;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Strong;
	
	public class MenuGame extends MovieClip
	{
		var opcoes : Vector.<MovieClip>;
		var _expedicao : Array;
		var _settings : Array;
		
		var _laboratorioTextField : TextField;
		var _expedicaoTextField : TextField;
		var _settingsTextField : TextField;
		
		var _mainGame : MainGame;
		
		var _opcaoEscolhida : uint;
		
		
		var miniJogo1 : MiniJogo1;
		
		public function MenuGame(mainGame : MainGame)
		{
			super();
			_mainGame = mainGame;
			
			var opcoesText : Vector.<String> = new <String>["Laboratório", "Expedição", "Configurações"];
			opcoes = new Vector.<MovieClip>;
			
			for (var i : uint = 0; i < 3; i++) {
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
				_opcaoEscolhida = 0;
			
			var tween : Tween = new Tween(this, "x", Strong.easeInOut, 10, -40, 0.5, true);
			new Tween(_mainGame.menuButton, "x", Strong.easeInOut, _mainGame.menuButton.x, -40, 0.5, true);
			tween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinish);
			
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
				_mainGame.mainMovieClip.background.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.mainMovieClip.alienPlanet.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
			}	
			else if (_opcaoEscolhida == 1) {
				miniJogo1 = new MiniJogo1(_mainGame.planeta);
				_mainGame.mainMovieClip.addChild(miniJogo1);
				_mainGame.mainMovieClip.background.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.mainMovieClip.alienPlanet.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
			}
			
			
		}
		
		private function voltarButtonClick (e : MouseEvent) {
			var tween : Tween = new Tween(e.currentTarget, "x", Strong.easeInOut, 10, -40, 0.5, true);
			tween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinishVoltar);
			
			if (_opcaoEscolhida == 0) {
				_mainGame.laboratorio.visible = false;
				
				//laboratorio.removeEventListener( MouseEvent.MOUSE_WHEEL, mouseScrollLaboratorio);
				

			}
			else if (_opcaoEscolhida == 1) {
				_mainGame.mainMovieClip.removeChild(miniJogo1);
				_mainGame.mainMovieClip.background.filters = [new BlurFilter(0,10,BitmapFilterQuality.HIGH)];
				_mainGame.mainMovieClip.alienPlanet.filters = [new BlurFilter(0,10,BitmapFilterQuality.HIGH)];
			}
			
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