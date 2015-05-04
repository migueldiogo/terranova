package
{
	import flash.display.MovieClip;

	public class Tecnologia extends MovieClip implements AlteradorPlaneta
	{
		public var ACTION_CO2 : uint = 0;
		public var ACTION_CH4 : uint = 1;
		public var ACTION_O2 : uint = 2
		public var ACTION_O3 : uint = 3;
		public var ACTION_GRAVIDADE : uint = 4;
		public var ACTION_GRAVIDADEEXT : uint = 5;
		public var ACTION_SPIN : uint = 6;

			
		protected var _nomeTecnologia : String;
		protected var _planeta : Planeta;
		protected var _nivel : uint;
		protected var _custoMinerioBase : uint;
		protected var _custoMinerioAtual : uint;
		protected var _taxaEnergiaBase : uint;
		protected var _descricao : String;
		protected var _actionsAtmosfera : Vector.<Parametro>;
		protected var _actionsGeodinamica : Vector.<Parametro>;
	
		
		public function Tecnologia(planeta : Planeta = null, nivel : uint = 0, nomeTecnologia : String = null, descricao : String = null, custoMinerioBase : uint = NaN)
		{
			stop();
			_actionsAtmosfera = new Vector.<Parametro>();
			_actionsGeodinamica = new Vector.<Parametro>();

			_planeta = planeta;
			_nivel = nivel;
			_nomeTecnologia = nomeTecnologia;
			_custoMinerioBase = _custoMinerioAtual = custoMinerioBase;
			_descricao = descricao;
			tecnologiaTextLabel.text = _nomeTecnologia;
			nivelLabel.text = "Nível " + _nivel;
			custoLabel.text = "Minerio: " + _custoMinerioBase*Math.pow(2,nivel);	
			descricaoLabel.text = _descricao;
		}
		
		public function get actionsGeodinamica():Vector.<Parametro>
		{
			return _actionsGeodinamica;
		}

		public function set actionsGeofisica(value:Vector.<Parametro>):void
		{
			_actionsGeodinamica = value;
		}

		public function get actionsAtmosfera():Vector.<Parametro>
		{
			return _actionsAtmosfera;
		}

		public function set actionsAtmosfera(value:Vector.<Parametro>):void
		{
			_actionsAtmosfera = value;
		}

		public function get custoMinerioAtual():uint
		{
			return _custoMinerioAtual;
		}

		public function set custoMinerioAtual(value:uint):void
		{
			_custoMinerioAtual = value;
		}

		public function atualizaActions() : void {
			

			var texto : String = "";
			var contador = 0;
			for(var i = 0; i < actionsAtmosfera.length; i++) {
				if (actionsAtmosfera[i].valor != 0) {
					contador++;
					texto += actionsAtmosfera[i].nome + ": " + actionsAtmosfera[i].valor + "\t\t";
				}
				if (contador>4) {
					texto += "\n";
					contador = 0;
				}	
				
			}
			
			for(i = 0; i < actionsGeodinamica.length; i++) {
				contador++;
				if (actionsGeodinamica[i].valor != 0) {
					contador++;
					texto += actionsGeodinamica[i].nome + ": " + actionsGeodinamica[i].valor + "\t\t";
				}
				if (contador>4) {
					texto += "\n";
					contador = 0;
				}
				
			}
			
			actionsLabel.text = texto;	
			
			
		}
		
		public function atualiza() : void {
			// atualiza custo para proximo nivel e nivel
			custoMinerioAtual = _custoMinerioBase*Math.pow(2,nivel);
			nivelLabel.text = "Nível " + _nivel;
			custoLabel.text = "Minerio: " + custoMinerioAtual;	
			// consequencias para o planeta
			for (var i : uint; i < planeta.atmosfera.length; i++) {
				planeta.atmosfera[i].valor += actionsAtmosfera[i].valor;
			}
			
			for (var j : uint; j < planeta.geodinamica.length; j++) {
				planeta.geodinamica[j].valor += actionsGeodinamica[j].valor;
			}
			
			atualizaActions();

		}
		
		

		public function get descricao():String
		{
			return _descricao;
		}

		public function set descricao(value:String):void
		{
			_descricao = value;
		}

		public function get custoMinerioBase():uint
		{
			return _custoMinerioBase;
		}

		public function set custoMinerioBase(value:uint):void
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

		public function alteraPlaneta(direcao : Boolean) : void {
			var modificador : uint = (direcao) ? 1 : -1;

			planeta.recursos.minerio += 1000*nivel * modificador;
			_custoMinerioBase = 1000*nivel;
			
			
			planeta.atualizaAparencia();

		}
		
		
		//
		// GETTERS AND SETTERS
		//
		

		
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
	}
}