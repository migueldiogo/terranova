package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import flash.text.TextField;
	
	import fl.controls.Button;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	
	
	/**
	 * EM CONSTRUCAO!!!!!!!!!!!!!!!!!!
	 */
	public class SettingsPanel extends MovieClip
	{
		private var _parentMovieClip : MovieClip;
		private var _parentMenu : Menu;
		private var _resetJogadoresButton : Button;
		private var _resetSettingsButton : Button;
		private var _sliderGraficos : Slider;
		private var _graficosValueTextField : TextField;
		private var _sharedObject : SharedObject;
		
		private var _musica : SliderOption;
		private var _graficos : SliderOption;
		
		
		public function SettingsPanel(parentMovieClip : MovieClip, menu : Menu = null)
		{
			super();
			_parentMovieClip = parentMovieClip;
			_parentMenu = menu;

			initSettings();

			var popUpWidth : Number = _parentMovieClip.stage.stageWidth/2;
			var popUpHeight : Number = _parentMovieClip.stage.stageHeight/4;
			var popUpX : Number = _parentMovieClip.stage.stageWidth/2 - popUpWidth/2;
			var popUpY : Number = _parentMovieClip.stage.stageHeight/2 - popUpHeight/2;
			
			var retangulo : Rectangle = new Rectangle(popUpX, popUpY, popUpWidth, popUpHeight);
			
			graphics.beginFill(parseInt(Pretty.COLOR_POPUP), 0.8);
			graphics.drawRoundRect(popUpX, popUpY, popUpWidth, popUpHeight, 15);
			graphics.endFill();
			
			
			_graficos = new SliderOption(retangulo, "Qualidade dos Gráficos");
			_graficos.slider.value = _sharedObject.data.graficos;
			if (_graficos.slider.value == 0)
				_graficos.valueLabel.text = "Baixa";
			else if (_graficos.slider.value == 1)
				_graficos.valueLabel.text = "Média";
			else
				_graficos.valueLabel.text = "Alta";

			_graficos.slider.addEventListener(SliderEvent.CHANGE, graficosChanged);
			//addChild(_graficos);
			var titulo : TextField = new TextField();
			titulo.defaultTextFormat = Pretty.HEADING_1;
			titulo.text = "DEFINIÇÕES";
			titulo.width = titulo.textWidth + 5;
			titulo.height = titulo.textHeight + 5;
			titulo.x = popUpX + popUpWidth/2 - titulo.width/2;
			titulo.y = popUpY + 5;
			addChild(titulo);

			
			_musica = new SliderOption(retangulo, "Música");
			_musica.slider.minimum = 0;
			_musica.slider.maximum = 100;
			_musica.y += 30;
			_musica.slider.x = _graficos.slider.x;
			_musica.valueLabel.x = _graficos.valueLabel.x;
			_musica.slider.value = _sharedObject.data.musica;
			_musica.valueLabel.text = "" + _musica.slider.value;
			_musica.slider.addEventListener(SliderEvent.CHANGE, musicaChanged);
			addChild(_musica);
			
			SoundMixer.soundTransform = new SoundTransform(_musica.slider.value / 100);

/*
			_resetSettingsButton = new Button();
			_resetSettingsButton.width = popUpWidth - 10;
			_resetSettingsButton.label = "Reset Settings";
			_resetSettingsButton.x = popUpX + popUpWidth/2 - _resetSettingsButton.width/2;
			_resetSettingsButton.y = popUpY + _musica.y + 40;
			_resetSettingsButton.addEventListener(MouseEvent.CLICK, resetClicked);	
			addChild(_resetSettingsButton);
			*/
			// button RESET
			_resetJogadoresButton  = new Button();
			_resetJogadoresButton.width = popUpWidth - 10;
			_resetJogadoresButton.label = "Reset Jogadores";
			_resetJogadoresButton.x = popUpX + popUpWidth/2 - _resetJogadoresButton.width/2;
			_resetJogadoresButton.y = popUpY + _musica.y + 60;
			_resetJogadoresButton.addEventListener(MouseEvent.CLICK, resetClicked);	
			addChild(_resetJogadoresButton);
			
			loadSettings();
			
			
		}
		
		/**
		 * atualiza jogo de acordo com definicoes
		 */
		public static function loadSettings() {
			var musica : uint = 0;
			var graficos : uint = 0;
			var settings : SharedObject = SharedObject.getLocal("TerraNovaSettings");
			if (settings.data.graficos == null && settings.data.musica == null) {
				//_sharedObject.data.graficos = 2;
				musica = 50;
			}
			else
				musica = settings.data.musica;
			
			SoundMixer.soundTransform = new SoundTransform(musica / 100);

			
		}
		
		private function initSettings() {
			_sharedObject = SharedObject.getLocal("TerraNovaSettings");
			
			// definicoes default
			if (_sharedObject.data.graficos == null && _sharedObject.data.musica == null) {
				_sharedObject.data.graficos = 2;
				_sharedObject.data.musica = 50;
			}
			
			
		}
		
		private function graficosChanged(e : SliderEvent) {
			_sharedObject.data.graficos = e.target.value;

			if (e.target.value == 0)
				e.target.parent.valueLabel.text = "Baixa";
			else if (e.target.value == 1)
				e.target.parent.valueLabel.text = "Média";
			else
				e.target.parent.valueLabel.text = "Alta";
		}
		
		private function musicaChanged(e : SliderEvent) {
			e.target.parent.valueLabel.text = e.target.value;
			_sharedObject.data.musica = e.target.value;
			SoundMixer.soundTransform = new SoundTransform(e.target.value / 100);

		}
		


		private function resetClicked (e : MouseEvent) {
			_parentMenu.sharedObject.clear();
			//_sharedObject.clear();
			initSettings();
			_parentMenu.initSharedObject();

			
		}
	}
}