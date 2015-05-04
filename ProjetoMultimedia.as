package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.ScrollPolicy;
	
	
	public class ProjetoMultimedia extends MovieClip {
		private var planeta : Planeta;
		private var terra : Planeta;
		private var laboratorio : ScrollPane;
		private var labButton : Button;
		private var minerioTextField : TextField;
		private var energiaTextField : TextField;
		private var tecnologias : Vector.<Tecnologia>;

		
		private var planetaTextField : TextField;

		
		public function ProjetoMultimedia() {
			
			planeta = new Planeta("Terra", 1, 10, 1, 15);	
			tecnologias = new Vector.<Tecnologia>();
			
			planetaTextField = new TextField();

			init();


		}
		
		/**
		 * Instancializa ecrã.
		 */
		private function init() : void {
			
			// DADOS DO PLANETA - LAYOUT
			var formatoTextPlaneta : TextFormat = new TextFormat();
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

			
			
			// BUTAO LAB
			labButton = new Button();			
			labButton.width = 100;
			labButton.move(5,5);
			labButton.label = "LABORATÓRIO";
			labButton.addEventListener(MouseEvent.CLICK, labButtonClick);
			addChild(labButton);
	
			
			// TECNOLOGIAS PANEL
			laboratorio = new ScrollPane();
			laboratorio.opaqueBackground = 0x2b2f43;
			
			laboratorio.y = 40;
			laboratorio.height = 440;
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
		private function setTimer() : void {
			var timerUpdate : Timer = new Timer(1000, 1);
			timerUpdate.addEventListener(TimerEvent.TIMER_COMPLETE, atualizaSimulacao);
			timerUpdate.start();
		}
		
		/**
		 * Atualiza os dados apresentados no ecra (label, butoes ativados). Pode ser despoletada por um timer ou de forma forçada com limitações.
		 */
		private function atualizaSimulacao (e : Event) {
			// incrementa recursos so quando a funcao for despoletada pelo temporizador 
			if (e != null) {
				planeta.recursos.minerio += planeta.recursos.minerioTaxa;
				planeta.recursos.energia += planeta.recursos.energiaTaxa;
				setTimer();

			}
			
			minerioTextField.text = "Minerio: " + planeta.recursos.minerio;
			energiaTextField.text = "Energia: " + planeta.recursos.energia;
			
			for (var i : uint = 0; i < tecnologias.length; i++) {
				
				if (tecnologias[i].custoMinerioAtual > planeta.recursos.minerio) {
					tecnologias[i].nivelButtons.disabled = true;
					tecnologias[i].nivelButtons.nivelUpButton.removeEventListener(MouseEvent.CLICK, evoluiTecnologia);
					tecnologias[i].nivelButtons.nivelUpButton.removeEventListener(MouseEvent.CLICK, vendeTecnologia);
					
				}
				else {
					tecnologias[i].nivelButtons.disabled = false;
					tecnologias[i].nivelButtons.buttonMode = true;
					tecnologias[i].nivelButtons.nivelUpButton.addEventListener(MouseEvent.CLICK, evoluiTecnologia);
					tecnologias[i].nivelButtons.nivelUpButton.addEventListener(MouseEvent.CLICK, vendeTecnologia);

				}

			}	
			

			
		}
		
		/**
		 * Funcao despoletadora do click do butao de laboratorio
		 */
		private function labButtonClick (e : MouseEvent) {
			if (laboratorio.visible)
				laboratorio.visible = false;
			else
				laboratorio.visible = true;
		}
		
		private function atualizaDadosPlaneta () : void {
			var texto : String = "Nome: " + planeta.nome + "\n" + 
				"Distancia Estrela: " + planeta.distanciaEstrelaMae + "\n" + 
				"Periodo de Translação: " + planeta.periodoTranslacao + "\n" + 
				"Periodo de Rotação: " + planeta.periodoRotacao + "\n";
			
			texto += "\n";
			for (var i  = 0; i<planeta.atmosfera.length; i++) {
				
				texto += planeta.atmosfera[i].nome + ": " + planeta.atmosfera[i].valor + "\n";
				trace(texto);
			}
			texto += "\n";
			
			for (i = 0; i<planeta.geodinamica.length; i++) {
				texto += planeta.geodinamica[i].nome + ": " + planeta.geodinamica[i].valor + "\n";
			}
			
			planetaTextField.text = texto;
		}
		
		/**
		 * Funcao despoletadora da evolucao de uma tecnologia ao clicar no botao de "evoluir"
		 */
		private function evoluiTecnologia (e : MouseEvent) {
			planeta.recursos.minerio -= e.target.parent.parent.parent.parent.custoMinerioAtual;
			e.target.parent.parent.parent.parent.nivel++;
			e.target.parent.parent.parent.parent.atualiza();
			atualizaSimulacao(null);
			atualizaDadosPlaneta();
		}	
		/**
		 * Funcao despoletadora da venda de uma tecnologia ao clicar no botao de "vender"
		 */
		private function vendeTecnologia (e : MouseEvent) {
			//TODO
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
			terra.periodoTranslacao = data.terra.periodoTranslacao;
			terra.periodoRotacao = data.terra.periodoRotacao;
			for (i = 0; i<data.terra.atmosfera.gas.length(); i++) {
				terra.atmosfera[i] = new Parametro(data.terra.atmosfera.gas[i].nome, data.terra..atmosfera.gas[i].valor, data.terra.atmosfera.gas[i].minimo, data.terra.atmosfera.gas[i].maximo);
				
			}
			for (i = 0; i<data.geodinamica.elemento.length(); i++) {
				terra.geodinamica[i] = new Parametro(data.terra.geodinamica.elemento[i].nome, data.terra.geodinamica.elemento[i].valor, data.terra.geodinamica.elemento[i].minimo, data.terra.geodinamica.elemento[i].maximo);
			}
			
			
			planeta = new Planeta();
			planeta.nome = data.planeta.nome;
			planeta.distanciaEstrelaMae = data.planeta.distanciaEstrelaMae;
			planeta.periodoTranslacao = data.planeta.periodoTranslacao;
			planeta.periodoRotacao = data.planeta.periodoRotacao;
			for (i = 0; i<data.planeta.atmosfera.gas.length(); i++) {
				planeta.atmosfera[i] = new Parametro(data.planeta.atmosfera.gas[i].nome, data.planeta.atmosfera.gas[i].valor);
				
			}
			for (i = 0; i<data.planeta.geodinamica.elemento.length(); i++) {
				planeta.geodinamica[i] = new Parametro(data.planeta.geodinamica.elemento[i].nome, data.planeta.geodinamica.elemento[i].valor);
			}
			
			
			atualizaDadosPlaneta();
			
			
			
		}
		
		/**
		 * Funcao de loading de tecnologias
		 */
		private function do_XMLTecnologias (e : Event) {
			var data : XML = new XML(e.target.data);
			var tecnologiasContainer : MovieClip = new MovieClip();
			for (var i : uint = 0; i<data.tecnologia.length(); i++) {
				

				
				tecnologias[i] = new Tecnologia(planeta, 0, data.tecnologia[i].nome, data.tecnologia[i].descricao, data.tecnologia[i].custos.minerio);
				
				for(var j : uint = 0; j<data.tecnologia[i].actions[0].*.length();j++) {
					if (data.tecnologia[i].actions.*[j].@type == "atmosfera") {
						tecnologias[i].actionsAtmosfera.push(new Parametro(data.tecnologia[i].actions.*[j].nome, data.tecnologia[i].actions.*[j].valor));
					}
					else {
						tecnologias[i].actionsGeodinamica.push(new Parametro(data.tecnologia[i].actions.*[j].nome, data.tecnologia[i].actions.*[j].valor));
					}
					
					tecnologias[i].imagemTecnologia.source = "http://cdn.radiolive.co.nz/radiolive/AM/2014/12/21/67690/tech-advances-dance-music.jpg";
					
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
		
		function completeHandler(event:Event) { 
			trace("Number of bytes loaded: " + event.target.bytesLoaded); 
		}
		
		
	}
		

	
}
