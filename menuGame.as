package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import fl.containers.ScrollPane;
	import fl.containers.UILoader;
	import fl.controls.List;
	import fl.controls.ScrollPolicy;
	import fl.controls.TextArea;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Strong;
	
	/**
	 * A classe MenuGame representa graficamente o menu do jogo.
	 */
	public class MenuGame extends MovieClip
	{

		
		private var opcoes : Vector.<MovieClip>;
		
		private var _mainGame : MainGame;
		
		private var _opcaoEscolhida : uint;
		
		private var _miniJogo1 : MiniJogo1;
		private var _settings : SettingsPanel;
		private var _scrollPaneHelp : ScrollPane;
		private var _podio : LoadDialog;
		
		private var _miniJogoCoolDownCounter : TextField;
		
		private var tween1 : Tween;
		private var tween2 : Tween;
		
		private var voltarButton : UILoader;
		
		private var _htmlTextAjuda : String;
		
		
		public function MenuGame(mainGame : MainGame)
		{
			super();
			_mainGame = mainGame;
			
			
			
			// Loading dos dados do planeta
			//var dataPlanetas:XML = new XML();
			var loaderAjuda:URLLoader = new URLLoader();
			loaderAjuda.load(new URLRequest("data/ajudaHTML.txt"));			
			loaderAjuda.addEventListener(Event.COMPLETE, carregaAjuda);	

			var opcoesText : Vector.<String> = new <String>["Laboratório", "Expedição", "Configurações", "Ajuda", "Ranking", "Reiniciar Nível"];
			opcoes = new Vector.<MovieClip>;
			
			
			for (var i : uint = 0; i < opcoesText.length; i++) {
				opcoes[i] = new MovieClip();
				var icon : UILoader = new UILoader();
				icon.maintainAspectRatio = true;
				icon.scaleContent = false;
				icon.width = 32;
				icon.height = 32;
				icon.source = "media/menu/menu" + i + "_32.png";
				icon.x = 0;
				icon.y = 50 + i*(32 + 20);		//32 + 25
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
			
			// se jogo em cooldown, atualiza a sua barra de progresso
			if (_mainGame.miniJogoCoolDown > 0)
				atualizaBarraCooldown();
			
			
		}
		
		private function carregaAjuda(e : Event) {
			_htmlTextAjuda = e.target.data;
		}
		
		public function atualizaBarraCooldown() {
			graphics.clear();
			graphics.lineStyle(5, 0xFF0000, 1, false, "normal", null);
			graphics.moveTo(0, 50+32+20+32+2);
			graphics.lineTo(_mainGame.miniJogoCoolDown*32/MiniJogo1.COOLDOWN, 50+32+20+32+2);
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
			else if (e.currentTarget.parent == opcoes[5])
				_opcaoEscolhida = 5;
			
			if ((_opcaoEscolhida != 1) || (_opcaoEscolhida == 1 && _mainGame.miniJogoCoolDown == 0 && _mainGame.timerUpdate.running)) {
				tween1 = new Tween(this, "x", Strong.easeInOut, 10, -40, 0.25, true);
				tween2 = new Tween(_mainGame.menuButton, "x", Strong.easeInOut, _mainGame.menuButton.x, -40, 0.25, true);
				tween1.addEventListener(TweenEvent.MOTION_FINISH, tweenFinish);
			}
			else if (!_mainGame.timerUpdate.running)
				trace("ESTA FUNCAO NAO E' VALIDA COM A SIMULACAO EM PAUSA");
			else
				trace ("MINI JOGO EM COOLDOWN - DISPONIVEL EM " + _mainGame.miniJogoCoolDown + " segundos");
		
			
		}
		
		private function abreOpcao() {
			if (_opcaoEscolhida != 5) {
				voltarButton = new UILoader();
				voltarButton.maintainAspectRatio = true;
				voltarButton.scaleContent = false;
				voltarButton.source = "media/header/backArrow_20.png";
				voltarButton.x = -40;
				voltarButton.y = 10;
				voltarButton.addEventListener(MouseEvent.CLICK, voltarButtonClick);
				voltarButton.addEventListener(MouseEvent.MOUSE_OVER, _mainGame.overButton);
				voltarButton.addEventListener(MouseEvent.MOUSE_OUT, _mainGame.outButton);
				_mainGame.mainMovieClip.addChild(voltarButton);
				
				_mainGame.menuButton.visible = false;
			
				tween2 = new Tween(voltarButton, "x", Strong.easeInOut, -40, 10, 0.5, true);
			}
			if (_opcaoEscolhida == 0) {
				_mainGame.laboratorio.visible = true;
				_mainGame.terceiraCamada.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.mainMovieClip.background.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
			}	
			else if (_opcaoEscolhida == 1) {
				_miniJogo1 = new MiniJogo1(_mainGame.planeta, _mainGame);
				_mainGame.mainMovieClip.addChild(_miniJogo1);
				//_mainGame.primeiraCamada.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.segundaCamada.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.terceiraCamada.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];			
				_mainGame.mainMovieClip.background.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
			}
			
			else if (_opcaoEscolhida == 2) {
				_settings = new SettingsPanel(_mainGame.mainMovieClip);
				_settings.resetJogadoresButton.enabled = false;
				_settings.resetJogadoresButton.visible = false;
				_mainGame.mainMovieClip.addChild(_settings);
				_mainGame.primeiraCamada.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.segundaCamada.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.terceiraCamada.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];			
				_mainGame.mainMovieClip.background.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
			}
			else if (_opcaoEscolhida == 3) {
				_scrollPaneHelp = new ScrollPane();
				_scrollPaneHelp.y = 40;
				_scrollPaneHelp.height = 325;
				_scrollPaneHelp.width = 640;
				_scrollPaneHelp.horizontalScrollPolicy = ScrollPolicy.OFF;
				
				
				var helpText : TextField = new TextField();
				helpText.width = _scrollPaneHelp.width - 20;

				helpText.defaultTextFormat = Pretty.BODY;
				helpText.wordWrap = true;
				helpText.htmlText = _htmlTextAjuda;
				helpText.height = helpText.textHeight + 100;
				_scrollPaneHelp.source = helpText;
				helpText.x = 10;

				
				_mainGame.mainMovieClip.addChild(_scrollPaneHelp); 
				_mainGame.terceiraCamada.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.mainMovieClip.background.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
			}
			else if (_opcaoEscolhida == 4) {
				_podio = new LoadDialog(_mainGame.mainMovieClip);
				
				var jogadores : Array = new Array();

				var sharedObject : SharedObject = SharedObject.getLocal("TerraNovaSaved");			
				
	
				for (var j : uint = 0; j < sharedObject.data.jogadores.length; j++) {
					if (sharedObject.data.jogadores[j].temposMaximos.length >= _mainGame.nivel) {
						jogadores.push({nome:sharedObject.data.jogadores[j].nome, tempo:(sharedObject.data.jogadores[j].temposMaximos[_mainGame.nivel-1])});
					}
				}
			
				jogadores.sortOn("tempo", Array.NUMERIC);
				
				for (var k : uint = 0; k < jogadores.length; k++) {
					_podio.list.addItem({label: jogadores[k].nome + "\t\t" + jogadores[k].tempo, data: k});
				}
				
				var imagem : UILoader = new UILoader();
				imagem.scaleContent = false;
				imagem.source = "media/menu/podium_114.png";
				imagem.alpha = 0.8;
				imagem.x = _mainGame.mainMovieClip.stage.stageWidth/2 - 114/2;
				imagem.y = _mainGame.mainMovieClip.stage.stageHeight/2 - 210;
				_podio.addChild(imagem);
				
				_podio.list.selectable = false;
				
				_podio.alpha = 0.9;
				
				_mainGame.mainMovieClip.addChild(_podio);
				_mainGame.primeiraCamada.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.segundaCamada.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.terceiraCamada.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
				_mainGame.mainMovieClip.background.filters = [new BlurFilter(10,10,BitmapFilterQuality.HIGH)];
			}
			
			else if (_opcaoEscolhida == 5) {

				_mainGame.soundChannel.stop();
				_mainGame.reset();
				
				_mainGame.menuButton.visible = true;
				tween2 = new Tween(_mainGame.menuButton, "x", Strong.easeInOut, -40, 10, 0.5, true);
				
			}
			
			
			
		}
		
		private function voltarButtonClick (e : MouseEvent) {
			tween2 = new Tween(e.currentTarget, "x", Strong.easeInOut, 10, -40, 0.25, true);
			tween2.addEventListener(TweenEvent.MOTION_FINISH, tweenFinishVoltar);
			
			if (_opcaoEscolhida == 0) {
				_mainGame.laboratorio.visible = false;

			}
			else if (_opcaoEscolhida == 1) {
				_mainGame.mainMovieClip.removeChild(_miniJogo1);
				_mainGame.miniJogoCoolDown = MiniJogo1.COOLDOWN;
			}
			
			else if (_opcaoEscolhida == 2) {
				_mainGame.mainMovieClip.removeChild(_settings);
			}
			
			else if (_opcaoEscolhida == 3) {
				_mainGame.mainMovieClip.removeChild(_scrollPaneHelp);
			}
			
			else if (_opcaoEscolhida == 4) {
				_mainGame.mainMovieClip.removeChild(_podio);
			}

			
			
			_mainGame.primeiraCamada.filters = [];
			_mainGame.segundaCamada.filters = [];
			_mainGame.terceiraCamada.filters = [];
			_mainGame.mainMovieClip.background.filters = [];

		}
		
		private function tweenFinishVoltar (e : TweenEvent) {
			_mainGame.menuButton.visible = true;

			tween2 = new Tween(_mainGame.menuButton, "x", Strong.easeInOut, -40, 10, 0.5, true);
			_mainGame.mainMovieClip.removeChild(voltarButton);


		}
		private function tweenFinish (e : TweenEvent) {
			_mainGame.tweenFinish(e);
			abreOpcao();
		}
		
		
	}
}