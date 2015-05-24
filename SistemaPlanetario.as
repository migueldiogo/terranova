package  {
	import flash.display.*;
	import flash.geom.*;
	
	public class SistemaPlanetario extends Sprite{
        var front : Sprite;
		var back  : Sprite;
		var planeta, lua :  CorpoCeleste;
		var hasMoon : Boolean  ;
		var coordX, coordY, randomSeed : Number;
		var nLinhas, nColunas, rOrbita : int;
		
		var estadoActual : int;
		var totalP, nPinteracao : int;
		var Tinicial, Tfinal,Taux:BitmapData;
		
		public function SistemaPlanetario(xposi:int,yposi:int,Nc:int, Nl :int, r:int, dataB:BitmapData, dataBF:BitmapData) {
			
			this.coordX = xposi;
            this.coordY = yposi;
			this.front = new Sprite();
			this.back = new Sprite();
			this.hasMoon = false;
			this.nLinhas = Nl;
			this.nColunas = Nc;
			
			
			this.estadoActual = 0;
			randomSeed = 0;
			this.Tinicial = dataB; 
			this.Tfinal = dataBF;
			this.Taux = Tinicial.clone();
			this.totalP = dataB.height * dataB.width;
			this.nPinteracao = this.totalP/100;
			
			
			this.planeta =  new CorpoCeleste(nLinhas, nColunas, r, dataB, null,coordX,coordY );
			
			this.addChild(back);
			this.addChild(planeta);
			this.addChild(front);
			
		}

       public function setatmosfera(valor:Number):void{
		  this.planeta.setatmosfera(valor); 
		 }
		
	   public function addLua( rl:int, rO:int, dataB:BitmapData):void{
		   this.hasMoon = true;
		   
		   if(rO - this.planeta.getRaio() <= rl)
		      this.rOrbita = this.planeta.getRaio() + rl;
		   else
		       this.rOrbita = rO;
		   
		   this.lua =  new CorpoCeleste(nLinhas, nColunas, rl, dataB,null,coordX,coordY);
		   }
		   
	   public function desenha( arg: Number, argL: Number = 0, argO: Number = 0, estado : int = 0){
		  var aux,aux2 : int;
		  var b: Boolean
		  if(estado > estadoActual){
			  aux = estado - estadoActual;
			  this.estadoActual = estado;
			  if(estado == 100)
			     aux2 = aux*this.nPinteracao + (totalP - aux*this.nPinteracao);
			  else 
			     aux2 = aux*this.nPinteracao;
				 this.randomSeed = Taux.pixelDissolve(this.Tfinal, this.Taux.rect, new Point(0, 0), this.randomSeed,aux2,0);
			  this.planeta.setTex( Taux );
			  
			  }else if(estado < estadoActual){
				  Taux = Tinicial.clone();
				  this.estadoActual = estado;
				  this.randomSeed = Taux.pixelDissolve(this.Tfinal, this.Taux.rect, new Point(0, 0), 0,estado*this.nPinteracao,0);
				  this.planeta.setTex( Taux );
				  }
		  
		  this.planeta.desanhaPlaneta(arg);
		  
		  if(this.hasMoon){
		           this.lua.desanhaLua(this.front, this.back, argL, rOrbita, argO);
				  }
		   }

	}
	
}
