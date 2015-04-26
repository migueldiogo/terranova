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

		
		public function ProjetoMultimedia() {
			init();
			planeta = new Planeta("Terra", 1, 10, 1, 15);
			
			// BUTAO LAB
			labButton = new Button();			
			labButton.width = 90;
			labButton.move(5,5);
			labButton.label = "LAB";
			labButton.addEventListener(MouseEvent.CLICK, labButtonClick);
			addChild(labButton);
			
			
			// TECNOLOGIAS
			laboratorio = new ScrollPane();
			laboratorio.opaqueBackground = 0x2b2f43;
		
			laboratorio.y = 40;
			laboratorio.height = 440;
			laboratorio.width = 640;
			laboratorio.horizontalScrollPolicy = ScrollPolicy.OFF;
			laboratorio.visible = false;

			
			tecnologias = new Vector.<Tecnologia>();

			
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

			// XML

			
			var dataTecnologias:XML = new XML();
			
			var xml_LoaderTecnologias:URLLoader = new URLLoader();
			xml_LoaderTecnologias.load(new URLRequest("data/tecnologias.xml"));
			
			// once that data is loaded, the event will be passed to the do_XML function
			xml_LoaderTecnologias.addEventListener(Event.COMPLETE, do_XMLTecnologias);
			

		}
		
		private function init() : void {
			var dataPlanetas:XML = new XML();
			
			var xml_LoaderPlanetas:URLLoader = new URLLoader();
			xml_LoaderPlanetas.load(new URLRequest("data/planetas.xml"));
			
			// once that data is loaded, the event will be passed to the do_XML function
			xml_LoaderPlanetas.addEventListener(Event.COMPLETE, do_XMLPlanetas);
			
			

			
			
			
		}
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

			
			
			var formatoTextPlaneta : TextFormat = new TextFormat();
			formatoTextPlaneta.font = "Arial";
			formatoTextPlaneta.size = 12;
			formatoTextPlaneta.color = 0xFFFFFF;
			
			var planetaTextField : TextField = new TextField();
			planetaTextField.defaultTextFormat = formatoTextPlaneta;
			planetaTextField.x = 5;
			planetaTextField.y = 50;
			planetaTextField.width = 200;
			planetaTextField.height = 400;
			planetaTextField.wordWrap = true;
			
			
			var texto : String = "Nome: " + planeta.nome + "\n" + 
				"Distancia Estrela: " + planeta.distanciaEstrelaMae + "\n" + 
				"Periodo de Translação: " + planeta.periodoTranslacao + "\n" + 
				"Periodo de Rotação: " + planeta.periodoRotacao + "\n";
			
			texto += "\n";
			for (i  = 0; i<planeta.atmosfera.length; i++) {

				texto += planeta.atmosfera[i].nome + ": " + planeta.atmosfera[i].valor + "\n";
				trace(texto);
			}
			texto += "\n";

			for (i = 0; i<planeta.geodinamica.length; i++) {
				texto += planeta.geodinamica[i].nome + ": " + planeta.geodinamica[i].valor + "\n";
			}
			
			planetaTextField.text = texto;
						
			
			addChild(planetaTextField);
			
		}
		
		private function do_XMLTecnologias (e : Event) {
			var data : XML = new XML(e.target.data);
			var tecnologiasContainer : MovieClip = new MovieClip();
			for (var i : uint = 0; i<data.tecnologia.length(); i++) {
				tecnologias[i] = new Tecnologia(0, planeta, 0, data.tecnologia[i].nome, data.tecnologia[i].descricao, data.tecnologia[i].custos.minerio);
				
				// layout
				tecnologias[i].y = i*163.95;
				tecnologias[i].x = 0;
				tecnologiasContainer.addChild(tecnologias[i]);
				
				laboratorio.source = tecnologiasContainer;
				addChild(laboratorio);
			}
			setTimer();

		}
		
		private function setTimer() : void {
			var timerUpdate : Timer = new Timer(1000, 1);
			timerUpdate.addEventListener(TimerEvent.TIMER_COMPLETE, atualizaSimulacao);
			timerUpdate.start();
		}
		
		private function atualizaSimulacao (e : Event) {
			planeta.recursos.minerio += planeta.recursos.minerioTaxa;
			planeta.recursos.energia += planeta.recursos.energiaTaxa;
			
			minerioTextField.text = "Minerio: " + planeta.recursos.minerio;
			energiaTextField.text = "Energia: " + planeta.recursos.energia;
			
			for (var i : uint = 0; i<2; i++) {
				
				if (tecnologias[i].custoMinerioLevelUp > planeta.recursos.minerio)
					tecnologias[i].nivelButtons.disabled = true;
				else
					tecnologias[i].nivelButtons.disabled = false;

			}	
			
			setTimer();
		}
		private function labButtonClick (e : MouseEvent) {
			if (laboratorio.visible)
				laboratorio.visible = false;
			else
				laboratorio.visible = true;
		}
		
		
	}
		

	
}
