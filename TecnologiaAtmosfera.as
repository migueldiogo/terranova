package
{
	public class TecnologiaAtmosfera extends Tecnologia
	{
		
		
		public function TecnologiaAtmosfera(codigo : uint)
		{
			super(codigo);
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
					planeta.atmosfera.percentagemOzono += planeta.atmosfera.percentagem * 0.1 * 3/2 * modificador;
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
					
				planeta.atualizaAparencia();
			
			}
		}
	}
}