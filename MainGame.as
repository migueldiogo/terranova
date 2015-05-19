package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.drm.AddToDeviceGroupSetting;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import fl.containers.ScrollPane;
	import fl.containers.UILoader;
	import fl.controls.Button;
	import fl.controls.ScrollPolicy;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;
	import fl.transitions.easing.Strong;

	
	public class MainGame {
		private var _container : MovieClip;
		
		private var clock : uint;
		private var clockDisplay : TextField;
		
		private var _planeta : Planeta;
		//private var terra : Planeta;
		private var _laboratorio : ScrollPane;
		
		private var menuGame : MenuGame;
		
		private var _headerRecursos : Sprite;
		private var _minerioTextField : TextField;
		private var _energiaTextField : TextField;
		private var _minerioIcon : UILoader;
		private var _energiaIcon : UILoader;
		private var _menuButton : UILoader;
		
		private var pauseAndPlayButton : PausePlayButton;
		
		private var timerUpdate : Timer;
		
		
		
		private var _mainMovieClip : MovieClip;
		
		private var _nivel : uint;
		private var _jogador : Jogador;
		private var _pontuacaoRecordGlobal : uint;
		
		private var vitoria : Boolean;
		
		public function MainGame(mainMovieClip : MovieClip = null, nivel : uint = NaN, jogador : Jogador = null, pontuacaoRecordGlobal : uint = 0) {
			_container = new MovieClip();
			_mainMovieClip = mainMovieClip;
			_jogador = jogador;
			_pontuacaoRecordGlobal = pontuacaoRecordGlobal;
			
			_laboratorio = new ScrollPane();
			
				
				
			_nivel = nivel;

			_mainMovieClip.gotoAndStop("MainGame");
			vitoria = false;
			
			clock = 0;
			clockDisplay = new TextField();
			clockDisplay.text = intToTime(clock);
			
			// se jogador ja jogou este nivel, carrega da memoria, se nao cria novo planeta com reset = true
			trace("NIVEL: " + _nivel + " planetas.length = " + _jogador.pontuacoesMaximas.length);
			_planeta = new Planeta(this, _jogador, _nivel, true);
			
			_planeta.resetPlaneta();


			//_jogador.planetas.push(planeta);
			
			_mainMovieClip.addChild(_container);
			
		}
		


		public function get planeta():Planeta
		{
			return _planeta;
		}

		public function set planeta(value:Planeta):void
		{
			_planeta = value;
		}

		public function get menuButton():UILoader
		{
			return _menuButton;
		}

		public function set menuButton(value:UILoader):void
		{
			_menuButton = value;
		}

		public function get laboratorio():ScrollPane
		{
			return _laboratorio;
		}

		public function set laboratorio(value:ScrollPane):void
		{
			_laboratorio = value;
		}

		public function get mainMovieClip():MovieClip
		{
			return _mainMovieClip;
		}

		public function set mainMovieClip(value:MovieClip):void
		{
			_mainMovieClip = value;
		}

		/**
		 * Instancializa ecrã.
		 */
		public function init() : void {

			// importa e formata dados do planeta para o ecra
			importaDadosDoPlaneta();
			
			
			// TECNOLOGIAS PANEL
			//laboratorio.opaqueBackground = Pretty.COLOR_PURPLE_1;			
			_laboratorio.y = 40;
			_laboratorio.height = 325;
			_laboratorio.width = 640;
			_laboratorio.horizontalScrollPolicy = ScrollPolicy.OFF;
			_laboratorio.visible = false;

			// importa e formata tecnologias do planeta para o ecra
			importaTecnologiasDoPlaneta();
	
			
			
			// BUTAO MENU
			_menuButton = new UILoader;
			_menuButton.maintainAspectRatio = true;
			_menuButton.scaleContent = false;
			_menuButton.source = "media/header/menu_20.png";
			_menuButton.x = 10;
			_menuButton.y = 10;
			_menuButton.addEventListener(MouseEvent.CLICK, menuButtonClick);
			_menuButton.addEventListener(MouseEvent.MOUSE_OVER, overButton);
			_menuButton.addEventListener(MouseEvent.MOUSE_OUT, outButton);
	
			_container.addChild(_menuButton);

			
			// RECURSOS
			_headerRecursos = new Sprite();

			_minerioIcon = new UILoader();
			_minerioIcon.scaleContent = false;
			_minerioIcon.maintainAspectRatio = true;
			_minerioIcon.source = "media/header/minerio_32.png";
			_minerioIcon.x = 0;
			_minerioIcon.y = 0;
			_headerRecursos.addChild(_minerioIcon);
			
			_minerioTextField = new TextField();
			_minerioTextField.defaultTextFormat = Pretty.HEADING_1;
			_minerioTextField.selectable = false;
			_minerioTextField.text = "Minerio: " + _planeta.recursos.minerio;
			_minerioTextField.width = _minerioTextField.textWidth + 10;
			_minerioTextField.height = _minerioTextField.textHeight + 3;

			_minerioTextField.x = 32 + 5;
			_minerioTextField.y = 4;
			_headerRecursos.addChild(_minerioTextField);
	

			_energiaIcon = new UILoader();
			_energiaIcon.scaleContent = false;
			_energiaIcon.maintainAspectRatio = true;
			_energiaIcon.source = "media/header/energia_32.png";
			_energiaIcon.x = _minerioTextField.x + _minerioTextField.width + 10;
			_energiaIcon.y = 0;
			_headerRecursos.addChild(_energiaIcon);
			
			
			_energiaTextField = new TextField();
			_energiaTextField.defaultTextFormat = Pretty.HEADING_1;
			_energiaTextField.selectable = false;
			_energiaTextField.text = "Energia: " + _planeta.recursos.energia;
			_energiaTextField.width = _energiaTextField.textWidth + 10;
			_energiaTextField.height = _energiaTextField.textHeight + 3;
			_energiaTextField.x = _energiaIcon.x + 32 + 5;
			_energiaTextField.y = _minerioTextField.y;
			_headerRecursos.addChild(_energiaTextField);
			
			_headerRecursos.x = mainMovieClip.stage.stageWidth/2 - _headerRecursos.width/2;
			_headerRecursos.y = 5;
			_container.addChild(_headerRecursos);
	
			// CLOCK DISPLAY
			clockDisplay.x = 550;
			clockDisplay.y = 5;
			clockDisplay.height = 30;
			clockDisplay.defaultTextFormat = Pretty.HEADING_1;
			clockDisplay.text = intToTime(clock);
			_container.addChild(clockDisplay);

			var clockIcon : UILoader = new UILoader();
			clockIcon.scaleContent = false;
			clockIcon.maintainAspectRatio = true;
			clockIcon.source = "media/header/time.png";
			clockIcon.x = clockDisplay.x - 20;
			clockIcon.y = 8;
			_container.addChild(clockIcon);
			
			// PAUSE AND PLAY BUTTON
			pauseAndPlayButton = new PausePlayButton();
			pauseAndPlayButton.buttonMode = true;
			pauseAndPlayButton.addEventListener(MouseEvent.CLICK, pauseAndPlayButtonClicked);
			pauseAndPlayButton.scaleX = 0.5;
			pauseAndPlayButton.scaleY = 0.5;
			pauseAndPlayButton.x = _mainMovieClip.stage.stageWidth - pauseAndPlayButton.width - 25;
			pauseAndPlayButton.y = 6;
			_container.addChild(pauseAndPlayButton);

			
		}
		
		public function overButton (e: MouseEvent) {
			e.currentTarget.alpha = 0.8;
		}
		
		public function outButton (e: MouseEvent) {
			e.currentTarget.alpha = 1;
		}
		
		

		/**
		 * Timer para a atualizção da simulação.
		 * @see atualizaSimulacao
		 */
		public function setTimer() : void {
			timerUpdate = new Timer(1000, 1);
			timerUpdate.addEventListener(TimerEvent.TIMER_COMPLETE, atualizaSimulacao);
			timerUpdate.start();
		}
		
		private function intToTime(clock : uint) : String {
			var seconds : int = Math.floor(clock);
			var minutes : int = Math.floor(seconds/60);
			seconds -= minutes*60;
			
			return minutes + ":" + String(seconds+100).substr(1,2);
		}
		
		/**
		 * verifica vitoria
		 */
		public function verificaVitoria() : Boolean {
			var vitoria : Boolean = true;
			for (var i : uint = 0; i < _planeta.dados.length && vitoria; i++) {
				if (_planeta.dados[i].correto == false)
					vitoria = false;
				trace(_planeta.dados[i].nome + " " + _planeta.dados[i].correto);
			}
			
			return vitoria;
		}
		
		private function atualizaLayoutRecursos() {
			// RECURSOS
			_minerioTextField.text = "Minerio: " + _planeta.recursos.minerio;
			_minerioTextField.width = _minerioTextField.textWidth + 10;
					
			_energiaIcon.x = _minerioTextField.x + _minerioTextField.width + 10;

			_energiaTextField.text = "Energia: " + _planeta.recursos.energia;
			_energiaTextField.width = _energiaTextField.textWidth + 10;
			_energiaTextField.x = _energiaIcon.x + 32 + 5;
			_energiaTextField.y = _minerioTextField.y;
			
			_headerRecursos.addChild(_energiaTextField);
			_headerRecursos.x = mainMovieClip.stage.stageWidth/2 - _headerRecursos.width/2;
			
		}
		
		/**
		 * Atualiza os dados apresentados no ecra (label, butoes ativados). Pode ser despoletada por um timer ou de forma forçada com limitações.
		 */
		public function atualizaSimulacao (e : Event) {
			// incrementa recursos so quando a funcao for despoletada pelo temporizador 
			if (e != null) {
				_planeta.recursos.minerio += _planeta.dados[Planeta.TAXA_MINERIO].valor;
				clock++;
				clockDisplay.text = intToTime(clock);
				
				setTimer();

			}
			
			atualizaLayoutRecursos();
			_minerioTextField.text = "Minerio: " + _planeta.recursos.minerio;
			_energiaTextField.text = "Energia: " + _planeta.recursos.energia;
			
			for (var i : uint = 0; i < _planeta.tecnologias.length; i++) {
				// se recursos nao chegam para evolucao de tecnologia ou o tempo esta parado, entao desativa tecnologia(s)
				if (Math.abs(_planeta.tecnologias[i].custoMinerioAtual) > _planeta.recursos.minerio || !timerUpdate.running) {
					_planeta.tecnologias[i].evoluirButton.enabled = false;
					_planeta.tecnologias[i].demolirButton.enabled = false;

					//planeta.tecnologias[i].nivelButtons.buttonMode = false;
					_planeta.tecnologias[i].evoluirButton.removeEventListener(MouseEvent.CLICK, _planeta.tecnologias[i].evoluiTecnologia);
					_planeta.tecnologias[i].demolirButton.removeEventListener(MouseEvent.CLICK, _planeta.tecnologias[i].vendeTecnologia);
					
				}
				else {
					_planeta.tecnologias[i].evoluirButton.enabled = true;
					_planeta.tecnologias[i].demolirButton.enabled = (_planeta.tecnologias[i].nivel == 0) ? false : true;
					_planeta.tecnologias[i].evoluirButton.addEventListener(MouseEvent.CLICK, _planeta.tecnologias[i].evoluiTecnologia);
					_planeta.tecnologias[i].demolirButton.addEventListener(MouseEvent.CLICK, _planeta.tecnologias[i].vendeTecnologia);
					
					
					// gerador de catastrofes
					if (Math.random() < _planeta.dados[Planeta.METEORITOS].valor)
						trace("ACONTECEU METEORITO");
					if (Math.random() < _planeta.dados[Planeta.TSUNAMI].valor)
						trace("ACONTECEU TSUNAMI");
					if (Math.random() < _planeta.dados[Planeta.VULCOES].valor)
						trace("ACONTECEU ERUPCAO");
				}

			}	
			
			
			
			// INCOMPLETO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			if (verificaVitoria()) {
				vitoria = true;
				_planeta.habitavel = true;
				_laboratorio.visible = false;
				
				timerUpdate.stop();
				var pontuacaoRecordPessoal : uint;
				
				
				_mainMovieClip.removeChild(_container);
				if (_jogador.pontuacoesMaximas.length < _nivel) {
					pontuacaoRecordPessoal = 0;
					_jogador.pontuacoesMaximas.push(clock);
				}
				
				else {
					pontuacaoRecordPessoal = _jogador.pontuacoesMaximas[_nivel-1];

					// record pessoal
					if (_jogador.pontuacoesMaximas[_nivel-1] > clock) {
						_jogador.pontuacoesMaximas[_nivel-1] = clock;
						
					}
				}
			
				/*
				if (_jogador.proximoNivel == _nivel)
					_jogador.proximoNivel++;*/
				
				var gameReport : GameReport = new GameReport(_mainMovieClip, _pontuacaoRecordGlobal, pontuacaoRecordPessoal, clock);
				gameReport.addEventListener(MouseEvent.CLICK, nextLevelButton);
				_mainMovieClip.addChild(gameReport);

				_container.filters = [new BlurFilter(10, 10, BitmapFilterQuality.HIGH)];

				// atualiza ficheiro sharedObject em disco com dados do jogador atualizados
				var sharedObject : SharedObject = SharedObject.getLocal("TerraNovaSaved");
				var encontrado : Boolean = false;
				for (var k : uint = 0; k < sharedObject.data.jogadores.length && !encontrado; k++) {
					if (_jogador.nome == sharedObject.data.jogadores[k].nome) {
						encontrado = true;
						sharedObject.data.jogadores[k] = new Jogador(_jogador.nome, _jogador.pontuacoesMaximas);
						sharedObject.flush();
					}
				}
				
				
				trace("VITORIA");
				
			}

			
		}

		
		private function nextLevelButton(e : MouseEvent) {
			_mainMovieClip.removeChild(e.target.parent);
			
			new Niveis(_mainMovieClip, _jogador);
		}
		
		/**
		 * Funcao despoletadora do click do butao de laboratorio
		 */
		public function menuButtonClick (e : MouseEvent) {
			var tween : Tween;
			if (menuGame == null) {
				menuGame = new MenuGame(this);
				_mainMovieClip.addChild(menuGame);
				tween = new Tween(menuGame, "x", Strong.easeInOut, -40, 10, 0.5, true);
				tween.start();
	
			}
			else {
				tween = new Tween(menuGame, "x", Strong.easeInOut, 10, -40, 0.5, true);
				//new Tween(_menuButton, "x", Strong.easeInOut, _menuButton.x, -40, 0.5, true);

				tween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinish);
				tween.start();

			}
			
		}
		
		public function tweenFinish (e : TweenEvent) {
			if (menuGame != null) {
				_mainMovieClip.removeChild(menuGame);
				menuGame = null;
		}
			
			
			
			/*
			if (laboratorio.visible) {
				laboratorio.visible = false;
				//laboratorio.removeEventListener( MouseEvent.MOUSE_WHEEL, mouseScrollLaboratorio);

				_mainMovieClip.background.filters = [];
				_mainMovieClip.alienPlanet.filters = [];

			}
			else {
				laboratorio.visible = true;
				
				//laboratorio.addEventListener( MouseEvent.MOUSE_WHEEL, mouseScrollLaboratorio);
				
				_mainMovieClip.background.filters = [new BlurFilter(64, 64, BitmapFilterQuality.HIGH)];
				_mainMovieClip.alienPlanet.filters = [new BlurFilter(64, 64, BitmapFilterQuality.HIGH)];
			}
			*/
		}
		
		
		
		
		
		/**
		 * Importa e formata dados do planeta
		 */
		private function importaDadosDoPlaneta () {
		
			// escreve os dados do planeta
			var contadorColunas : uint = 0;
			var contadorLinhas : uint = 0;
			for (var i : uint = 0; i<_planeta.dados.length; i++) {
				trace(_planeta.dados[i].nome);
				_planeta.nivel = i+1;
				_planeta.dados[i].x = 10 + 160*contadorColunas;
				_planeta.dados[i].y = 370 + contadorLinhas * 35;
				_planeta.dados[i].nomeValorTextField.width = 120;
				_container.addChild(_planeta.dados[i]);
				
				// ajustar em colunas 
				if (contadorColunas >= 3) {
					contadorColunas = 0;
					contadorLinhas++;
				}
				else {
					contadorColunas++;
				}
				
				_planeta.dados[i].verificaDado();
			}
			
						
			
			
		}
	
			
			
		
		/**
		 * Importa e formata tecnologias do planeta
		 */
		private function importaTecnologiasDoPlaneta () {
			
			var tecnologiasContainer : MovieClip = new MovieClip();

			for (var i : uint = 0; i<_planeta.tecnologias.length; i++) {
				
				// layout
				_planeta.tecnologias[i].y = i*163.95;
				_planeta.tecnologias[i].x = 0;

				
				tecnologiasContainer.addChild(_planeta.tecnologias[i]);
				
				
				_laboratorio.source = tecnologiasContainer;
				
				_container.addChild(_laboratorio);
			}
			setTimer();
			
		}
		
		
		function completeHandler(event:Event) { 
			trace("Number of bytes loaded: " + event.target.bytesLoaded); 
		}
		
		private function pauseAndPlayButtonClicked(e : MouseEvent) {
			
			if (pauseAndPlayButton.isPause()) {
				// PAUSE SIMULATION
				pauseAndPlayButton.setPlay();
				timerUpdate.stop();
				atualizaSimulacao(null);
			}
			else {
				// RESUME SIMULATION
				pauseAndPlayButton.setPause();
				timerUpdate.start();
				atualizaSimulacao(null);
				
			}
		}
		
		private function mouseScrollLaboratorio(e : MouseEvent) {
			if( _laboratorio !== null )
			{
				_laboratorio.verticalScrollPosition += - ( e.delta * 8 );
			}
		}
		
		
	}
		

	
}
