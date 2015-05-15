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
		private var _parentMenu : Menu;
		private var _backButton : BackArrow;
		private var _resetButton : Button;
		private var _sliderGraficos : Slider;
		private var _graficosValueTextField : TextField;
		private var _sharedObject : SharedObject;
		
		
		public function SettingsPanel(parentMenu : Menu)
		{
			super();
			_parentMenu = parentMenu;
			_sharedObject = SharedObject.getLocal("TerraNovaSettings");
			
			// definicoes default
			if (_sharedObject.data.graficos == null && _sharedObject.data.musica == null) {
				_sharedObject.data.graficos = 2;
				_sharedObject.data.musica = 50;
			}
			
			// seta para volta para tras
			_backButton = new BackArrow();
			_backButton.buttonMode = true;
			_backButton.x = 15;
			_backButton.y = 15;
			addChild(_backButton);
			
			var popUpWidth : Number = _parentMenu.main.stage.stageWidth/2;
			var popUpHeight : Number = _parentMenu.main.stage.stageHeight/2;
			var popUpX : Number = _parentMenu.main.stage.stageWidth/2 - popUpWidth/2;
			var popUpY : Number = _parentMenu.main.stage.stageHeight/2 - popUpHeight/2;
			
			var retangulo : Rectangle = new Rectangle(popUpX, popUpY, popUpWidth, popUpHeight);
			graphics.beginFill(parseInt(Pretty.COLOR_POPUP), 0.8);
			graphics.drawRect(popUpX, popUpY, popUpWidth, popUpHeight);
			graphics.endFill();
			
			
			var graficos : SliderOption = new SliderOption(retangulo, "Qualidade dos Gráficos");
			graficos.slider.value = _sharedObject.data.graficos;
			if (graficos.slider.value == 0)
				graficos.valueLabel.text = "Baixa";
			else if (graficos.slider.value == 1)
				graficos.valueLabel.text = "Média";
			else
				graficos.valueLabel.text = "Alta";

			graficos.slider.addEventListener(SliderEvent.CHANGE, graficosChanged);
			addChild(graficos);
			
			
			var musica : SliderOption = new SliderOption(retangulo, "Música");
			musica.slider.minimum = 0;
			musica.slider.maximum = 100;
			musica.y += 30;
			musica.slider.x = graficos.slider.x;
			musica.valueLabel.x = graficos.valueLabel.x;
			musica.slider.value = _sharedObject.data.musica;
			musica.valueLabel.text = "" + musica.slider.value;
			musica.slider.addEventListener(SliderEvent.CHANGE, musicaChanged);
			addChild(musica);

			
			
			
			// button RESET
			_resetButton  = new Button();
			_resetButton.label = "RESET";
			_resetButton.x = popUpX + popUpWidth - _resetButton.width - 10;
			_resetButton.y = popUpY + popUpHeight - _resetButton.height - 10;
			_resetButton.addEventListener(MouseEvent.CLICK, resetClicked);	
			addChild(_resetButton);
			
			
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
		
		
		public function get backButton():BackArrow
		{
			_sharedObject.flush();
			return _backButton;
		}

		public function set backButton(value:BackArrow):void
		{
			_backButton = value;
		}

		private function resetClicked (e : MouseEvent) {
			_parentMenu.sharedObject.clear();
			_parentMenu.initSharedObject();

			
		}
	}
}