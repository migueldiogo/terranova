package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	

	public class Planeta extends Astro
	{		
		// constantes de acesso ao vetor _dados
		public static var TAXA_MINERIO : uint = 0;
		public static var DIOXIDO_DE_CARBONO : uint = 1;
		public static var METANO : uint = 2;
		public static var OXIGENIO : uint = 3;
		public static var OZONO : uint = 4;
		
		public static var GRAVIDADE : uint = 5;
		public static var SPIN : uint = 6;
		public static var LAPSE : uint = 7;
		public static var TEMPERATURA : uint = 8;
		
		public static var TSUNAMI: uint = 9;
		public static var VULCOES: uint = 10;
		public static var METEORITOS: uint = 11;
		
		
		
		private var _distanciaEstrelaMae : Number;
		private var _periodoTranslacao : Number;
		private var _periodoRotacao : Number;
		
		private var _habitavel : Boolean;
		
		private var _dados : Vector.<Parametro>;
		
		private var _recursos : Recursos;
		private var _laboratorio : Laboratorio;
		
		private var _modelo : Planeta;
		
		
		public function Planeta(modelo : Planeta = null)
		{
			super();
			_modelo = modelo;
			_dados = new Vector.<Parametro>();			
			_recursos = new Recursos();
			

		}
		
		public function atualizaDados()
		{
			
			for (var i : uint  = 0; i < _dados.length; i++) {
				var texto : String = "";
				
				// valor incorreto
				if (_dados[i].valor < _modelo.dados[i].valorOtimoMinimo || _dados[i].valor > _modelo.dados[i].valorOtimoMaximo) {
					texto += '<font color="#FF0000">';
					texto += _dados[i].valor + "</font>\n";
					_dados[i].correto = false;
				}
				// valor nao importante para vencer o nivel
				else if (isNaN(_modelo.dados[i].valorOtimoMinimo) || isNaN(_modelo.dados[i].valorOtimoMaximo)) {
					texto += _dados[i].valor + "\n";
					dados[i].correto = true;
				}
				// valor correto
				else {
					texto += '<font color="#00FF00">';
					texto += _dados[i].valor + "</font>\n";
					dados[i].correto = true;
				}
				
				_dados[i].valorLabel.htmlText = _dados[i].nome + ": " + texto;

			}
			
			

			
			
		}
		
		
		

		
		// 
		// Getters and Setters
		// 
		
		public function get dados():Vector.<Parametro>
		{
			return _dados;
		}

		public function set dados(value:Vector.<Parametro>):void
		{
			_dados = value;
		}

		

		public function get laboratorio():Laboratorio
		{
			return _laboratorio;
		}

		public function set laboratorio(value:Laboratorio):void
		{
			_laboratorio = value;
		}



		public function get recursos():Recursos
		{
			return _recursos;
		}

		public function set recursos(value:Recursos):void
		{
			_recursos = value;
		}



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