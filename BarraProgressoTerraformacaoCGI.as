package
{
	import flash.display.Sprite;
	import flash.text.TextField;

	public class BarraProgressoTerraformacaoCGI extends Sprite
	{
		//private var _percentagem : uint;
		private var _percentagemText : TextField;
		
		public function BarraProgressoTerraformacaoCGI()
		{
			super();
			graphics.clear();
			graphics.lineStyle(1, 0xFFFFFF, 1.0, false, "normal");
			graphics.beginFill(0xFFFFFF, 0);
			graphics.drawRect(0, 0, 207, 7);
			graphics.endFill();
			
			_percentagemText = new TextField();
			_percentagemText.defaultTextFormat = Pretty.BODY;
			_percentagemText.text = 0 + "%";
			
			_percentagemText.x = 210;
			_percentagemText.y = -7;
			
			addChild(_percentagemText);
			
			
			var titulo : TextField = new TextField();
			titulo.defaultTextFormat = Pretty.BODY;
			titulo.text = "Terraformação";
			
			titulo.x = 207 / 2 - titulo.textWidth/2;
			titulo.y = -7 - 10;
			
			addChild(titulo);

			
			
		}
		
		public function atualiza(valor : uint) {
			graphics.lineStyle(4, 0x00FF00, 1);
			graphics.moveTo(4, 4);
			graphics.lineTo(4 + valor*2, 4);
			
			_percentagemText.text = valor + "%";
		}
	}
}