package
{
	import flash.display.MovieClip;

	public class Tecnologia extends MovieClip implements AlteradorPlaneta
	{
		protected static var FILTRO_DE_CARBONO : uint = 0;
		protected static var PRODUTOR_DE_OZONO : uint = 1;
		protected static var DESTRUIDOR_DE_LUAS : uint = 2;		
		protected static var MODIFICADOR_ROTACIONAL : uint = 3;		
		protected static var EXPLORADOR_DE_MINERIO : uint = 4;
		protected static var ENERGIAS_RENOVAVEIS : uint = 5;
		
		
		protected var _codigoTecnologia : uint;
		protected var _nomeTecnologia : String;
		protected var _planeta : Planeta;
		protected var _nivel : uint;
		
		public function Tecnologia(codigoTecnologia : uint = 0, planeta : Planeta = null, nivel : uint = 0)
		{
			_codigoTecnologia = codigoTecnologia;
			_planeta = planeta;
			_nivel = nivel;
			gotoAndStop(_codigoTecnologia + 1);

			switch(_codigoTecnologia)
			{
				case FILTRO_DE_CARBONO:
				{
					_nomeTecnologia = "Filtro de Carbono";
					break;
				}
					
				case PRODUTOR_DE_OZONO:
				{
					_nomeTecnologia = "Produtor de Ozono";
					break;
				}
					
				case DESTRUIDOR_DE_LUAS:
				{
					_nomeTecnologia = "Destruidor de Luas";
					break;
				}
					
				case MODIFICADOR_ROTACIONAL:
				{
					_nomeTecnologia = "Modificador Rotacional";
					break;
				}
					
				case EXPLORADOR_DE_MINERIO:
				{
					_nomeTecnologia = "Explorador de Minério";
					break;
				}
					
				case ENERGIAS_RENOVAVEIS:
				{
					_nomeTecnologia = "Energias Renováveis";
					break;
				}
					
				default:
				{
					break;
				}
					
			}
			
			tecnologiaTextLabel.text = _nomeTecnologia;
			
			
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