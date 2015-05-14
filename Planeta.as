package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.registerClassAlias;
	import flash.text.TextField;
	

	public class Planeta extends Astro
	{		
		// constantes de acesso ao vetor _dados
		public static var TAXA_MINERIO : uint = 0;
		public static var DIOXIDO_DE_CARBONO : uint = 1;
		public static var METANO : uint = 2;
		public static var OXIGENIO : uint = 3;
		public static var OZONO : uint = 4;
		
		public static var GRAVIDADE : uint = 5;
		public static var SPIN : uint = 6;
		public static var LAPSE : uint = 7;
		public static var TEMPERATURA : uint = 8;
		
		public static var TSUNAMI: uint = 9;
		public static var VULCOES: uint = 10;
		public static var METEORITOS: uint = 11;
		
		
		
		private var _distanciaEstrelaMae : Number;
		private var _periodoTranslacao : Number;
		private var _periodoRotacao : Number;
		
		private var _habitavel : Boolean;
		
		private var _dados : Vector.<Parametro>;
		
		private var _recursos : Recursos;
		private var _tecnologias : Vector.<Tecnologia>;
		
		//private var _modelo : Planeta;
		
		private var _jogador : Jogador;
		private var _nivel : uint;
		
		private var _game : MainGame;
		private var _loadersCompleted : uint;
		
		
		
		
		public function Planeta(game : MainGame = null, jogador : Jogador = null, nivel : uint = NaN, reset : Boolean = false)
		{
			
			super();
			_game = game;
			_loadersCompleted = 0;
			
			_jogador = jogador;
			_nivel = nivel;
			_dados = new Vector.<Parametro>();			
			_recursos = new Recursos();
			_tecnologias = new Vector.<Tecnologia>;
			_habitavel = false;
			
	

		}


		public function get game():MainGame
		{
			return _game;
		}

		public function set game(value:MainGame):void
		{
			_game = value;
		}

		public function resetPlaneta() {
			// Loading dos dados do planeta
			var dataPlanetas:XML = new XML();
			var xml_LoaderPlanetas:URLLoader = new URLLoader();
			xml_LoaderPlanetas.load(new URLRequest("data/planetas.xml"));			
			xml_LoaderPlanetas.addEventListener(Event.COMPLETE, carregaPlanetaOriginal);	
			
			// Loading dos dados das tecnologias	
			var dataTecnologias:XML = new XML();
			var xml_LoaderTecnologias:URLLoader = new URLLoader();
			xml_LoaderTecnologias.load(new URLRequest("data/tecnologias.xml"));			
			xml_LoaderTecnologias.addEventListener(Event.COMPLETE, carregaTecnologiasOriginais);
			
		}

		public function get jogador():Jogador
		{
			return _jogador;
		}

		public function set jogador(value:Jogador):void
		{
			_jogador = value;
		}

		public function init() {

			

			
		}
		
		public function get tecnologias():Vector.<Tecnologia>
		{
			return _tecnologias;
		}

		public function set tecnologias(value:Vector.<Tecnologia>):void
		{
			_tecnologias = value;
		}

		public function get nivel():uint
		{
			return _nivel;
		}

		public function set nivel(value:uint):void
		{
			_nivel = value;
		}

		public function verificaDados()
		{
			
			for (var i : uint  = 0; i < _dados.length; i++) {
				var texto : String = "";
				
				// valor incorreto
				if (_dados[i].valor < _dados[i].valorOtimoMinimo || _dados[i].valor > dados[i].valorOtimoMaximo) {
					texto += '<font color="#FF0000">';
					texto += _dados[i].valor + "</font>\n";
					_dados[i].correto = false;
				}
				// valor nao importante para vencer o nivel
				else if (isNaN(_dados[i].valorOtimoMinimo) || isNaN(_dados[i].valorOtimoMaximo)) {
					texto += _dados[i].valor + "\n";
					_dados[i].correto = true;
				}
				// valor correto
				else {
					texto += '<font color="#00FF00">';
					texto += _dados[i].valor + "</font>\n";
					_dados[i].correto = true;
				}
				
				_dados[i].valorLabel.htmlText = _dados[i].nome + ": " + texto;

			}
			
			

			
			
		}
		
		private function carregaPlanetaOriginal (e : Event) {
			var data : XML = new XML(e.target.data);
			
			_nome = data.planeta[nivel-1].nome;
			_distanciaEstrelaMae = data.planeta[nivel-1].distanciaEstrelaMae;
			_periodoTranslacao = data.planeta[nivel-1].periodoTranslacao;
			_periodoRotacao = data.planeta[nivel-1].periodoRotacao;
			
			var contadorColunas : uint = 0;
			var contadorLinhas : uint = 0;
			
			for (var i : uint = 0; i<data.planeta[nivel-1].dado.length(); i++) {
				_dados[i] = new Parametro(data.planeta.dado[i].nome, i, data.planeta.dado[i].parametro.valor, data.terra.dado[i].parametro.minimo, data.terra.dado[i].parametro.maximo);
			}
			
			_loadersCompleted++;
			
			if (_loadersCompleted == 2)
				_game.init();

		}
		
		
		private function carregaTecnologiasOriginais (e : Event) {
			var data : XML = new XML(e.target.data);
			
			for (var i : uint = 0; i<data.tecnologia.length(); i++) {
				
				tecnologias[i] = new Tecnologia(this, 0, data.tecnologia[i].nome, data.tecnologia[i].descricao, data.tecnologia[i].custos.minerio, data.tecnologia[i].custos.energia);
				for(var j : uint = 0; j<data.tecnologia[i].actions[0].*.length();j++) {
					tecnologias[i].actions.push(new Parametro(data.tecnologia[i].actions.*[j].nome, i, data.tecnologia[i].actions.*[j].valor));
					
					
					tecnologias[i].imagemTecnologia.source = "media/parametros/data0.png";
					
					tecnologias[i].imagemTecnologia.scaleContent = true; 
					
					//tecnologias[i].imagemTecnologia.addEventListener(Event.COMPLETE, completeHandler); 
										
				}
				
				// popula label com as consequencias desta tecnologia no planeta
				tecnologias[i].atualizaActions();
				
				// accionar butoes
				tecnologias[i].nivelButtons.nivelUpButton.buttonMode = true;
				tecnologias[i].nivelButtons.nivelDownButton.buttonMode = true;
				

			}
			_loadersCompleted++;
			
			if (_loadersCompleted == 2)
				_game.init();
		}
		
		

		
		// 
		// Getters and Setters
		// 
		
		public function get dados():Vector.<Parametro>
		{
			return _dados;
		}

		public function set dados(value:Vector.<Parametro>):void
		{
			_dados = value;
		}

		



		public function get recursos():Recursos
		{
			return _recursos;
		}

		public function set recursos(value:Recursos):void
		{
			_recursos = value;
		}



		public function get habitavel():Boolean
		{
			return _habitavel;
		}

		public function set habitavel(value:Boolean):void
		{
			_habitavel = value;
		}



		public function get periodoRotacao():Number
		{
			return _periodoRotacao;
		}

		public function set periodoRotacao(value:Number):void
		{
			_periodoRotacao = value;
		}

		public function get periodoTranslacao():Number
		{
			return _periodoTranslacao;
		}

		public function set periodoTranslacao(value:Number):void
		{
			_periodoTranslacao = value;
		}

		public function get distanciaEstrelaMae():Number
		{
			return _distanciaEstrelaMae;
		}

		public function set distanciaEstrelaMae(value:Number):void
		{
			_distanciaEstrelaMae = value;
		}

		public function atualizaAparencia() : void {
			// TODO
		}
	
		
	}
}