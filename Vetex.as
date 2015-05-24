package {
	
	public class Vetex {
        var xp:Number;/* embora nao fasa sentidoo uso de valores nao inteiros, 
		é preferivel nao perder informacao entre transformacoes*/
		var yp:Number;
		var zp:Number;
		/* constructor */
		public function Vetex(xx:Number, yy:Number, zz:Number) {
			this.xp = xx;
			this.yp = yy;
			this.zp = zz;
		}
		/* metodos */
		public function Setvetex(xx:Number, yy:Number, zz:Number):void {
			this.xp = xx;
			this.yp = yy;
			this.zp = zz;
		}
		
		public function GetvetexX():Number {
			return this.xp;
		}
		public function GetvetexY():Number {
			return this.yp;
		}
		public function GetvetexZ():Number {
			return this.zp;
		}

	}
	
}
