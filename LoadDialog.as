package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import fl.controls.Button;
	import fl.controls.List;
	import fl.controls.TextInput;
	
	public class LoadDialog extends MovieClip
	{
		private var _list : List;
		
		
		public function LoadDialog(parentMenu : Menu)
		{
			super();

			var jogadoresNomes : Array = new Array(parentMenu.sharedObject.data.jogadores.length);
			_list = new List();
			_list.width = 400;
			_list.height = 200;
			_list.x = parentMenu.main.stage.stageWidth/2 - _list.width/2;
			_list.y = parentMenu.main.stage.stageHeight/2 - _list.height/2;
			_list.setRendererStyle("textFormat", Pretty.HEADING_1);

			

			addChild(_list);
			
		}
		
		
		

		


		public function get list():List
		{
			return _list;
		}

		public function set list(value:List):void
		{
			_list = value;
		}

	}
}