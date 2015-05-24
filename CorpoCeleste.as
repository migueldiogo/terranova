package {
	
	import flash.display.*;
    import flash.geom.*;
	import flash.filters.*;
	
	
	public class CorpoCeleste extends Sprite{
		
        /* declaracao de variaveis */
        var Ncolunas, Nlinhas : int;
		var uvt   : Vector.<Number>;
		var pontos : Array;
		var triangulosmeshI   : Vector.<int>;
		var raio , obsX, obsY             : int;
		var tex,finaltex               : BitmapData;
		var tematmosfera , flag, flaglua: Boolean;
		var gl,sombra :GlowFilter;
		var NpixeisT,Npixeis,nPmudar: Number;
		
		public function CorpoCeleste(Nc:int, Nl :int, r:int, dataB:BitmapData, dataBF:BitmapData = null,obx:int = 0, oby:int = 0) {
			this.flag = true;
			this.Ncolunas = Nc;
			this.Nlinhas = Nl;
			this.raio = r;
			this.tex = dataB;
			this.finaltex = dataBF;
			this.obsX = obx;
			this.obsY = oby;
			
			if(dataBF == null)
			  this.flaglua = true;
			   
			this.pontos = new Array();
			this.uvt = new Vector.<Number>();
			this.triangulosmeshI = new Vector.<int>();
			
			criarVertices();
			criarUvt();
			triangulosmesh();
			tematmosfera = false;
			this.sombra = new GlowFilter(0x000000,0.5,50.0,50.0,3,1,true);
		}
		public function getRaio():int{ 
		    return this.raio;
		}
		
		public function setTex( dataB:BitmapData ):void{ 
		    this.tex = dataB;
		}
/*Transformações de visualização
		rotacao simples em torno do proprio eixo 
		matriz de transformacao:
			        cos(ang)  sin(ang)
					-sin(ang) cos(ang)
			*/
		public function transformacoes_de_visualização_rotacao_simples(ary:Vector.<Number>, ang:Number): void {
			var i, ii   : int;
	        var aux , aux1, aux2 : Number;
			
			/* conversao para radianos*/
			ang = ang*Math.PI;
			ang = ang/180;
			
			
			for(i = 0;i < pontos.length; i++){
				aux2 = this.pontos[i].GetvetexX();
				aux1 = this.pontos[i].GetvetexY();
				aux1 = Math.cos(ang)* aux1 +(-1)*(Math.sin(ang)* aux2);
				/*projeccao no eixo ZoY*/
				/*transformacao para coordenadas do observador */
				ary.push( aux1 + this.obsX, this.pontos[i].GetvetexZ() + this.obsY);
				
				 }
			}
		
		private function criarUvt():void {
			var i, ii :int
		     for(i = 0; i < this.Nlinhas; i++){
		        for(ii = 0; ii < this.Ncolunas; ii++){
			        uvt.push(i / (Nlinhas -1), ii / (Ncolunas -1));
			   } 
			   }
			  }
		
		
		private function criarVertices():void {
	       /* criacao de uma esfera normalizada*/
		   /*
		   http://mathworld.wolfram.com/Sphere.html
		    where theta is an azimuthal coordinate running from 0 to  2pi (longitude),
		   phi is a polar coordinate running from 0 to pi (colatitude),
		   and rho is the radius. Note that there are several other notations sometimes
		   used in which the symbols for theta and phi are interchanged or where r is used instead of rho.
		   If rho is allowed to run from 0 to a given radius r, then a solid ball is obtained.
		   A sphere with center at the origin may also be represented parametrically 
		   by letting u=rcosphi, so
           x	=	sqrt(r^2-u^2)costheta	
           y	=	sqrt(r^2-u^2)sintheta	
           z	=	u, */
			  
	      var i, ii   : int;
	      var aux , aux1, aux2, v, u,pespectiva   : Number;
		  /* calculo dos racios de forma a estimar angulo entre 2 pontos 
		  visto existirem Npartes pontos  equi distantes , 
		  o angulo formado entre 2 pontos adjacentes e yy sera
		  igal a2PI)/Npartes */
		  v = (2*Math.PI)/(this.Nlinhas-1); 
	      u = Math.PI/(this.Ncolunas-1) ;
	      for(i = 0; i < this.Nlinhas; i++){
		     for(ii = 0; ii < this.Ncolunas; ii++){
			      aux =  Math.sqrt(Math.pow(raio,2)-Math.pow(raio*Math.cos(u*ii),2))*Math.cos(v*i);
			      aux1 = Math.sqrt(Math.pow(raio,2)-Math.pow(raio*Math.cos(u*ii),2))*Math.sin(v*i);
			      aux2 = - raio*Math.cos(u*ii);/* *-1,mudança para coordenadas do flash*/
				 
			      pontos.push( new Vetex(aux, aux1, aux2) );
			 
				  
			} }
	
        }
		private function triangulosmesh():void {
			/* calcular indixes */
		    var i, ii, aux :int
		
		     for (i = 0; i < (Nlinhas-1); i++){
                  aux = (i * Ncolunas); /*offset*/
			      for (ii = 0; ii < (Ncolunas -1); ii++){
				  /*primeiro triangulo 2 pontos de cima e um de baixo */
				  triangulosmeshI.push(aux + ii, aux + ii + 1, aux + ii + Ncolunas) ;
				  /*triangulo complementar ao primeiro triangulo  */
				  triangulosmeshI.push(aux + ii + 1, aux + ii + 1 + Ncolunas, aux + ii + Ncolunas);
				  }
			 }
				  
		}
		
		/* externos */
	 public function setatmosfera(valor:Number):void{
		 /*azul agua : 0x66CCCC*/
		 this.tematmosfera = true;
		 gl = new GlowFilter(valor,0.9,50.0,50.0,1);
		 }
	 
	 public function desanhaPlaneta( arg: Number):void{
	        this.graphics.clear();
			   
            this.graphics.beginBitmapFill(this.tex, null, false, true);
			var arr:  Vector.<Number> = new Vector.<Number>();
			if( this.tematmosfera)
			         this.filters =[ sombra, gl ];
				else this.filters =[ sombra ];
	        
			transformacoes_de_visualização_rotacao_simples(arr, arg);
			this.graphics.drawTriangles(arr, this.triangulosmeshI, this.uvt, TriangleCulling.NEGATIVE);
            this.graphics.endFill();
			/*debug
			sp.graphics.lineStyle(0, 0, .5);
            sp.graphics.drawTriangles(arr, triangulosmeshI, null, TriangleCulling.NEGATIVE);*/
	  }
	/*********************************************/
	   public function desanhaLua(sp:Sprite, sp2:Sprite, arg: Number, r:Number, arg2: Number):void{
		   /*sp:Sprite plano  de desanha afrente  da cena /planeta 
		   sp2:Sprite camada de desanha atras da cena 
		   arg: angulo  de rotacao proprio eixo
		   r:raio da orbita 
		   arg2: angulo de translacao*/
	        sp.graphics.clear();
			sp2.graphics.clear();
			
			var arr:  Vector.<Number> = new Vector.<Number>();
            var b:Boolean = transformacoes_de_visualização_rotacaoZ(arr, arg, r, arg2);
			if (!b){
			    sp = sp2;
				}
			sp.filters =[ sombra ];
			sp.graphics.beginBitmapFill(this.tex, null, false, true);
			sp.graphics.drawTriangles(arr, this.triangulosmeshI, this.uvt, TriangleCulling.NEGATIVE);
            sp.graphics.endFill();
		    
			
			
	  }
	  public function transformacoes_de_visualização_rotacaoZ(ary:Vector.<Number>, ang:Number, r:Number, ang2:Number):Boolean {
		  
			var i, ii   : int;
	        var aux , aux1, aux2  : Number;
			var scale:Number; 
			var rb:Boolean = true;
			
			/* conversao para radianos*/
			ang = ang*Math.PI;
			ang = ang/180;
			
			
			
			ang2 = ang2*Math.PI;
			ang2 = ang2/180;
			
			aux = Math.sin(ang2);
			
			if(aux < 0)
			    rb = false;
			
			/*transformacao para coordenadas do observador */
			for(i = 0;i < pontos.length; i++){
				aux2 = this.pontos[i].GetvetexX();
				aux = aux2;
				aux1 = this.pontos[i].GetvetexY();
				
				aux = Math.cos(ang)* aux + Math.sin(ang)* aux1; /*x*/
				aux1 = Math.cos(ang)* aux1 +(-1)*(Math.sin(ang)* aux2);
				
				aux1 = aux1 +r ;
				aux2 = aux ;
				
				aux = Math.cos(ang2)* aux + Math.sin(ang2)* aux1; /*x*/
				aux1 = Math.cos(ang2)* aux1 +(-1)*(Math.sin(ang2)* aux2);
				
				aux = (1000 + aux)/1000;/*escala consuante a distancia */
				//aux = (3*aux )/ (aux*4);//isometrica 
				ary.push( (aux1 *aux) + this.obsX, (this.pontos[i].GetvetexZ() *aux)+ this.obsY);
				
				
				 }
				 return rb;
			}
			

/**********************************************************/
		/*
		//metodo so deve ser chamado se flag == true
		public function Calldissolvetextura(dataB:BitmapData,nP ):void{
			this.flag = false;
			this.temptex = dataB;
			this.NpixeisT = temptex.height;
			this.NpixeisT = this.NpixeisT * temptex.width;
			this.randomSeed = Math.floor(Math.random() * 10);
			this.nPmudar = nP;
			this.Npixeis = 0;
			dissolvetextura();
			}
		private function dissolvetextura( ):void{
			 this.randomSeed = tex.pixelDissolve(this.temptex, this.tex.rect, new Point(0, 0), this.randomSeed,this.nPmudar,0);
			 this.Npixeis += this.nPmudar ;
			 if(this.Npixeis > NpixeisT)
			      this.flag = true;
				  
			}
			
		public function getFlag( ):Boolean{
			return this.flag;
			}*/

	}/* feicha class*/
	
}/* feicha package*/

