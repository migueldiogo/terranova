package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import fl.containers.UILoader;
	import fl.controls.Label;
	
	
	public class Niveis
	{
		private var _niveis : Array;
		private var _pretty : Pretty;
		
		public function Niveis(mainMovieClip : MovieClip = null)
		{
			_niveis = new Array;
			_pretty = new Pretty();
			super();
			gotoAndStop(1);
			
			var title : TextField = new TextField();
			title.width = 640;
			title.defaultTextFormat = _pretty.title1;
			
			title.text = "TERRA NOVA";
			
			title.x = 0;
			title.y = 20;
			addChild(title);
			
			var colunas : uint = 0;
			var linhas : uint = 0;
			for (var i : uint = 0; i < 10; i++) {
				// adiciona label do nivel
				var label : Label = new Label;
				label.text = "Nivel " + (i+1);
				label.setStyle("textFormat", _pretty.heading1); 
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
				nivelLoader.buttonMode = true;
				nivelLoader.addEventListener(MouseEvent.CLICK, startLevel);
				
				addChild(label);
				addChild(nivelLoader);
				
				if (colunas == 4) {
					linhas++;
					colunas = 0;
				}
				else {
					colunas++;
				}
			}
			
			
		}
		
		public function get pretty():Pretty
		{
			return _pretty;
		}
		
		public function set pretty(value:Pretty):void
		{
			_pretty = value;
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
					new MainGame(this, i);
				}
				
			}
		}
		
		
	}
	
	
}

