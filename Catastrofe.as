package
{
	import flash.events.Event;
	import flash.text.TextField;

	public class Catastrofe
	{
		public static var TSUNAMI : uint = 0;
		public static var ERUPSAO : uint = 1;
		public static var METEORITO : uint = 2;
		
		private var _codigo : uint;
		private var _probabilidadeOcorrencia : Number;
		
		private var banner : TextField;
	
		public function Catastrofe(mainMovieClip : MovieClip)
		{
			banner = new TextField;
			banner.defaultTextFormat = Pretty.HEADING_1;
			banner.text = "TSUNAMI REGISTADO NA COORDENADA 34,23'12''";
			banner.background = true;
			banner.backgroundColor = 0x000000;
			
			banner.x = 0;
			banner.y = 350;
			banner.width = mainMovieClip.stage.stageWidth();
			banner.height = 40;
			banner.rotationX = 90;
			
			addEventListener(Event.ENTER_FRAME, move);
			
		}
		
		private function move(e : Event) {
			banner.rotationX -= 3.75;
		}
		
		public function get probabilidadeOcorrencia():Number
		{
			return _probabilidadeOcorrencia;
		}

		public function set probabilidadeOcorrencia(value:Number):void
		{
			_probabilidadeOcorrencia = value;
		}

		public function get codigo():uint
		{
			return _codigo;
		}

		public function set codigo(value:uint):void
		{
			_codigo = value;
		}

		public function alteraPlaneta(direcao : Boolean) : void {
			// TODO
		}
	}
}