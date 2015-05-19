package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import fl.containers.UILoader;
	import fl.controls.Button;

	public class Tecnologia extends MovieClip implements AlteradorPlaneta
	{
		public static var PRECISAO_NUMBER : uint = 100;
		
		protected var _mainScreen : MovieClip;	
		protected var _nomeTecnologia : String;
		protected var _planeta : Planeta;
		protected var _nivel : uint;
		protected var _custoMinerioBase : int;
		protected var _custoMinerioAtual : int;
		protected var _custoEnergiaBase : int;
		protected var _custoEnergiaAtual : int;
		protected var _taxaEnergiaBase : int;
		protected var _descricao : String;
		protected var _actions : Vector.<Parametro>;
		
		
		
		private var _evoluirButton : Button;
		private var _demolirButton : Button;
		private var _nomeTextField : TextField;
		private var _imagem : UILoader;
		private var _descricaoTextField : TextField;
		private var _actionsTextField : TextField;
		private var _nivelTextField : TextField;
		private var _custosTextField : TextField;
		
		private var _iconMinerio : UILoader;
		private var _iconEnergia : UILoader;
		private var _minerioTextField : TextField;
		private var _energiaTextField : TextField;
		
		
		
		
		private var _parentMainDisplay : MovieClip;
	
		
		public function Tecnologia( planeta : Planeta = null, nivel : uint = NaN, nomeTecnologia : String = null, descricao : String = null, custoMinerioBase : int = NaN, custoEnergiaBase :int = NaN, parentMainMc : MovieClip = null)
		{

			stop();
			
			_parentMainDisplay = parentMainMc;
			
			_actions = new Vector.<Parametro>();

			_planeta = planeta;
			_nivel = nivel;
			_nomeTecnologia = nomeTecnologia;
			_custoMinerioBase = _custoMinerioAtual = custoMinerioBase;
			_custoEnergiaBase = _custoEnergiaAtual = custoEnergiaBase;
			_descricao = descricao;
			
			trace("MINERIO" + ": " + _custoMinerioBase);
			
			
			
			// LAYOUT
			_nomeTextField = new TextField();
			_nomeTextField.x = 10;
			_nomeTextField.y = 10;
			_nomeTextField.defaultTextFormat = Pretty.HEADING_1;
			_nomeTextField.text = _nomeTecnologia;
			_nomeTextField.width = 170;
			_nomeTextField.height = _nomeTextField.textHeight + 2;
			_nomeTextField.selectable = false;
			

			addChild(_nomeTextField);
			
			_nivelTextField = new TextField();
			_nivelTextField.defaultTextFormat = Pretty.BODY;
			_nivelTextField.x = _parentMainDisplay.stage.stageWidth/2 - 40;
			_nivelTextField.y = _nomeTextField.y;
			_nivelTextField.selectable = false;

			_nivelTextField.text = "Nível " + _nivel;
			addChild(_nivelTextField);
			
			
			_imagem = new UILoader();
			_imagem.x = _nomeTextField.x;
			_imagem.y = _nomeTextField.y + _nomeTextField.height + 10;
			_imagem.width = 114;
			_imagem.height = 114;
			_imagem.maintainAspectRatio = true;
			_imagem.scaleContent = false;
			addChild(_imagem);

			_descricaoTextField = new TextField();
			_descricaoTextField.defaultTextFormat = Pretty.BODY;
			_descricaoTextField.wordWrap = true;
			_descricaoTextField.x = _imagem.x + _imagem.width + 20;
			_descricaoTextField.y = imagem.y;
			_descricaoTextField.width = _parentMainDisplay.stage.stageWidth - _descricaoTextField.x - 25;
			_descricaoTextField.height = _imagem.height/2;
			_descricaoTextField.text = _descricao;
			_descricaoTextField.selectable = false;
			addChild(_descricaoTextField);
			
			_actionsTextField = new TextField();
			_actionsTextField.defaultTextFormat = Pretty.BODY;
			_actionsTextField.x = _descricaoTextField.x;
			_actionsTextField.y = _descricaoTextField.y + _descricaoTextField.height;
			_actionsTextField.width = _descricaoTextField.width;
			_actionsTextField.height = _imagem.height/2;
			//addChild(_actionsTextField);	
			
			_custosTextField = new TextField();
			_custosTextField.defaultTextFormat = Pretty.BODY_BOLD;
			_custosTextField.x = _descricaoTextField.x;
			_custosTextField.y = _actionsTextField.y + 40;
			_custosTextField.width = _descricaoTextField.width;
			_custosTextField.defaultTextFormat.align = TextFormatAlign.RIGHT;
			_custosTextField.selectable = false;
			//addChild(_custosTextField);	
					
			
			_demolirButton = new Button();
			_demolirButton.setStyle("textFormat", Pretty.BODY);
			_demolirButton.label = "DEMOLIR";
			_demolirButton.x= _parentMainDisplay.stage.stageWidth - _demolirButton.width - 25;
			_demolirButton.y = _nomeTextField.y;
			addChild(_demolirButton);
			
			_evoluirButton = new Button();
			_evoluirButton.setStyle("textFormat", Pretty.BODY);
			_evoluirButton.label = "EVOLUIR";
			_evoluirButton.x= _demolirButton.x - _evoluirButton.width - 10;
			_evoluirButton.y = _nomeTextField.y;
			addChild(_evoluirButton);
			
			//atualizaCustos();
			
			
			
			_custoMinerioAtual = _custoMinerioBase*Math.pow(2, _nivel);
			_custoEnergiaAtual = _custoEnergiaBase*Math.pow(2, _nivel);
			_nivelTextField.text = "Nível " + _nivel;
			
			_iconMinerio = new UILoader();
			_iconMinerio.maintainAspectRatio = true;
			_iconMinerio.scaleContent = false;
			_iconMinerio.x = _descricaoTextField.x;
			_iconMinerio.y = _imagem.y + _imagem.height - 20;
			_iconMinerio.width = 16;
			_iconMinerio.height = 16;
			_iconMinerio.source = "media/header/minerio_16.png";
			addChild(_iconMinerio);
			
			_minerioTextField = new TextField();
			_minerioTextField = new TextField();
			_minerioTextField.defaultTextFormat = Pretty.BODY_BOLD;
			_minerioTextField.x = _iconMinerio.x + 20;
			_minerioTextField.y = _iconMinerio.y;
			_minerioTextField.defaultTextFormat.align = TextFormatAlign.RIGHT;
			_minerioTextField.selectable = false;
			
			var texto : String = "";
			if (_custoMinerioAtual > 0)
				texto += "+";
			
			texto += "" + _custoMinerioAtual;
			_minerioTextField.text = texto;
			_minerioTextField.width = _minerioTextField.textWidth + 10;
			
			addChild(_minerioTextField);
			
			_iconEnergia = new UILoader;
			_iconEnergia.maintainAspectRatio = true;
			_iconEnergia.scaleContent = false;
			_iconEnergia.x = _minerioTextField.x + _minerioTextField.width + 15;
			_iconEnergia.y = _iconMinerio.y;
			_iconEnergia.width = 16;
			_iconEnergia.height = 16;
			_iconEnergia.source = "media/header/energia_16.png";
			addChild(_iconEnergia);
			
			_energiaTextField = new TextField();
			_energiaTextField = new TextField();
			_energiaTextField.defaultTextFormat = Pretty.BODY_BOLD;
			_energiaTextField.x = _iconEnergia.x + 20;
			_energiaTextField.y = _iconMinerio.y;
			_energiaTextField.width = 80;
			_energiaTextField.defaultTextFormat.align = TextFormatAlign.RIGHT;
			_energiaTextField.selectable = false;
			
			texto = "";
			if (_custoEnergiaAtual > 0)
				texto += "+";
			
			texto += "" + _custoEnergiaAtual;
			_energiaTextField.text = texto;
			
			addChild(_energiaTextField);
			

			
			graphics.lineStyle(1, 0xFFFFFF, 0.5);
			graphics.moveTo(0, _imagem.y + _imagem.width + 10);
			graphics.lineTo(_parentMainDisplay.stage.stageWidth, _imagem.y + _imagem.width + 10);
			
		}
		


		/**
		 * Funcao despoletadora da evolucao de uma tecnologia ao clicar no botao de "evoluir"
		 */
		public function evoluiTecnologia (e : MouseEvent) {

			_planeta.recursos.minerio += _custoMinerioAtual;
			_planeta.recursos.energia += _custoEnergiaAtual;
			
			_nivel++;
			atualizaTecnologia();
			
			_planeta.game.atualizaSimulacao(null);

		}	
		
		

		
		/**
		 * Funcao despoletadora da venda de uma tecnologia ao clicar no botao de "vender"
		 */
		public function vendeTecnologia (e : MouseEvent) {
			//TODO
			parent.filters = [ new BlurFilter(5, 5, BitmapFilterQuality.HIGH) ];
			
			var popUpContainer : Sprite = new Sprite();
			var popUp : Rectangle = new Rectangle(0, 0, _parentMainDisplay.stage.stageWidth/2, _parentMainDisplay.stage.stageHeight - 280);
			popUp.x = _parentMainDisplay.stage.stageWidth/2 - popUp.width/2;
			popUp.y = _parentMainDisplay.stage.stageHeight/2 - popUp.height/2;
			
			popUpContainer.graphics.beginFill(parseInt(Pretty.COLOR_POPUP), 0.9);
			popUpContainer.graphics.drawRect(popUp.x, popUp.y, popUp.width, popUp.height);
			popUpContainer.graphics.endFill();
			
			var titulo : TextField = new TextField();
			titulo.defaultTextFormat = Pretty.HEADING_1;
			titulo.x = popUp.x + 5;
			titulo.y = popUp.y;
			titulo.width = popUp.width - 10;
			titulo.text = "Demolir Tecnologia";
			titulo.defaultTextFormat.align = TextFormatAlign.CENTER;
			popUpContainer.addChild(titulo);
			
			var descrição : TextField = new TextField();
			descrição.defaultTextFormat = Pretty.BODY;
			descrição.wordWrap = true;
			descrição.x = titulo.x;
			descrição.y = titulo.y + 50;
			descrição.width = titulo.width
			descrição.defaultTextFormat.align = TextFormatAlign.CENTER;
			descrição.text = "A demolição desta tecologia para o seu nível anterior tem os seguintes custos: ... Tem a certeza que quer demolir?";
			popUpContainer.addChild(descrição);
			
			// button OK
			var _okButton : Button = new Button();
			_okButton.label = "OK";
			_okButton.x = popUp.x + popUp.width - _okButton.width - 10;
			_okButton.y = popUp.y + popUp.height - _okButton.height - 10;
			_okButton.addEventListener(MouseEvent.CLICK, confirmaVenda);
			
			
			popUpContainer.addChild(_okButton);
			
			// button Cancel
			var _cancelarButton : Button = new Button();
			_cancelarButton.label = "Cancelar";
			_cancelarButton.x = _okButton.x - _okButton.width - 10;
			_cancelarButton.y = _okButton.y;
			_cancelarButton.addEventListener(MouseEvent.CLICK, cancelaVenda);

			
			
			popUpContainer.addChild(_cancelarButton);
			
			_parentMainDisplay.addChild(popUpContainer);
			
			
			
			
			
			
		}
		
		private function confirmaVenda(e : MouseEvent) {
			
			// consequencias para os dados
			for (var i : uint = 0; i < planeta.dados.length; i++) {
				planeta.dados[i].valor -= actions[i].valor;
				
				// arredonda consoante precisao definida
				planeta.dados[i].valor = Math.round(planeta.dados[i].valor * PRECISAO_NUMBER) / PRECISAO_NUMBER;
				planeta.dados[i].verificaDado();
			}
			
			_custoMinerioAtual = _custoMinerioBase*Math.pow(2, _nivel - 1);
			_custoEnergiaAtual = _custoEnergiaBase*Math.pow(2, _nivel - 1);
			
			// a demolicao nao e' gratuita
			planeta.recursos.minerio += _custoMinerioBase*Math.pow(2, _nivel - 1) * 0.5; 
			planeta.recursos.energia += _custoEnergiaBase*Math.pow(2, _nivel - 1) * 0.5; 

			
			_nivel = _nivel - 1;
			atualizaCustos();
			
			planeta.game.atualizaSimulacao(null);
			
			parent.filters = [];
			_parentMainDisplay.removeChild(e.target.parent);

		}
		
		private function cancelaVenda(e : MouseEvent) {
			parent.filters = [];
			_parentMainDisplay.removeChild(e.target.parent);
		}
		


		/**
		 * Atualiza actions para proximo nivel
		 */
		public function atualizaActions() : void {
			

			var texto : String = "";
			var colunas = 0;
			var linhas = 0;
			for(var i : uint = 0; i < actions.length; i++) {
				if (actions[i].valor != 0) {
					var icon : UILoader = new UILoader;
					icon.maintainAspectRatio = true;
					icon.scaleContent = false;
					icon.x = _descricaoTextField.x + colunas*80;
					icon.y = _descricaoTextField.y + _descricaoTextField.height + linhas*10;
					icon.width = 16;
					icon.height = 16;
					icon.source = "media/parametros/data" + i + "_16.png";
					addChild(icon);
					

					
					
					var sinal : String = "";
					if (actions[i].valor > 0)
						sinal += "+";
					
					var actionText : TextField = new TextField();
					actionText.defaultTextFormat = Pretty.BODY_BOLD;
					actionText.x = icon.x + 16 + 2;
					actionText.y = icon.y;
					actionText.width = 80;
					actionText.text = sinal + actions[i].valor;
					addChild(actionText);	

					if (colunas>6) {
						texto += "\n";
						linhas++;
						colunas = 0;
					}	
					else {
						colunas++;
				}

					
				}
				
			}

			//actionsLabel.setStyle("textFormat", Pretty.BODY);
			//_actionsTextField.htmlText = texto;	
			trace(texto);
			
			
		}
		
		/**
		 * Atualiza custos da tecnologia, nivel e aplica as actions no planeta
		 */
		public function atualizaTecnologia() : void {
			// atualiza custo para proximo nivel e nivel
			atualizaCustos();
			// altera planeta
			alteraPlaneta(true);
			
			// atualiza actions da tecnologia do proximo nivel
			//atualizaActions();

		}
		
		public function atualizaCustos() {			
			_custoMinerioAtual = _custoMinerioBase*Math.pow(2, _nivel);
			_custoEnergiaAtual = _custoEnergiaBase*Math.pow(2, _nivel);
			_nivelTextField.text = "Nível " + _nivel;
			
			_iconMinerio.y = _imagem.y + _imagem.height - 20;
			
			_minerioTextField.x = _iconMinerio.x + 20;
			_minerioTextField.y = _iconMinerio.y;
			
			var texto : String = "";
			if (_custoMinerioAtual > 0)
				texto += "+";
			
			texto += "" + _custoMinerioAtual;
			_minerioTextField.text = texto;
			_minerioTextField.width = _minerioTextField.textWidth + 10;

			
			_iconEnergia.x = _minerioTextField.x + _minerioTextField.width + 15;
			_iconEnergia.y = _iconMinerio.y;


			_energiaTextField.x = _iconEnergia.x + 20;
			_energiaTextField.y = _iconMinerio.y;

			
			texto = "";
			if (_custoEnergiaAtual > 0)
				texto += "+";
			
			texto += "" + _custoEnergiaAtual;
			_energiaTextField.text = texto;
			
		}
		
		/**
		 * altera o planeta com actions da tecnologia recem evoluida
		 */
		public function alteraPlaneta(direcao : Boolean) : void {
			// consequencias para o planeta
			for (var i : uint = 0; i < planeta.dados.length; i++) {
				planeta.dados[i].valor += actions[i].valor;
				
				// arredonda consoante precisao definida
				planeta.dados[i].valor = Math.round(planeta.dados[i].valor * PRECISAO_NUMBER) / PRECISAO_NUMBER;
				planeta.dados[i].atualizaBarra();
				planeta.dados[i].verificaDado();
			}
			
		}
		
		
		
		
		//
		// GETTERS AND SETTERS
		//
		

		public function get descricao():String
		{
			return _descricao;
		}

		public function set descricao(value:String):void
		{
			_descricao = value;
		}

		public function get custoMinerioBase():int
		{
			return _custoMinerioBase;
		}

		public function set custoMinerioBase(value:int):void
		{
			_custoMinerioBase = value;
		}

		public function get nomeTecnologia():String
		{
			return _nomeTecnologia;
		}

		public function set nomeTecnologia(value:String):void
		{
			_nomeTecnologia = value;
		}
			
		public function get nivel():uint
		{
			return _nivel;
		}
		
		public function set nivel(value:uint):void
		{
			_nivel = value;
		}
		
		public function get planeta():Planeta
		{
			return _planeta;
		}
		
		public function set planeta(value:Planeta):void
		{
			_planeta = value;
		}
		
		public function get custoEnergiaAtual():int
		{
			return _custoEnergiaAtual;
		}
		
		public function set custoEnergiaAtual(value:int):void
		{
			_custoEnergiaAtual = value;
		}
		
		public function get custoEnergiaBase():int
		{
			return _custoEnergiaBase;
		}
		
		public function set custoEnergiaBase(value:int):void
		{
			_custoEnergiaBase = value;
		}
		
		public function get actions():Vector.<Parametro>
		{
			return _actions;
		}
		
		public function set actions(value:Vector.<Parametro>):void
		{
			_actions = value;
		}
		
		
		public function get custoMinerioAtual():int
		{
			return _custoMinerioAtual;
		}
		
		public function set custoMinerioAtual(value:int):void
		{
			_custoMinerioAtual = value;
		}
		
		public function get custosTextField():TextField
		{
			return _custosTextField;
		}
		
		public function set custosTextField(value:TextField):void
		{
			_custosTextField = value;
		}
		
		public function get nivelTextField():TextField
		{
			return _nivelTextField;
		}
		
		public function set nivelTextField(value:TextField):void
		{
			_nivelTextField = value;
		}
		
		public function get actionsTextField():TextField
		{
			return _actionsTextField;
		}
		
		public function set actionsTextField(value:TextField):void
		{
			_actionsTextField = value;
		}
		
		public function get descricaoTextField():TextField
		{
			return _descricaoTextField;
		}
		
		public function set descricaoTextField(value:TextField):void
		{
			_descricaoTextField = value;
		}
		
		public function get imagem():UILoader
		{
			return _imagem;
		}
		
		public function set imagem(value:UILoader):void
		{
			_imagem = value;
		}
		
		public function get nameTextField():TextField
		{
			return _nomeTextField;
		}
		
		public function set nameTextField(value:TextField):void
		{
			_nomeTextField = value;
		}
		
		
		
		public function get demolirButton():Button
		{
			return _demolirButton;
		}
		
		public function set demolirButton(value:Button):void
		{
			_demolirButton = value;
		}
		
		public function get evoluirButton():Button
		{
			return _evoluirButton;
		}
		
		public function set evoluirButton(value:Button):void
		{
			_evoluirButton = value;
		}
	}
}