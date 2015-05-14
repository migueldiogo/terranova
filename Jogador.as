package  {
	import flash.net.registerClassAlias;
	
	public class Jogador {

		private var _nome : String;
		private var _pontuacoesMaximas : Vector.<uint>;
		//private var _medalhas : int;						// a retirar ??????
		//private var _planetas : Vector.<Planeta>;			// a retirar
		//private var _proximoNivel : uint;
		
		public function Jogador(nome : String = "", pontuacoesMaximas : Vector.<uint> = null) {
			_nome = nome;
			_pontuacoesMaximas = pontuacoesMaximas;

			

			
		}

		public function proximoNivel():uint
		{
			return _pontuacoesMaximas.length + 1;;
		}
/*
		public function set proximoNivel(value:uint):void
		{
			_proximoNivel = value;
		}
/*
		public function get planetas():Vector.<Planeta>
		{
			return _planetas;
		}

		public function set planetas(value:Vector.<Planeta>):void
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
*/
		public function get pontuacoesMaximas():Vector.<uint>
		{
			return _pontuacoesMaximas;
		}

		public function set pontuacoesMaximas(value:Vector.<uint>):void
		{
			_pontuacoesMaximas = value;
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
