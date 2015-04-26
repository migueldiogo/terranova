package  {
	
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	import fl.motion.Color;
	
	
	public class NivelButtons extends MovieClip {
		private var _disabled : Boolean;
		
		public function NivelButtons() {
			// constructor code
			stop();
			nivelUpButton.label.text = "evoluir";
			nivelDownButton.label.text = "vender";		
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
