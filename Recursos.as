package  {
	import flash.net.registerClassAlias;
	
	public class Recursos {

		private var _minerio : uint;
		private var _energia : uint;
		
		private var _minerioTaxa : uint;
		//private var _energiaTaxa : uint;
		
		public function Recursos() {
			

			minerio = 200;
			energia = 300;
			_minerioTaxa = 5;
			//_energiaTaxa = 0;
		}
		/*
		public function get energiaTaxa():uint
		{
			return _energiaTaxa;
		}

	
		public function set energiaTaxa(value:uint):void
		{
			_energiaTaxa = value;
		}
		*/
		public function get minerioTaxa():uint
		{
			return _minerioTaxa;
		}

		public function set minerioTaxa(value:uint):void
		{
			_minerioTaxa = value;
		}

		public function get energia():uint
		{
			return _energia;
		}

		public function set energia(value:uint):void
		{
			_energia = value;
		}

		public function get minerio():uint
		{
			return _minerio;
		}

		public function set minerio(value:uint):void
		{
			_minerio = value;
		}

	}
	
}
