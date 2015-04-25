package
{
	public class TecnologiaFisica extends Tecnologia
	{
		public function TecnologiaFisica(planeta:Planeta=null, nivel:uint=0)
		{
			super(planeta, nivel);
		}
		

		
		public function alteraPlaneta(direcao : Boolean) : void {
			var modificador : uint = (direcao) ? 1 : -1;
			
			
			switch(_codigoTecnologia)
			{
				
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
					

					
				default:
				{
					break;
				}
					
				planeta.atualizaAparencia();
			}
		}
	}
}