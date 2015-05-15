package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	
	public class SliderOption extends MovieClip
	{
		private var _parent : Rectangle;
		
		private var _label : TextField;
		private var _slider : Slider;
		private var _valueLabel : TextField;
		
		public function SliderOption(parent : Rectangle, labelText : String = "Label", valueText : String = "Value")
		{
			super();
			_parent = parent;
			// Label
			_label = new TextField();
			_label.defaultTextFormat = Pretty.HEADING_2;
			_label.autoSize = "left";
			//graficosTextField.wordWrap = true;
			_label.text = labelText;
			_label.width = 100;
			_label.x = _parent.x + 10;
			_label.y = _parent.y + 10;
			addChild(_label);
			
			// Slider
			_slider = new Slider();
			_slider.x = _label.x + _label.width + 20;
			_slider.y = _label.y + _slider.height + 5;
			_slider.maximum = 2;
			_slider.minimum = 0;
			_slider.value = 2;
			
			addChild(_slider);
			
			// Valor
			_valueLabel = new TextField();
			_valueLabel.defaultTextFormat = Pretty.BODY_BOLD;
			_valueLabel.autoSize = "left";	
			_valueLabel.text = valueText;
			_valueLabel.width = 100;
			_valueLabel.x = _slider.x + _slider.width + 20;
			_valueLabel.y = _label.y;
			addChild(_valueLabel);
			
		}

		public function get valueLabel():TextField
		{
			return _valueLabel;
		}

		public function set valueLabel(value:TextField):void
		{
			_valueLabel = value;
		}

		public function get slider():Slider
		{
			return _slider;
		}

		public function set slider(value:Slider):void
		{
			_slider = value;
		}

		public function get label():TextField
		{
			return _label;
		}

		public function set label(value:TextField):void
		{
			_label = value;
		}

	}
}