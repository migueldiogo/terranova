package
{
	import flash.text.TextFormat;
	
	import fl.motion.Color;

	public class Pretty
	{
		public static var TITLE_1 : TextFormat;
		public static var HEADING_1 : TextFormat;
		public static var HEADING_2 : TextFormat;
		public static var BODY_BOLD : TextFormat;
		public static var BODY : TextFormat;

		public static var COLOR_PURPLE_1 : String;
		public static var COLOR_POPUP : String;


		// static initializer
		{

			HEADING_1 = new TextFormat();
			HEADING_1.color = "0xFFFFFF";
			HEADING_1.bold = true;
			HEADING_1.font = "Arial";
			HEADING_1.size = 15;
			
			HEADING_2 = new TextFormat();
			HEADING_2.color = "0xFFFFFF";
			HEADING_2.bold = false;
			HEADING_2.font = "Arial";
			HEADING_1.size = 15;

			
			BODY = new TextFormat();
			BODY.color = "0xFFFFFF";
			BODY.bold = false;
			BODY.font = "Arial";
			BODY.size = 12;
			
			BODY_BOLD = new TextFormat();
			BODY_BOLD.color = "0xFFFFFF";
			BODY_BOLD.bold = true;
			BODY_BOLD.font = "Arial";
			BODY_BOLD.size = 12;
			
			
			TITLE_1 = new TextFormat();
			TITLE_1.color = "0xFFFFFF";
			TITLE_1.bold = true;
			TITLE_1.font = "Arial";
			TITLE_1.size = 30;
			TITLE_1.align = "center";
			
			COLOR_PURPLE_1 = "0x660066"
			COLOR_POPUP = "0x2D245C"



		}
		
		



	}
}