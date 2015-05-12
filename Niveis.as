package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	
	import fl.containers.UILoader;
	import fl.controls.Label;
	import fl.motion.Color;
	
	
	public class Niveis
	{
		private var _niveis : Array;
		private var container : MovieClip;
		private var _main : MovieClip;
		private var _jogador : Jogador;
		
		public function Niveis(main : MovieClip, jogador : Jogador)
		{
			_jogador = jogador;
			_main = main;
			_niveis = new Array;
			container = new MovieClip();
			
			_main.gotoAndStop(1);
			
			var title : TextField = new TextField();
			title.width = 640;
			title.defaultTextFormat = Pretty.TITLE_1;
			
			title.text = "TERRA NOVA";
			
			title.x = 0;
			title.y = 20;
			container.addChild(title);
			
			var colunas : uint = 0;
			var linhas : uint = 0;
			for (var i : uint = 0; i < 10; i++) {
				// adiciona label do nivel
				var label : Label = new Label;
				label.text = "Nivel " + (i+1);
				label.setStyle("textFormat", Pretty.HEADING_1); 
				label.x = 54 + colunas*120;
				label.y = 120 + linhas * 180;
				
				// adiciona icon do nivel
				var nivelLoader : UILoader = new UILoader();
				_niveis.push(nivelLoader);
				nivelLoader.width = 114;
				nivelLoader.height = 114;
				nivelLoader.source = "media/parametros/data" + i + ".png";

				nivelLoader.x = label.x - 40;
				nivelLoader.y = label.y + 20;
				
				// niveis estao bloqueados consoante o progresso do jogador
				if (i+1 <= _jogador.proximoNivel) {

					nivelLoader.buttonMode = true;
					nivelLoader.addEventListener(MouseEvent.CLICK, startLevel);
				}
				else {
					nivelLoader.buttonMode = false;
					nivelLoader.alpha = 0.4; 	//filters[new BlurFilter(20,20, BitmapFilterQuality.HIGH)];

				}
				
				container.addChild(label);
				container.addChild(nivelLoader);
				
				if (colunas == 4) {
					linhas++;
					colunas = 0;
				}
				else {
					colunas++;
				}
			}
			
			_main.addChild(container);
			
			
		}
		
		public function get niveis():Array
		{
			return _niveis;
		}
		
		public function set niveis(value:Array):void
		{
			_niveis = value;
		}
		
		private function startLevel (e : MouseEvent) {
			var encontrado : Boolean = false;
			for (var i :uint = 0; i < _niveis.length && !encontrado; i++) {
				if (e.currentTarget == _niveis[i]) {
					encontrado = true;
					new MainGame(_main, i+1, _jogador);
					_main.removeChild(container);
				}
				
			}
		}
		
		
	}
	
	
}

