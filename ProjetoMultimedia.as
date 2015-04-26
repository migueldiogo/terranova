package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.ScrollPolicy;
	
	
	public class ProjetoMultimedia extends MovieClip {
		private var planeta : Planeta;
		private var laboratorio : ScrollPane;
		private var labButton : Button;
		private var minerioTextField : TextField;
		private var energiaTextField : TextField;

		
		public function ProjetoMultimedia() {
			setTimer();
			planeta = new Planeta("Terra", 1, 10, 1, 15);
			
			// BUTAO LAB
			labButton = new Button();			
			//labButton.height = 5;
			labButton.width = 90;
			labButton.move(5,5);
			labButton.label = "LAB";
			//labButton.emphasized = true;

			//labButton.opaqueBackground = 0xFF0000;
			labButton.addEventListener(MouseEvent.CLICK, labButtonClick);
			addChild(labButton);
			
			
			// TECNOLOGIAS
			laboratorio = new ScrollPane();
		
			laboratorio.y = 40;
			laboratorio.height = 440;
			laboratorio.width = 640;
			laboratorio.horizontalScrollPolicy = ScrollPolicy.OFF;
			laboratorio.visible = false;

			
			var tecnologias : Vector.<Tecnologia> = new Vector.<Tecnologia>();
			var tecnologiasContainer : MovieClip = new MovieClip();
			for (var i : uint = 0; i<6; i++) {
				
				tecnologias[i] = new Tecnologia(i);
				tecnologias[i].codigoTecnologia = i;
				
				tecnologias[i].y = i*150;
				tecnologias[i].x = 0;
				tecnologiasContainer.addChild(tecnologias[i]);
			}
			
			laboratorio.source = tecnologiasContainer;
			addChild(laboratorio);
			
			
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
