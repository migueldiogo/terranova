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
		private var _correto : Boolean;
		
		private var _imagem : UILoader;
		private var _nomeValorTextField : TextField;
		
		public function Parametro(nome:String = null, codigo : uint = NaN, valor : Number = NaN, valorOtimoMinimo : Number = NaN, valorOtimoMaximo : Number = NaN)
		{
			_nome = nome;
			_codigo = codigo;
			_valor = valor;
			_valorOtimoMinimo = valorOtimoMinimo;
			_valorOtimoMaximo = valorOtimoMaximo;
			_correto = false;
			
			//_nomeValorTextField.htmlText = "";
			//icon.source = "media/parametros/data" + _codigo + ".png";
			//icon.alpha = 0.9;
			
			//icon.addEventListener(MouseEvent.MOUSE_OVER, popToolTip);

			
			_imagem = new UILoader();
			_imagem.maintainAspectRatio = true;
			_imagem.scaleContent = false;
			_imagem.source = "media/parametros/data" + _codigo + "_32.png"
			_imagem.alpha = 0.9;

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
		
		public function get nomeValorTextField():TextField
		{
			return _nomeValorTextField;
		}

		public function set nomeValorTextField(value:TextField):void
		{
			_nomeValorTextField = value;
		}

		/**
		 * Normaliza valor x correpondente ao intervalo [xMin, xMax] para o intervalo [yMin, yMax]
		 */
		private function normalizaValor(x : Number, xMin : Number, xMax : Number) : Number {
			return (x - xMin)/(xMax - xMin) * 100;
		}
		
		/**
		 * Cria ou atualiza a barra que marca o valor do parametro
		 */
		public function atualizaBarra() {
			var valorMinimoDominio : Number;
			var valorMaximoDominio : Number;
			
			
			var deltaIntervaloOtimo : Number = Math.abs(_valorOtimoMaximo - _valorOtimoMinimo);
			
			
			if (deltaIntervaloOtimo >= _valorOtimoMinimo && valorOtimoMinimo >= 0)
				valorMinimoDominio = 0;
			else
				valorMinimoDominio = _valorOtimoMinimo - deltaIntervaloOtimo;
			
			valorMaximoDominio = _valorOtimoMaximo + deltaIntervaloOtimo;
			
			
			
			
			if (!isNaN(_valorOtimoMinimo) && !isNaN(_valorOtimoMaximo)) {
				graphics.lineStyle(10, parseInt(Pretty.COLOR_RED_PALE), 0.8, false, "normal", "none");
				graphics.moveTo(_nomeValorTextField.x + 2, _imagem.y + 12);
				graphics.lineTo(_nomeValorTextField.x + 2 + normalizaValor(_valorOtimoMinimo, valorMinimoDominio, valorMaximoDominio), _imagem.y + 12);
				
				graphics.moveTo(_nomeValorTextField.x + 2 + normalizaValor(_valorOtimoMinimo, valorMinimoDominio, valorMaximoDominio), _imagem.y + 12);
				graphics.lineStyle(10, parseInt(Pretty.COLOR_GREEN_PALE), 0.8, false, "normal", "none");
				graphics.lineTo(_nomeValorTextField.x + 2 + normalizaValor(_valorOtimoMaximo, valorMinimoDominio, valorMaximoDominio), _imagem.y + 12);
				graphics.moveTo(_nomeValorTextField.x + 2 + normalizaValor(_valorOtimoMaximo, valorMinimoDominio, valorMaximoDominio), _imagem.y + 12);
				graphics.lineStyle(10, parseInt(Pretty.COLOR_RED_PALE), 0.8, false, "normal", "none");
				graphics.lineTo(_nomeValorTextField.x + 2 + normalizaValor(valorMaximoDominio, valorMinimoDominio, valorMaximoDominio), _imagem.y + 12);
				
				graphics.lineStyle();
				graphics.beginFill(0xFFFFFF);
				graphics.drawCircle(_nomeValorTextField.x + 2 + normalizaValor(_valor, valorMinimoDominio, valorMaximoDominio), _imagem.y + 12, 3);
				graphics.endFill();
			}
		}
		
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
			
			
			
			
			
		}
		
		
		
		public function get correto():Boolean
		{
			return _correto;
		}

		public function set correto(value:Boolean):void
		{
			_correto = value;
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