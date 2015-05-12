package  {
	
	public class Jogador {

		private var _nome : String;
		private var _pontuacao : int;
		private var _medalhas : int;
		private var _planetas : Array;
		private var _proximoNivel : uint;
		
		public function Jogador(nome : String) {
			_nome = nome;
			_planetas = new Array();
			_proximoNivel = 1;
			
		}

		public function get proximoNivel():uint
		{
			return _proximoNivel;
		}

		public function set proximoNivel(value:uint):void
		{
			_proximoNivel = value;
		}

		public function get planetas():Array
		{
			return _planetas;
		}

		public function set planetas(value:Array):void
		{
			_planetas = value;
		}

		public function get medalhas():int
		{
			return _medalhas;
		}

		public function set medalhas(value:int):void
		{
			_medalhas = value;
		}

		public function get pontuacao():int
		{
			return _pontuacao;
		}

		public function set pontuacao(value:int):void
		{
			_pontuacao = value;
		}

		public function get nome():String
		{
			return _nome;
		}

		public function set nome(value:String):void
		{
			_nome = value;
		}

	}
	
}
