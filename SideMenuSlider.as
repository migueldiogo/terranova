package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class SideMenuSlider extends MovieClip {
		var clicked : Boolean;
		
		public function SideMenuSlider() {
			// constructor code
			clicked = false;

			addEventListener(MouseEvent.MOUSE_DOWN, down);
			addEventListener(MouseEvent.MOUSE_UP, up);
			

		}
		

		public function down(event : MouseEvent) : void {
			clicked = true;
		}
		public function up(event : MouseEvent) : void {
			clicked = false;
		}
	}
	
}
