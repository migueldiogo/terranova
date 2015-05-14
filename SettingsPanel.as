package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import fl.controls.Button;
	
	
	/**
	 * EM CONSTRUCAO!!!!!!!!!!!!!!!!!!
	 */
	public class SettingsPanel extends MovieClip
	{
		private var _parentMenu : Menu;
		private var _backButton : BackArrow;

		
		
		public function SettingsPanel(parentMenu : Menu)
		{
			super();
			_parentMenu = parentMenu;
			
			// seta para volta para tras
			backButton = new BackArrow();
			backButton.buttonMode = true;
			backButton.x = 15;
			backButton.y = 15;
			addChild(backButton);
			
			var popUpWidth : Number = parent.stage.stageWidth/2;
			var popUpHeight : Number = parent.stage.stageHeight/2-130;
			var popUpX : Number = parent.stage.stageWidth/2 - popUpWidth/2;
			var popUpY : Number = parent.stage.stageHeight/2 - popUpHeight/2;
			
			graphics.beginFill(0xAA99FF, 0.8);
			graphics.drawRect(popUpX, popUpY, popUpWidth, popUpHeight);
			graphics.endFill();
			
			// button RESET
			var resetButton : Button = new Button();
			resetButton.label = "RESET";
			resetButton.x = popUpX + popUpWidth - resetButton.width - 10;
			resetButton.y = popUpY + popUpHeight - resetButton.height - 10;
			resetButton.addEventListener(MouseEvent.CLICK, resetClicked);
			
			addChild(_okButton);
			
			
		}
		
		public function get backButton():BackArrow
		{
			return _backButton;
		}

		public function set backButton(value:BackArrow):void
		{
			_backButton = value;
		}

		private function resetClicked (e : MouseEvent) {
			_parentMenu.sharedObject.clear();
			
		}
	}
}