package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class Planeta extends Astro
	{		
		public static var DIOXIDO_DE_CARBONO : uint = 0;
		public static var METANO : uint = 1;
		public static var AZOTO : uint = 2;
		public static var OXIGENIO : uint = 3;
		public static var OZONO : uint = 4;
		
		public static var GRAVIDADE : uint = 0;
		public static var LUAS : uint = 1;

		private var _distanciaEstrelaMae : Number;
		private var _periodoTranslacao : Number;
		private var _periodoRotacao : Number;
		
		private var _habitavel : Boolean;
		//private var _estrela : Estrela;
		
		private var _atmosfera : Vector.<Parametro>;
		private var _geodinamica : Vector.<Parametro>;
		
		private var _recursos : Recursos;
		private var _catastrofes : Array;
		private var _laboratorio : Laboratorio;
		
		
		public function Planeta(nome : String = null, raio : Number = NaN, gravidade : Number = NaN, massa : Number = NaN, temperatura : Number = NaN)
		{
			super();
			_atmosfera = new Vector.<Parametro>();
			_geodinamica = new Vector.<Parametro>();
			_catastrofes = new Array(3);
			catastrofes[Catastrofe.TSUNAMI] = new Catastrofe(Catastrofe.TSUNAMI, 0.5);
			catastrofes[Catastrofe.ERUPSAO] = new Catastrofe(Catastrofe.ERUPSAO, 0.5);
			catastrofes[Catastrofe.METEORITO] = new Catastrofe(Catastrofe.METEORITO, 0.5);	
			
			_recursos = new Recursos();
			

		}
		
		
		

		
		// 
		// Getters and Setters
		// 
		
		public function get geodinamica():Vector.<Parametro>
		{
			return _geodinamica;
		}

		public function set geodinamica(value:Vector.<Parametro>):void
		{
			_geodinamica = value;
		}

		public function get atmosfera():Vector.<Parametro>
		{
			return _atmosfera;
		}

		public function set atmosfera(value:Vector.<Parametro>):void
		{
			_atmosfera = value;
		}

		public function get laboratorio():Laboratorio
		{
			return _laboratorio;
		}

		public function set laboratorio(value:Laboratorio):void
		{
			_laboratorio = value;
		}

		public function get catastrofes():Array
		{
			return _catastrofes;
		}

		public function set catastrofes(value:Array):void
		{
			_catastrofes = value;
		}

		public function get recursos():Recursos
		{
			return _recursos;
		}

		public function set recursos(value:Recursos):void
		{
			_recursos = value;
		}


/*
		public function get estrela():Estrela
		{
			return _estrela;
		}

		public function set estrela(value:Estrela):void
		{
			_estrela = value;
		}
*/
		public function get habitavel():Boolean
		{
			return _habitavel;
		}

		public function set habitavel(value:Boolean):void
		{
			_habitavel = value;
		}



		public function get periodoRotacao():Number
		{
			return _periodoRotacao;
		}

		public function set periodoRotacao(value:Number):void
		{
			_periodoRotacao = value;
		}

		public function get periodoTranslacao():Number
		{
			return _periodoTranslacao;
		}

		public function set periodoTranslacao(value:Number):void
		{
			_periodoTranslacao = value;
		}

		public function get distanciaEstrelaMae():Number
		{
			return _distanciaEstrelaMae;
		}

		public function set distanciaEstrelaMae(value:Number):void
		{
			_distanciaEstrelaMae = value;
		}

		public function atualizaAparencia() : void {
			// TODO
		}
	
		
	}
}