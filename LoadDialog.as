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
		private var _backButton : BackArrow;
		
		
		public function LoadDialog(parentMenu : Menu)
		{
			super();
			
			// seta para volta para tras
			backButton = new BackArrow();
			backButton.buttonMode = true;
			backButton.x = 15;
			backButton.y = 15;
			addChild(backButton);
			
			

			var jogadoresNomes : Array = new Array(parentMenu.sharedObject.data.jogadores.length);
			_list = new List();
			_list.width = 400;
			_list.height = 200;
			_list.x = parentMenu.main.stage.stageWidth/2 - _list.width/2;
			_list.y = parentMenu.main.stage.stageHeight/2 - _list.height/2;
			_list.setRendererStyle("textFormat", Pretty.HEADING_1);

			

			addChild(_list);
			
		}
		
		
		

		
		public function get backButton():BackArrow
		{
			return _backButton;
		}

		public function set backButton(value:BackArrow):void
		{
			_backButton = value;
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