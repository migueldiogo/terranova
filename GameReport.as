package
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	
	public class GameReport extends MovieClip
	{
		
		private var _texto : TextField;
		private var _nextLevelButton : Button;
		private var _parent : MovieClip;
		
		private var _pontuacaoRecordGlobal : uint;
		private var _pontuacaoRecordPessoal : uint;
		
		private var _pontuacaoAgora : uint;
		
		public function GameReport(parent : MovieClip, pontuacaoRecordGlobal : uint, pontuacaoRecordPessoal : uint, pontuacaoAgora : uint)
		{
			super();
			
			_parent = parent;
			_pontuacaoRecordGlobal = pontuacaoRecordGlobal;
			_pontuacaoRecordPessoal = pontuacaoRecordPessoal
			_pontuacaoAgora = pontuacaoAgora;
			
			
			var popUpWidth : Number = _parent.stage.stageWidth/2;
			var popUpHeight : Number = _parent.stage.stageHeight/2-130;
			var popUpX : Number = _parent.stage.stageWidth/2 - popUpWidth/2;
			var popUpY : Number = _parent.stage.stageHeight/2 - popUpHeight/2;
			
			graphics.beginFill(0x4E4770, 0.8);
			graphics.drawRect(popUpX, popUpY, popUpWidth, popUpHeight);
			graphics.endFill();
			

			texto = new TextField();
			texto.defaultTextFormat = Pretty.BODY_BOLD;
			
			texto.x = popUpX + 10;
			texto.y = popUpY + 10;
			texto.width = popUpWidth - 10;
			
			
			
			texto.text = "Record Global: " + _pontuacaoRecordGlobal + "\n\nRecord Pessoal: " + _pontuacaoRecordPessoal + "\nPontuação: " + _pontuacaoAgora;
			
			addChild(texto);
			
			_nextLevelButton = new Button();
			_nextLevelButton.label = "NÍVEIS";
			_nextLevelButton.x = popUpX + popUpWidth - _nextLevelButton.width - 10;
			_nextLevelButton.y = popUpY + popUpHeight - _nextLevelButton.height - 10;
			
			
			addChild(_nextLevelButton);
			
			
		}

		public function get pontuacaoRecordPessoal():uint
		{
			return _pontuacaoRecordPessoal;
		}

		public function set pontuacaoRecordPessoal(value:uint):void
		{
			_pontuacaoRecordPessoal = value;
		}

		public function get nextLevelButton():Button
		{
			return _nextLevelButton;
		}

		public function set nextLevelButton(value:Button):void
		{
			_nextLevelButton = value;
		}

		public function get texto():TextField
		{
			return _texto;
		}

		public function set texto(value:TextField):void
		{
			_texto = value;
		}

	}
}