package
{
	public class Planeta extends Astro
	{

		private var _distanciaEstrelaMae : Number;
		private var _periodoTranslacao : Number;
		private var _periodoRotacao : Number;
		private var _satelites : Array;
		private var _habitavel : Boolean;
		private var _estrela : Estrela;
		private var _atmosfera : Atmosfera;
		private var _recursos : Recursos;
		private var _catastrofes : Array;
		private var _laboratorio : Laboratorio;
		
		
		public function Planeta(nome : String = null, raio : Number = NaN, gravidade : Number = NaN, massa : Number = NaN, temperatura : Number = NaN)
		{
			super();
			_catastrofes = new Array(3);
			catastrofes[Catastrofe.TSUNAMI] = new Catastrofe(Catastrofe.TSUNAMI, 0.5);
			catastrofes[Catastrofe.ERUPSAO] = new Catastrofe(Catastrofe.ERUPSAO, 0.5);
			catastrofes[Catastrofe.METEORITO] = new Catastrofe(Catastrofe.METEORITO, 0.5);	
			
			_recursos = new Recursos();

		}
		
		

		
		// 
		// Getters and Setters
		// 
		
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

		public function get atmosfera():Atmosfera
		{
			return _atmosfera;
		}

		public function set atmosfera(value:Atmosfera):void
		{
			_atmosfera = value;
		}

		public function get estrela():Estrela
		{
			return _estrela;
		}

		public function set estrela(value:Estrela):void
		{
			_estrela = value;
		}

		public function get habitavel():Boolean
		{
			return _habitavel;
		}

		public function set habitavel(value:Boolean):void
		{
			_habitavel = value;
		}

		public function get satelites():Array
		{
			return _satelites;
		}

		public function set satelites(value:Array):void
		{
			_satelites = value;
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