package  {
	
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	import fl.motion.Color;
	
	
	public class NivelButtons extends MovieClip {
		private var _disabled : Boolean;
		
		public function NivelButtons() {
			// constructor code
			stop();
			
			nivelUpButton.label.setStyle("textFormat", Pretty.BODY_BOLD);
			nivelDownButton.label.setStyle("textFormat", Pretty.BODY_BOLD);

			nivelUpButton.label.text = "evoluir";
			nivelDownButton.label.text = "vender";	
			
			var color : Color = new Color();
			color.setTint(0x5E7F5E, 1);
			
			nivelDownButton.button.transform.colorTransform = color;
			nivelUpButton.button.transform.colorTransform = color;
			
		}

		public function get disabled():Boolean
		{
			return _disabled;
		}

		public function set disabled(value:Boolean):void
		{
			var color :Color = new Color();
			
			_disabled = value;
			
			if (value) {
				color.setTint(0xFFFFFF, 0.5);
				this.transform.colorTransform = color;
			}
				
			else {
				color.setTint(0xFFFFFF, 0);
				this.transform.colorTransform = color;		
			}
		}

	}
	
}
