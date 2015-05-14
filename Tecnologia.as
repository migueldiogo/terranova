package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class Tecnologia extends MovieClip implements AlteradorPlaneta
	{
		public static var PRECISAO_NUMBER : uint = 100;
		
		protected var _mainScreen : MovieClip;	
		protected var _nomeTecnologia : String;
		protected var _planeta : Planeta;
		protected var _nivel : uint;
		protected var _custoMinerioBase : int;
		protected var _custoMinerioAtual : int;
		protected var _custoEnergiaBase : int;
		protected var _custoEnergiaAtual : int;
		protected var _taxaEnergiaBase : int;
		protected var _descricao : String;
		protected var _actions : Vector.<Parametro>;
		
	
		
		public function Tecnologia( planeta : Planeta = null, nivel : uint = NaN, nomeTecnologia : String = null, descricao : String = null, custoMinerioBase : int = NaN, custoEnergiaBase :int = NaN)
		{

			stop();
			
			_actions = new Vector.<Parametro>();

			_planeta = planeta;
			_nivel = nivel;
			_nomeTecnologia = nomeTecnologia;
			_custoMinerioBase = _custoMinerioAtual = custoMinerioBase;
			_custoEnergiaBase = _custoEnergiaAtual = custoEnergiaBase;
			_descricao = descricao;
			
			trace("MINERIO" + ": " + _custoMinerioBase);
			
			tecnologiaTextLabel.setStyle("textFormat", Pretty.HEADING_1);
			nivelLabel.setStyle("textFormat", Pretty.BODY);
			custoLabel.setStyle("textFormat", Pretty.BODY);
			descricaoLabel.setStyle("textFormat", Pretty.BODY);
			
			
			
			tecnologiaTextLabel.text = _nomeTecnologia;
			nivelLabel.text = "Nível " + _nivel;
			custoLabel.text = "Minerio: " + _custoMinerioBase*Math.pow(2,nivel) + "\t Energia: " + _custoEnergiaBase*Math.pow(2,nivel);	
			descricaoLabel.text = _descricao;
		}
		
		/**
		 * Funcao despoletadora da evolucao de uma tecnologia ao clicar no botao de "evoluir"
		 */
		public function evoluiTecnologia (e : MouseEvent) {

			_planeta.recursos.minerio += _custoMinerioAtual;
			_planeta.recursos.energia += _custoEnergiaAtual;
			
			_nivel++;
			atualizaTecnologia();
			
			_planeta.game.atualizaSimulacao(null);

		}	
		/**
		 * Funcao despoletadora da venda de uma tecnologia ao clicar no botao de "vender"
		 */
		public function vendeTecnologia (e : MouseEvent) {
			//TODO
		}
		


		/**
		 * Atualiza actions para proximo nivel
		 */
		public function atualizaActions() : void {
			

			var texto : String = "";
			var contador = 0;
			for(var i : uint = 0; i < actions.length; i++) {
				if (actions[i].valor != 0) {
					contador++;
					texto += actions[i].nome + ": " + actions[i].valor + "\t\t";
				}
				if (contador>4) {
					texto += "\n";
					contador = 0;
				}	
				
			}

			actionsLabel.setStyle("textFormat", Pretty.BODY);
			actionsLabel.text = texto;	
			
			
		}
		
		/**
		 * Atualiza custos da tecnologia, nivel e aplica as actions no planeta
		 */
		public function atualizaTecnologia() : void {
			// atualiza custo para proximo nivel e nivel
			_custoMinerioAtual = _custoMinerioBase*Math.pow(2, nivel);
			_custoEnergiaAtual = _custoEnergiaBase*Math.pow(2, nivel);
			nivelLabel.text = "Nível " + _nivel;
			custoLabel.text = "Minerio: " + _custoMinerioAtual + "\tEnergia: " + _custoEnergiaAtual;
			
			// altera planeta
			alteraPlaneta(true);
			
			// atualiza actions da tecnologia do proximo nivel
			atualizaActions();

		}
		
		/**
		 * altera o planeta com actions da tecnologia recem evoluida
		 */
		public function alteraPlaneta(direcao : Boolean) : void {
			// consequencias para o planeta
			for (var i : uint = 0; i < planeta.dados.length; i++) {
				planeta.dados[i].valor += actions[i].valor;
				
				// arredonda consoante precisao definida
				planeta.dados[i].valor = Math.round(planeta.dados[i].valor * PRECISAO_NUMBER) / PRECISAO_NUMBER;
				planeta.verificaDados();
			}
			
		}
		
		
		
		
		//
		// GETTERS AND SETTERS
		//
		

		public function get descricao():String
		{
			return _descricao;
		}

		public function set descricao(value:String):void
		{
			_descricao = value;
		}

		public function get custoMinerioBase():int
		{
			return _custoMinerioBase;
		}

		public function set custoMinerioBase(value:int):void
		{
			_custoMinerioBase = value;
		}

		public function get nomeTecnologia():String
		{
			return _nomeTecnologia;
		}

		public function set nomeTecnologia(value:String):void
		{
			_nomeTecnologia = value;
		}
			
		public function get nivel():uint
		{
			return _nivel;
		}
		
		public function set nivel(value:uint):void
		{
			_nivel = value;
		}
		
		public function get planeta():Planeta
		{
			return _planeta;
		}
		
		public function set planeta(value:Planeta):void
		{
			_planeta = value;
		}
		
		public function get custoEnergiaAtual():int
		{
			return _custoEnergiaAtual;
		}
		
		public function set custoEnergiaAtual(value:int):void
		{
			_custoEnergiaAtual = value;
		}
		
		public function get custoEnergiaBase():int
		{
			return _custoEnergiaBase;
		}
		
		public function set custoEnergiaBase(value:int):void
		{
			_custoEnergiaBase = value;
		}
		
		public function get actions():Vector.<Parametro>
		{
			return _actions;
		}
		
		public function set actions(value:Vector.<Parametro>):void
		{
			_actions = value;
		}
		
		
		public function get custoMinerioAtual():int
		{
			return _custoMinerioAtual;
		}
		
		public function set custoMinerioAtual(value:int):void
		{
			_custoMinerioAtual = value;
		}
	}
}