package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	
	public class InputDialog extends MovieClip
	{
		private var _inputDescription : TextField;
		private var _inputText : TextInput;
		private var _okButton : Button;
		private var _cancelarButton : Button;

		
		public function InputDialog(parent : MovieClip, descricao : String = "")
		{
			super();
			
			var popUpWidth : Number = parent.stage.stageWidth/2;
			var popUpHeight : Number = parent.stage.stageHeight/2-130;
			var popUpX : Number = parent.stage.stageWidth/2 - popUpWidth/2;
			var popUpY : Number = parent.stage.stageHeight/2 - popUpHeight/2;
			
			graphics.beginFill(0xAA99FF, 0.8);
			graphics.drawRect(popUpX, popUpY, popUpWidth, popUpHeight);
			graphics.endFill();
			
			
			// descricao do input
			var inputDescription = new TextField();
			inputDescription.defaultTextFormat = Pretty.BODY_BOLD;
			
			inputDescription.x = popUpX + 10;
			inputDescription.y = popUpY + 10;
			inputDescription.width = popUpWidth - 10;
			
			
			inputDescription.text = descricao;
			
			addChild(inputDescription);
			
			
			// input de texto
			_inputText = new TextInput();
			_inputText.opaqueBackground = 0xFFFFFF;
			_inputText.enabled = true;
			_inputText.x = popUpX + 10;
			_inputText.y = inputDescription.y + 30;
			_inputText.width = popUpWidth - 20;
			_inputText.height = 20;
			
			addChild(_inputText);
			
			
			// button OK
			_okButton = new Button();
			_okButton.label = "OK";
			_okButton.x = popUpX + popUpWidth - _okButton.width - 10;
			_okButton.y = popUpY + popUpHeight - _okButton.height - 10;
						
			
			addChild(_okButton);
			
			// button Cancel
			_cancelarButton = new Button();
			_cancelarButton.label = "Cancelar";
			_cancelarButton.x = _okButton.x - _okButton.width - 10;
			_cancelarButton.y = _okButton.y;
			
			
			addChild(_cancelarButton);
		}
		
		
		public function get cancelarButton():Button
		{
			return _cancelarButton;
		}

		public function set cancelarButton(value:Button):void
		{
			_cancelarButton = value;
		}

		public function get okButton():Button
		{
			return _okButton;
		}

		public function set okButton(value:Button):void
		{
			_okButton = value;
		}

		public function get inputText():TextInput
		{
			return _inputText;
		}

		public function set inputText(value:TextInput):void
		{
			_inputText = value;
		}

		public function get inputDescription():TextField
		{
			return _inputDescription;
		}

		public function set inputDescription(value:TextField):void
		{
			_inputDescription = value;
		}

	}
}