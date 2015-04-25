package
{
	public class Astro
	{
		protected var _nome : String;
		protected var _raio : Number;
		protected var _gravidade : Number;
		protected var _massa : Number;
		protected var _temperatura : Number;
		

		public function Astro(nome : String = null, raio : Number = NaN, gravidade : Number = NaN, massa : Number = NaN, temperatura : Number = NaN) {
			this.nome = nome;
			this.raio = raio;
			this.gravidade = gravidade;
			this.massa = massa;
			this.temperatura = temperatura;	
		}
		
		
		


		public function get temperatura():Number
		{
			return _temperatura;
		}

		public function set temperatura(value:Number):void
		{
			_temperatura = value;
		}

		public function get massa():Number
		{
			return _massa;
		}

		public function set massa(value:Number):void
		{
			_massa = value;
		}

		public function get gravidade():Number
		{
			return _gravidade;
		}

		public function set gravidade(value:Number):void
		{
			_gravidade = value;
		}

		public function get raio():Number
		{
			return _raio;
		}

		public function set raio(value:Number):void
		{
			_raio = value;
		}

		public function get nome():String
		{
			return _nome;
		}

		public function set nome(value:String):void
		{
			_nome = value;
		}

	}
}