package
{
	public class Catastrofe implements AlteradorPlaneta
	{
		public static var TSUNAMI : uint = 0;
		public static var ERUPSAO : uint = 1;
		public static var METEORITO : uint = 2;
		
		private var _codigo : uint;
		private var _probabilidadeOcorrencia : Number;
		
		public function Catastrofe(codigo : uint, probabilidadeOcorrencia : Number)
		{
			_codigo = codigo;
			_probabilidadeOcorrencia = probabilidadeOcorrencia;
		}
		
		public function get probabilidadeOcorrencia():Number
		{
			return _probabilidadeOcorrencia;
		}

		public function set probabilidadeOcorrencia(value:Number):void
		{
			_probabilidadeOcorrencia = value;
		}

		public function get codigo():uint
		{
			return _codigo;
		}

		public function set codigo(value:uint):void
		{
			_codigo = value;
		}

		public function alteraPlaneta(direcao : Boolean) : void {
			// TODO
		}
	}
}