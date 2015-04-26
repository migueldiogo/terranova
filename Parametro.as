package
{
	public class Parametro
	{
		private var _nome : String;
		private var _valor : Number;
		private var _valorOtimoMinimo : Number;
		private var _valorOtimoMaximo : Number;
		
		
		public function Parametro(nome:String = null, valor : Number = NaN, valorOtimoMinimo : Number = NaN, valorOtimoMaximo : Number = NaN)
		{
			_nome = nome;
			_valor = valor;
			_valorOtimoMinimo = valorOtimoMinimo;
			_valorOtimoMaximo = valorOtimoMaximo;
		}

		
		
		
		
		
		//
		// GETTER AND SETTERS
		//

		public function get nome():String
		{
			return _nome;
		}

		public function set nome(value:String):void
		{
			_nome = value;
		}

		public function get valorOtimoMaximo():Number
		{
			return _valorOtimoMaximo;
		}

		public function set valorOtimoMaximo(value:Number):void
		{
			_valorOtimoMaximo = value;
		}

		public function get valorOtimoMinimo():Number
		{
			return _valorOtimoMinimo;
		}

		public function set valorOtimoMinimo(value:Number):void
		{
			_valorOtimoMinimo = value;
		}

		public function get valor():Number
		{
			return _valor;
		}

		public function set valor(value:Number):void
		{
			_valor = value;
		}

	}
}