package  {
	
	public class Atmosfera {

		public var CO2 : uint = 0;
		public var CH4 : uint = 1;
		public var O2 : uint = 2
		public var O3 : uint = 3;

		
		private var _gases : Vector.<double>;
		
		public function Atmosfera() {
			// constructor code
			gases : new Vector.<double>(4);
		}

		
		//
		// GETTERS AND SETTERS
		//
		
		


		public function get gases():Vector.<double>
		{
			return _gases;
		}

		public function set gases(value:Vector.<double>):void
		{
			_gases = value;
		}

	}
	
}
