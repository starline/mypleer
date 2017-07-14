package starline.utils{

  import flash.filesystem.File;
  import flash.filesystem.FileStream;
  import flash.filesystem.FileMode;
  
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.system.Capabilities;
  import flash.events.Event;
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.text.TextFieldAutoSize;
  import flash.utils.ByteArray;
  
  
	/**
	* Use for AIR only
	* @author AS3Coder
	* Основной класс приложения
	*/
	
  public class SistemInfo extends Sprite {
    /**
     * Конструктор
     */
    function SistemInfo():void {
      addEventListener(Event.ADDED_TO_STAGE, onAddToStage, false, 0, true);
    }
    /**
     * Метод создает текстовое поле, заполняет его данными.
     * Открывает поток и записывает содержимое 
     * тектового поля в файл.
     */
    private function create ():void{
      var str:String;
      var txt:TextField;
      var fil:FileStream;
      //
      str = "";
      str += "navHardwareDisable: " + Capabilities.avHardwareDisable;
      str += "\nhasAccessibility: " + Capabilities.hasAccessibility;
      str += "\nhasAudio: " + Capabilities.hasAudio;
      str += "\nhasAudioEncoder: " + Capabilities.hasAudioEncoder;
      str += "\nhasEmbeddedVideo: " + Capabilities.hasEmbeddedVideo;
      str += "\nhasIME: " + Capabilities.hasIME;
      str += "\nhasMP3: " + Capabilities.hasMP3;
      str += "\nhasPrinting: " + Capabilities.hasPrinting;
      str += "\nhasScreenBroadcast: " + Capabilities.hasScreenBroadcast;
      str += "\nhasScreenPlayback: " + Capabilities.hasScreenPlayback;
      str += "\nhasStreamingAudio: " + Capabilities.hasStreamingAudio;
      str += "\nhasStreamingVideo: " + Capabilities.hasStreamingVideo;
      str += "\nhasTLS: " + Capabilities.hasTLS;
      str += "\nhasVideoEncoder: " + Capabilities.hasVideoEncoder;
      str += "\nisDebugger: " + Capabilities.isDebugger;
      str += "\nisEmbeddedInAcrobat: " + Capabilities.isEmbeddedInAcrobat;
      str += "\nlanguage: " + Capabilities.language;
      str += "\nlanguages: " + Capabilities.languages;
      str += "\nlocalFileReadDisable: " + Capabilities.localFileReadDisable;
      str += "\nmanufacturer: " + Capabilities.manufacturer;
      str += "\nmaxLevelIDC: " + Capabilities.maxLevelIDC;
      str += "\nos: " + Capabilities.os;
      str += "\npixelAspectRatio: " + Capabilities.pixelAspectRatio;
      str += "\nplayerType: " + Capabilities.playerType;
      str += "\nscreenColor: " + Capabilities.screenColor;
      str += "\nscreenDPI: " + Capabilities.screenDPI;
      str += "\nscreenResolutionX: " + Capabilities.screenResolutionX;
      str += "\nscreenResolutionY: " + Capabilities.screenResolutionY;
      str += "\nserverString: " + Capabilities.serverString;
      str += "\nversion: " + Capabilities.version;
      //
      txt = new TextField()
      txt.selectable = false;
      txt.multiline = true;
      txt.defaultTextFormat = new TextFormat("Courier New", 12);
      txt.autoSize = TextFieldAutoSize.LEFT;
      txt.text = str;
      txt.x = 10;
      txt.y = 10;
      addChild(txt);
      //
      fil = new FileStream();
      fil.open(new File(File.desktopDirectory.nativePath + "/Capabilities.txt"), FileMode.WRITE);
      fil.writeUTFBytes(str.split("\n").join("\r\n"));
      fil.close();
    }
    /**
     * Метод обрабатывает событие добавления 
     * основного клипа приложения на сцену.
     */
    private function onAddToStage (e:Event):void{
      removeEventListener(Event.ADDED_TO_STAGE, onAddToStage, false);
      //
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      //
      create();
    }
  }
}