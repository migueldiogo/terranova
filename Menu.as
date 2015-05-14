package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.net.registerClassAlias;
	import flash.text.TextField;
	
	import fl.controls.Button;
	import fl.controls.List;
	import fl.controls.TextInput;

	public class Menu
	{
		private var _sharedObject : SharedObject;
		private var inputDialog : InputDialog;

		
		private var _main : MovieClip;
		private var _container : MovieClip;
		
		public function Menu(main : MovieClip)
		{
			_main = main;
			_container = new MovieClip();

			_main.gotoAndStop(1);

			
			registerClassAlias("Jogador", Jogador);

			initSharedObject();
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
			carregarJogoButton.addEventListener(MouseEvent.CLICK, carregaJogoButtonClicked);

			var settingsButton : SettingsIcon = new SettingsIcon;
			settingsButton.buttonMode = true;
			settingsButton.x = 15;
			settingsButton.y = _main.stage.stageHeight - settingsButton.height - 15;
			settingsButton.addEventListener(MouseEvent.CLICK, settings);

			_container.addChild(settingsButton);
			
			
			_main.addChild(_container);
			
			

			
		}
		
		public function initSharedObject() {
			_sharedObject = SharedObject.getLocal("TerraNovaSaved");

			// se array de jogadores ainda nao tiver sido instanciado em disco, instancializa aqui
			// se esta condição nao fosse adicionada, o jogo iria apagar informação previamente gravada
			// numa sessao anterior
			if (_sharedObject.data.jogadores == null)
				_sharedObject.data.jogadores = new Vector.<Jogador>();
		}
		
		public function novoJogo(e : MouseEvent) {
			
			inputDialog = new InputDialog(_main, "Escreve aqui o teu nome:");
			inputDialog.okButton.addEventListener(MouseEvent.CLICK, okInput);
			inputDialog.cancelarButton.addEventListener(MouseEvent.CLICK, cancelaInput);
			inputDialog.backButton.visible = false;
			inputDialog.backButton.enabled = false;

			
			_container.filters= [ new BlurFilter(10, 10, BitmapFilterQuality.HIGH) ];
			_main.addChild(inputDialog);
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
					var novoJogador : Jogador = new Jogador(inputDialog.inputText.text, new Vector.<uint>);
					// ALTERAR
					// deep copy do jogador para ficheiro
					_sharedObject.data.jogadores.push(new Jogador(novoJogador.nome, new Vector.<uint>));
					_sharedObject.flush();
					/////////////
					
					
					new Niveis(_main, novoJogador);
					_container.filters= [];
					_main.removeChild(inputDialog);
					_main.removeChild(_container);
					
					
				}
			}
		}
		
		
		public function cancelaInput (e : MouseEvent) {
			
			_main.removeChild(e.target.parent);
			_container.filters= [];
			
			
		}
		
		/**
		 * 
		 */
		public function carregaJogoButtonClicked(e : MouseEvent) {
			
			// lista nomes de jogadores em cache
			var loadDialog : LoadDialog = new LoadDialog(this);
			
			for (var i : uint = 0; i < _sharedObject.data.jogadores.length; i++) {
				loadDialog.list.addItem({label: _sharedObject.data.jogadores[i].nome, data: i});
			}
			
			loadDialog.list.addEventListener(Event.CHANGE, loadJogador); 
			loadDialog.backButton.addEventListener(MouseEvent.CLICK, goBack);
			
			_container.filters= [ new BlurFilter(10, 10, BitmapFilterQuality.HIGH) ];
			_main.addChild(loadDialog);


			
		}
		
		/**
		 * Carregga jogador
		 */
		public function loadJogador(e : Event) {
			e.target.removeEventListener(Event.CHANGE, loadJogador);
			_container.filters= [];

			var novoJogador : Jogador = new Jogador(_sharedObject.data.jogadores[e.target.selectedItem.data].nome, _sharedObject.data.jogadores[e.target.selectedItem.data].pontuacoesMaximas);


			new Niveis(_main, novoJogador);
			
			_main.removeChild(e.target.parent);
			_main.removeChild(_container);
		}
		
		
		public function settings(e : MouseEvent) {
			_sharedObject.clear();
			initSharedObject();
		}
		
		
		public function goBack(e : MouseEvent) {
			_main.removeChild(e.target.parent);
			_container.filters= [];
		}
		
		
		
		
		
		
		
		public function get main():MovieClip
		{
			return _main;
		}
		
		public function set main(value:MovieClip):void
		{
			_main = value;
		}
		
		public function get sharedObject():SharedObject
		{
			return _sharedObject;
		}
		
		public function set sharedObject(value:SharedObject):void
		{
			_sharedObject = value;
		}

		
		

	}
}