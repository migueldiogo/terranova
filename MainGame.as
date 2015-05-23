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
	import flash.geom.Rectangle;
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
		
		private var _clock : uint;
		private var _clockDisplay : TextField;
		
		private var _planeta : Planeta;
		//private var terra : Planeta;
		private var _laboratorio : ScrollPane;
		
		private var _menuGame : MenuGame;
		
		private var _headerRecursos : Sprite;
		private var _minerioTextField : TextField;
		private var _energiaTextField : TextField;
		private var _minerioIcon : UILoader;
		private var _energiaIcon : UILoader;
		private var _menuButton : UILoader;
		
		private var _pauseAndPlayButton : PausePlayButton;
		
		private var _timerUpdate : Timer;
		
		private var _miniJogoCoolDown : uint = 0;
		
		
		
		private var _mainMovieClip : MovieClip;
		
		private var _nivel : uint;
		private var _jogador : Jogador;
		private var _tempoRecordGlobal : uint;
		
		private var _notificacoesOnScreen : uint;
		private var _notificacoesSlotsFree : Vector.<Boolean>;
		
		private var _vitoria : Boolean;
		
		public function MainGame(mainMovieClip : MovieClip = null, nivel : uint = NaN, jogador : Jogador = null, tempoRecordGlobal : uint = 0) {
			_container = new MovieClip();
			_mainMovieClip = mainMovieClip;
			_jogador = jogador;
			_tempoRecordGlobal = tempoRecordGlobal;
			
			_laboratorio = new ScrollPane();
			_laboratorio.y = 40;
			_laboratorio.height = 325;
			_laboratorio.width = 640;
			_laboratorio.horizontalScrollPolicy = ScrollPolicy.OFF;
			_laboratorio.visible = false;

				
				
			_nivel = nivel;

			_mainMovieClip.gotoAndStop("MainGame");
			_vitoria = false;
			
			_clock = 0;
			_clockDisplay = new TextField();
			_clockDisplay.text = intToTime(_clock);
			
			// se jogador ja jogou este nivel, carrega da memoria, se nao cria novo planeta com reset = true
			trace("NIVEL: " + _nivel + " planetas.length = " + _jogador.temposMaximos.length);
			_planeta = new Planeta(this, _jogador, _nivel, true);
			
			_planeta.resetPlaneta();


			//_jogador.planetas.push(planeta);
			
			_mainMovieClip.addChild(_container);
			
		}
		


		public function get menuGame():MenuGame
		{
			return _menuGame;
		}

		public function set menuGame(value:MenuGame):void
		{
			_menuGame = value;
		}

		public function get container():MovieClip
		{
			return _container;
		}

		public function set container(value:MovieClip):void
		{
			_container = value;
		}

		public function get miniJogoCoolDown():uint
		{
			return _miniJogoCoolDown;
		}

		public function set miniJogoCoolDown(value:uint):void
		{
			_miniJogoCoolDown = value;
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
	
			_mainMovieClip.addChild(_menuButton);

			
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
			_mainMovieClip.addChild(_energiaTextField);
			
			_headerRecursos.x = mainMovieClip.stage.stageWidth/2 - _headerRecursos.width/2;
			_headerRecursos.y = 5;
			_mainMovieClip.addChild(_headerRecursos);
	
			// CLOCK DISPLAY
			_clockDisplay.x = 550;
			_clockDisplay.y = 5;
			_clockDisplay.height = 30;
			_clockDisplay.defaultTextFormat = Pretty.HEADING_1;
			_clockDisplay.text = intToTime(_clock);
			_mainMovieClip.addChild(_clockDisplay);

			var clockIcon : UILoader = new UILoader();
			clockIcon.scaleContent = false;
			clockIcon.maintainAspectRatio = true;
			clockIcon.source = "media/header/time.png";
			clockIcon.x = _clockDisplay.x - 20;
			clockIcon.y = 8;
			_mainMovieClip.addChild(clockIcon);
			
			// PAUSE AND PLAY BUTTON
			_pauseAndPlayButton = new PausePlayButton();
			_pauseAndPlayButton.buttonMode = true;
			_pauseAndPlayButton.addEventListener(MouseEvent.CLICK, pauseAndPlayButtonClicked);
			_pauseAndPlayButton.scaleX = 0.5;
			_pauseAndPlayButton.scaleY = 0.5;
			_pauseAndPlayButton.x = _mainMovieClip.stage.stageWidth - _pauseAndPlayButton.width - 25;
			_pauseAndPlayButton.y = 6;
			_mainMovieClip.addChild(_pauseAndPlayButton);
			
			_notificacoesOnScreen = 0;
			_notificacoesSlotsFree = new Vector.<Boolean>();
			_notificacoesSlotsFree[0] = true;
			_notificacoesSlotsFree[1] = true;
			_notificacoesSlotsFree[2] = true;
	
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
			_timerUpdate = new Timer(1000, 1);
			_timerUpdate.addEventListener(TimerEvent.TIMER_COMPLETE, atualizaSimulacao);
			_timerUpdate.start();
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
				_clock++;
				_clockDisplay.text = intToTime(_clock);
				
				// cooldown mini-jogo decrementa
				if (_miniJogoCoolDown > 0)
					_miniJogoCoolDown--;
				
				setTimer();

			}
			
			atualizaLayoutRecursos();
			_minerioTextField.text = "Minerio: " + _planeta.recursos.minerio;
			_energiaTextField.text = "Energia: " + _planeta.recursos.energia;
			
			for (var i : uint = 0; i < _planeta.tecnologias.length; i++) {
				// se recursos nao chegam para evolucao de tecnologia ou o tempo esta parado, entao desativa tecnologia(s)
				if (Math.abs(_planeta.tecnologias[i].custoMinerioAtual) > _planeta.recursos.minerio || !_timerUpdate.running) {
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
					
					var catastrofeTipo : Number = NaN;
					trace("---------------- " + Math.random());
					if (Math.random() < _planeta.dados[Planeta.METEORITOS].valor && _notificacoesOnScreen < 3) {
						trace("ACONTECEU METEORITO: " + _planeta.dados[Planeta.METEORITOS].valor);
						catastrofeTipo = Planeta.METEORITOS;
					}
					if (Math.random() < _planeta.dados[Planeta.TSUNAMI].valor && _notificacoesOnScreen < 3) {
						trace("ACONTECEU TSUNAMI");
						catastrofeTipo = Planeta.TSUNAMI;
 
					}
					if (Math.random() < _planeta.dados[Planeta.VULCOES].valor && _notificacoesOnScreen < 3) {
						trace("ACONTECEU ERUPCAO");
						catastrofeTipo = Planeta.VULCOES;

					}
					
					if (!isNaN(catastrofeTipo)) {
						_notificacoesOnScreen++;
						var slotEncontrado : Boolean = false;
						for (var m : uint = 0; m < _notificacoesSlotsFree.length && !slotEncontrado; m++) {
							slotEncontrado = _notificacoesSlotsFree[m];
						}
						
						_notificacoesSlotsFree[m-1] = false;
						
						
						var notificacaoCatastrofe : Notificacao = new Notificacao(_container, _mainMovieClip.stage.stageWidth, _clockDisplay.y + _clockDisplay.height + 10 + (m-1)*55, 200, 50, m-1);
						notificacaoCatastrofe.addEventListener(Notificacao.NOTIFICACAO_ACABOU, notificacaoOut);
						
						notificacaoCatastrofe.icon.source = "media/parametros/data" + catastrofeTipo + "_32.png";
						notificacaoCatastrofe.titulo.text = "TSUNAMI";
						
						
						
						if (catastrofeTipo == Planeta.TSUNAMI)
							notificacaoCatastrofe.titulo.text = "TSUNAMI";
						else if (catastrofeTipo == Planeta.METEORITOS)
							notificacaoCatastrofe.titulo.text = "METEORITOS";
						else if (catastrofeTipo == Planeta.VULCOES)
							notificacaoCatastrofe.titulo.text = "VULCAO";
						
						notificacaoCatastrofe.start();

						
						

						
					}
				}

			}	
			
			
			
			if (verificaVitoria()) {
				_vitoria = true;
				_planeta.habitavel = true;
				_laboratorio.visible = false;
				
				_timerUpdate.stop();
				var tempoRecordPessoal : uint;
				
				
				_mainMovieClip.removeChild(_container);
				if (_jogador.temposMaximos.length < _nivel) {
					tempoRecordPessoal = 0;
					_jogador.temposMaximos.push(_clock);
				}
				
				else {
					tempoRecordPessoal = _jogador.temposMaximos[_nivel-1];

					// record pessoal
					if (_jogador.temposMaximos[_nivel-1] > _clock) {
						_jogador.temposMaximos[_nivel-1] = _clock;
						
					}
				}
			
				/*
				if (_jogador.proximoNivel == _nivel)
					_jogador.proximoNivel++;*/
				


				// atualiza ficheiro sharedObject em disco com dados do jogador atualizados
				var sharedObject : SharedObject = SharedObject.getLocal("TerraNovaSaved");
				var encontrado : Boolean = false;
				for (var k : uint = 0; k < sharedObject.data.jogadores.length && !encontrado; k++) {
					if (_jogador.nome == sharedObject.data.jogadores[k].nome) {
						encontrado = true;
						sharedObject.data.jogadores[k] = new Jogador(_jogador.nome, _jogador.temposMaximos);
						sharedObject.flush();
					}
				}
				
				var gameReport : GameReport = new GameReport(_mainMovieClip, _tempoRecordGlobal, tempoRecordPessoal, _clock);
				gameReport.addEventListener(MouseEvent.CLICK, nextLevelButton);
				_mainMovieClip.addChild(gameReport);
				
				_container.filters = [new BlurFilter(10, 10, BitmapFilterQuality.HIGH)];
				
				trace("VITORIA");
				
			}
			
			if (_menuGame != null) {
				if (miniJogoCoolDown > 0) {
					_menuGame.miniJogoCoolDownCounter.visible = true;
					_menuGame.miniJogoCoolDownCounter.text = "" + miniJogoCoolDown;
				}
				else {
					_menuGame.miniJogoCoolDownCounter.visible = false;
				}
			}

			
		}
		
		private function notificacaoOut(e : Event) {
			_notificacoesOnScreen--;
			_notificacoesSlotsFree[e.currentTarget.slot] = true;
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
			if (_menuGame == null) {
				_menuGame = new MenuGame(this);
				_mainMovieClip.addChild(_menuGame);
				tween = new Tween(_menuGame, "x", Strong.easeInOut, -40, 10, 0.25, true);
				tween.start();
	
			}
			else {
				tween = new Tween(_menuGame, "x", Strong.easeInOut, 10, -40, 0.25, true);
				//new Tween(_menuButton, "x", Strong.easeInOut, _menuButton.x, -40, 0.5, true);

				tween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinish);
				tween.start();

			}
			
		}
		
		public function tweenFinish (e : TweenEvent) {
			if (_menuGame != null) {
				_mainMovieClip.removeChild(_menuGame);
				_menuGame = null;
			}
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
				_mainMovieClip.addChild(_planeta.dados[i]);
				
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
			}
			
			_laboratorio.source = tecnologiasContainer;
			
			_mainMovieClip.addChild(_laboratorio);
			
			setTimer();
			
		}
		
		
		function completeHandler(event:Event) { 
			trace("Number of bytes loaded: " + event.target.bytesLoaded); 
		}
		
		private function pauseAndPlayButtonClicked(e : MouseEvent) {
			
			if (_pauseAndPlayButton.isPause()) {
				// PAUSE SIMULATION
				_pauseAndPlayButton.setPlay();
				_timerUpdate.stop();
				atualizaSimulacao(null);
			}
			else {
				// RESUME SIMULATION
				_pauseAndPlayButton.setPause();
				_timerUpdate.start();
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
