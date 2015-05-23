package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.drm.AddToDeviceGroupSetting;
	import flash.text.TextField;
	
	import fl.containers.ScrollPane;
	import fl.containers.UILoader;
	import fl.controls.Label;
	import fl.motion.Color;
	
	
	public class Niveis
	{
		private var _niveis : Array;
		private var container : Sprite;
		private var niveisSprite : Sprite;
		private var _main : MovieClip;
		private var _jogador : Jogador;

		private var _numeroDeNiveis :uint;
		
		public function Niveis(main : MovieClip, jogador : Jogador)
		{
			
			_jogador = jogador;
			_main = main;
			_niveis = new Array;
			container = new Sprite();
			niveisSprite = new Sprite();
			
			
			_main.gotoAndStop(1);
			
			// Loading dos dados do planeta
			var dataPlanetas:XML = new XML();
			var xml_LoaderPlanetas:URLLoader = new URLLoader();
			xml_LoaderPlanetas.load(new URLRequest("data/planetas.xml"));			
			xml_LoaderPlanetas.addEventListener(Event.COMPLETE, carregaPlanetas);
			
			
			
			
		}
		
		public function get numeroDeNiveis():uint
		{
			return _numeroDeNiveis;
		}

		public function set numeroDeNiveis(value:uint):void
		{
			_numeroDeNiveis = value;
		}

		public function init() {
			var sharedObject : SharedObject = SharedObject.getLocal("TerraNovaSaved");			
			
			var title : TextField = new TextField();

			title.width = 640;
			title.defaultTextFormat = Pretty.TITLE_1;
			
			title.text = "Níveis";
			
			title.x = 0;
			title.y = 20;
			
			var scrollPane : ScrollPane = new ScrollPane();
			scrollPane.width = _main.stage.stageWidth;
			//scrollPane.y = title.y + title.textHeight + 10;
			//scrollPane.height = _main.stage.stageHeight - scrollPane.y;
			scrollPane.height = _main.stage.stageHeight;
			scrollPane.opaqueBackground = null;

			
			var colunas : uint = 0;
			var linhas : uint = 0;
			var nivel : Nivel;
			for (var i : uint = 0; i < _numeroDeNiveis; i++) {
				
				// descobre record global do nivel i+1
				var tempoRecordGlobal : Number = NaN;
				for (var j : uint = 0; j < sharedObject.data.jogadores.length; j++) {
					if (i < sharedObject.data.jogadores[j].temposMaximos.length) {
						if (sharedObject.data.jogadores[j].temposMaximos[i] < tempoRecordGlobal || isNaN(tempoRecordGlobal))
							tempoRecordGlobal = sharedObject.data.jogadores[j].temposMaximos[i];
					}
				}
				
				
				nivel = new Nivel(i+1, tempoRecordGlobal);
				
				// posiciona nivel
				nivel.x = 54 + colunas*120			//54 + colunas*120;
				nivel.y = 120 + linhas * 180;		// 120 + linhas * 180
				

				
				// niveis estao bloqueados consoante o progresso do jogador
				if (i+1 <= _jogador.proximoNivel()) {
					
					nivel.buttonMode = true;
					nivel.addEventListener(MouseEvent.CLICK, startLevel);
				}
				else {
					nivel.buttonMode = false;
					nivel.alpha = 0.4;			// ou filters = [new BlurFilter(20,20, BitmapFilterQuality.HIGH)];			// ou 
					
				}
				
				niveisSprite.addChild(nivel);
				_niveis.push(nivel);

				
				if (colunas == 4) {
					linhas++;
					colunas = 0;
				}
				else {
					colunas++;
				}
			}
			
			scrollPane.source = niveisSprite;
			container.addChild(scrollPane);
			container.addChild(title);
			_main.addChild(container);
					
			
		}
		
		private function carregaPlanetas (e : Event) {
			e.target.removeEventListener(Event.COMPLETE, carregaPlanetas)
			var data : XML = new XML(e.target.data);
			
			_numeroDeNiveis = data.planeta.length();
			trace("NUMERO DE NIVEIS: " + _numeroDeNiveis);
			init();
			
		}
		
		public function get niveis():Array
		{
			return _niveis;
		}
		
		public function set niveis(value:Array):void
		{
			_niveis = value;
		}
		
		private function startLevel (e : MouseEvent) {
			var encontrado : Boolean = false;
			for (var i :uint = 0; i < _niveis.length && !encontrado; i++) {
				if (e.currentTarget == _niveis[i]) {
					encontrado = true;
					
					new MainGame(_main, i+1, _jogador, e.currentTarget.tempoRecordGlobal.valueOf());
					_main.removeChild(container);
				}
				
			}
		}
		
		
	}
	
	
}

