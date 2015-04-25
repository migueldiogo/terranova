package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	
	
	public class ProjetoMultimedia extends MovieClip {
		var side : SideMenuMain;
		
		public function ProjetoMultimedia() {
			
			var planeta : Planeta = new Planeta("Terra", 1, 10, 1, 15);
			
			
			
			// TECNOLOGIAS
			var side2 : ScrollPane = new ScrollPane();
		
			side2.height = 480;
			side2.width = 130;
			side2.horizontalScrollPolicy = ScrollPolicy.OFF;
			
			
			
			var tecnologias : Vector.<Tecnologia> = new Vector.<Tecnologia>();
			var tecnologiasContainer : MovieClip = new MovieClip();
			for (var i : uint = 0; i<6; i++) {
				
				tecnologias[i] = new Tecnologia(i);
				tecnologias[i].codigoTecnologia = i;
				
				tecnologias[i].y = i*150;
				tecnologias[i].x = 0;
				tecnologiasContainer.addChild(tecnologias[i]);
			}
			
			side2.source = tecnologiasContainer;
			addChild(side2);
			
			
			// RECURSOS
			var formatoTextRecursos : TextFormat = new TextFormat();
			formatoTextRecursos.font = "Arial";
			formatoTextRecursos.size = 15;
			formatoTextRecursos.color = 0xFFFFFF;
			
			var minerioTextField : TextField = new TextField();
			minerioTextField.defaultTextFormat = formatoTextRecursos;
			minerioTextField.text = "Minerio: " + planeta.recursos.minerio;
			minerioTextField.x = 200;
			
			var energiaTextField : TextField = new TextField();
			energiaTextField.defaultTextFormat = formatoTextRecursos;
			energiaTextField.text = "Energia: " + planeta.recursos.energia;
			energiaTextField.x = 350;
			
			addChild(minerioTextField);
			addChild(energiaTextField);

			
		}
		
		
	}
		

	
}
