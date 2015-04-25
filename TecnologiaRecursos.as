package
{
	public class TecnologiaRecursos extends Tecnologia
	{
		public function TecnologiaRecursos(planeta:Planeta=null, nivel:uint=0)
		{
			super(planeta, nivel);
		}
		
		
		public function alteraPlaneta(direcao : Boolean) : void {
			var modificador : uint = (direcao) ? 1 : -1;
			
			
			switch(_codigoTecnologia)
			{
				
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