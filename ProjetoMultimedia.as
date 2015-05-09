package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.ScrollPolicy;
	import flash.display.StageScaleMode;

	
	public class ProjetoMultimedia extends MovieClip {
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
		
		private var formatoTextPlaneta : TextFormat;

		
		private var planetaTextField : TextField;

		
		public function ProjetoMultimedia() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			clock = 0;
			clockDisplay = new TextField();
			clockDisplay.text = intToTime(clock);
			
			
			planeta = new Planeta();	
			tecnologias = new Vector.<Tecnologia>();
			dependencias = new Vector.<Vector.<Number>>();
			
			planetaTextField = new TextField();

			
			// DADOS DO PLANETA - LAYOUT
			formatoTextPlaneta  = new TextFormat();
			formatoTextPlaneta.font = "Arial";
			formatoTextPlaneta.size = 12;
			formatoTextPlaneta.color = 0xFFFFFF;
			
			planetaTextField = new TextField();
			planetaTextField.defaultTextFormat = formatoTextPlaneta;
			planetaTextField.x = 5;
			planetaTextField.y = 50;
			planetaTextField.width = 200;
			planetaTextField.height = 400;
			planetaTextField.wordWrap = true;
			
			addChild(planetaTextField);
			
			
			init();
			



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
			addChild(labButton);
	
			
			// TECNOLOGIAS PANEL
			laboratorio = new ScrollPane();
			//laboratorio.opaqueBackground = 0x2b2f43;
			
			laboratorio.y = 40;
			laboratorio.height = 325;
			laboratorio.width = 640;
			laboratorio.horizontalScrollPolicy = ScrollPolicy.OFF;
			laboratorio.visible = false;
			

			
			// RECURSOS
			var formatoTextRecursos : TextFormat = new TextFormat();
			formatoTextRecursos.font = "Arial";
			formatoTextRecursos.size = 15;
			formatoTextRecursos.color = 0xFFFFFF;
			

			minerioTextField = new TextField();
			minerioTextField.defaultTextFormat = formatoTextRecursos;
			minerioTextField.text = "Minerio: " + planeta.recursos.minerio;
			minerioTextField.x = 200;
			minerioTextField.y = 5;
			minerioTextField.height = 30;
	
			energiaTextField = new TextField();
			energiaTextField.defaultTextFormat = formatoTextRecursos;
			energiaTextField.text = "Energia: " + planeta.recursos.energia;
			energiaTextField.x = 350;
			energiaTextField.y = 5;
			energiaTextField.height = 30;
			
			addChild(minerioTextField);
			addChild(energiaTextField);
	
			// CLOCK DISPLAY
			clockDisplay.x = 550;
			clockDisplay.y = 5;
			clockDisplay.height = 30;
			clockDisplay.defaultTextFormat = formatoTextRecursos;
			addChild(clockDisplay);

			
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
			

			
		}
		
		/**
		 * Funcao despoletadora do click do butao de laboratorio
		 */
		public function labButtonClick (e : MouseEvent) {
			

			if (laboratorio.visible) {
				laboratorio.visible = false;
				background.filters = [];
				alienPlanet.filters = [];

			}
			else {
				laboratorio.visible = true;
				
				var blurFilter:BlurFilter = new BlurFilter();
				blurFilter.blurX = 64;
				blurFilter.blurY = 64;

				blurFilter.quality = BitmapFilterQuality.HIGH;
				
				background.filters = [blurFilter];
				alienPlanet.filters = [blurFilter];
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
				planeta.dados[i].valorLabel.setStyle("textFormat", formatoTextPlaneta);
				addChild(planeta.dados[i]);
				trace(data.planeta.dado[i].valor);
				
				// ajustar em colunas 
				if (contadorColunas >= 3) {
					contadorColunas = 0;
					contadorLinhas++;
					trace("muda linha");
				}
				else {
					contadorColunas++;
					trace("muda col");
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
				
				tecnologias[i] = new Tecnologia(this, planeta, 0, data.tecnologia[i].nome, data.tecnologia[i].descricao, data.tecnologia[i].custos.minerio, data.tecnologia[i].custos.energia);
				
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
				
				addChild(laboratorio);
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
