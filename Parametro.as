package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import fl.containers.UILoader;
	

	public class Parametro extends MovieClip
	{
		private var _nome : String;
		private var _codigo : uint;
		private var _valor : Number;
		private var _valorOtimoMinimo : Number;
		private var _valorOtimoMaximo : Number;
		
		private var _valorMinimoDominio : Number;
		private var _valorMaximoDominio : Number;

		private var _correto : Boolean;
		
		private var _imagem : UILoader;
		private var _nomeValorTextField : TextField;
		
		private var _estadoTerraformacaoDado : uint;
		
		public function Parametro(nome:String = null, codigo : uint = NaN, valor : Number = NaN, valorOtimoMinimo : Number = NaN, valorOtimoMaximo : Number = NaN)
		{
			_nome = nome;
			_codigo = codigo;
			_valor = valor;
			_valorOtimoMinimo = valorOtimoMinimo;
			_valorOtimoMaximo = valorOtimoMaximo;
			_correto = false;
			
			var deltaIntervaloOtimo : Number = Math.abs(_valorOtimoMaximo - _valorOtimoMinimo);
			
			if (deltaIntervaloOtimo >= _valorOtimoMinimo && valorOtimoMinimo >= 0)
				_valorMinimoDominio = 0;
			else
				_valorMinimoDominio = _valorOtimoMinimo - deltaIntervaloOtimo;
			
			_valorMaximoDominio = _valorOtimoMaximo + deltaIntervaloOtimo;
			
			
			_imagem = new UILoader();
			_imagem.maintainAspectRatio = true;
			_imagem.scaleContent = false;
			_imagem.source = "media/parametros/data" + _codigo + "_32.png"
			//_imagem.alpha = 0.9;

			addChild(_imagem);
				
			_nomeValorTextField = new TextField();
			_nomeValorTextField.defaultTextFormat = Pretty.BODY;
			_nomeValorTextField.x = _imagem.x + 32 + 5;
			_nomeValorTextField.y = _imagem.y + 32/2;
			_nomeValorTextField.htmlText = "";
			
			addChild(_nomeValorTextField);
			
			verificaDado();
			atualizaBarra();
			

		}
		



		/**
		 * Normaliza valor x correpondente ao intervalo [xMin, xMax] para o intervalo [yMin, yMax]
		 */
		public static function normalizaValor(x : Number, xMin : Number, xMax : Number) : Number {
			return (x - xMin)/(xMax - xMin) * 100;
		}
		
		/**
		 * Cria ou atualiza a barra que marca o valor do parametro
		 */
		public function atualizaBarra() {
			graphics.clear();
			if (!isNaN(_valorOtimoMinimo) && !isNaN(_valorOtimoMaximo)) {
				graphics.lineStyle(10, parseInt(Pretty.COLOR_RED_PALE), 0.8, false, "normal", "none");
				graphics.moveTo(_nomeValorTextField.x + 2, _imagem.y + 12);
				graphics.lineTo(_nomeValorTextField.x + 2 + normalizaValor(_valorOtimoMinimo, _valorMinimoDominio, _valorMaximoDominio), _imagem.y + 12);
				
				graphics.moveTo(_nomeValorTextField.x + 2 + normalizaValor(_valorOtimoMinimo, _valorMinimoDominio, _valorMaximoDominio), _imagem.y + 12);
				graphics.lineStyle(10, parseInt(Pretty.COLOR_GREEN_PALE), 0.8, false, "normal", "none");
				graphics.lineTo(_nomeValorTextField.x + 2 + normalizaValor(_valorOtimoMaximo, _valorMinimoDominio, _valorMaximoDominio), _imagem.y + 12);
				graphics.moveTo(_nomeValorTextField.x + 2 + normalizaValor(_valorOtimoMaximo, _valorMinimoDominio, _valorMaximoDominio), _imagem.y + 12);
				graphics.lineStyle(10, parseInt(Pretty.COLOR_RED_PALE), 0.8, false, "normal", "none");
				graphics.lineTo(_nomeValorTextField.x + 2 + normalizaValor(_valorMaximoDominio, _valorMinimoDominio, _valorMaximoDominio), _imagem.y + 12);
				
				graphics.lineStyle();
				graphics.beginFill(0xFFFFFF);
				graphics.drawCircle(_nomeValorTextField.x + 2 + normalizaValor(_valor, _valorMinimoDominio, _valorMaximoDominio), _imagem.y + 12, 3);
				graphics.endFill();
			}
		}
		
		/**
		 * Formata dados de acordo os parâmetros ótimos.
		 * Esta função também atualiza quão ótimo está este dado: 0 - Nada ótimo; 100 - Está ótimo.
		 */
		public function verificaDado()
		{
			
			var texto : String = "";
			
			// valor incorreto
			if (_valor < _valorOtimoMinimo || _valor > _valorOtimoMaximo) {
				texto += '<font color="#FF0000">';
				texto += _valor + "</font>\n";
				_correto = false;
			}
				// valor nao importante para vencer o nivel
			else if (isNaN(_valorOtimoMinimo) || isNaN(_valorOtimoMaximo)) {
				texto += _valor + "\n";
				_correto = true;
			}
				// valor correto
			else {
				texto += '<font color="#00FF00">';
				texto += _valor + "</font>\n";
				_correto = true;
			}
			
			_nomeValorTextField.htmlText = _nome + ": " + texto;
			
			
			// atualiza o estado de terraformação (quão ótimo é este valor em relação aos parâmetros estabelecidos
			_estadoTerraformacaoDado = atualizaEstadoTerraformacao();
			
		}
		
		/**
		 * Funcao devolve um numero de 0 a 100, consoante a sua proximidade do limite otimo. Quando o valor
		 * é 100 o estado de terraformacao deste dado esta completo.
		 */
		private function atualizaEstadoTerraformacao() : uint {
			var estado : uint;
			
			
			if ((valor >= _valorOtimoMinimo && valor <= _valorOtimoMaximo) || (isNaN(_valorOtimoMinimo) && isNaN(_valorOtimoMaximo)))
				estado = 100;
			else {
				var distanciaOtimaMinima : Number = (Math.abs(valor - _valorOtimoMaximo) <= Math.abs(valor - _valorOtimoMinimo)) ? Math.abs(valor - _valorOtimoMaximo) : Math.abs(valor - _valorOtimoMinimo);
				var distanciaMaxima : Number = (Math.abs(_valorMaximoDominio - _valorOtimoMaximo) <= Math.abs(_valorMinimoDominio - _valorOtimoMinimo)) ? Math.abs(_valorMinimoDominio - _valorOtimoMinimo) : Math.abs(_valorMaximoDominio - _valorOtimoMaximo);
				estado = 100 - normalizaValor(distanciaOtimaMinima, 0, distanciaMaxima);
			}
			
			return estado;
		}
		
		

		
		
		/******************************************************
		 * GETTERS & SETTERS
		 ******************************************************/

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
		
		public function get correto():Boolean
		{
			return _correto;
		}
		
		public function set correto(value:Boolean):void
		{
			_correto = value;
		}
		
		public function get estadoTerraformacaoDado():uint
		{
			return _estadoTerraformacaoDado;
		}
		
		public function set estadoTerraformacaoDado(value:uint):void
		{
			_estadoTerraformacaoDado = value;
		}
		
		public function get nomeValorTextField():TextField
		{
			return _nomeValorTextField;
		}
		
		public function set nomeValorTextField(value:TextField):void
		{
			_nomeValorTextField = value;
		}
		
		public function get valorMaximoDominio():Number
		{
			return _valorMaximoDominio;
		}
		
		public function set valorMaximoDominio(value:Number):void
		{
			_valorMaximoDominio = value;
		}
		
		public function get valorMinimoDominio():Number
		{
			return _valorMinimoDominio;
		}
		
		public function set valorMinimoDominio(value:Number):void
		{
			_valorMinimoDominio = value;
		}

	}
}