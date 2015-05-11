package
{
	
	import flash.display.MovieClip;
	
	import fl.containers.UILoader;
	
	public class NivelLoader extends MovieClip {
		private var _nivel : uint;
		private var _icon : UILoader;
		
		public function NivelLoader (nivel : uint, src : String) {
			super();
			_nivel = nivel;
			_icon = new UILoader();
			_icon.source = src;
			this.addChild(_icon);
		}
		
		public function get icon():UILoader
		{
			return _icon;
		}

		public function set icon(value:UILoader):void
		{
			_icon = value;
		}

		public function get nivel():uint
		{
			return _nivel;
		}
		
		public function set nivel(value:uint):void
		{
			_nivel = value;
		}
		
	}
}