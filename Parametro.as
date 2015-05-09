package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	

	public class Parametro extends MovieClip
	{
		private var _nome : String;
		private var _codigo : uint;
		private var _valor : Number;
		private var _valorOtimoMinimo : Number;
		private var _valorOtimoMaximo : Number;
		
		
		public function Parametro(nome:String = null, codigo : uint = NaN, valor : Number = NaN, valorOtimoMinimo : Number = NaN, valorOtimoMaximo : Number = NaN)
		{
			_nome = nome;
			_codigo = codigo;
			_valor = valor;
			_valorOtimoMinimo = valorOtimoMinimo;
			_valorOtimoMaximo = valorOtimoMaximo;
			
			valorLabel.htmlText = "";
			icon.source = "media/parametros/data" + _codigo + ".png";
			
			icon.addEventListener(MouseEvent.MOUSE_OVER, popToolTip);
			
		}
		

		
		private function popToolTip(e : MouseEvent) {
			
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