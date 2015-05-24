package  {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import fl.containers.ScrollPane;
	import fl.containers.UILoader;
	import fl.controls.Button;
	import fl.controls.ScrollPolicy;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Strong;

	/**
	 * A classe MainGame faz a simulação e a centralização de todo o jogo.
	 */
	public class MainGame {
		/******************************************************
		 * CONTAINERS
		 ******************************************************/
		
		/**
		 * Movie clip principal.
		 */
		private var _mainMovieClip : MovieClip;
		
		/**
		 * Um MovieClip - conteudo em terceira camada.
		 * @see _mainMovieClip
		 */
		private var _terceiraCamada : MovieClip;
		
		private var _segundaCamada : MovieClip;
		
		private var _primeiraCamada : MovieClip;

		
		/******************************************************
		 * JOGO/SIMULAÇÃO
		 ******************************************************/
		
		/**
		 * Referência para o planeta com que a simulção trabalha.
		 * @see Planeta
		 */
		private var _planeta : Planeta;
		
		private var _timerUpdate : Timer;
		/**
		 * Cooldown do mini-jogo/expedição.
		 */
		private var _miniJogoCoolDown : uint = 0;

		private var _nivel : uint;
		private var _jogador : Jogador;
		private var _tempoRecordGlobal : uint;
		/**
		 * Quantidade de notificações em ecrã.
		 */
		private var _notificacoesOnScreen : uint;
		/**
		 * Slots das notificações em ecrã.
		 */
		private var _notificacoesSlotsFree : Vector.<Boolean>;
		/**
		 * True se nível passado.
		 */
		private var _vitoria : Boolean;
		/**
		 * Musica de Bacground
		 */
		private var _musicaBackground : Sound;
		private var _soundChannel : SoundChannel;
		private var _gameReport : GameReport;
		
		
		
		/******************************************************
		 * HEADER
		 ******************************************************/
		
		/**
		 * Referência para o scroll pane que armazenará o laboratório com as tecnologias.
		 * @see MenuGame
		 */
		private var _laboratorio : ScrollPane;
		
		/**
		 * Referência para o menu do jogo.
		 * @see MenuGame
		 */
		private var _menuGame : MenuGame;
		
		
		/**
		 * Sprite que contém o cabeçalho do jogo.
		 */
		private var _headerRecursos : Sprite;
		
		/**
		 * Valor do minério do planeta a apresentar.
		 * @see Recursos
		 * @see Planeta
		 */
		private var _minerioTextField : TextField;
		
		/**
		 * Valor da energia do planeta a apresentar.
		 * @see Recursos
		 * @see Planeta
		 */
		private var _energiaTextField : TextField;
		
		/**
		 * Icon do minerio.
		 */
		private var _minerioIcon : UILoader;
		
		/**
		 * Icon da minerio.
		 */
		private var _energiaIcon : UILoader;
		
		/**
		 * Butão do menu do jogo.
		 */
		private var _menuButton : UILoader;
		
		/**
		 * Botao Play/Pause da simulação.
		 * @see PausePlayButton
		 */
		private var _pauseAndPlayButton : PausePlayButton;
	
		/**
		 * Clock do jogo em inteiro.
		 */
		private var _clock : uint;
		
		/**
		 * Clock do jogo convertido em texto de formato mm:ss
		 */
		private var _clockDisplay : TextField;
		
		/**
		 * Icon do Clock.
		 */
		private var _clockIcon : UILoader;
		
		/**
		 * Tween para animar alguns elementos.
		 */
		private var _tween : Tween;

		
		
		
		
		/******************************************************
		 * CGI VARIABLES
		 ******************************************************/
		
		/**
		 * Timer de atualização do modelo 3D.
		 */
		private var _timerUpdateCGI : Timer;
		
		
		/**
		 * Contadores de loaders já compeltos.
		 */
		private var _loadersTexturasCompleted : uint;
		
		/**
		 * Instancia do modelo 3D.
		 */
		private var _sistemaPlanetario : SistemaPlanetario;
		

		/**
		 * Angulo de Rotacao por cada unidade de tempo de simulacao grafica.
		 */
		private var _anguloRotacao : Number = 0;
		
		/**
		 * Loader textura inicial do planeta.
		 */
		private var _loaderTexturaInicial : Loader;
		
		/**
		 * Loader textura inicial da lua.
		 */
		private var _loaderTexturaLua : Loader;
		
		/**
		 * Loader textura final do planeta.
		 */
		private var _loaderTexturaFinal : Loader;
		
		/**
		 * Estado de terraformação do planeta CGI. 0 - Planeta Mau; 100 - Planeta Bom.
		 */
		private var _estadoTerraformacaoCGI : uint;
		/**
		 * Barra de terraformação CGI.
		 */
		private var _barraTerraformacaoCGI : BarraProgressoTerraformacaoCGI;
		/**
		 * Cor da atmosfera CGI. 0x66CCCC - Planeta Bom.
		 */
		private var _corAtmosferaCGI : int;

		
		public function MainGame(mainMovieClip : MovieClip = null, nivel : uint = NaN, jogador : Jogador = null, tempoRecordGlobal : uint = 0) {

			_mainMovieClip = mainMovieClip;
			_mainMovieClip.gotoAndStop("MainGame");

			_jogador = jogador;
			_tempoRecordGlobal = tempoRecordGlobal;
			
			_terceiraCamada = new MovieClip();
			_segundaCamada = new MovieClip();
			_primeiraCamada = new MovieClip();

			_mainMovieClip.addChild(_terceiraCamada);
			_mainMovieClip.addChild(_segundaCamada);
			_mainMovieClip.addChild(_primeiraCamada);
		
			_vitoria = false;
			
			_nivel = nivel;
			


			_laboratorio = new ScrollPane();
			_laboratorio.y = 40;
			_laboratorio.height = 325;
			_laboratorio.width = 640;
			_laboratorio.horizontalScrollPolicy = ScrollPolicy.OFF;
			_laboratorio.visible = false;
			
			
			_clockDisplay = new TextField();
			_menuButton = new UILoader;
			_headerRecursos = new Sprite();
			_minerioIcon = new UILoader();
			_minerioTextField = new TextField();
			_energiaIcon = new UILoader();
			_energiaTextField = new TextField();
			
			_clockIcon = new UILoader();
			_pauseAndPlayButton = new PausePlayButton();
			_notificacoesSlotsFree = new Vector.<Boolean>();


			
			_timerUpdate = new Timer(1000, 1);
			_timerUpdate.addEventListener(TimerEvent.TIMER_COMPLETE, atualizaSimulacao);
			
			_timerUpdateCGI = new Timer(1000/24, 1);
			_timerUpdateCGI.addEventListener(TimerEvent.TIMER_COMPLETE, atualizaCGI);

			_planeta = new Planeta(this, _jogador, _nivel);
			
			
			_planeta.resetPlaneta();
			
	
		}
		



		/**
		 * Carrega as texturas do modelo CGI.
		 */
		public function loadCGI() : void {

			_loadersTexturasCompleted = 0;

			_loaderTexturaInicial = new Loader();
			_loaderTexturaLua = new Loader();
			_loaderTexturaFinal = new Loader();
			
			_loaderTexturaInicial.contentLoaderInfo.addEventListener(Event.COMPLETE, texturasCompleted);
			_loaderTexturaLua.contentLoaderInfo.addEventListener(Event.COMPLETE, texturasCompleted);
			_loaderTexturaFinal.contentLoaderInfo.addEventListener(Event.COMPLETE, texturasCompleted);
			
			_loaderTexturaInicial.load(new URLRequest("media/texturas/mercurio.jpg"));
			_loaderTexturaLua.load(new URLRequest("media/texturas/lua.jpg"));
			_loaderTexturaFinal.load(new URLRequest("media/texturas/terra.jpg"));
		
		}
		
		private function texturasCompleted (e : Event) {
			_loadersTexturasCompleted++;
			init();
			initCGI();
		}
		
		
		/******************************************************
		 * INICIALIZADORES (CGI E JOGO/SIMULAÇÃO)
		 ******************************************************/
		
		/**
		 * Inicia modelo 3D após as texturas estarem devidamente carregadas.
		 */
		public function initCGI() {
			if (_loadersTexturasCompleted == 3) {
				_estadoTerraformacaoCGI = 0;
				_corAtmosferaCGI = 0x000000;
				_barraTerraformacaoCGI = new BarraProgressoTerraformacaoCGI();
				_barraTerraformacaoCGI.x = _mainMovieClip.stage.stageWidth/2 - 207/2;
				_barraTerraformacaoCGI.y = _mainMovieClip.stage.stageHeight/2 + 155/2 + 40;

				
				_anguloRotacao = 0;
				_sistemaPlanetario = new SistemaPlanetario(_primeiraCamada.stage.stageWidth/2, _primeiraCamada.stage.stageHeight/2 - 50, 40, 40, 155, Bitmap(_loaderTexturaInicial.content).bitmapData, Bitmap(_loaderTexturaFinal.content).bitmapData);
				//sistemaPlanetario.setatmosfera(0x66CCCC);
				_sistemaPlanetario.setatmosfera(0x000000)
				_sistemaPlanetario.addLua(55, 290, Bitmap(_loaderTexturaLua.content).bitmapData);
				
				_segundaCamada.addChild(_sistemaPlanetario);
				_segundaCamada.addChild(_barraTerraformacaoCGI);
				
				_sistemaPlanetario.cacheAsBitmap = true;
				// inicia animacao CGI
				setTimerCGI();	
				//init();
			}
		}

		/**
		 * Inicia o ecrã de jogo.
		 */
		public function init() : void {
			
			// clock a zero
			_clock = 0;
			_clockDisplay.text = intToTime(_clock);
			
			// importa e formata dados do planeta para o ecra
			importaDadosDoPlaneta();
			
			// importa e formata tecnologias do planeta para o ecra
			importaTecnologiasDoPlaneta();
	
			// BUTAO MENU
			_menuButton.maintainAspectRatio = true;
			_menuButton.scaleContent = false;
			_menuButton.source = "media/header/menu_20.png";
			_menuButton.x = 10;
			_menuButton.y = 10;
			_menuButton.addEventListener(MouseEvent.CLICK, menuButtonClick);
			_menuButton.addEventListener(MouseEvent.MOUSE_OVER, overButton);
			_menuButton.addEventListener(MouseEvent.MOUSE_OUT, outButton);
			_primeiraCamada.addChild(_menuButton);

			// HEADER
				// minerio - icon
			_minerioIcon.scaleContent = false;
			_minerioIcon.maintainAspectRatio = true;
			_minerioIcon.source = "media/header/minerio_32.png";
			_minerioIcon.x = 0;
			_minerioIcon.y = 0;
			_headerRecursos.addChild(_minerioIcon);
				// minerio - label
			_minerioTextField.defaultTextFormat = Pretty.HEADING_1;
			_minerioTextField.selectable = false;
			_minerioTextField.text = "Minerio: " + _planeta.recursos.minerio;
			_minerioTextField.width = _minerioTextField.textWidth + 10;
			_minerioTextField.height = _minerioTextField.textHeight + 3;
			_minerioTextField.x = 32 + 5;
			_minerioTextField.y = 4;
			_headerRecursos.addChild(_minerioTextField);
				// energia - icon
			_energiaIcon.scaleContent = false;
			_energiaIcon.maintainAspectRatio = true;
			_energiaIcon.source = "media/header/energia_32.png";
			_energiaIcon.x = _minerioTextField.x + _minerioTextField.width + 10;
			_energiaIcon.y = 0;
			_headerRecursos.addChild(_energiaIcon);
				// energia - label
			_energiaTextField.defaultTextFormat = Pretty.HEADING_1;
			_energiaTextField.selectable = false;
			_energiaTextField.text = "Energia: " + _planeta.recursos.energia;
			_energiaTextField.width = _energiaTextField.textWidth + 10;
			_energiaTextField.height = _energiaTextField.textHeight + 3;
			_energiaTextField.x = _energiaIcon.x + 32 + 5;
			_energiaTextField.y = _minerioTextField.y;
			_primeiraCamada.addChild(_energiaTextField);
			
			_headerRecursos.x = mainMovieClip.stage.stageWidth/2 - _headerRecursos.width/2;
			_headerRecursos.y = 5;
			_primeiraCamada.addChild(_headerRecursos);
	
			atualizaLayoutRecursos();

			
			
			// CLOCK DISPLAY
				//display
			_clockDisplay.x = 550;
			_clockDisplay.y = 8;
			_clockDisplay.height = 30;
			_clockDisplay.defaultTextFormat = Pretty.HEADING_1;
			_clockDisplay.text = intToTime(_clock);
			_primeiraCamada.addChild(_clockDisplay);
				// icon
			_clockIcon.scaleContent = false;
			_clockIcon.maintainAspectRatio = true;
			_clockIcon.source = "media/header/time.png";
			_clockIcon.x = _clockDisplay.x - 20;
			_clockIcon.y = _clockDisplay.y + 3;
			_primeiraCamada.addChild(_clockIcon);
			
			// PAUSE AND PLAY BUTTON
			_pauseAndPlayButton.setPause();
			_pauseAndPlayButton.addEventListener(MouseEvent.CLICK, pauseAndPlayButtonClicked);
			_pauseAndPlayButton.addEventListener(MouseEvent.MOUSE_OVER, overButton);
			_pauseAndPlayButton.addEventListener(MouseEvent.MOUSE_OUT, outButton);
			_pauseAndPlayButton.scaleX = 0.5;
			_pauseAndPlayButton.scaleY = 0.5;
			_pauseAndPlayButton.x = _clockDisplay.x + _clockDisplay.textWidth + 10;
			_pauseAndPlayButton.y = _menuButton.y - 2;

			_primeiraCamada.addChild(_pauseAndPlayButton);
			
			// NOTIFICACOES
				// quantas notificacoes em ecra
			_notificacoesOnScreen = 0;
				// quais os slots livres, usado para indicar qual o slot de notificacao a ocupar
			_notificacoesSlotsFree[0] = true;
			_notificacoesSlotsFree[1] = true;
			_notificacoesSlotsFree[2] = true;
			
			// MUSICA
			_musicaBackground = new Sound();
			_musicaBackground.load(new URLRequest("media/musica/Time_in_Music.mp3"));
			_soundChannel = _musicaBackground.play(0, int.MAX_VALUE);
			
			//initCGI();

		}
		

		
		
		/******************************************************
		 * TIMERS (Simulação + CGI)
		 ******************************************************/
		
		/**
		 * Timer para a atualizção da simulação.
		 * @see atualizaSimulacao
		 */
		public function setTimer() : void {
			_timerUpdate.start();
		}
		
		/**
		 * Timer para a atualizção da CGI.
		 * @see atualizaSimulacao
		 */
		public function setTimerCGI() : void {
			_timerUpdateCGI.start();
		}
		
		
		
		
		/**
		 * Atualiza CGI em cada término do Timer CGI.
		 */
		private function atualizaCGI(e : TimerEvent) {
			// altera rotacao do planeta consoante os dados em vigor
			_anguloRotacao += _planeta.dados[Planeta.SPIN].valor/24;
			
			// se o estado de terraformacao do planeta estiver diferente daquele
			// apresentado pelo modelo CGI, ele comeca a animacao a tender para o novo estado
			if (_estadoTerraformacaoCGI < _planeta.estadoTerraformacao)
				_estadoTerraformacaoCGI += 1;
			else if (_estadoTerraformacaoCGI > _planeta.estadoTerraformacao)
				_estadoTerraformacaoCGI -= 1;
		
			// Comparar atmosfera CGI com atmosfera de plaenta em memoria
			// comparar red's
			if ( ((_corAtmosferaCGI >> 16) & 0xFF) < ((_planeta.corAtmosfera >> 16) & 0xFF) )
				_corAtmosferaCGI += 0x010000;
			else if ( ((_corAtmosferaCGI >> 16) & 0xFF) > ((_planeta.corAtmosfera >> 16) & 0xFF) )
				_corAtmosferaCGI -= 0x010000;;
			
			// comparar green's
			if ( ((_corAtmosferaCGI >> 8) & 0xFF) < ((_planeta.corAtmosfera >> 8) & 0xFF) )
				_corAtmosferaCGI += 0x000100;
			else if ( ((_corAtmosferaCGI >> 8) & 0xFF) > ((_planeta.corAtmosfera >> 8) & 0xFF) )
				_corAtmosferaCGI -= 0x000100;
			
			// comparar blue's
			if ( (_corAtmosferaCGI & 0xFF) < (_planeta.corAtmosfera & 0xFF))
				_corAtmosferaCGI += 0x000001;
			else if ( (_corAtmosferaCGI & 0xFF) > (_planeta.corAtmosfera & 0xFF) )
				_corAtmosferaCGI -= 0x000001;
							
			// redesenha o CGI
			_sistemaPlanetario.desenha(_anguloRotacao, _anguloRotacao, _anguloRotacao, _estadoTerraformacaoCGI);
			_sistemaPlanetario.setatmosfera(_corAtmosferaCGI);
			
			// atualiza barra de terraformacao do CGI
			_barraTerraformacaoCGI.atualiza(_estadoTerraformacaoCGI);
			
			// reinicia o timer para proxima atualizacao do CGI
			setTimerCGI();
		}
		

		
		
		
		/******************************************************
		 * SIMULADOR
		 ******************************************************/
		
		/**
		 * Atualiza os dados apresentados no ecra (label, butoes ativados). Pode ser despoletada por um timer ou de forma forçada com limitações.
		 * @param e evento que aciona a funcao, null se for uma atualizacao assincrona.
		 */
		public function atualizaSimulacao (e : Event) {
			// incrementa recursos so quando a funcao for despoletada pelo temporizador 
			if (e != null) {
				_planeta.recursos.minerio += _planeta.dados[Planeta.TAXA_MINERIO].valor;
				_clock++;
				_clockDisplay.text = intToTime(_clock);
				
				// atualiza cooldown mini-jogo - decrementa
				if (_miniJogoCoolDown > 0) {
					_miniJogoCoolDown--;
					if (_menuGame != null)
						_menuGame.atualizaBarraCooldown();
				}
				
				
				/******************************************************
				 * GERADOR DE CATASTROFES / GERADOR DE AJUDAS
				 ******************************************************/
				
				// gerador de notificacoes de Meteoritos
				if (Math.random() < _planeta.dados[Planeta.METEORITOS].valor && _notificacoesOnScreen < 3) {
					geraNotificacao(Planeta.METEORITOS);
				}
				// gerador de notificacoes de Tsunamis
				if (Math.random() < _planeta.dados[Planeta.TSUNAMI].valor && _notificacoesOnScreen < 3) {
					geraNotificacao(Planeta.TSUNAMI);
					
				}
				// gerador de notificacoes de Vulcoes
				if (Math.random() < _planeta.dados[Planeta.VULCOES].valor && _notificacoesOnScreen < 3) {
					geraNotificacao(Planeta.VULCOES);
					
				}
				// gerador de notificacoes de Ajudas
				if (Math.random() < 0.002 && _planeta.estadoTerraformacao != 100 && _notificacoesOnScreen < 3) {
					geraNotificacao(-1);
					
				}
					
				setTimer();

			}
			
			// atualiza estado de terraformacao
			_planeta.atualizaEstadoTerraformacao();
			
			// atualiza recursos
			atualizaLayoutRecursos();
			_minerioTextField.text = "Minerio: " + _planeta.recursos.minerio;
			_energiaTextField.text = "Energia: " + _planeta.recursos.energia;
			
			for (var i : uint = 0; i < _planeta.tecnologias.length; i++) {
				// se recursos nao chegam para evolucao de tecnologia ou o tempo esta parado, entao desativa tecnologia(s)
				if (Math.abs(_planeta.tecnologias[i].custoMinerioAtual) > _planeta.recursos.minerio || !_timerUpdate.running) {
					_planeta.tecnologias[i].evoluirButton.enabled = false;
					_planeta.tecnologias[i].demolirButton.enabled = false;

					_planeta.tecnologias[i].evoluirButton.removeEventListener(MouseEvent.CLICK, _planeta.tecnologias[i].evoluiTecnologia);
					_planeta.tecnologias[i].demolirButton.removeEventListener(MouseEvent.CLICK, _planeta.tecnologias[i].vendeTecnologia);
					
				}
				else {
					_planeta.tecnologias[i].evoluirButton.enabled = true;
					_planeta.tecnologias[i].demolirButton.enabled = (_planeta.tecnologias[i].nivel == 0) ? false : true;
					_planeta.tecnologias[i].evoluirButton.addEventListener(MouseEvent.CLICK, _planeta.tecnologias[i].evoluiTecnologia);
					_planeta.tecnologias[i].demolirButton.addEventListener(MouseEvent.CLICK, _planeta.tecnologias[i].vendeTecnologia);
					
					

					
					

					
					
				}

			}	
			
			
			// se vitoria
			if (verificaVitoria()) {
				_vitoria = true;
				_planeta.habitavel = true;
				_laboratorio.visible = false;
				
				_timerUpdate.stop();
				
				//
				// Atualiza record's
				//
				var tempoRecordPessoal : uint;
				
				_mainMovieClip.removeChild(_terceiraCamada);
				_mainMovieClip.removeChild(_primeiraCamada);
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
				
				// apresenta relatorio de fim de jogo
				_gameReport = new GameReport(_mainMovieClip, _tempoRecordGlobal, tempoRecordPessoal, _clock);
				_gameReport.addEventListener(MouseEvent.CLICK, nextLevelButton);
				_mainMovieClip.addChild(_gameReport);
				
				// desfoca ecra de tras
				_terceiraCamada.filters = [new BlurFilter(10, 10, BitmapFilterQuality.HIGH)];
				
				trace("VITORIA");
				
			}

			
		}
		
		
		
		/******************************************************
		 * NOTIFICACOES
		 ******************************************************/
		/**
		 * Gera uma notificação com tipo igual ao argumento código. Maior que 0 para parâmetros (Usar Planeta.CODIGO_DE.PARAMETRO)
		 * ou valores menores que 0 para notificações de ajuda.
		 */
		private function geraNotificacao(codigo : int) {
			// incrementa notificacoes em ecra
			_notificacoesOnScreen++;
			
			// encontra um slot livre...
			var slotEncontrado : Boolean = false;
			for (var m : uint = 0; m < _notificacoesSlotsFree.length && !slotEncontrado; m++) {
				slotEncontrado = _notificacoesSlotsFree[m];
			}
			
			// ... e ocupa-o
			_notificacoesSlotsFree[m-1] = false;
			
			// inicia a notificacao
			var notificacaoCatastrofe : Notificacao = new Notificacao(_segundaCamada, _primeiraCamada.stage.stageWidth, _clockDisplay.y + _clockDisplay.height + 10 + (m-1)*55, 200, 50, m-1);
			notificacaoCatastrofe.addEventListener(Notificacao.NOTIFICACAO_ACABOU, notificacaoOut);
			
			notificacaoCatastrofe.icon.source = "media/parametros/data" + codigo + "_32.png";
			//notificacaoCatastrofe.titulo.text = "TSUNAMI";
			
			if (codigo == Planeta.TSUNAMI)
				notificacaoCatastrofe.titulo.text = "TSUNAMI";
			else if (codigo == Planeta.METEORITOS)
				notificacaoCatastrofe.titulo.text = "METEORITO";
			else if (codigo == Planeta.VULCOES)
				notificacaoCatastrofe.titulo.text = "VULCÃO";
			else {
				notificacaoCatastrofe.titulo.text = "AJUDA";
				notificacaoCatastrofe.icon.source = "media/menu/menu3_32.png";
			}
			
			if (codigo >= 0)
				notificacaoCatastrofe.titulo.appendText("\nCoordenadas: " + (uint)(Math.random()*100) + "º " + (uint)(Math.random()*100) + "' " + (uint)(Math.random()*100) + "''");
			else {
				var dadosIncorretos : Vector.<uint> = new Vector.<uint>();
				for (var n : uint = 0; n < _planeta.dados.length; n++) {
					trace(_planeta.dados[n].nome + " --- " + _planeta.dados[n].valor + " " +  _planeta.dados[n].estadoTerraformacaoDado);
					if (_planeta.dados[n].estadoTerraformacaoDado != 100)
						dadosIncorretos.push(n);
				}
				notificacaoCatastrofe.titulo.appendText("\nValor de '" + _planeta.dados[dadosIncorretos[(uint)(Math.random()*dadosIncorretos.length)]].nome + "' incorreto");
				
				
				
			}
			notificacaoCatastrofe.start();	
			
			
		}
		
		
		
		
		/******************************************************
		 * FIM DO JOGO?
		 ******************************************************/

		/**
		 * Verifica vitoria do nivel. Tenta validar os dados.
		 */
		public function verificaVitoria() : Boolean {
			var vitoria : Boolean = true;
			for (var i : uint = 0; i < _planeta.dados.length && vitoria; i++) {
				if (_planeta.dados[i].correto == false)
					vitoria = false;
			}
			
			return vitoria;
		}
		
		
		/**
		 * Quando o botão "proximo nivel" no relatório do fim do nível é premido.
		 */
		private function nextLevelButton(e : MouseEvent) {
			_gameReport.removeEventListener(MouseEvent.CLICK, nextLevelButton);

			_soundChannel.stop();
			_mainMovieClip.removeChild(e.target.parent);
			_mainMovieClip.removeChild(_primeiraCamada);
			_mainMovieClip.removeChild(_segundaCamada);
			_mainMovieClip.removeChild(_terceiraCamada);
			new Niveis(_mainMovieClip, _jogador);
		}
		
		
		/**
		 * Limpa jogo
		 */
		public function clean() {
			_tween.removeEventListener(TweenEvent.MOTION_FINISH, tweenFinish);
			_loaderTexturaInicial.contentLoaderInfo.removeEventListener(Event.COMPLETE, texturasCompleted);
			_loaderTexturaLua.contentLoaderInfo.removeEventListener(Event.COMPLETE, texturasCompleted);
			_loaderTexturaFinal.contentLoaderInfo.removeEventListener(Event.COMPLETE, texturasCompleted);
			
			_menuButton.removeEventListener(MouseEvent.CLICK, menuButtonClick);
			_menuButton.removeEventListener(MouseEvent.MOUSE_OVER, overButton);
			_menuButton.removeEventListener(MouseEvent.MOUSE_OUT, outButton);
			
			_pauseAndPlayButton.removeEventListener(MouseEvent.CLICK, pauseAndPlayButtonClicked);
			_pauseAndPlayButton.removeEventListener(MouseEvent.MOUSE_OVER, overButton);
			_pauseAndPlayButton.removeEventListener(MouseEvent.MOUSE_OUT, outButton);
			_timerUpdate.removeEventListener(TimerEvent.TIMER_COMPLETE, atualizaSimulacao);
			_timerUpdateCGI.removeEventListener(TimerEvent.TIMER_COMPLETE, atualizaCGI);
			
			_timerUpdate.reset();
			_timerUpdateCGI.reset();

	
			//_planeta.tecnologias[i].demolirButton.removeEventListener(MouseEvent.CLICK, _planeta.tecnologias[i].vendeTecnologia);
			//_planeta.tecnologias[i].evoluirButton.removeEventListener(MouseEvent.CLICK, _planeta.tecnologias[i].evoluiTecnologia);
		}
		
		
		
		/**
		 * Reset ao nivel.
		 */
		public function reset() {
			
			//_soundChannel.stop();
			_mainMovieClip.removeChild(_primeiraCamada);
			_mainMovieClip.removeChild(_segundaCamada);
			_mainMovieClip.removeChild(_terceiraCamada);
			
			
			_primeiraCamada = new MovieClip();
			_segundaCamada = new MovieClip();
			_terceiraCamada = new MovieClip();
			
			_mainMovieClip.addChild(_terceiraCamada);
			_mainMovieClip.addChild(_segundaCamada);
			_mainMovieClip.addChild(_primeiraCamada);

			//new Niveis(_mainMovieClip, _jogador);
			


			clean();
			
			_planeta = new Planeta(this, _jogador, _nivel);
			_planeta.resetPlaneta();
			
			_timerUpdate.addEventListener(TimerEvent.TIMER_COMPLETE, atualizaSimulacao);
			_timerUpdateCGI.addEventListener(TimerEvent.TIMER_COMPLETE, atualizaCGI);
			
			//_planeta = new Planeta(this, _jogador, _nivel);
			
		}
		
		
		
		
		/******************************************************
		 * MENU DO JOGO + TWEENS
		 ******************************************************/
		
		/**
		 * Funcao despoletadora do click do butao de menu.
		 */
		public function menuButtonClick (e : MouseEvent) {
			// se menu nao estiver a ser aprensetado...
			if (_menuGame == null) {
				//... cria uma instancia
				_menuGame = new MenuGame(this);
				_primeiraCamada.addChild(_menuGame);
				
				// e anima a sua entrada ao palco
				_tween = new Tween(_menuGame, "x", Strong.easeInOut, -40, 10, 0.25, true);
				_tween.start();
	
			}
			// mas se sim...
			else {
				// ... anima a sua saida do palco
				_tween = new Tween(_menuGame, "x", Strong.easeInOut, 10, -40, 0.25, true);
				_tween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinish);
				_tween.start();
			}
			
		}
		
		/**
		 * Funcao despoletada pelo fim da animacao de saida do menu do jogo.
		 */
		public function tweenFinish (e : TweenEvent) {
			// se o menu existe, e' porque este evento foi despoletado à sua saida do palco
			if (_menuGame != null) {
				// entao remove-o do palco para otimizar o sistema
				_primeiraCamada.removeChild(_menuGame);
				// e indica que ele nao existe ao simulador
				_menuGame = null;
			}
		}
				
		/**
		 * Importa e formata dados do planeta.
		 * @see Planeta
		 * @see Parametro
		 */
		private function importaDadosDoPlaneta () {
		
			// conta linhas e colunas
			var contadorColunas : uint = 0;
			var contadorLinhas : uint = 0;
			
			// dependendo da linha e coluna em que esta, posiciona os dados no seu respetivo lugar
			for (var i : uint = 0; i<_planeta.dados.length; i++) {
				_planeta.dados[i].x = 10 + 160*contadorColunas;
				_planeta.dados[i].y = 370 + contadorLinhas * 35;
				_planeta.dados[i].nomeValorTextField.width = 120;
				_primeiraCamada.addChild(_planeta.dados[i]);
				
				// se chegar ao fim das colunas permitidas, muda de linha... 
				if (contadorColunas >= 3) {
					contadorColunas = 0;
					contadorLinhas++;
				}
				// ... se não incrementa mais uma coluna
				else {
					contadorColunas++;
				}
				
				// no fim, verifica os dados, dando-lhes a cor verde ou vermelho consoante a sua compatibilidade
				// com a espécie humana
				_planeta.dados[i].verificaDado();
			}
			
						
			
			
		}
	
			
			
		
		/**
		 * Importa e formata tecnologias do planeta.
		 * @Planeta
		 * @Tecnologia
		 */
		private function importaTecnologiasDoPlaneta () {
			// container para a lista de tecnologias
			var tecnologiasContainer : MovieClip = new MovieClip();
	
			for (var i : uint = 0; i<_planeta.tecnologias.length; i++) {
				// posiciona tecnologia graficamente
				_planeta.tecnologias[i].y = i*163.95;
				_planeta.tecnologias[i].x = 0;

				// adiciona tecnologia ao container que detem a lista de tecnologias
				tecnologiasContainer.addChild(_planeta.tecnologias[i]);
			}
			
			// associa a lista de tecnologias ao scroll pane.
			_laboratorio.source = tecnologiasContainer;
			
			// adiciona o scroll pane (_laboratorio) ao movie clip principal (mais à frente)
			_primeiraCamada.addChild(_laboratorio);
			
			// inicia a simulacao
			setTimer();
			
		
		}
		
		/******************************************************
		 * EVENTOS
		 ******************************************************/
		
		/**
		 * Rato em cima do botão target.
		 */
		public function overButton (e: MouseEvent) {
			e.currentTarget.alpha = 0.8;
		}
		
		/**
		 * Rato fora do botão target.
		 */
		public function outButton (e: MouseEvent) {
			e.currentTarget.alpha = 1;
		}
		
		/**
		 * Botao pause/play clicado
		 */
		private function pauseAndPlayButtonClicked(e : MouseEvent) {
			
			if (_pauseAndPlayButton.isPause()) {
				// para a simuacao
				_pauseAndPlayButton.setPlay();
				_timerUpdate.stop();
				_timerUpdateCGI.stop();
				atualizaSimulacao(null);
			}
			else {
				// retoma simulacao
				_pauseAndPlayButton.setPause();
				_timerUpdate.start();
				_timerUpdateCGI.start();
				atualizaSimulacao(null);
				
			}
		}
		
		/**
		 * Quando uma notificacao abandona o ecra.
		 */
		private function notificacaoOut(e : Event) {
			e.target.removeEventListener(Notificacao.NOTIFICACAO_ACABOU, notificacaoOut);
			// desincrementa notificacoes em ecra
			_notificacoesOnScreen--;
			// liberta slot
			_notificacoesSlotsFree[e.currentTarget.slot] = true;
		}
		
		
		
		
		/**
		 * Converte o tempo em inteiro para string de formato mm:ss.
		 */
		private function intToTime(clock : uint) : String {
			var seconds : int = Math.floor(clock);
			var minutes : int = Math.floor(seconds/60);
			seconds -= minutes*60;
			
			return minutes + ":" + String(seconds+100).substr(1,2);
		}
		
		
		
		/**
		 * Atualiza disposicao e valores dos recursos (header) apresentados em ecra.
		 */
		private function atualizaLayoutRecursos() {
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
		
		
		
		
		/******************************************************
		 * GETTERS & SETTERS
		 ******************************************************/
		
		public function get menuGame():MenuGame
		{
			return _menuGame;
		}
		
		public function set menuGame(value:MenuGame):void
		{
			_menuGame = value;
		}
		
		public function get terceiraCamada():MovieClip
		{
			return _terceiraCamada;
		}
		
		public function set terceiraCamada(value:MovieClip):void
		{
			_terceiraCamada = value;
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
		 * Nível associado à simulação.
		 */
		public function get nivel():uint
		{
			return _nivel;
		}
		
		/**
		 * @private
		 */
		public function set nivel(value:uint):void
		{
			_nivel = value;
		}
		
		/**
		 * Timer da simulação.
		 */
		public function get timerUpdate():Timer
		{
			return _timerUpdate;
		}
		
		/**
		 * @private
		 */
		public function set timerUpdate(value:Timer):void
		{
			_timerUpdate = value;
		}
		
		
		/**
		 * Jogador associado à simulação.
		 */
		public function get jogador():Jogador
		{
			return _jogador;
		}
		
		/**
		 * @private
		 */
		public function set jogador(value:Jogador):void
		{
			_jogador = value;
		}
		
		/**
		 * Tempo record global do nível desta simulação.
		 */
		public function get tempoRecordGlobal():uint
		{
			return _tempoRecordGlobal;
		}
		
		/**
		 * @private
		 */
		public function set tempoRecordGlobal(value:uint):void
		{
			_tempoRecordGlobal = value;
		}
		
		/**
		 * Canal sonoro
		 */
		public function get soundChannel():SoundChannel
		{
			return _soundChannel;
		}
		
		/**
		 * @private
		 */
		public function set soundChannel(value:SoundChannel):void
		{
			_soundChannel = value;
		}
		
		/**
		 * Um MovieClip - conteudo em primeira camada.
		 * @see _mainMovieClip
		 */
		public function get primeiraCamada():MovieClip
		{
			return _primeiraCamada;
		}
		
		/**
		 * @private
		 */
		public function set primeiraCamada(value:MovieClip):void
		{
			_primeiraCamada = value;
		}
		
		/**
		 * Um MovieClip - conteudo em segunda camada.
		 * @see _mainMovieClip
		 */
		public function get segundaCamada():MovieClip
		{
			return _segundaCamada;
		}
		
		/**
		 * @private
		 */
		public function set segundaCamada(value:MovieClip):void
		{
			_segundaCamada = value;
		}

		
		
	}
		

	
}
