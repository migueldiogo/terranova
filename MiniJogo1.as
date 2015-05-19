package  {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	//import ExplosionChain;
	
	public class MiniJogo1 extends MovieClip{
		var catcher:Catcher;
		var nextObject:Timer;
		// Array com todos os objectos
		var objects:Array = new Array(); 
		var score:int = 0;
		var energy:int = 0;
		var lifes:int = 3;
		var speed:Number = 10;
		var gameOver:Boolean = false;
		
		var _planeta : Planeta;
		
		public function MiniJogo1(planeta : Planeta) {
			_planeta = planeta;
			// Cria a nave, posiciona-a e adiciona-a ao jogo
			catcher = new Catcher(); 	
			catcher.y = 350;			
			addChild(catcher);
			
			setNextObject();
			addEventListener(Event.ENTER_FRAME, moveObjects);
			
		}
		
		public function setNextObject(){
			nextObject = new Timer(500+Math.random()*500,1);
			nextObject.addEventListener(TimerEvent.TIMER_COMPLETE, newObject);
			nextObject.start();
		}
		
		public function newObject(e:Event){
			// Array de objectos que são para apanhar
			var toCatch:Array = ["Mineral","Energy"];
			// Array de objectos para evitar
			var toAvoid:Array = ["Asteroid1","Asteroid2","Asteroid3"]; 
			// Probabilidade que vai definir que objecto vai aparecer
			// A probabilidade de calhar um 'objecto bom' é igual à de calhar um 'objecto mau'
			if(Math.random() <= .5){ 
				var a:int = Math.floor(Math.random()*toCatch.length);
				// Criar uma referência ao objecto com as palavras "bom" e "mau" respectivamente
				var classRef:Class = getDefinitionByName(toCatch[a]) as Class;
				var newObject:MovieClip = new classRef();
				newObject.typestr = "bom";
				// Garantir que os objectos comecem a cair por baixo da Scoreboard
				newObject.y = 60;
			}
			else{
				a = Math.floor(Math.random()*toAvoid.length);
				classRef = getDefinitionByName(toAvoid[a]) as Class;
				newObject = new classRef();
				newObject.typestr = "mau";
				newObject.y = 60;
			}
			// Cria uma coordenada X aleatoria
			newObject.x = Math.random()*500;
			// Adiciona o novo objecto ao jogo
			addChild(newObject);
			// E por ultimo vai colocá-lo no Array de objectos
			objects.push(newObject);
			// Se gameover == false (é false por definição) vai aumentando a velocidade de queda dos objectos
			if(!gameOver){
				speed+=0.2;
				setNextObject();
			}
		}
			
		public function moveObjects(e:Event){
			for(var i:int = objects.length - 1; i >= 0; i--){
				objects[i].y += speed;
				if(objects[i].y > 400){
					removeChild(objects[i]);
					// Remove o objecto
					objects.splice(i,1);
				}
				if(objects[i].hitTestObject(catcher)){
					if(objects[i].typestr == "bom"){
						if(objects[i] is Mineral){
							_planeta.recursos.minerio += 25;
						}
						else{
							_planeta.recursos.energia += 25;
						}
					}
					else{
						score -= 1;
						lifes--;
						
						if(lifes == 0){
							// Quando o numero de vidas chegar a 0, torna a variavel gameOver a true e adiciona o texto a dizer "Game Over"
							gameOver = true;
							var go : GameOver = new GameOver();
							go.x = this.stage.stageWidth/2 - go.width/2;
							go.y = this.stage.stageHeight/2 - go.height/2;
							addChild(go);
						}
					}
					//scoreDisplay.text = "Score: "+score;
					//lifesDisplay.text = "Lifes: "+lifes;
					//energyDisplay.text = "Energy: "+energy;
					removeChild(objects[i]);
					objects.splice(i,1);
				}
			}
			if(!gameOver){
				// Quando for gameover, impossibilita o utilizador de mover a nave
				catcher.x = mouseX;	
			}
		}
		
	}
	
}
