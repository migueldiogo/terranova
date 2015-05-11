package
{
	import flash.text.TextFormat;

	public class Pretty
	{
		private var _title1 : TextFormat;
		private var _heading1 : TextFormat;
		private var _heading2 : TextFormat;
		private var _bodyBold : TextFormat;
		private var _body : TextFormat;


		
		public function Pretty() {

			_heading1 = new TextFormat();
			_heading1.color = "0xFFFFFF";
			_heading1.bold = true;
			_heading1.font = "Arial";
			_heading1.size = 15;
			
			_heading2 = new TextFormat();
			_heading2.color = "0xFFFFFF";
			_heading2.bold = false;
			_heading2.font = "Arial";
			_heading1.size = 15;

			
			_body = new TextFormat();
			_body.color = "0xFFFFFF";
			_body.bold = false;
			_body.font = "Arial";
			_body.size = 12;
			
			_bodyBold = new TextFormat();
			_bodyBold.color = "0xFFFFFF";
			_bodyBold.bold = true;
			_bodyBold.font = "Arial";
			_bodyBold.size = 12;
			
			_title1 = new TextFormat();
			_title1.color = "0xFFFFFF";
			_title1.bold = true;
			_title1.font = "Arial";
			_title1.size = 30;
			_title1.align = "center";

		}

		public function get title1():TextFormat
		{
			return _title1;
		}

		public function set title1(value:TextFormat):void
		{
			_title1 = value;
		}

		public function get bodyBold():TextFormat
		{
			return _bodyBold;
		}

		public function set bodyBold(value:TextFormat):void
		{
			_bodyBold = value;
		}

		public function get heading1():TextFormat
		{
			return _heading1;
		}

		public function set heading1(value:TextFormat):void
		{
			_heading1 = value;
		}

		public function get heading2():TextFormat
		{
			return _heading2;
		}

		public function set heading2(value:TextFormat):void
		{
			_heading2 = value;
		}

		public function get body():TextFormat
		{
			return _body;
		}

		public function set body(value:TextFormat):void
		{
			_body = value;
		}

	}
}