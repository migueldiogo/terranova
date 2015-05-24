package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.registerClassAlias;
	import flash.text.TextField;
	
	import fl.motion.motion_internal;
	

	public class Planeta extends Astro
	{		
		// constantes de acesso ao vetor _dados
		public static var TAXA_MINERIO : uint = 0;
		public static var TSUNAMI: uint = 1;
		public static var VULCOES: uint = 2;
		public static var METEORITOS: uint = 3;
		
		public static var TEMPERATURA : uint = 4;
		public static var GRAVIDADE : uint = 5;
		public static var SPIN : uint = 6;
		public static var LAPSE : uint = 7;
		
		public static var DIOXIDO_DE_CARBONO : uint = 8;
		public static var METANO : uint = 9;
		public static var OXIGENIO : uint = 10;
		public static var OZONO : uint = 11;
		/////////////////////////////////////////

		
		/**
		 * Distancia do planeta à sua estrela mãe.
		 */
		private var _distanciaEstrelaMae : Number;
		
		/**
		 * True quando planeta habitável (dados todos verificados dentro dos intervalos de referência.
		 */
		private var _habitavel : Boolean;
		
		/**
		 * Array com dados do planeta.
		 * @see Parametro
		 */
		private var _dados : Vector.<Parametro>;
		
		/**
		 * Recursos do planeta (minério e energia).
		 * @see Recursos
		 */
		private var _recursos : Recursos;
		
		/**
		 * Tecnologias associadas ao planeta.
		 */
		private var _tecnologias : Vector.<Tecnologia>;
		
		/**
		 * Jogador associado.
		 * @see Menu
		 * @see Jogador
		 */
		private var _jogador : Jogador;
		
		/**
		 * Nível de dificuldade associado a este planeta.
		 * @Nivel
		 * @Niveis
		 */
		private var _nivel : uint;
		
		/**
		 * Jogo/Simulador associado a este planeta.
		 */
		private var _game : MainGame;
		
		/**
		 * Controlador dos loaders xml. Este valor indica o seu término.
		 */
		private var _loadersCompleted : uint;
		
		private var _estadoTerraformacao : uint;
		
		
		
		public function Planeta(game : MainGame = null, jogador : Jogador = null, nivel : uint = NaN)
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





		/**
		 * Planeta é populado com valores em ficheiro.
		 */
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
		

		public function atualizaEstadoTerraformacao() : void {
			var estado : uint = 0;
			for (var i : uint = 0; i < _dados.length; i++) {
				estado += _dados[i].estadoTerraformacaoDado;
			}
			
			_estadoTerraformacao = estado / _dados.length;
		}

		
		
		/**
		 * Carrega dados do planeta em ficheiro.
		 * @see Parametro
		 */
		private function carregaPlanetaOriginal (e : Event) {
			var data : XML = new XML(e.target.data);
			
			_nome = data.planeta[nivel-1].nome;
			_distanciaEstrelaMae = data.planeta[nivel-1].distanciaEstrelaMae;

			
			for (var i : uint = 0; i<data.planeta[nivel-1].dado.length(); i++) {
				_dados[i] = new Parametro(data.planeta[nivel-1].dado[i].nome, i, data.planeta[nivel-1].dado[i].parametro.valor, data.terra.dado[i].parametro.minimo, data.terra.dado[i].parametro.maximo);
			}
			
			_loadersCompleted++;
			
			if (_loadersCompleted == 2)
				_game.init();

		}
		
		/**
		 * Carrega tecnologias em ficheiro.
		 * @see Parametro
		 * @see Tecnologia
		 */
		private function carregaTecnologiasOriginais (e : Event) {
			var data : XML = new XML(e.target.data);
			
			for (var i : uint = 0; i<data.tecnologia.length(); i++) {	
				tecnologias[i] = new Tecnologia(this, 0, data.tecnologia[i].nome, data.tecnologia[i].descricao, data.tecnologia[i].custos.minerio, data.tecnologia[i].custos.energia, _game.mainMovieClip);
				for(var j : uint = 0; j<data.tecnologia[i].actions[0].*.length();j++) {
					tecnologias[i].actions.push(new Parametro(data.tecnologia[i].actions.*[j].nome, i, data.tecnologia[i].actions.*[j].valor));
					tecnologias[i].imagem.source = "media/tecnologias/tecnologia" + i + ".jpg";
				}
				
				// popula label com as consequencias desta tecnologia no planeta
				tecnologias[i].atualizaActions();
				
				// accionar butoes
				tecnologias[i].evoluirButton.enabled = true;
				tecnologias[i].demolirButton.enabled = true;
				

			}
			_loadersCompleted++;
			
			if (_loadersCompleted == 2)
				_game.loadCGI();
		}
		

		

		
		/******************************************************
		 * GETTERS & SETTERS
		 ******************************************************/
		
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


		public function get distanciaEstrelaMae():Number
		{
			return _distanciaEstrelaMae;
		}

		public function set distanciaEstrelaMae(value:Number):void
		{
			_distanciaEstrelaMae = value;
		}

		
		public function get game():MainGame
		{
			return _game;
		}
		
		public function set game(value:MainGame):void
		{
			_game = value;
		}
		
		public function get jogador():Jogador
		{
			return _jogador;
		}
		
		public function set jogador(value:Jogador):void
		{
			_jogador = value;
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
		
		/**
		 * Estado de Terraformacao. 0 - mais parece uma rocha; 100 - um lar perfeito para se viver.
		 */
		public function get estadoTerraformacao():uint
		{
			return _estadoTerraformacao;
		}
		
		/**
		 * @private
		 */
		public function set estadoTerraformacao(value:uint):void
		{
			_estadoTerraformacao = value;
		}
	
		
	}
}