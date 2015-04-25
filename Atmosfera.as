package  {
	
	public class Atmosfera {

		private var _pressao : Number;
		private var _percentagemOxigenio : Number;
		private var _percentagemVaporDeAgua : Number;
		private var _percentagemAzoto : Number;
		private var _percentagemDioxidoDeCarbono : Number;
		private var _percentagemArgon : Number;
		private var _percentagemOzono : Number;
		private var _percentagemMetano : Number;
		
		public function Atmosfera() {
			// constructor code
		}

		
		//
		// GETTERS AND SETTERS
		//
		
		public function get percentagemMetano():Number
		{
			return _percentagemMetano;
		}

		public function set percentagemMetano(value:Number):void
		{
			_percentagemMetano = value;
		}

		public function get percentagemOzono():Number
		{
			return _percentagemOzono;
		}

		public function set percentagemOzono(value:Number):void
		{
			_percentagemOzono = value;
		}

		public function get percentagemArgon():Number
		{
			return _percentagemArgon;
		}

		public function set percentagemArgon(value:Number):void
		{
			_percentagemArgon = value;
		}

		public function get percentagemDioxidoDeCarbono():Number
		{
			return _percentagemDioxidoDeCarbono;
		}

		public function set percentagemDioxidoDeCarbono(value:Number):void
		{
			_percentagemDioxidoDeCarbono = value;
		}

		public function get percentagemAzoto():Number
		{
			return _percentagemAzoto;
		}

		public function set percentagemAzoto(value:Number):void
		{
			_percentagemAzoto = value;
		}

		public function get percentagemVaporDeAgua():Number
		{
			return _percentagemVaporDeAgua;
		}

		public function set percentagemVaporDeAgua(value:Number):void
		{
			_percentagemVaporDeAgua = value;
		}

		public function get percentagemOxigenio():Number
		{
			return _percentagemOxigenio;
		}

		public function set percentagemOxigenio(value:Number):void
		{
			_percentagemOxigenio = value;
		}

		public function get pressao():Number
		{
			return _pressao;
		}

		public function set pressao(value:Number):void
		{
			_pressao = value;
		}

	}
	
}
