package  {
	
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.sampler.pauseSampling;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.ScrollPolicy;

	
	public class MainGame {
		private var clock : uint;
		private var clockDisplay : TextField;
		
		private var planeta : Planeta;
		private var terra : Planeta;
		private var laboratorio : ScrollPane;
		private var labButton : Button;
		private var minerioTextField : TextField;
		private var energiaTextField : TextField;
		private var tecnologias : Vector.<Tecnologia>;
		private var dependencias : Vector.<Vector.<Number>>;
		
		private var _pretty : Pretty;
		private var _mainMovieClip : MovieClip;
		
		private var _nivel : uint;

		
		private var vitoria : Boolean;
		
		public function MainGame(mainMovieClip : MovieClip = null, nivel : int = NaN) {
			_mainMovieClip = mainMovieClip;
			_nivel = nivel;

			_mainMovieClip.gotoAndStop("MainGame");
			_pretty = new Pretty();
			vitoria = false;
			
			clock = 0;
			clockDisplay = new TextField();
			clockDisplay.text = intToTime(clock);
			
			
			planeta = new Planeta();	
			tecnologias = new Vector.<Tecnologia>();
			dependencias = new Vector.<Vector.<Number>>();
			

			init();
			



		}
		

		public function get pretty():Pretty
		{
			return _pretty;
		}

		public function set pretty(value:Pretty):void
		{
			_pretty = value;
		}

		/**
		 * Instancializa ecrã.
		 */
		public function init() : void {
			


			
			
			// BUTAO LAB
			labButton = new Button();			
			labButton.width = 100;
			labButton.move(5,5);
			labButton.label = "LABORATÓRIO";
			labButton.addEventListener(MouseEvent.CLICK, labButtonClick);
			_mainMovieClip.addChild(labButton);
	
			
			// TECNOLOGIAS PANEL
			laboratorio = new ScrollPane();
			//laboratorio.opaqueBackground = 0x2b2f43;
			
			laboratorio.y = 40;
			laboratorio.height = 325;
			laboratorio.width = 640;
			laboratorio.horizontalScrollPolicy = ScrollPolicy.OFF;
			laboratorio.visible = false;
			

			
			// RECURSOS
			minerioTextField = new TextField();
			minerioTextField.defaultTextFormat = _pretty.heading1;
			minerioTextField.text = "Minerio: " + planeta.recursos.minerio;
			minerioTextField.x = 200;
			minerioTextField.y = 5;
			minerioTextField.height = 30;
	
			energiaTextField = new TextField();
			energiaTextField.defaultTextFormat = _pretty.heading1;
			energiaTextField.text = "Energia: " + planeta.recursos.energia;
			energiaTextField.x = 350;
			energiaTextField.y = 5;
			energiaTextField.height = 30;
			
			_mainMovieClip.addChild(minerioTextField);
			_mainMovieClip.addChild(energiaTextField);
	
			// CLOCK DISPLAY
			clockDisplay.x = 550;
			clockDisplay.y = 5;
			clockDisplay.height = 30;
			clockDisplay.defaultTextFormat = _pretty.heading1;
			_mainMovieClip.addChild(clockDisplay);

			
			// Loading dos dados das dependencias	
			var dataDependencias:XML = new XML();
			var xml_LoaderDependencias:URLLoader = new URLLoader();
			xml_LoaderDependencias.load(new URLRequest("data/dependencias.xml"));			
			xml_LoaderDependencias.addEventListener(Event.COMPLETE, do_XMLDependencias);
			
			// Loading dos dados dos planetas
			var dataPlanetas:XML = new XML();
			var xml_LoaderPlanetas:URLLoader = new URLLoader();
			xml_LoaderPlanetas.load(new URLRequest("data/planetas.xml"));			
			xml_LoaderPlanetas.addEventListener(Event.COMPLETE, do_XMLPlanetas);
			
			// Loading dos dados das tecnologias	
			var dataTecnologias:XML = new XML();
			var xml_LoaderTecnologias:URLLoader = new URLLoader();
			xml_LoaderTecnologias.load(new URLRequest("data/tecnologias.xml"));			
			xml_LoaderTecnologias.addEventListener(Event.COMPLETE, do_XMLTecnologias);
			

			
			
			
		}

		/**
		 * Timer para a atualizção da simulação.
		 * @see atualizaSimulacao
		 */
		public function setTimer() : void {
			var timerUpdate : Timer = new Timer(1000, 1);
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
			
			for (var i : uint = 0; i < tecnologias.length; i++) {
				
				if (tecnologias[i].custoMinerioAtual > planeta.recursos.minerio) {
					tecnologias[i].nivelButtons.disabled = true;
					tecnologias[i].nivelButtons.nivelUpButton.removeEventListener(MouseEvent.CLICK, tecnologias[i].evoluiTecnologia);
					tecnologias[i].nivelButtons.nivelUpButton.removeEventListener(MouseEvent.CLICK, tecnologias[i].vendeTecnologia);
					
				}
				else {
					tecnologias[i].nivelButtons.disabled = false;
					tecnologias[i].nivelButtons.buttonMode = true;
					tecnologias[i].nivelButtons.nivelUpButton.addEventListener(MouseEvent.CLICK, tecnologias[i].evoluiTecnologia);
					tecnologias[i].nivelButtons.nivelUpButton.addEventListener(MouseEvent.CLICK, tecnologias[i].vendeTecnologia);

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
		 * Funcao de loading de planetas
		 */
		private function do_XMLPlanetas (e : Event) {
			var data : XML = new XML(e.target.data);
			var tecnologiasContainer : MovieClip = new MovieClip();
			var i : uint;
			terra = new Planeta();
			terra.nome = data.terra.nome;
			terra.distanciaEstrelaMae = data.terra.distanciaEstrelaMae;
			terra.periodoTranslacao = data.terra.dado[Planeta.LAPSE];
			terra.periodoRotacao = data.terra.dado[Planeta.SPIN];
			for (i = 0; i<data.terra.dado.length(); i++) {
				terra.dados[i] = new Parametro(data.terra.dado[i].nome, i, data.terra.dado[i].parametro.valor, data.terra.dado[i].parametro.minimo, data.terra.dado[i].parametro.maximo);
				
			}
			
			planeta = new Planeta(terra);
			planeta.nome = data.planeta.nome;
			planeta.distanciaEstrelaMae = data.planeta.distanciaEstrelaMae;
			planeta.periodoTranslacao = data.planeta.periodoTranslacao;
			planeta.periodoRotacao = data.planeta.periodoRotacao;
			
			var contadorColunas : uint = 0;
			var contadorLinhas : uint = 0;
			
			for (i = 0; i<data.planeta.dado.length(); i++) {
				
				planeta.dados[i] = new Parametro(data.planeta.dado[i].nome, i, data.planeta.dado[i].parametro.valor);
				planeta.dados[i].x = 160*contadorColunas;
				planeta.dados[i].y = 370 + contadorLinhas * 35;
				planeta.dados[i].valorLabel.setStyle("textFormat", _pretty.body);
				_mainMovieClip.addChild(planeta.dados[i]);
				
				// ajustar em colunas 
				if (contadorColunas >= 3) {
					contadorColunas = 0;
					contadorLinhas++;
				}
				else {
					contadorColunas++;
				}
				
				
			}
			
			planeta.atualizaDados();
						
			
			
		}
		
		/**
		 * Funcao de loading de tecnologias
		 */
		private function do_XMLTecnologias (e : Event) {
			var data : XML = new XML(e.target.data);
			var tecnologiasContainer : MovieClip = new MovieClip();
			for (var i : uint = 0; i<data.tecnologia.length(); i++) {
				
				tecnologias[i] = new Tecnologia(_mainMovieClip, planeta, 0, data.tecnologia[i].nome, data.tecnologia[i].descricao, data.tecnologia[i].custos.minerio, data.tecnologia[i].custos.energia);
				
				for(var j : uint = 0; j<data.tecnologia[i].actions[0].*.length();j++) {
					tecnologias[i].actions.push(new Parametro(data.tecnologia[i].actions.*[j].nome, i, data.tecnologia[i].actions.*[j].valor));

					
					tecnologias[i].imagemTecnologia.source = "media/parametros/data0.png";
					
					tecnologias[i].imagemTecnologia.scaleContent = true; 
					
					tecnologias[i].imagemTecnologia.addEventListener(Event.COMPLETE, completeHandler); 
					


				}
				
				// popula label com as consequencias desta tecnologia no planeta
				tecnologias[i].atualizaActions();

				// accionar butoes
				tecnologias[i].nivelButtons.nivelUpButton.buttonMode = true;
				tecnologias[i].nivelButtons.nivelDownButton.buttonMode = true;
				
				// layout
				tecnologias[i].y = i*163.95;
				tecnologias[i].x = 0;
				tecnologiasContainer.addChild(tecnologias[i]);
				
				
				laboratorio.source = tecnologiasContainer;
				
				_mainMovieClip.addChild(laboratorio);
			}
			setTimer();
			
		}
		
		/**
		 * Funcao de loading de dependencias
		 */
		private function do_XMLDependencias (e : Event) {
			var data : XML = new XML(e.target.data);
			
			for (var i : uint = 0; i < data.*.length(); i++) {
				dependencias[i] = new Vector.<Number>;
				for (var j : uint = 0; j < data.*[i].sideEffects.*.length(); j++) {
					dependencias[i][j] = data.*[i].sideEffects.*[j].valor;
				}
			}
			
			
		}
		
		function completeHandler(event:Event) { 
			trace("Number of bytes loaded: " + event.target.bytesLoaded); 
		}
		
		
	}
		

	
}
