package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.ScrollPolicy;

	
	public class MainGame {
		private var _container : MovieClip;
		
		private var clock : uint;
		private var clockDisplay : TextField;
		
		private var planeta : Planeta;
		private var terra : Planeta;
		private var laboratorio : ScrollPane;
		private var labButton : Button;
		private var minerioTextField : TextField;
		private var energiaTextField : TextField;
		
		private var pauseAndPlayButton : PausePlayButton;
		
		private var timerUpdate : Timer;
		
		
		
		private var _mainMovieClip : MovieClip;
		
		private var _nivel : uint;
		private var _jogador : Jogador;
		
		private var vitoria : Boolean;
		
		public function MainGame(mainMovieClip : MovieClip, nivel : uint, jogador : Jogador) {
			_container = new MovieClip();
			_mainMovieClip = mainMovieClip;
			
			laboratorio = new ScrollPane();
			
			_jogador = jogador;
			_nivel = nivel;

			_mainMovieClip.gotoAndStop("MainGame");
			vitoria = false;
			
			clock = 0;
			clockDisplay = new TextField();
			clockDisplay.text = intToTime(clock);
			
			// se jogador ja jogou este nivel, carrega da memoria, se nao cria novo planeta com reset = true
			planeta = new Planeta(this, _jogador, _nivel, _jogador.planetas[_nivel-1] == null);
			
			//tecnologias = new Vector.<Tecnologia>();
			_mainMovieClip.addChild(_container);
			
		}
		


		/**
		 * Instancializa ecrã.
		 */
		public function init() : void {

			// importa e formata dados do planeta para o ecra
			importaDadosDoPlaneta();
			
			// TECNOLOGIAS PANEL
			//laboratorio.opaqueBackground = 0x2b2f43;			
			laboratorio.y = 40;
			laboratorio.height = 325;
			laboratorio.width = 640;
			laboratorio.horizontalScrollPolicy = ScrollPolicy.OFF;
			laboratorio.visible = false;

			// importa e formata tecnologias do planeta para o ecra
			importaTecnologiasDoPlaneta();
	
			
			
			// BUTAO LAB
			labButton = new Button();			
			labButton.width = 100;
			labButton.move(5,5);
			labButton.label = "LABORATÓRIO";
			labButton.addEventListener(MouseEvent.CLICK, labButtonClick);
			_container.addChild(labButton);
	

			
			

			

			
			// RECURSOS
			minerioTextField = new TextField();
			minerioTextField.defaultTextFormat = Pretty.HEADING_1;
			minerioTextField.text = "Minerio: " + planeta.recursos.minerio;
			minerioTextField.x = 200;
			minerioTextField.y = 5;
			minerioTextField.height = 30;
	
			energiaTextField = new TextField();
			energiaTextField.defaultTextFormat = Pretty.HEADING_1;
			energiaTextField.text = "Energia: " + planeta.recursos.energia;
			energiaTextField.x = 350;
			energiaTextField.y = 5;
			energiaTextField.height = 30;
			
			_container.addChild(minerioTextField);
			_container.addChild(energiaTextField);
	
			// CLOCK DISPLAY
			clockDisplay.x = 550;
			clockDisplay.y = 5;
			clockDisplay.height = 30;
			clockDisplay.defaultTextFormat = Pretty.HEADING_1;
			_container.addChild(clockDisplay);
			
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
			for (var i : uint = 0; i < planeta.dados.length && vitoria; i++) {
				if (planeta.dados[i].correto == false)
					vitoria = false;
				trace(planeta.dados[i].nome + " " + planeta.dados[i].correto);
			}
			
			return vitoria;
		}
		
		
		/**
		 * Atualiza os dados apresentados no ecra (label, butoes ativados). Pode ser despoletada por um timer ou de forma forçada com limitações.
		 */
		public function atualizaSimulacao (e : Event) {
			// incrementa recursos so quando a funcao for despoletada pelo temporizador 
			if (e != null) {
				planeta.recursos.minerio += planeta.dados[Planeta.TAXA_MINERIO].valor;
				clock++;
				clockDisplay.text = intToTime(clock);
				
				setTimer();

			}
			
			minerioTextField.text = "Minerio: " + planeta.recursos.minerio;
			energiaTextField.text = "Energia: " + planeta.recursos.energia;
			
			for (var i : uint = 0; i < planeta.tecnologias.length; i++) {
				trace("DESSATIVEI" + " " + planeta.tecnologias[i].custoMinerioAtual +" " + planeta.recursos.minerio);

				if (planeta.tecnologias[i].custoMinerioAtual > planeta.recursos.minerio) {
					planeta.tecnologias[i].nivelButtons.disabled = true;
					planeta.tecnologias[i].nivelButtons.nivelUpButton.removeEventListener(MouseEvent.CLICK, planeta.tecnologias[i].evoluiTecnologia);
					planeta.tecnologias[i].nivelButtons.nivelUpButton.removeEventListener(MouseEvent.CLICK, planeta.tecnologias[i].vendeTecnologia);
					
				}
				else {
					planeta.tecnologias[i].nivelButtons.disabled = false;
					planeta.tecnologias[i].nivelButtons.buttonMode = true;
					planeta.tecnologias[i].nivelButtons.nivelUpButton.addEventListener(MouseEvent.CLICK, planeta.tecnologias[i].evoluiTecnologia);
					planeta.tecnologias[i].nivelButtons.nivelUpButton.addEventListener(MouseEvent.CLICK, planeta.tecnologias[i].vendeTecnologia);

				}

			}	
			
			if (verificaVitoria()) {
				_mainMovieClip.gotoAndStop(2);
				vitoria = true;
				laboratorio.visible = false;
				trace("VITORIA");
				
			}

			
		}
		
		/**
		 * Funcao despoletadora do click do butao de laboratorio
		 */
		public function labButtonClick (e : MouseEvent) {
			

			if (laboratorio.visible) {
				laboratorio.visible = false;
				_mainMovieClip.background.filters = [];
				_mainMovieClip.alienPlanet.filters = [];

			}
			else {
				laboratorio.visible = true;
				
				var blurFilter:BlurFilter = new BlurFilter();
				blurFilter.blurX = 64;
				blurFilter.blurY = 64;

				blurFilter.quality = BitmapFilterQuality.HIGH;
				
				_mainMovieClip.background.filters = [blurFilter];
				_mainMovieClip.alienPlanet.filters = [blurFilter];
			}
		}
		
		
		
		
		
		/**
		 * Importa e formata dados do planeta
		 */
		private function importaDadosDoPlaneta () {
		
			// escreve os dados do planeta
			var contadorColunas : uint = 0;
			var contadorLinhas : uint = 0;
			for (var i : uint = 0; i<planeta.dados.length; i++) {
				trace(planeta.dados[i].nome);
				planeta.nivel = i+1;
				planeta.dados[i].x = 160*contadorColunas;
				planeta.dados[i].y = 370 + contadorLinhas * 35;
				planeta.dados[i].valorLabel.setStyle("textFormat", Pretty.BODY);
				_container.addChild(planeta.dados[i]);
				
				// ajustar em colunas 
				if (contadorColunas >= 3) {
					contadorColunas = 0;
					contadorLinhas++;
				}
				else {
					contadorColunas++;
				}
				
				
			}
			
			planeta.verificaDados();		// dados sao formatados consoante o seu estado (errado ou certo)

			

						
			
			
		}
	
			
			
		
		/**
		 * Importa e formata tecnologias do planeta
		 */
		private function importaTecnologiasDoPlaneta () {
			
			var tecnologiasContainer : MovieClip = new MovieClip();

			for (var i : uint = 0; i<planeta.tecnologias.length; i++) {
				
				// layout
				planeta.tecnologias[i].y = i*163.95;
				planeta.tecnologias[i].x = 0;
				
				tecnologiasContainer.addChild(planeta.tecnologias[i]);
				
				
				laboratorio.source = tecnologiasContainer;
				
				_container.addChild(laboratorio);
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
			}
			else {
				// RESUME SIMULATION
				pauseAndPlayButton.setPause();
				timerUpdate.start();
				
			}
		}
		
		
	}
		

	
}
