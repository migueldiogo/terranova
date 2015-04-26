package
{
	import flash.display.MovieClip;

	public class Tecnologia extends MovieClip implements AlteradorPlaneta
	{

			
		protected var _codigoTecnologia : uint;
		protected var _nomeTecnologia : String;
		protected var _planeta : Planeta;
		protected var _nivel : uint;
		protected var _custoMinerioLevelUp : uint;
		protected var _taxaEnergiaCurrentLevel : uint;
		protected var _taxaEnergiaLevelUp : uint;
		protected var _descricao : String;
		
		public function Tecnologia(codigoTecnologia : uint = 0, planeta : Planeta = null, nivel : uint = 0, nomeTecnologia : String = null, descricao : String = null, custoMinerioLevelUp : uint = NaN)
		{
			stop();
			_codigoTecnologia = codigoTecnologia;
			_planeta = planeta;
			_nivel = nivel;
			_nomeTecnologia = nomeTecnologia;
			_custoMinerioLevelUp = custoMinerioLevelUp;
			_descricao = descricao;
			
			tecnologiaTextLabel.text = _nomeTecnologia;
			custoLabel.text = "Minerio: " + _custoMinerioLevelUp;	
			descricaoLabel.text = _descricao;
		}
		
		

		public function get descricao():String
		{
			return _descricao;
		}

		public function set descricao(value:String):void
		{
			_descricao = value;
		}

		public function get custoMinerioLevelUp():uint
		{
			return _custoMinerioLevelUp;
		}

		public function set custoMinerioLevelUp(value:uint):void
		{
			_custoMinerioLevelUp = value;
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
			
			
			/*
			switch(_codigoTecnologia)
			{
				case FILTRO_DE_CARBONO:
				{
					planeta.atmosfera.percentagemDioxidoDeCarbono -= planeta.atmosfera.percentagemDioxidoDeCarbono * 0.1 * modificador;
					planeta.temperatura -= 0.3 * modificador;

					break;
				}
					
				case PRODUTOR_DE_OZONO:
				{
					planeta.atmosfera.percentagemOxigenio -= planeta.atmosfera.percentagemOxigenio * 0.1 * modificador;
					planeta.atmosfera.percentagemOzono += planeta.atmosfera.percentagemOzono * 0.1 * 3/2 * modificador;
					planeta.temperatura += 2 * modificador;
					break;
				}
					
				case DESTRUIDOR_DE_LUAS:
				{
					planeta.gravidade -= 1 * modificador;
					Catastrofe(planeta.catastrofes[Catastrofe.TSUNAMI]).probabilidadeOcorrencia -= 0.1 * modificador;
					break;
				}
					
				case MODIFICADOR_ROTACIONAL:
				{
					planeta.gravidade += 1 * modificador;
					planeta.temperatura -= 1.5 * modificador;
					break;
				}
					
				case EXPLORADOR_DE_MINERIO:
				{
					planeta.recursos.minerioTaxa += nivel*3 * modificador;
					planeta.recursos.energiaTaxa -= nivel*2 * modificador;
					planeta.recursos.minerio -= nivel*500;
					break;
				}
					
				case ENERGIAS_RENOVAVEIS:
				{
					planeta.recursos.energiaTaxa += nivel * 4 * modificador;
					planeta.recursos.minerio -= nivel*100;	
					break;
				}
					
				default:
				{
					break;
				}
					
			}
			*/
			planeta.recursos.minerio += 1000*nivel * modificador;
			_custoMinerioLevelUp = 1000*nivel;
			
			
			planeta.atualizaAparencia();

		}
		
		
		//
		// GETTERS AND SETTERS
		//
		
		public function get codigoTecnologia():uint
		{
			return _codigoTecnologia;
		}
		
		public function set codigoTecnologia(value:uint):void
		{
			_codigoTecnologia = value;
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
	}
}