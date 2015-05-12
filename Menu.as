package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.text.TextField;
	
	import fl.controls.Button;
	import fl.controls.TextInput;

	public class Menu
	{
		private var _sharedObject : SharedObject;
		private var inputDialog : InputDialog;

		
		private var _main : MovieClip;
		private var _container : MovieClip;
		
		public function Menu(main : MovieClip)
		{
			_sharedObject = SharedObject.getLocal("TerraNovaSaved");
			_sharedObject.data.jogadores = new Vector.<Jogador>();
			
			_main = main;
			_main.gotoAndStop(1);
			
			_container = new MovieClip();

			init();
		}
		
		private function init() : void {
			
			var title : TextField = new TextField();
			title.width = 640;
			title.defaultTextFormat = Pretty.TITLE_1;
			
			title.text = "TERRA NOVA";
			
			title.x = 0;
			title.y = 20;
			_container.addChild(title);

			var novoJogoButton : Button = new Button();
			novoJogoButton.label = "Novo Jogo";
			novoJogoButton.setStyle("textFormat", Pretty.BODY_BOLD);
			novoJogoButton.width = 170;
			novoJogoButton.height = 40;
			novoJogoButton.x = _main.stage.stageWidth/2 - novoJogoButton.width/2;
			novoJogoButton.y = 200;
			novoJogoButton.addEventListener(MouseEvent.CLICK, novoJogo);
			_container.addChild(novoJogoButton);
			
			
			
			var carregarJogoButton : Button = new Button();
			carregarJogoButton.label = "Carregar Jogo";
			carregarJogoButton.setStyle("textFormat", Pretty.BODY_BOLD);
			carregarJogoButton.width = 170;
			carregarJogoButton.height = 40;
			carregarJogoButton.x = _main.stage.stageWidth/2 - carregarJogoButton.width/2;
			carregarJogoButton.y = 260;
			_container.addChild(carregarJogoButton);
			
			_main.addChild(_container);

			
			
			
			
		}
		
		public function novoJogo(e : MouseEvent) {
			var blur : BlurFilter = new BlurFilter();
			blur.blurX = 10;
			blur.blurY = 10;
			blur.quality = BitmapFilterQuality.HIGH;
			
			
			inputDialog = new InputDialog(_main, "Escreve aqui o teu nome:");
			inputDialog.okButton.addEventListener(MouseEvent.CLICK, okInput);
			inputDialog.cancelarButton.addEventListener(MouseEvent.CLICK, cancelaInput);
			
			_container.filters= [ blur ];
			_main.addChild(inputDialog);

			
			
			//new Niveis(_main);
			//_main.removeChild(_container);
		}
		
		
		
		public function okInput (e : MouseEvent) {
			if (inputDialog.inputText.text == "") {
				trace("JOGADOR MAL INPUTADO");
			}
			else {
				var encontrado : Boolean = false;
				for (var i : uint = 0; i < _sharedObject.data.jogadores.length && !encontrado; i++) {
					if (inputDialog.inputText.text == _sharedObject.data.jogadores[i].nome)
						encontrado = true;
				}
				
				if (encontrado) {
					trace("JOGADOR JA EXISTE");
					inputDialog.okButton.label = "MAL";
				}
				else {
					trace("JOGADOR VALIDO");
					var novoJogador : Jogador = new Jogador(inputDialog.inputText.text);
					
					
					
					// ALTERAR
					_sharedObject.data.jogadores.push(novoJogador);
					_sharedObject.flush();
					/////////////
					
					
					new Niveis(_main, novoJogador);
					
					_main.removeChild(inputDialog);
					_main.removeChild(_container);
					
				}
			}
		}
		
		public function cancelaInput (e : MouseEvent) {
			_main.removeChild(e.currentTarget.parent);
			_container.filters= [];
			
			

		}
		
		

		// REVER
		//
		//

	}
}