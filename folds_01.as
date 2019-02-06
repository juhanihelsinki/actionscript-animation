package{
    import flash.events.Event;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.*;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.net.URLRequest;
    import flash.utils.Timer;

	public class folds_01  extends Sprite {
		private var url:String = "ateena_03.mp3";
        	private var soundFactory:Sound;
        	private var channel:SoundChannel;
        	private var positionTimer:Timer;
		private var astia: Sprite = new Sprite();
		private var pallot:Array = [];
		private var k:uint = 0;
		private var dragging:Boolean = false;
		private var pause:Boolean = false;
		private var volumeNew:Number;

		public function folds_01() {
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			var request:URLRequest = new URLRequest(url);
            		soundFactory = new Sound();
            		//soundFactory.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            		soundFactory.load(request);
            		channel = soundFactory.play(15000,20);
		}
		
		function onAdded(e:Event):void {
			addEventListener(Event.ENTER_FRAME, liikutaPalloja);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, rotate);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, hiirenNappiAlas);
			stage.addEventListener(MouseEvent.MOUSE_UP, hiirenNappiYlos);	
			
			astia.x = stage.stageWidth / 2;
			astia.y = stage.stageHeight / 2;
			addChild(astia);
			astia.rotationX = 70;
			astia.rotationY = -50.25;
			setVolume(0);

			for (var i:uint = 0; i < 30 ; i++) pallot.push({
				omaPallo: new Sprite()
			})
			
			for (var j:uint = 0; j < 30 ; j++) {
				astia.addChild(pallot[j].omaPallo);
				//pallot[j].omaPallo.graphics.beginFill(8 * (30 - j) * 0xFF0000, 0.2 + j * 0.026); 
				//pallot[j].omaPallo.graphics.drawEllipse(0, -90, 30, 75 + j * 10);
				pallot[j].omaPallo.graphics.beginFill( 1024 * (30 - j) * 0x00FF01, 1 );
				pallot[j].omaPallo.graphics.drawRect(0, -90, 150 - j * 5, 150 - j * 5);
			}
		
			function liikutaPalloja(evt: Event = null): void {
				if (!pause) k++;
				for (var i:uint = 0; i < 30 ; i++){
					//pallot[i].omaPallo.x = 12 * i *  Math.sin((k+i)/10);
					pallot[i].omaPallo.x = 10 *  i *  Math.exp(Math.sin((k+i)/10)) - 300;
					pallot[i].omaPallo.y = - 200;
					//pallot[i].omaPallo.rotationY = 5*i - 60;
					pallot[i].omaPallo.rotationY = (k%1000) * i ;
					pallot[i].omaPallo.rotationX = 2*i - 60;
					
				}
			}
		
			function rotate(event:MouseEvent): void {
				var halfStage:uint = Math.floor(stage.stageWidth / 2);
				var xPos:uint = event.stageX;
				var yPos:uint = event.stageY;
				var value:Number;
				var pan:Number;
				var volume:Number = 1 - 1.2 *(yPos / stage.stageHeight);
				if (volume < 0 ) volume = 0;
				
				
				if (xPos > halfStage) {
					value = xPos / halfStage;
					pan = value - 1;
				} else if (xPos < halfStage) {
					value = (xPos - halfStage) / halfStage;
					pan = value;				
				} else {
					pan = 0;
				}
				
				if (xPos < 5 || xPos > stage.stageWidth || yPos < 0 || yPos > stage.stageHeight) {
					pan = 1;
					volume = 0;
				}
				//trace (volume, pan);
				
				if (dragging) {
					astia.rotationX = (stage.mouseY - 600 / 2) / 2;
					astia.rotationY = -(stage.mouseX - 600 / 2) / 4;
					setVolume(volume);
					setPan(pan);
				}
				
				
			}
			
			function setPan(pan:Number):void {
				var transform:SoundTransform = channel.soundTransform;
				transform.pan = pan;
				channel.soundTransform = transform;
			}
			
			function reportKeyDown(event:KeyboardEvent):void { 
				if (event.charCode == 32) pause = !pause;
			} 
			
			function setVolume(volume:Number):void {
				var transform:SoundTransform = channel.soundTransform;
				transform.volume = volume;
				channel.soundTransform = transform;
			}
		
			
			function hiirenNappiAlas(evt:MouseEvent = null): void {
				dragging = true;
			}
		
			function hiirenNappiYlos(evt:MouseEvent = null): void {
				dragging = false;
				setVolume(0);
			}


		}	
	}
}
