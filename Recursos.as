package  {
	
	public class Recursos {

		private var _minerio : uint;
		private var _energia : uint;
		
		private var _minerioTaxa : uint;
		
		public function Recursos() {
			
/*
			minerio = 200;
			energia = 300;
			*/
			
			minerio = 2000000;
			energia = 3000000;
			_minerioTaxa = 5;
		}

		
		/******************************************************
		 * GETTERS & SETTERS
		 ******************************************************/
		
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
