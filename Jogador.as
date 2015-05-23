package  {
	import flash.net.registerClassAlias;
	
	public class Jogador {

		private var _nome : String;
		private var _temposMaximos : Vector.<uint>;
		//private var _medalhas : int;						// a retirar ??????
		//private var _planetas : Vector.<Planeta>;			// a retirar
		//private var _proximoNivel : uint;
		
		public function Jogador(nome : String = "", temposMaximos : Vector.<uint> = null) {
			_nome = nome;
			_temposMaximos = temposMaximos;

			

			
		}

		public function proximoNivel():uint
		{
			return _temposMaximos.length + 1;;
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
		public function get temposMaximos():Vector.<uint>
		{
			return _temposMaximos;
		}

		public function set temposMaximos(value:Vector.<uint>):void
		{
			_temposMaximos = value;
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
