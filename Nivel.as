package  {
	import flash.display.MovieClip;
	import flash.net.drm.AddToDeviceGroupSetting;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import fl.containers.UILoader;
	import fl.transitions.Fade;
	
	public class Nivel extends MovieClip{
		private var _numeroNivel : uint;
		private var _titulo : TextField;
		private var _imagem : UILoader;
		private var _estrelas : Array;
		private var _tempoRecordGlobal : uint;
		
		public function Nivel(numeroNivel : uint, tempoRecordGlobal : uint = 0) {
			// constructor code
			_numeroNivel = numeroNivel;
			_tempoRecordGlobal = tempoRecordGlobal;
			
			
			_imagem = new UILoader();
			_imagem.source = "media/niveis/world_azul.png";
			_imagem.maintainAspectRatio = true;
			_imagem.scaleContent = false;
			_imagem.x = 0;
			_imagem.y = 20;
			addChild(_imagem);
			
			_titulo = new TextField();
			_titulo.autoSize = "left";
			_titulo.defaultTextFormat = Pretty.HEADING_1;
			_titulo.height = 20;
			_titulo.text = "Nível " + _numeroNivel;
			_titulo.x = 114/2 - _titulo.width/2;
			_titulo.y = 0;
			_titulo.selectable = false;
			_titulo.mouseEnabled = false;
			addChild(_titulo);

			
			// TO DO
			_estrelas = null;
			
			
		}

		public function get tempoRecordGlobal():uint
		{
			return _tempoRecordGlobal;
		}

		public function set tempoRecordGlobal(value:uint):void
		{
			_tempoRecordGlobal = value;
		}

		public function get numeroNivel():uint
		{
			return _numeroNivel;
		}

		public function set numeroNivel(value:uint):void
		{
			_numeroNivel = value;
		}

		public function get estrelas():Array
		{
			return _estrelas;
		}

		public function set estrelas(value:Array):void
		{
			_estrelas = value;
		}

		public function get imagem():UILoader
		{
			return _imagem;
		}

		public function set imagem(value:UILoader):void
		{
			_imagem = value;
		}

		public function get titulo():TextField
		{
			return _titulo;
		}

		public function set titulo(value:TextField):void
		{
			_titulo = value;
		}

	}
	
}
